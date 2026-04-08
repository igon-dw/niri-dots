#!/bin/bash

# Icon helpers for the fzf-based quick opener.

set -euo pipefail

get_path_kind() {
  local path="$1"
  local name="${path##*/}"
  local lower_name="${name,,}"

  if [ -L "$path" ]; then
    if [ -d "$path" ]; then
      echo "link_dir"
    else
      echo "link_file"
    fi
    return 0
  fi

  if [ -d "$path" ]; then
    echo "directory"
    return 0
  fi

  if [ -x "$path" ] && [ -f "$path" ]; then
    echo "executable"
    return 0
  fi

  case "$lower_name" in
    *.md|*.markdown|*.rst|*.txt)
      echo "text"
      ;;
    *.sh|*.bash|*.zsh|*.fish)
      echo "shell"
      ;;
    *.json|*.jsonc)
      echo "json"
      ;;
    *.yaml|*.yml|*.toml|*.ini|*.conf|*.kdl)
      echo "config"
      ;;
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg|*.avif)
      echo "image"
      ;;
    *.mp4|*.mkv|*.webm|*.mov|*.avi)
      echo "video"
      ;;
    *.mp3|*.ogg|*.flac|*.wav|*.m4a)
      echo "audio"
      ;;
    *.zip|*.tar|*.gz|*.xz|*.bz2|*.7z|*.rar)
      echo "archive"
      ;;
    *.pdf|*.epub)
      echo "document"
      ;;
    *.rs|*.go|*.py|*.js|*.ts|*.tsx|*.jsx|*.c|*.cc|*.cpp|*.h|*.hpp|*.java|*.lua)
      echo "code"
      ;;
    *)
      echo "file"
      ;;
  esac
}

get_icon_for_kind() {
  local kind="$1"

  case "$kind" in
    directory)
      echo ""
      ;;
    link_dir)
      echo ""
      ;;
    link_file)
      echo ""
      ;;
    executable)
      echo ""
      ;;
    text)
      echo "󰈙"
      ;;
    shell)
      echo ""
      ;;
    json)
      echo ""
      ;;
    config)
      echo ""
      ;;
    image)
      echo "󰋩"
      ;;
    video)
      echo "󰕧"
      ;;
    audio)
      echo "󰎆"
      ;;
    archive)
      echo "󰗄"
      ;;
    document)
      echo "󰈦"
      ;;
    code)
      echo "󰆍"
      ;;
    *)
      echo "󰈔"
      ;;
  esac
}

get_label_for_kind() {
  local kind="$1"

  case "$kind" in
    directory)
      echo "DIR "
      ;;
    link_dir)
      echo "LNKD"
      ;;
    link_file)
      echo "LNKF"
      ;;
    executable)
      echo "EXEC"
      ;;
    text)
      echo "TEXT"
      ;;
    shell)
      echo "SH  "
      ;;
    json)
      echo "JSON"
      ;;
    config)
      echo "CONF"
      ;;
    image)
      echo "IMG "
      ;;
    video)
      echo "VID "
      ;;
    audio)
      echo "AUD "
      ;;
    archive)
      echo "ARCH"
      ;;
    document)
      echo "DOC "
      ;;
    code)
      echo "CODE"
      ;;
    *)
      echo "FILE"
      ;;
  esac
}

get_icon_for_path() {
  local path="$1"
  local kind
  kind=$(get_path_kind "$path")
  get_icon_for_kind "$kind"
}
