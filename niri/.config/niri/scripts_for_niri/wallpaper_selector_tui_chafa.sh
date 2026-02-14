#!/bin/bash
# Wallpaper selector TUI using chafa
# Works with any terminal (uses block characters or sixel)

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Image preview using chafa
# --format=symbols: fastest (block chars), or use sixel/kitty for quality
# --optimize=0: skip optimization for speed (0-9, higher=slower)
preview_image() {
  chafa --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" \
    --format=kitty --optimize=0 --animate=off "$1" 2>/dev/null
}
export -f preview_image

# Get monitors from swww
monitors=($(swww query | awk -F': ' 'NF>1 {print $2}' | awk -F':' '{print $1}'))
[[ ${#monitors[@]} -eq 0 ]] && {
  echo "Error: No monitors found"
  exit 1
}

# Wallpaper selection with fzf
select_wallpaper() {
  fd -e jpg -e png -e jpeg . "$WALLPAPER_DIR" | fzf \
    --preview 'bash -c "preview_image {}"' \
    --preview-window 'right:50%' \
    --header "$1" --prompt '🖼️  ' --border --height 100%
}

if [[ ${#monitors[@]} -eq 1 ]]; then
  selected=$(select_wallpaper "Select Wallpaper (ESC to cancel)")
  [[ -n "$selected" ]] && swww img "$selected" && echo "✓ Set: $(basename "$selected")"
else
  # Multiple monitors: select wallpaper for each
  for m in "${monitors[@]}"; do
    selected=$(select_wallpaper "Select for $m (ESC to skip)")
    [[ -n "$selected" ]] && swww img --outputs "$m" "$selected" && echo "✓ $m: $(basename "$selected")"
  done
fi
