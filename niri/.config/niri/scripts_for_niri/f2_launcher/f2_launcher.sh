#!/bin/bash

# f2_launcher: Advanced Fuzzy File Launcher with MIME-type support
# -------------------------------------------------------------------
# An improved version of f2_launcher that reads configuration files
# and opens files with appropriate applications based on MIME types.
# Supports multiple candidate applications per MIME type and user selection.
# -------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/f2_launcher.toml"

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
    notify-send -u "$urgency" "f2_launcher" "$message"
  fi
}

show_error_terminal() {
  local message="$1"
  local term
  term=$(get_default_terminal)

  if command_exists "$term"; then
    # shellcheck disable=SC2016
    env F2_LAUNCHER_MESSAGE="$message" \
      "$term" -e bash -lc 'printf "%s\n" "Error: $F2_LAUNCHER_MESSAGE"; sleep 3' 2>/dev/null &
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

build_exclude_args() {
  build_exclude_args_for_launcher "fuzzel"
}

get_fuzzel_args() {
  local args
  args=$(get_config_value '.launcher.fuzzel.dmenu_args')

  if [ -z "$args" ] || [ "$args" = "null" ]; then
    echo "-w 120 -l 20"
  else
    echo "$args"
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

# ============================================================================
# MAIN LOGIC
# ============================================================================

main() {
  require_config_file

  # Build fd command arguments
  local -a exclude_args=()
  local exclude_pattern
  while IFS= read -r -d '' exclude_pattern; do
    exclude_args+=(--exclude "$exclude_pattern")
  done < <(build_exclude_args)

  local fuzzel_args
  fuzzel_args=$(get_fuzzel_args)

  # Select file using fd and fuzzel
  local selected
  # shellcheck disable=SC2086
  selected=$(fd --hidden \
    --base-directory "$HOME" \
    "${exclude_args[@]}" \
    . | fuzzel --dmenu $fuzzel_args 2>/dev/null) || {
    # User cancelled
    exit 0
  }

  # Exit if empty
  if [ -z "$selected" ]; then
    exit 0
  fi

  local file_path
  file_path=$(resolve_absolute_path "$selected")

  # Verify file exists
  if [ ! -e "$file_path" ]; then
    show_error_terminal "File no longer exists: $selected"
    show_notification "File no longer exists: $selected" "normal"
    exit 1
  fi

  # Get MIME type
  local mime_type
  mime_type=$(detect_mime_type "$file_path") || {
    show_error_terminal "Cannot determine MIME type for: $selected"
    show_notification "Cannot determine MIME type" "normal"
    exit 1
  }

  # Get available apps for this MIME type
  local available_apps
  available_apps=$(get_available_apps_for_mime "$mime_type")

  local default_app
  default_app=$(get_default_app)

  # Build selection list
  local selection_list=""
  if [ -n "$available_apps" ]; then
    selection_list="$available_apps"$'\n'
  fi
  selection_list="${selection_list}Open with default apps (xdg-open)"

  # Show selection dialog to user
  local selected_app
  selected_app=$(echo "$selection_list" | fuzzel --dmenu -w 100 -l 10 -p "Open with: " 2>/dev/null) || {
    # User cancelled
    exit 0
  }

  if [ -z "$selected_app" ]; then
    exit 0
  fi

  # Extract app name
  local app
  if [[ "$selected_app" == *"default apps"* ]]; then
    app="$default_app"
  else
    app="$selected_app"
  fi

  open_with_app "$app" "$file_path"

  exit 0
}

# Run main
main "$@"
