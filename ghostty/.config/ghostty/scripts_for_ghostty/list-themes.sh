#!/bin/sh
# List available Ghostty themes
# Usage:
#   ./list-themes.sh         # Show formatted list with current theme marked
#   ./list-themes.sh --simple # Show simple list (for fuzzel/dmenu)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GHOSTTY_DIR="$(dirname "$SCRIPT_DIR")"
THEME_CONF="$GHOSTTY_DIR/theme.conf"

# Get current theme if it exists
CURRENT=""
if [ -f "$THEME_CONF" ]; then
    CURRENT=$(grep "^theme = " "$THEME_CONF" | sed 's/^theme = //')
fi

# Simple mode for fuzzel/dmenu (just theme names)
if [ "$1" = "--simple" ]; then
    ghostty +list-themes 2>/dev/null | sed 's/ (resources)$//'
    exit 0
fi

# Formatted mode (default)
echo "Available themes:"
echo ""

ghostty +list-themes 2>/dev/null | sed 's/ (resources)$//' | while IFS= read -r theme_name; do
    if [ "$theme_name" = "$CURRENT" ]; then
        echo "  * $theme_name (current)"
    else
        echo "    $theme_name"
    fi
done
