#!/bin/bash

# ウィンドウ一覧をJSON形式で取得
windows=$(niri msg --json windows)

# AppID と Title を "AppID: Title" 形式で表示、IDを末尾に保持
selected_line=$(echo "$windows" | jq -r '.[] | "\(.app_id): \(.title)|\(.id)"' | fuzzel --dmenu -i -w 100 -l 20 -p "Select Window:")

# 選択がキャンセルされた場合は終了
if [ -z "$selected_line" ]; then
  exit 0
fi

# 選択された行からウィンドウIDを抽出
window_id=$(echo "$selected_line" | cut -d'|' -f2)

# フォーカスを移動
if [ -n "$window_id" ]; then
  niri msg action focus-window --id "$window_id"
fi
