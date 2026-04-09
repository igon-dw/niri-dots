#!/bin/sh
# Waybar Theme Switcher Script
# Usage: ./switch-theme.sh [theme]
# Available themes: catppuccin, original, nord, gruvbox, tokyo-night, solarized
#
# If no theme is specified, fuzzel will be used to interactively select a theme.

set -e

STYLE_CSS="style.css"
STYLE_TEMPLATE="style.css.template"
DIR="$(dirname "$0")/.."
TARGET="$DIR/$STYLE_CSS"
TEMPLATE="$DIR/$STYLE_TEMPLATE"
THEMES_DIR="$DIR/themes"

list_themes() {
  find "$THEMES_DIR" -maxdepth 1 -type f -name '*.css' -exec basename {} .css \; | sort
}

# Check that the template file exists.
if [ ! -f "$TEMPLATE" ]; then
  echo "Error: $TEMPLATE not found."
  exit 2
fi

# If no argument is given, prompt with fuzzel.
if [ -z "$1" ]; then
  # Collect the theme list from the themes/ directory.
  if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: themes directory not found."
    exit 2
  fi

  # Strip the .css extension and build the list.
  THEME_LIST=$(list_themes)

  if [ -z "$THEME_LIST" ]; then
    echo "Error: No theme files found in $THEMES_DIR"
    exit 2
  fi

  # Let fuzzel handle interactive selection.
  if command -v fuzzel >/dev/null 2>&1; then
    SELECTED_THEME=$(echo "$THEME_LIST" | fuzzel --dmenu --prompt "Select theme: ")

    if [ -z "$SELECTED_THEME" ]; then
      echo "Theme selection cancelled."
      exit 0
    fi

    # Re-run the script with the selected theme.
    exec "$0" "$SELECTED_THEME"
  else
    echo "Error: fuzzel is not installed."
    echo "Please install fuzzel or specify a theme manually."
    echo ""
    echo "Available themes:"
    echo "$THEME_LIST"
    exit 2
  fi
fi

# Check that the selected theme file exists.
THEME_FILE="$1.css"
THEME_PATH="$DIR/themes/$THEME_FILE"

if [ ! -f "$THEME_PATH" ]; then
  echo "Error: Theme '$1' not found."
  echo ""
  echo "Available themes:"
  if ! list_themes | sed 's/^/  /'; then
    echo "  (none)"
  fi
  exit 1
fi

# Format the theme name by replacing hyphens with spaces and capitalizing words.
THEME_NAME=$(echo "$1" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Generate style.css from the template.
cp "$TEMPLATE" "$TARGET"

# Rewrite the @import "themes/XXX.css" line with sed.
if ! sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$THEME_FILE\";|" "$TARGET"; then
  echo "Error: Theme switching failed."
  exit 3
fi

echo "✓ Theme switched to '$THEME_NAME' ($THEME_FILE)"

# Restart Waybar.
if command -v pkill >/dev/null 2>&1; then
  pkill -x waybar 2>/dev/null || true
  sleep 0.5

  # Run in the background with nohup.
  if command -v nohup >/dev/null 2>&1; then
    nohup waybar >/dev/null 2>&1 &
  else
    waybar >/dev/null 2>&1 &
  fi

  echo "✓ Waybar restarted."
else
  echo "⚠ Please restart Waybar manually."
fi

# Send success notification
notify-send "✓ Waybar Theme Changed" "Successfully switched to '$THEME_NAME'" -u low

exit 0
