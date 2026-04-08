#!/bin/bash

# f2_launcher: Fast Fuzzy File Launcher
# -------------------------------------------------------------
# "f2" stands for "Fast Fuzzy" — a modern, blazing-fast file
# launcher inspired by popular OSS tools. Select files from your
# home directory using fuzzel's fuzzy search and instantly open
# them in zeditor.
# -------------------------------------------------------------

selected=$(fd --hidden \
  --base-directory "$HOME" \
  --exclude .git \
  --exclude node_modules \
  . | fuzzel --dmenu -w 120 -l 20)

# If selection is cancelled, exit silently
if [ -z "$selected" ]; then
  exit 0
fi

# Convert relative path to absolute and launch in zeditor
zeditor "$HOME/$selected"
