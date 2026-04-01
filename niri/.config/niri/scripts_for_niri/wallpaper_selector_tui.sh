#!/bin/bash
# Wallpaper selector TUI for terminal (kitty, ghostty, etc.)
# Uses kitty graphics protocol (fastest terminal image protocol)
# Note: Ghostty also supports kitty graphics protocol, so this works with both terminals

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Image preview using kitty graphics protocol via kitten icat
preview_image() {
	kitten icat --clear --transfer-mode=memory --stdin=no \
		--place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" "$1" 2>/dev/null
}
export -f preview_image

# Get monitors from awww
monitors=($(awww query | awk -F': ' 'NF>1 {print $2}' | awk -F':' '{print $1}'))
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
	[[ -n "$selected" ]] && awww img "$selected" && echo "✓ Set: $(basename "$selected")"
else
	# Multiple monitors: select wallpaper for each
	for m in "${monitors[@]}"; do
		selected=$(select_wallpaper "Select for $m (ESC to skip)")
		[[ -n "$selected" ]] && awww img --outputs "$m" "$selected" && echo "✓ $m: $(basename "$selected")"
	done
fi
