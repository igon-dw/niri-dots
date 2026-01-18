#!/bin/sh
# Ghostty Theme Switcher Script
# Usage: ./switch-theme.sh [theme]
#
# If no theme is specified, fuzzel will be used to interactively select a theme.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GHOSTTY_DIR="$(dirname "$SCRIPT_DIR")"
THEME_CONF="$GHOSTTY_DIR/theme.conf"
DEFAULT_THEME="Catppuccin Mocha"

# theme.conf が存在しない場合は初期化（初回セットアップ）
if [ ! -e "$THEME_CONF" ]; then
  echo "Initializing theme configuration with default theme: $DEFAULT_THEME"
  
  cat > "$THEME_CONF" << EOF
# Auto-generated theme configuration
# This file is managed by scripts_for_ghostty/switch-theme.sh
theme = $DEFAULT_THEME
EOF
  
  echo "✓ Initialized with theme: $DEFAULT_THEME"
  echo ""
fi

# 引数なしの場合、fuzzelで選択
if [ -z "$1" ]; then
  # fuzzelがインストールされているか確認
  if command -v fuzzel >/dev/null 2>&1; then
    THEME_LIST=$("$SCRIPT_DIR/list-themes.sh" --simple)
    
    if [ -z "$THEME_LIST" ]; then
      echo "Error: No themes found. Please check ghostty installation." >&2
      exit 2
    fi
    
    SELECTED_THEME=$(echo "$THEME_LIST" | fuzzel --dmenu --prompt "Select Ghostty theme: ")
    
    if [ -z "$SELECTED_THEME" ]; then
      echo "Theme selection cancelled."
      exit 0
    fi
    
    # 選択されたテーマで再帰呼び出し
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

# テーマが存在するか確認（ghostty +list-themesの出力と照合）
if ! ghostty +list-themes 2>/dev/null | sed 's/ (resources)$//' | grep -Fxq "$THEME_NAME"; then
  echo "Error: Theme '$THEME_NAME' not found." >&2
  echo "" >&2
  echo "Run 'ghostty +list-themes' to see available themes." >&2
  exit 1
fi

# theme.conf を更新
cat > "$THEME_CONF" << EOF
# Auto-generated theme configuration
# This file is managed by scripts_for_ghostty/switch-theme.sh
theme = $THEME_NAME
EOF

echo "✓ Theme set to: $THEME_NAME"
echo "✓ Ghostty will automatically reload the configuration"

# Send success notification
if command -v notify-send >/dev/null 2>&1; then
  notify-send "✓ Ghostty Theme Changed" "Successfully switched to '$THEME_NAME'" -u low
fi

exit 0
