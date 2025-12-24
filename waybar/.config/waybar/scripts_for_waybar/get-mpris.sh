#!/bin/bash

# MPRIS情報を取得して、titleだけを制限するスクリプト

# MPRISプレイヤーの情報を取得
PLAYER_INFO=$(playerctl metadata --format '{"player_icon":"{{lc(playerName)}}","title":"{{title}}","artist":"{{artist}}"}' 2>/dev/null)

if [ -z "$PLAYER_INFO" ]; then
    exit 0
fi

# JSONを解析
PLAYER_ICON=$(echo "$PLAYER_INFO" | grep -o '"player_icon":"[^"]*"' | cut -d'"' -f4)
TITLE=$(echo "$PLAYER_INFO" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
ARTIST=$(echo "$PLAYER_INFO" | grep -o '"artist":"[^"]*"' | cut -d'"' -f4)

# titleの最大文字数（調整可能）
TITLE_MAX_LENGTH=20

# titleを制限
if [ ${#TITLE} -gt $TITLE_MAX_LENGTH ]; then
    TITLE="${TITLE:0:$((TITLE_MAX_LENGTH-1))}…"
fi

# player_iconをemoji/iconに変換
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

# 再生状態を確認
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
