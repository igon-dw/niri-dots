#!/bin/bash
set -euo pipefail

WAYBAR_THEMES_DIR="$HOME/.config/waybar/themes"
KITTY_THEMES_DIR="$HOME/.config/kitty/themes"

# Get theme list from waybar (base)
THEME_LIST=$(cd "$WAYBAR_THEMES_DIR" && ls -1 *.css 2>/dev/null | sed 's/\.css$//' || echo "")

if [ -z "$THEME_LIST" ]; then
  echo "Error: No theme files found"
  exit 1
fi

# Select theme once with fuzzel
if command -v fuzzel >/dev/null 2>&1; then
  SELECTED_THEME=$(echo "$THEME_LIST" | fuzzel --dmenu --prompt "Select theme: ")

  if [ -z "$SELECTED_THEME" ]; then
    exit 0
  fi
else
  echo "Error: fuzzel is not installed"
  exit 1
fi

# Apply to waybar
if ~/.config/waybar/scripts_for_waybar/switch-theme.sh "$SELECTED_THEME"; then
  WAYBAR_SUCCESS=true
else
  WAYBAR_SUCCESS=false
fi

# Check if theme exists in kitty
if [ -f "$KITTY_THEMES_DIR/$SELECTED_THEME.conf" ]; then
  if ~/.config/kitty/scripts_for_kitty/switch-theme.sh "$SELECTED_THEME"; then
    KITTY_SUCCESS=true
  else
    KITTY_SUCCESS=false
  fi
else
  notify-send "Theme '$SELECTED_THEME' not found in Kitty" "Please select a Kitty theme manually" -u normal
  if ~/.config/kitty/scripts_for_kitty/switch-theme.sh; then
    KITTY_SUCCESS=true
  else
    KITTY_SUCCESS=false
  fi
fi

# Notify on successful completion
if [ "$WAYBAR_SUCCESS" = true ] && [ "$KITTY_SUCCESS" = true ]; then
  THEME_NAME=$(echo "$SELECTED_THEME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
  notify-send "✓ Theme Changed" "Successfully switched to '$THEME_NAME'" -u normal
fi
