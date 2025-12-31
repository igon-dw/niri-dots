#!/bin/bash

# ------------------------------------------------------------------------------
# [1] Configuration Variables
# ------------------------------------------------------------------------------

# Color Scheme: 'prefer-dark', 'prefer-light', or 'default'
# Affects Libadwaita apps and portals
COLOR_SCHEME="prefer-dark"

# Text Scaling Factor (Default: 1.0)
# Useful for HiDPI screens if you don't want to scale the whole UI
TEXT_SCALING="1.0"

# Animations: true or false
ENABLE_ANIMATIONS="true"

# Sound theme: typically 'freedesktop'
SOUND_THEME="freedesktop"

# Event sounds: true or false
EVENT_SOUNDS="true"

# ------------------------------------------------------------------------------
# [2] Helper Function
# ------------------------------------------------------------------------------

# Safely apply gsettings with schema existence check
apply_setting() {
  local schema="$1"
  local key="$2"
  local value="$3"
  local type="$4"

  if gsettings list-schemas | grep -q "^${schema}$"; then
    echo "Applying: $schema $key -> $value"
    gsettings set "$schema" "$key" "$type" "$value"
  else
    echo "Skipping: Schema '$schema' not found."
  fi
}

# Check if gsettings command exists
if ! command -v gsettings &>/dev/null; then
  echo "Error: 'gsettings' command not found. Please install glib2."
  exit 1
fi

echo "Starting GNOME settings configuration..."
echo "----------------------------------------"

# ------------------------------------------------------------------------------
# [3] Apply Settings
# ------------------------------------------------------------------------------

# Color Scheme: Critical for xdg-desktop-portal-gnome and Libadwaita apps
apply_setting "org.gnome.desktop.interface" "color-scheme" "$COLOR_SCHEME" "s"

# Text Scaling: nwg-look handles DPI, this factor is separate
apply_setting "org.gnome.desktop.interface" "text-scaling-factor" "$TEXT_SCALING" "d"

# Animations: Enable/disable desktop animations
apply_setting "org.gnome.desktop.interface" "enable-animations" "$ENABLE_ANIMATIONS" "b"

# Sound Theme: Usually 'freedesktop'
apply_setting "org.gnome.desktop.sound" "theme-name" "$SOUND_THEME" "s"

# Event Sounds: Enable/disable system event sounds
apply_setting "org.gnome.desktop.sound" "event-sounds" "$EVENT_SOUNDS" "b"

echo "----------------------------------------"
echo "Configuration complete."
echo "Note: Theme/Icons are managed by nwg-look. Only backend settings applied."
