#!/bin/bash

# Specify wallpaper directory (change as needed)
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Get available monitors from swww
get_monitors() {
    swww query | awk -F': ' 'NF>1 {print $2}' | awk -F':' '{print $1}'
}

# Get monitors
monitors=($(get_monitors))

if [ ${#monitors[@]} -eq 0 ]; then
    echo "Error: No monitors found"
    exit 1
fi

# Single monitor: standard processing
if [ ${#monitors[@]} -eq 1 ]; then
    selected=$(fd -e jpg -e png -e jpeg . "$WALLPAPER_DIR" | fuzzel --dmenu -w 100 -i -p "Select Wallpaper (Press Esc to skip)>")
    if [ -n "$selected" ]; then
        swww img "$selected"
    fi
else
    # Multiple monitors: select wallpaper for each monitor
    # Press Esc to skip and keep the current wallpaper for that monitor
    for monitor in "${monitors[@]}"; do
        selected=$(fd -e jpg -e png -e jpeg . "$WALLPAPER_DIR" | fuzzel --dmenu -w 100 -i -p "Select Wallpaper for $monitor (Press Esc to skip)>")
        if [ -n "$selected" ]; then
            swww img --outputs "$monitor" "$selected"
        fi
    done
fi
