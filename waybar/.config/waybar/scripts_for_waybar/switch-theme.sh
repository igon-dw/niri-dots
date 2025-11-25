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

# テンプレートファイルの存在確認
if [ ! -f "$TEMPLATE" ]; then
  echo "Error: $TEMPLATE not found."
  exit 2
fi

# 引数なしの場合、fuzzelで選択
if [ -z "$1" ]; then
  # themes/ ディレクトリからテーマ一覧を取得
  if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: themes directory not found."
    exit 2
  fi

  # .cssファイルから拡張子を除いてリスト化
  THEME_LIST=$(cd "$THEMES_DIR" && ls -1 *.css 2>/dev/null | sed 's/\.css$//' || echo "")

  if [ -z "$THEME_LIST" ]; then
    echo "Error: No theme files found in $THEMES_DIR"
    exit 2
  fi

  # fuzzelで選択
  if command -v fuzzel >/dev/null 2>&1; then
    SELECTED_THEME=$(echo "$THEME_LIST" | fuzzel --dmenu --prompt "Select theme: ")

    if [ -z "$SELECTED_THEME" ]; then
      echo "Theme selection cancelled."
      exit 0
    fi

    # 選択されたテーマで再帰呼び出し
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

# テーマファイルの存在確認
THEME_FILE="$1.css"
THEME_PATH="$DIR/themes/$THEME_FILE"

if [ ! -f "$THEME_PATH" ]; then
  echo "Error: Theme '$1' not found."
  echo ""
  echo "Available themes:"
  cd "$THEMES_DIR" && ls -1 *.css 2>/dev/null | sed 's/\.css$//' | sed 's/^/  /' || echo "  (none)"
  exit 1
fi

# テーマ名を整形（ハイフンをスペースに、最初の文字を大文字に）
THEME_NAME=$(echo "$1" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# テンプレートからstyle.cssを生成
cp "$TEMPLATE" "$TARGET"

# sed で @import "themes/XXX.css" の行を書き換え
sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$THEME_FILE\";|" "$TARGET"

if [ $? -ne 0 ]; then
  echo "Error: Theme switching failed."
  exit 3
fi

echo "✓ Theme switched to '$THEME_NAME' ($THEME_FILE)"

# Waybar再起動
if command -v pkill >/dev/null 2>&1; then
  pkill -x waybar 2>/dev/null || true
  sleep 0.5

  # nohupでバックグラウンド実行
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
