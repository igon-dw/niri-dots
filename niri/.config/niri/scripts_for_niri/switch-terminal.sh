#!/bin/bash
# Terminal switcher script for niri and waybar configurations
# Switches between kitty and ghostty configurations
# Note: This manages symlinks in the home directory, not in the repository

set -euo pipefail

# Configuration files in home directory
NIRI_CONFIG="$HOME/.config/niri/config.kdl"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

# Repository paths
REPO_NIRI_KITTY="$HOME/niri-dots/niri/.config/niri/config.kdl.kitty"
REPO_NIRI_GHOSTTY="$HOME/niri-dots/niri/.config/niri/config.kdl.ghostty"
REPO_WAYBAR_KITTY="$HOME/niri-dots/waybar/.config/waybar/config.jsonc.kitty"
REPO_WAYBAR_GHOSTTY="$HOME/niri-dots/waybar/.config/waybar/config.jsonc.ghostty"

# Available terminals
TERMINALS=("kitty" "ghostty")

# Select terminal
if command -v fuzzel >/dev/null 2>&1; then
  SELECTED=$(printf '%s\n' "${TERMINALS[@]}" | fuzzel --dmenu --prompt "Select terminal: ")
else
  echo "Available terminals:"
  for i in "${!TERMINALS[@]}"; do
    echo "$((i+1)). ${TERMINALS[i]}"
  done
  echo -n "Select terminal (1-${#TERMINALS[@]}): "
  read -r choice
  if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#TERMINALS[@]}" ]; then
    SELECTED="${TERMINALS[$((choice-1))]}"
  else
    echo "Invalid choice"
    exit 1
  fi
fi

if [ -z "$SELECTED" ]; then
  echo "No terminal selected"
  exit 0
fi

# Backup current configs if they exist and are not symlinks (from stow)
if [ -L "$NIRI_CONFIG" ]; then
  echo "Warning: $NIRI_CONFIG is a symlink (probably managed by stow)"
  echo "Please unstow niri first: stow -D niri"
  exit 1
fi

if [ -L "$WAYBAR_CONFIG" ]; then
  echo "Warning: $WAYBAR_CONFIG is a symlink (probably managed by stow)"
  echo "Please unstow waybar first: stow -D waybar"
  exit 1
fi

# Backup current configs if they exist
if [ -f "$NIRI_CONFIG" ]; then
  cp "$NIRI_CONFIG" "$NIRI_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
  echo "Backed up current niri config to $NIRI_CONFIG.backup.*"
fi

if [ -f "$WAYBAR_CONFIG" ]; then
  cp "$WAYBAR_CONFIG" "$WAYBAR_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
  echo "Backed up current waybar config to $WAYBAR_CONFIG.backup.*"
fi

# Create symlinks to repository files
case "$SELECTED" in
  kitty)
    ln -sf "$REPO_NIRI_KITTY" "$NIRI_CONFIG"
    ln -sf "$REPO_WAYBAR_KITTY" "$WAYBAR_CONFIG"
    ;;
  ghostty)
    ln -sf "$REPO_NIRI_GHOSTTY" "$NIRI_CONFIG"
    ln -sf "$REPO_WAYBAR_GHOSTTY" "$WAYBAR_CONFIG"
    ;;
  *)
    echo "Unknown terminal: $SELECTED"
    exit 1
    ;;
esac

echo "✓ Switched to $SELECTED"
echo "Please restart niri (logout/login) for changes to take effect"

# Send notification
if command -v notify-send >/dev/null 2>&1; then
  notify-send "✓ Terminal Switched" "Now using $SELECTED" -u normal
fi
fi

if [ -z "$SELECTED" ]; then
	echo "No terminal selected"
	exit 0
fi

# Backup current configs if they exist and are not symlinks
if [ -f "$NIRI_CONFIG" ] && [ ! -L "$NIRI_CONFIG" ]; then
	cp "$NIRI_CONFIG" "$NIRI_CONFIG.backup"
	echo "Backed up current niri config to $NIRI_CONFIG.backup"
fi

if [ -f "$WAYBAR_CONFIG" ] && [ ! -L "$WAYBAR_CONFIG" ]; then
	cp "$WAYBAR_CONFIG" "$WAYBAR_CONFIG.backup"
	echo "Backed up current waybar config to $WAYBAR_CONFIG.backup"
fi

# Create symlinks
case "$SELECTED" in
kitty)
	ln -sf "$NIRI_CONFIG_DIR/config.kdl.kitty" "$NIRI_CONFIG"
	ln -sf "$WAYBAR_CONFIG_DIR/config.jsonc.kitty" "$WAYBAR_CONFIG"
	;;
ghostty)
	ln -sf "$NIRI_CONFIG_DIR/config.kdl.ghostty" "$NIRI_CONFIG"
	ln -sf "$WAYBAR_CONFIG_DIR/config.jsonc.ghostty" "$WAYBAR_CONFIG"
	;;
*)
	echo "Unknown terminal: $SELECTED"
	exit 1
	;;
esac

echo "✓ Switched to $SELECTED"
echo "Please restart niri (logout/login) for changes to take effect"

# Send notification
if command -v notify-send >/dev/null 2>&1; then
	notify-send "✓ Terminal Switched" "Now using $SELECTED" -u normal
fi
