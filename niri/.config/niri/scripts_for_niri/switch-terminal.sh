#!/bin/bash
# Terminal switcher script for niri and waybar configurations
# Switches between kitty and ghostty by updating symlinks inside the repository.
# stow manages the link from ~/.config to this repository, so no stow operations needed.

set -euo pipefail

# Repository root (relative to this script's location)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NIRI="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_WAYBAR="$(cd "$REPO_NIRI/../../waybar/.config/waybar" && pwd)"

NIRI_LINK="$REPO_NIRI/config.kdl"
WAYBAR_LINK="$REPO_WAYBAR/config.jsonc"

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

# Update symlinks in the repository (stow propagates these to ~/.config automatically)
case "$SELECTED" in
kitty)
	ln -sf config.kdl.kitty "$NIRI_LINK"
	ln -sf config.jsonc.kitty "$WAYBAR_LINK"
	;;
ghostty)
	ln -sf config.kdl.ghostty "$NIRI_LINK"
	ln -sf config.jsonc.ghostty "$WAYBAR_LINK"
	;;
*)
	echo "Unknown terminal: $SELECTED"
	exit 1
	;;
esac

echo "✓ Switched to $SELECTED"
echo "Please reload niri config (niri msg action reload-config) for changes to take effect"

# Send notification
if command -v notify-send >/dev/null 2>&1; then
	notify-send "✓ Terminal Switched" "Now using $SELECTED" -u normal
fi
