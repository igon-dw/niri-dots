#!/usr/bin/env bash
# niri-taskbar-watcher.sh
# Monitors niri event-stream and signals waybar to refresh the taskbar
# whenever window or workspace state changes.
#
# Usage: run this script at startup (e.g. via niri spawn-at-startup).
# It sends SIGRTMIN+8 to waybar on relevant events, allowing config.jsonc
# to use "signal": 8 instead of polling with a short interval.

SIGNAL_NUM=8
RECONNECT_DELAY=1
DEBOUNCE_MS=150

# Refresh taskbar when window ordering, focus, workspace membership, or
# workspace activation changes.
EVENTS=(
	WindowsChanged
	WorkspacesChanged
	WorkspaceActivated
	WorkspaceActiveWindowChanged
	WindowOpenedOrChanged
	WindowClosed
	WindowFocusChanged
	WindowFocusTimestampChanged
	WindowLayoutsChanged
)

should_refresh() {
	local event_name="$1"
	local event

	for event in "${EVENTS[@]}"; do
		if [[ "$event_name" == "$event" ]]; then
			return 0
		fi
	done

	return 1
}

signal_waybar() {
	local now_ms delta_ms

	now_ms=$(date +%s%3N)
	if [[ -n "${LAST_SIGNAL_MS:-}" ]]; then
		delta_ms=$((now_ms - LAST_SIGNAL_MS))
		if ((delta_ms < DEBOUNCE_MS)); then
			return 0
		fi
	fi

	LAST_SIGNAL_MS=$now_ms
	pkill -x -RTMIN+"$SIGNAL_NUM" waybar >/dev/null 2>&1 || true
}

while true; do
	niri msg -j event-stream 2>/dev/null | while IFS= read -r line; do
		[[ -z "$line" ]] && continue

		event_name=$(jq -r 'keys[0] // empty' <<<"$line" 2>/dev/null)
		[[ -z "$event_name" ]] && continue

		if should_refresh "$event_name"; then
			signal_waybar
		fi
	done

	sleep "$RECONNECT_DELAY"
done
