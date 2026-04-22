if ! command -v abbr >/dev/null 2>&1; then
  return
fi

bindkey " " abbr-expand-and-insert 2>/dev/null

_abbr_add() {
  local name="$1"
  shift
  local expansion="$*"

  if [[ ${ABBR_REGULAR_SESSION_ABBREVIATIONS[$name]-} != "$expansion" ]]; then
    abbr -S --quiet --force "$name=$expansion"
  fi
}

_abbr_add ls 'eza -a --icons'
_abbr_add ll 'eza -al --icons'
_abbr_add lt2 'eza -a --tree --level=2 --icons --ignore-glob=".git|node_modules"'
_abbr_add lt3 'eza -a --tree --level=3 --icons --ignore-glob=".git|node_modules"'
_abbr_add lt4 'eza -a --tree --level=4 --icons --ignore-glob=".git|node_modules"'
_abbr_add lt5 'eza -a --tree --level=5 --icons --ignore-glob=".git|node_modules"'

if command -v fd >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
  _abbr_add cdf 'cd $(fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf)'
fi

_abbr_add lzg 'lazygit'
_abbr_add cvim 'NVIM_APPNAME=cvim nvim'
_abbr_add cplt 'copilot'
_abbr_add cpltr 'copilot --resume'
_abbr_add oc 'opencode'
_abbr_add ocw 'opencode web'
_abbr_add ttc 'tty-clock -sc -C 6 -t'
_abbr_add ffclip 'ffmpeg -hide_banner -y -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -ss 00:00:00 -to 00:01:00 -i input.mp4 -vf "format=nv12,hwupload" -c:v av1_vaapi -qr 18 -c:a aac -b:a 192k output_clip.mp4'

unset -f _abbr_add
