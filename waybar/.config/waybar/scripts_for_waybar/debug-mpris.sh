#!/bin/bash

# デバッグスクリプト：playerctlの出力を確認

echo "=== playerctl status ==="
playerctl status 2>/dev/null || echo "No player found"

echo -e "\n=== playerctl metadata (全て) ==="
playerctl metadata 2>/dev/null || echo "No metadata available"

echo -e "\n=== playerctl metadata --format での出力 ==="
playerctl metadata --format '{"player_icon":"{{lc(playerName)}}","title":"{{title}}","artist":"{{artist}}"}' 2>/dev/null || echo "Error getting metadata"

echo -e "\n=== プレイヤー名のみ ==="
playerctl metadata --format '{{playerName}}' 2>/dev/null || echo "No player name"

echo -e "\n=== プレイヤー名（小文字） ==="
playerctl metadata --format '{{lc(playerName)}}' 2>/dev/null || echo "No player name"

echo -e "\n=== 利用可能なプレイヤー一覧 ==="
playerctl --list-all 2>/dev/null || echo "No players available"
