#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NIRI="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPO_WAYBAR="$REPO_ROOT/waybar/.config/waybar"

WAYBAR_THEMES_DIR="$HOME/.config/waybar/themes"
KITTY_THEMES_DIR="$HOME/.config/kitty/themes"
NIRI_LINK="$REPO_NIRI/config.kdl"
WAYBAR_LINK="$REPO_WAYBAR/config.jsonc"

detect_active_terminal() {
	local niri_target=""
	local waybar_target=""

	if [ -L "$NIRI_LINK" ]; then
		niri_target="$(basename "$(readlink "$NIRI_LINK")")"
	fi

	if [ -L "$WAYBAR_LINK" ]; then
		waybar_target="$(basename "$(readlink "$WAYBAR_LINK")")"
	fi

	case "$niri_target:$waybar_target" in
	config.kdl.kitty:config.jsonc.kitty | config.kdl.kitty:)
		echo "kitty"
		;;
	config.kdl.ghostty:config.jsonc.ghostty | config.kdl.ghostty:)
		echo "ghostty"
		;;
	:config.jsonc.kitty)
		echo "kitty"
		;;
	:config.jsonc.ghostty)
		echo "ghostty"
		;;
	*)
		echo "unknown"
		;;
	esac
}

apply_kitty_theme() {
	local theme="$1"
	local switcher="$HOME/.config/kitty/scripts_for_kitty/switch-theme.sh"

	if [ ! -x "$switcher" ]; then
		echo "Kitty switcher not found: $switcher" >&2
		return 1
	fi

	if [ -f "$KITTY_THEMES_DIR/$theme.conf" ]; then
		"$switcher" "$theme"
	else
		notify-send "Theme '$theme' not found in Kitty" "Please select a Kitty theme manually" -u normal
		"$switcher"
	fi
}

apply_ghostty_theme() {
	local theme="$1"
	local switcher="$HOME/.config/ghostty/scripts_for_ghostty/switch-theme.sh"

	if [ ! -x "$switcher" ]; then
		echo "Ghostty switcher not found: $switcher" >&2
		return 1
	fi

	if command -v ghostty >/dev/null 2>&1 && ghostty +list-themes 2>/dev/null | sed 's/ (resources)$//' | grep -Fxq "$theme"; then
		"$switcher" "$theme"
	else
		notify-send "Theme '$theme' not found in Ghostty" "Please select a Ghostty theme manually" -u normal
		"$switcher"
	fi
}

# TODO: Replace ls-based enumeration with a safer glob/find approach if theme filenames need broader character support.
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

ACTIVE_TERMINAL="$(detect_active_terminal)"

# Apply to waybar
if ~/.config/waybar/scripts_for_waybar/switch-theme.sh "$SELECTED_THEME"; then
	WAYBAR_SUCCESS=true
else
	WAYBAR_SUCCESS=false
fi

# Apply terminal themes, prioritizing the currently selected terminal profile.
KITTY_SUCCESS=false
GHOSTTY_SUCCESS=false

if [ "$ACTIVE_TERMINAL" = "ghostty" ]; then
	if apply_ghostty_theme "$SELECTED_THEME"; then
		GHOSTTY_SUCCESS=true
	else
		GHOSTTY_SUCCESS=false
	fi
elif [ "$ACTIVE_TERMINAL" = "kitty" ]; then
	if apply_kitty_theme "$SELECTED_THEME"; then
		KITTY_SUCCESS=true
	else
		KITTY_SUCCESS=false
	fi
else
	notify-send "Active terminal profile could not be detected" "Skipping terminal theme update" -u normal
fi

# Notify on successful completion
if [ "$WAYBAR_SUCCESS" = true ] && { [ "$KITTY_SUCCESS" = true ] || [ "$GHOSTTY_SUCCESS" = true ]; }; then
	THEME_NAME=$(echo "$SELECTED_THEME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
	notify-send "✓ Theme Changed" "Successfully switched to '$THEME_NAME'" -u normal
fi
