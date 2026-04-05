#!/usr/bin/env bash

set -u

# Retry quickly only when Waybar exits immediately during cold boot.
# This keeps normal startup fast while tolerating session-service races.
delays=(0 0.2 0.5 1 2)
stable_after=3

for delay in "${delays[@]}"; do
    if [[ "$delay" != "0" ]]; then
        sleep "$delay"
    fi

    waybar &
    pid=$!

    sleep "$stable_after"

    if kill -0 "$pid" 2>/dev/null; then
        disown "$pid" 2>/dev/null || true
        exit 0
    fi

    wait "$pid" 2>/dev/null || true
done

exit 1
