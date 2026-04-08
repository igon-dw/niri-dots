#!/bin/bash

# Shared core logic for the fzf-based quick opener.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../f2_launcher"
CONFIG_FILE="$CONFIG_DIR/f2_launcher.toml"

# shellcheck source=/dev/null
source "$SCRIPT_DIR/fzf_quick_opener_icons.sh"

get_config_value() {
  local key="$1"
  yq eval "$key" "$CONFIG_FILE" 2>/dev/null || echo ""
}

command_exists() {
  command -v "$1" &> /dev/null
}

get_default_terminal() {
  local term
  term=$(get_config_value '.default_terminal')

  if [ -z "$term" ] || [ "$term" = "null" ]; then
    for t in "${TERMINAL:-}" foot kitty ghostty alacritty xterm; do
      if [ -n "$t" ] && command_exists "$t"; then
        echo "$t"
        return 0
      fi
    done

    echo "xterm"
  else
    echo "$term"
  fi
}

show_notification() {
  local message="$1"
  local urgency="${2:-normal}"

  if command_exists notify-send; then
    notify-send -u "$urgency" "fzf_quick_opener" "$message"
  fi
}

show_error_terminal() {
  local message="$1"
  local term
  term=$(get_default_terminal)

  if command_exists "$term"; then
    # shellcheck disable=SC2016
    env FZF_QUICK_OPENER_MESSAGE="$message" \
      "$term" -e bash -lc 'printf "%s\n" "Error: $FZF_QUICK_OPENER_MESSAGE"; sleep 3' 2>/dev/null &
  fi
}

require_config_file() {
  if [ ! -f "$CONFIG_FILE" ]; then
    show_error_terminal "Configuration file not found at $CONFIG_FILE"
    show_notification "Configuration file not found" "critical"
    exit 1
  fi
}

build_exclude_args_for_launcher() {
  local launcher="$1"
  local excludes
  excludes=$(yq eval ".launcher.${launcher}.exclude[]" "$CONFIG_FILE" 2>/dev/null || echo "")

  if [ -z "$excludes" ] || [ "$excludes" = "null" ]; then
    excludes=$(yq eval '.launcher.fuzzel.exclude[]' "$CONFIG_FILE" 2>/dev/null || echo "")
  fi

  while IFS= read -r pattern; do
    if [ -n "$pattern" ] && [ "$pattern" != "null" ]; then
      printf '%s\0' "$pattern"
    fi
  done <<< "$excludes"
}

get_fzf_option() {
  local key="$1"
  local default_value="$2"
  local value
  value=$(get_config_value ".launcher.fzf.${key}")

  if [ -z "$value" ] || [ "$value" = "null" ]; then
    echo "$default_value"
  else
    echo "$value"
  fi
}

get_default_app() {
  local default_app
  default_app=$(get_config_value '.default_app')

  if [ -z "$default_app" ] || [ "$default_app" = "null" ]; then
    echo "xdg-open"
  else
    echo "$default_app"
  fi
}

get_app_type() {
  local app="$1"
  local app_type
  app_type=$(yq eval ".app_metadata[\"$app\"]" "$CONFIG_FILE" 2>/dev/null)

  if [ -z "$app_type" ] || [ "$app_type" = "null" ]; then
    echo "gui"
  else
    echo "$app_type"
  fi
}

get_all_apps_for_mime() {
  local mime_type="$1"
  yq eval ".mime_types[\"$mime_type\"][]" "$CONFIG_FILE" 2>/dev/null || echo ""
}

get_available_apps_for_mime() {
  local mime_type="$1"
  local all_apps
  all_apps=$(get_all_apps_for_mime "$mime_type")

  local available=""
  while IFS= read -r app; do
    if [ -n "$app" ] && [ "$app" != "null" ] && command_exists "$app"; then
      if [ -z "$available" ]; then
        available="$app"
      else
        available="$available"$'\n'"$app"
      fi
    fi
  done <<< "$all_apps"

  echo "$available"
}

detect_mime_type() {
  local file_path="$1"
  file -L --mime-type -b "$file_path" 2>/dev/null
}

