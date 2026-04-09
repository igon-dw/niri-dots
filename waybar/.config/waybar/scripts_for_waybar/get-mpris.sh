#!/bin/bash

# Fetch MPRIS metadata and truncate the title.

# Fetch the MPRIS player metadata.
PLAYER_INFO=$(playerctl metadata --format '{"player_icon":"{{lc(playerName)}}","title":"{{title}}","artist":"{{artist}}"}' 2>/dev/null)

if [ -z "$PLAYER_INFO" ]; then
    exit 0
fi

# Parse the JSON payload.
PLAYER_ICON=$(echo "$PLAYER_INFO" | grep -o '"player_icon":"[^"]*"' | cut -d'"' -f4)
TITLE=$(echo "$PLAYER_INFO" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
ARTIST=$(echo "$PLAYER_INFO" | grep -o '"artist":"[^"]*"' | cut -d'"' -f4)

# Maximum title length, adjustable as needed.
TITLE_MAX_LENGTH=20

# Truncate the title if needed.
if [ ${#TITLE} -gt $TITLE_MAX_LENGTH ]; then
    TITLE="${TITLE:0:$((TITLE_MAX_LENGTH-1))}…"
fi

# Map player_icon to an emoji or icon.
case "$PLAYER_ICON" in
    chromium|google-chrome|chrome)
        PLAYER_ICON="󰊯"
        ;;
    firefox)
        PLAYER_ICON="󰈹"
        ;;
    vlc)
        PLAYER_ICON="󰕼"
        ;;
    mpv)
        PLAYER_ICON="󰐹"
        ;;
    spotify)
        PLAYER_ICON="󰓇"
        ;;
    totem)
        PLAYER_ICON="󰎬"
        ;;
    *)
        PLAYER_ICON="󰝚"
        ;;
esac

# Check playback status.
STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" = "Paused" ]; then
    echo "$PLAYER_ICON $TITLE (paused)"
else
    if [ -z "$ARTIST" ]; then
        echo "$PLAYER_ICON $TITLE"
    else
        echo "$PLAYER_ICON $TITLE - $ARTIST"
    fi
fi
