#!/bin/sh
# Get current Waybar theme name
# This script extracts the current theme from style.css

set -e

DIR="$(dirname "$0")/.."
STYLE_CSS="$DIR/style.css"

# Check if style.css exists
if [ ! -f "$STYLE_CSS" ]; then
  echo "unknown"
  exit 0
fi

# Extract theme name from @import line
THEME=$(grep -E '@import "themes/.*\.css";' "$STYLE_CSS" | head -n 1 | sed -E 's/.*themes\/(.*)\.css.*/\1/')

if [ -z "$THEME" ]; then
  echo "unknown"
  exit 0
fi

# Format theme name (convert hyphens to spaces, capitalize first letter of each word)
THEME_NAME=$(echo "$THEME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

echo "$THEME_NAME"
exit 0
