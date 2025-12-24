#!/bin/bash

# f2_launcher: Advanced Fuzzy File Launcher with MIME-type support
# -------------------------------------------------------------------
# An improved version of f2_launcher that reads configuration files
# and opens files with appropriate applications based on MIME types.
# Supports multiple candidate applications per MIME type and user selection.
# -------------------------------------------------------------------

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/f2_launcher.toml"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Parse TOML value using yq (mikefarah/yq supports TOML)
get_config_value() {
  local key="$1"
  yq eval "$key" "$CONFIG_FILE" 2>/dev/null || echo ""
}

# Get array values from TOML
get_config_array() {
  local key="$1"
  yq eval "$key[]" "$CONFIG_FILE" 2>/dev/null | grep -v "^null$" || true
}

# Get default terminal
get_default_terminal() {
  local term
  term=$(get_config_value '.default_terminal')

  # Auto-detect if not configured or null
  if [ -z "$term" ] || [ "$term" = "null" ]; then
    for t in "${TERMINAL:-}" foot kitty alacritty xterm; do
      if [ -n "$t" ] && command -v "$t" &> /dev/null; then
        echo "$t"
        return 0
      fi
    done
    echo "xterm"  # fallback
  else
    echo "$term"
  fi
}

# Show error in terminal
show_error_terminal() {
  local message="$1"
  local term
  term=$(get_default_terminal)

  if command -v "$term" &> /dev/null; then
    "$term" -e bash -c "echo 'Error: $message'; sleep 3" 2>/dev/null &
  fi
}

# Show notification (fallback)
show_notification() {
  local message="$1"
  local urgency="${2:-normal}"

  if command -v notify-send &> /dev/null; then
    notify-send -u "$urgency" "f2_launcher" "$message"
  fi
}

# Check if command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Get app type (cli or gui)
get_app_type() {
  local app="$1"
  local app_type
  app_type=$(yq eval ".app_metadata[\"$app\"]" "$CONFIG_FILE" 2>/dev/null)

  if [ -z "$app_type" ] || [ "$app_type" = "null" ]; then
    # Default to gui if not specified
    echo "gui"
  else
    echo "$app_type"
  fi
}

# Get all configured apps for MIME type
get_all_apps_for_mime() {
  local mime_type="$1"
  yq eval ".mime_types[\"$mime_type\"][]" "$CONFIG_FILE" 2>/dev/null || echo ""
}

# Get available apps (filter only installed apps)
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

# Build exclude patterns for fd
build_exclude_args() {
  local excludes
  excludes=$(yq eval '.launcher.fuzzel.exclude[]' "$CONFIG_FILE" 2>/dev/null || echo "")

  local args=""
  while IFS= read -r pattern; do
    if [ -n "$pattern" ] && [ "$pattern" != "null" ]; then
      args="$args --exclude $pattern"
    fi
  done <<< "$excludes"

  echo "$args"
}

# Get fuzzel dmenu arguments
get_fuzzel_args() {
  local args
  args=$(get_config_value '.launcher.fuzzel.dmenu_args')

  if [ -z "$args" ] || [ "$args" = "null" ]; then
    echo "-w 120 -l 20"
  else
    echo "$args"
  fi
}

# ============================================================================
# MAIN LOGIC
# ============================================================================

main() {
  # Verify config file exists
  if [ ! -f "$CONFIG_FILE" ]; then
    show_error_terminal "Configuration file not found at $CONFIG_FILE"
    show_notification "Configuration file not found" "critical"
    exit 1
  fi

  # Build fd command arguments
  local exclude_args
  exclude_args=$(build_exclude_args)

  local fuzzel_args
  fuzzel_args=$(get_fuzzel_args)

  # Select file using fd and fuzzel
  local selected
  # shellcheck disable=SC2086
  selected=$(fd --hidden \
    --base-directory "$HOME" \
    $exclude_args \
    . | fuzzel --dmenu $fuzzel_args 2>/dev/null) || {
    # User cancelled
    exit 0
  }

  # Exit if empty
  if [ -z "$selected" ]; then
    exit 0
  fi

  # Convert to absolute path
  local file_path="$HOME/$selected"

  # Verify file exists
  if [ ! -e "$file_path" ]; then
    show_error_terminal "File no longer exists: $selected"
    show_notification "File no longer exists: $selected" "normal"
    exit 1
  fi

  # Get MIME type
  local mime_type
  mime_type=$(file --mime-type -b "$file_path" 2>/dev/null) || {
    show_error_terminal "Cannot determine MIME type for: $selected"
    show_notification "Cannot determine MIME type" "normal"
    exit 1
  }

  # Get available apps for this MIME type
  local available_apps
  available_apps=$(get_available_apps_for_mime "$mime_type")

  local default_app
  default_app=$(get_config_value '.default_app')
  if [ -z "$default_app" ] || [ "$default_app" = "null" ]; then
    default_app="xdg-open"
  fi

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

  # Launch application
  if ! command_exists "$app"; then
    show_error_terminal "Application not found: $app"
    show_notification "Application not found: $app" "normal"
    exit 1
  fi

  # Check if app is CLI or GUI
  local app_type
  app_type=$(get_app_type "$app")

  if [ "$app_type" = "cli" ]; then
    # CLI application - launch in terminal
    local term
    term=$(get_default_terminal)

    if command_exists "$term"; then
      nohup "$term" -e "$app" "$file_path" &>/dev/null &
    else
      show_error_terminal "Terminal not found to run CLI app: $app"
      show_notification "Terminal not found to run CLI app: $app" "normal"
      exit 1
    fi
  else
    # GUI application - launch directly
    nohup "$app" "$file_path" &>/dev/null &
  fi

  exit 0
}

# Run main
main "$@"
