#!/usr/bin/env bash
# niri-taskbar-watcher.sh
# Monitors niri event-stream and signals waybar to refresh the taskbar
# whenever window or workspace state changes.
#
# Usage: run this script at startup (e.g. via niri spawn-at-startup).
# It sends SIGRTMIN+8 to waybar on relevant events, allowing config.jsonc
# to use "signal": 8 instead of polling with a short interval.

EVENTS="WindowsChanged|WindowOpenedOrClosed|WindowFocusChanged|WorkspacesChanged"

niri msg -j event-stream | while IFS= read -r line; do
	if echo "$line" | grep -qE "\"($EVENTS)\""; then
		pkill -RTMIN+8 waybar
	fi
done
