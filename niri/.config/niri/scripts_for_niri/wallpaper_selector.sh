#!/bin/bash

# 壁紙ディレクトリを指定（必要に応じて変更）
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# swwwで利用可能なモニターを取得
get_monitors() {
    swww query | awk -F': ' 'NF>1 {print $2}' | awk -F':' '{print $1}'
}

# モニターを取得
monitors=($(get_monitors))

if [ ${#monitors[@]} -eq 0 ]; then
    echo "Error: No monitors found"
    exit 1
fi

# 単一モニターの場合は従来通りの処理
if [ ${#monitors[@]} -eq 1 ]; then
    selected=$(fd -e jpg -e png -e jpeg . "$WALLPAPER_DIR" | fuzzel --dmenu -w 100 -i -p "Select Wallpaper (Press Esc to skip)>")
    if [ -n "$selected" ]; then
        swww img "$selected"
    fi
else
    # 複数モニターの場合：各モニターに壁紙を選択
    # Escキーでスキップすることで、そのモニターの壁紙は変更されません
    for monitor in "${monitors[@]}"; do
        selected=$(fd -e jpg -e png -e jpeg . "$WALLPAPER_DIR" | fuzzel --dmenu -w 100 -i -p "Select Wallpaper for $monitor (Press Esc to skip)>")
        if [ -n "$selected" ]; then
            swww img --outputs "$monitor" "$selected"
        fi
    done
fi
