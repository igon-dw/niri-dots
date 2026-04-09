#!/bin/sh
# Kitty Theme Switcher Script
# Usage: ./switch-theme.sh [theme]
#
# If no theme is specified, fuzzel will be used to interactively select a theme.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KITTY_DIR="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$KITTY_DIR/themes"
CURRENT_THEME_LINK="$KITTY_DIR/current-theme.conf"
DEFAULT_THEME="Earthsong"

# Check that the theme directory exists.
if [ ! -d "$THEMES_DIR" ]; then
  echo "Error: Themes directory not found at $THEMES_DIR" >&2
  exit 2
fi

# Initialize current-theme.conf if it does not exist yet (first-time setup).
if [ ! -e "$CURRENT_THEME_LINK" ]; then
  echo "Initializing theme configuration with default theme: $DEFAULT_THEME"

  if [ ! -f "$THEMES_DIR/$DEFAULT_THEME.conf" ]; then
    echo "Error: Default theme '$DEFAULT_THEME' not found." >&2
    exit 2
  fi

  ln -s "./themes/$DEFAULT_THEME.conf" "$CURRENT_THEME_LINK"
  echo "✓ Initialized with theme: $DEFAULT_THEME"
  echo ""
fi

# If no argument is given, prompt with fuzzel.
if [ -z "$1" ]; then
  # Check whether fuzzel is installed.
  if command -v fuzzel >/dev/null 2>&1; then
    THEME_LIST=$("$SCRIPT_DIR/list-themes.sh" --simple)

    if [ -z "$THEME_LIST" ]; then
      echo "Error: No theme files found in $THEMES_DIR" >&2
      exit 2
    fi

    SELECTED_THEME=$(echo "$THEME_LIST" | fuzzel --dmenu --prompt "Select Kitty theme: ")

    if [ -z "$SELECTED_THEME" ]; then
      echo "Theme selection cancelled."
      exit 0
    fi

    # Re-run the script with the selected theme.
    exec "$SCRIPT_DIR/$(basename "$0")" "$SELECTED_THEME"
  else
    echo "Error: No theme specified and fuzzel is not installed." >&2
    echo "Please install fuzzel or specify a theme manually." >&2
    echo "" >&2
    echo "Usage: $0 <theme-name>" >&2
    echo "" >&2
    "$SCRIPT_DIR/list-themes.sh"
    exit 2
  fi
fi

THEME_NAME="$1"
THEME_FILE="$THEMES_DIR/$THEME_NAME.conf"

# Check that the theme file exists.
if [ ! -f "$THEME_FILE" ]; then
  echo "Error: Theme '$THEME_NAME' not found." >&2
  echo "Theme file expected at: $THEME_FILE" >&2
  echo "" >&2
  "$SCRIPT_DIR/list-themes.sh"
  exit 1
fi

# Update the symbolic link using a relative path to keep it portable.
ln -sf "./themes/$THEME_NAME.conf" "$CURRENT_THEME_LINK"

echo "✓ Theme set to: $THEME_NAME"

# Apply the change to running Kitty instances.
if command -v kitty >/dev/null 2>&1 && pgrep -x kitty >/dev/null 2>&1; then
  if kitty @ set-colors --all --configured "$CURRENT_THEME_LINK" 2>/dev/null; then
    echo "✓ Applied to running kitty instances"
  else
    echo "Note: Could not apply to running instances. Restart kitty or reload config."
  fi
else
  echo "Note: No running kitty instances found. Theme will apply on next launch."
fi

# Send success notification
notify-send "✓ Kitty Theme Changed" "Successfully switched to '$THEME_NAME'" -u low

exit 0