resolve_absolute_path() {
  local selected="$1"

  if [[ "$selected" == /* ]]; then
    echo "$selected"
  else
    echo "$HOME/$selected"
  fi
}

launch_detached() {
  local app="$1"
  shift

  if command_exists setsid; then
    setsid -f "$app" "$@" >/dev/null 2>&1 < /dev/null
  else
    nohup "$app" "$@" >/dev/null 2>&1 < /dev/null &
  fi
}

open_with_app() {
  local app="$1"
  local file_path="$2"
  local run_cli_in_current_tty="${3:-0}"

  if ! command_exists "$app"; then
    show_error_terminal "Application not found: $app"
    show_notification "Application not found: $app" "normal"
    return 1
  fi

  local app_type
  app_type=$(get_app_type "$app")

  if [ "$app_type" = "cli" ]; then
    if [ "$run_cli_in_current_tty" = "1" ] && [ -t 0 ] && [ -t 1 ]; then
      exec "$app" "$file_path"
    fi

    local term
    term=$(get_default_terminal)

    if command_exists "$term"; then
      launch_detached "$term" -e "$app" "$file_path"
    else
      show_error_terminal "Terminal not found to run CLI app: $app"
      show_notification "Terminal not found to run CLI app: $app" "normal"
      return 1
    fi
  else
    if [ "$app" = "xdg-open" ]; then
      if ! xdg-open "$file_path" >/dev/null 2>&1; then
        show_error_terminal "Failed to open with xdg-open: $file_path"
        show_notification "Failed to open with xdg-open: $file_path" "normal"
        return 1
      fi
    else
      launch_detached "$app" "$file_path"
    fi
  fi
}

build_fd_exclude_args() {
  local -a exclude_args=()
  local exclude_pattern

  while IFS= read -r -d '' exclude_pattern; do
    exclude_args+=(--exclude "$exclude_pattern")
  done < <(build_exclude_args_for_launcher "fzf")

  printf '%s\0' "${exclude_args[@]}"
}

emit_candidate_line() {
  local rel_path="$1"
  local abs_path="$HOME/$rel_path"
  local kind
  local icon
  local label

  kind=$(get_path_kind "$abs_path")
  icon=$(get_icon_for_kind "$kind")
  label=$(get_label_for_kind "$kind")

  printf '%s\t%s\t%s\t%s\n' "$rel_path" "$icon" "$label" "$rel_path"
}

list_candidates() {
  local -a fd_args=(--hidden --base-directory "$HOME")
  local -a exclude_args=()
  local item
  local rel_path
  local -A seen=()

  while IFS= read -r -d '' item; do
    exclude_args+=("$item")
  done < <(build_fd_exclude_args)

  while IFS= read -r rel_path; do
    [ -n "$rel_path" ] || continue
    seen["$rel_path"]=1
    emit_candidate_line "$rel_path" || return 0
  done < <(fd "${fd_args[@]}" "${exclude_args[@]}" --max-depth 1 .)

  while IFS= read -r rel_path; do
    [ -n "$rel_path" ] || continue
    [ -z "${seen["$rel_path"]+x}" ] || continue
    emit_candidate_line "$rel_path" || return 0
  done < <(fd "${fd_args[@]}" "${exclude_args[@]}" .)
}

preview_path() {
  local rel_path="$1"
  local file_path
  file_path=$(resolve_absolute_path "$rel_path")

  if [ ! -e "$file_path" ]; then
    printf '%s\n' "Path not found: $rel_path"
    return 0
  fi

  printf 'Path: %s\n' "$file_path"
  printf 'Kind: %s\n' "$(get_path_kind "$file_path")"
  printf 'MIME: %s\n' "$(detect_mime_type "$file_path" || echo unknown)"
  printf '\n'

  if [ -d "$file_path" ]; then
    if command_exists eza; then
      eza --icons=always --group-directories-first --color=always -1 -- "$file_path" | sed -n '1,120p'
    elif command_exists tree; then
      tree -C -L 2 -- "$file_path" | sed -n '1,120p'
    else
      find "$file_path" -maxdepth 1 -mindepth 1 -printf '%f\n' | sed -n '1,120p'
    fi
    return 0
  fi

  case "$(detect_mime_type "$file_path" || echo unknown)" in
    text/*|*/json|*/xml|*/yaml|application/x-yaml)
      if command_exists bat; then
        bat --color=always --style=plain --line-range=:200 -- "$file_path"
      else
        sed -n '1,200p' -- "$file_path"
      fi
      ;;
    image/*|audio/*|video/*|application/pdf|application/zip)
      file -L --brief -- "$file_path"
      printf '\n'
      stat --printf='Size: %s bytes\nModified: %y\n' -- "$file_path" 2>/dev/null || true
      ;;
    *)
      file -L --brief -- "$file_path"
      ;;
  esac
}

choose_path_with_fzf() {
  local prompt
  local header
  local height
  local preview_window
  local layout
  local selection
  local status

  prompt=$(get_fzf_option 'prompt' 'Quick Open > ')
  header=$(get_fzf_option 'header' 'Enter: select path | Esc: cancel')
  height=$(get_fzf_option 'height' '85%')
  preview_window=$(get_fzf_option 'preview_window' 'right,60%,border-left')
  layout=$(get_fzf_option 'layout' 'reverse')

  set +o pipefail
  selection=$(list_candidates | fzf \
    --height="$height" \
    --layout="$layout" \
    --border=rounded \
    --ansi \
    --delimiter=$'\t' \
    --with-nth=2,3,4 \
    --preview-window="$preview_window" \
    --prompt "$prompt" \
    --header "$header" \
    --preview "$SCRIPT_DIR/fzf_quick_opener_core.sh --preview {1}")
  status=$?
  set -o pipefail

  [ "$status" -eq 0 ] || return "$status"
  printf '%s\n' "$selection"
}

build_app_selection_lines() {
  local file_path="$1"
  local mime_type="$2"
  local available_apps
  local default_app

  available_apps=$(get_available_apps_for_mime "$mime_type")
  default_app=$(get_default_app)

  while IFS= read -r app; do
    [ -n "$app" ] || continue
    printf '%s\t%s\t%s\n' "$app" "$(get_app_type "$app")" "$app"
  done <<< "$available_apps"

  printf '%s\t%s\t%s\n' "$default_app" "default" "Open with default app ($default_app)"

}

choose_app_for_path() {
  local file_path="$1"
  local mime_type="$2"
  local selection
  local height
  local layout
  local status

  height=$(get_fzf_option 'height' '85%')
  layout=$(get_fzf_option 'layout' 'reverse')

  set +o pipefail
  selection=$(build_app_selection_lines "$file_path" "$mime_type" | fzf \
    --height="$height" \
    --layout="$layout" \
    --border=rounded \
    --ansi \
    --delimiter=$'\t' \
    --prompt "Open With > " \
    --header "Enter: open | Esc: cancel" \
    --with-nth=2,3)
  status=$?
  set -o pipefail

  [ "$status" -eq 0 ] || return "$status"

  printf '%s\n' "${selection%%$'\t'*}"
}

launch_selected_path() {
  local rel_path="$1"
  local file_path
  local mime_type
  local app

  file_path=$(resolve_absolute_path "$rel_path")

  if [ ! -e "$file_path" ]; then
    printf '%s\n' "Path no longer exists: $rel_path" >&2
    return 1
  fi

  mime_type=$(detect_mime_type "$file_path") || {
    printf '%s\n' "Cannot determine MIME type: $rel_path" >&2
    return 1
  }

  app=$(choose_app_for_path "$file_path" "$mime_type") || return 1
  open_with_app "$app" "$file_path" "1"
}

main() {
  local selection
  local rel_path

  require_config_file

  if [ ! -t 0 ] || [ ! -t 1 ]; then
    printf '%s\n' "fzf_quick_opener must run in an interactive terminal." >&2
    exit 1
  fi

  selection=$(choose_path_with_fzf) || exit 0
  rel_path=${selection%%$'\t'*}

  [ -n "$rel_path" ] || exit 0

  launch_selected_path "$rel_path"
}

if [ "${1:-}" = "--preview" ]; then
  preview_path "${2:-}"
  exit 0
fi
