#!/bin/bash

# --- 1. Configuration section ---
# Work duration in minutes. Kept short for debugging; use 25 in production.
DURATION_MIN=1
# File used to store the process ID for later signaling.
PID_FILE="/tmp/pomo.pid"
# Status file for Waybar; defined here even though it is not used yet.
STATUS_FILE="/tmp/pomo_status.json"

# --- 2. Cleanup function ---
# Always runs when the script exits, whether normally or due to an error.
cleanup() {
  echo "Running cleanup..."
  # Remove the files if they exist.
  rm -f "$PID_FILE" "$STATUS_FILE"
  exit 0
}

# --- 3. Trap setup ---
# Run cleanup when the EXIT signal is received.
trap cleanup EXIT

# --- 4. Startup ---
# Simple double-start check.
if [ -f "$PID_FILE" ]; then
  echo "It looks like this is already running. (PID file exists)"
  exit 1
fi

# Write this process's PID to the file.
# `$$` is a special variable that expands to the current process ID.
echo $$ >"$PID_FILE"

echo "Started the Pomodoro timer (PID: $$)"

# --- 5. Main logic (countdown) ---

# Convert minutes to seconds using arithmetic expansion.
# Keep DURATION_MIN=1 or similar if you want a short test run.
duration=$((DURATION_MIN * 60))
remaining=$duration

echo "Starting countdown: ${DURATION_MIN} minute(s) (${duration} seconds)"

# Loop until the remaining time reaches zero.
while [ $remaining -ge 0 ]; do
  time_fmt=$(printf "%02d:%02d" $((remaining / 60)) $((remaining % 60)))
  echo "$time_fmt"
  sleep 1
  remaining=$((remaining - 1))
done

echo "Done."
# Cleanup runs automatically when the script exits here.
