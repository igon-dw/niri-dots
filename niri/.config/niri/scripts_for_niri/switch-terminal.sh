#!/bin/bash
# Terminal switcher script for niri and waybar configurations
# Switches between kitty and ghostty configurations

set -euo pipefail

# Configuration files
NIRI_CONFIG_DIR="$HOME/.config/niri"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"

NIRI_CONFIG="$NIRI_CONFIG_DIR/config.kdl"
WAYBAR_CONFIG="$WAYBAR_CONFIG_DIR/config.jsonc"

# Available terminals
TERMINALS=("kitty" "ghostty")

# Select terminal
if command -v fuzzel >/dev/null 2>&1; then
	SELECTED=$(printf '%s\n' "${TERMINALS[@]}" | fuzzel --dmenu --prompt "Select terminal: ")
else
	echo "Available terminals:"
	for i in "${!TERMINALS[@]}"; do
		echo "$((i + 1)). ${TERMINALS[i]}"
	done
	echo -n "Select terminal (1-${#TERMINALS[@]}): "
	read -r choice
	if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#TERMINALS[@]}" ]; then
		SELECTED="${TERMINALS[$((choice - 1))]}"
	else
		echo "Invalid choice"
		exit 1
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
