#!/bin/sh
# List available Kitty themes
# Usage:
#   ./list-themes.sh         # Show formatted list with current theme marked
#   ./list-themes.sh --simple # Show simple list (for fuzzel/dmenu)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KITTY_DIR="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$KITTY_DIR/themes"

if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: Themes directory not found at $THEMES_DIR" >&2
    exit 1
fi

# Get current theme if it exists
CURRENT=""
if [ -L "$KITTY_DIR/current-theme.conf" ]; then
    CURRENT=$(readlink "$KITTY_DIR/current-theme.conf" | sed 's|./themes/||' | sed 's|\.conf$||')
fi

# Simple mode for fuzzel/dmenu (just theme names)
if [ "$1" = "--simple" ]; then
    for theme_file in "$THEMES_DIR"/*.conf; do
        if [ -f "$theme_file" ]; then
            basename "$theme_file" .conf
        fi
    done
    exit 0
fi

# Formatted mode (default)
echo "Available themes:"
echo ""

for theme_file in "$THEMES_DIR"/*.conf; do
    if [ -f "$theme_file" ]; then
        theme_name=$(basename "$theme_file" .conf)
        if [ "$theme_name" = "$CURRENT" ]; then
            echo "  * $theme_name (current)"
        else
            echo "    $theme_name"
        fi
    fi
done
