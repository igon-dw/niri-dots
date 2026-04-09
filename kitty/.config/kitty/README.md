# Kitty Configuration

This directory contains the Kitty configuration used by this repository, with script-driven theme switching and live updates for running Kitty instances.

> **Japanese version available**: [README.ja.md](README.ja.md)

---

## Overview

The Kitty setup here is centered on:

- `kitty.conf` as the base config
- `current-theme.conf` as the active theme link
- a script-driven theme switcher
- optional coordinated theme switching with Waybar and Ghostty

Main files:

- `kitty.conf`
- `THEMES.md`
- `themes/`
- `scripts_for_kitty/`

Notes:

- `current-theme.conf` is generated on first use and is not tracked in Git.
- `kitty.conf` includes `./current-theme.conf`.
- remote control is enabled so the theme script can update running Kitty windows.

---

## Directory Structure

```text
kitty/.config/kitty/
|- kitty.conf
|- current-theme.conf
|- THEMES.md
|- themes/
|  |- ayu.conf
|  |- catppuccin.conf
|  |- earthsong.conf
|  |- everforest.conf
|  |- flatland.conf
|  |- gruvbox.conf
|  |- night-owl.conf
|  |- nord.conf
|  |- palenight.conf
|  |- shades-of-purple.conf
|  |- solarized.conf
|  `- tokyo-night.conf
`- scripts_for_kitty/
   |- switch-theme.sh
   `- list-themes.sh
```

---

## Theme Switching

### Interactive mode

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
```

If `current-theme.conf` does not exist yet, the script initializes it with the default theme `Earthsong` before proceeding.

### Direct theme selection

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh tokyo-night
~/.config/kitty/scripts_for_kitty/switch-theme.sh nord
~/.config/kitty/scripts_for_kitty/switch-theme.sh gruvbox
```

### List themes

```bash
~/.config/kitty/scripts_for_kitty/list-themes.sh
~/.config/kitty/scripts_for_kitty/list-themes.sh --simple
```

### Unified switching with Waybar

To switch Waybar and terminal themes together:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

This uses the selected Waybar theme name and applies the same name to Kitty if the matching `.conf` exists.

---

## How It Works

The switcher script does the following:

1. ensures `current-theme.conf` exists
2. validates that the requested theme file exists under `themes/`
3. updates `current-theme.conf` to a relative symlink like `./themes/gruvbox.conf`
4. tries to apply the new colors to running Kitty instances with `kitty @ set-colors --all --configured`
5. sends a desktop notification

This means:

- newly launched Kitty windows read the active theme through `include ./current-theme.conf`
- already running Kitty windows can update immediately if remote control is available

### Symlink Chain

When deployed with Stow, the theme reference forms a two-level chain:

```text
~/.config/kitty/current-theme.conf       (created by switch-theme.sh)
    -> ./themes/earthsong.conf           (stow symlink)
    -> ~/niri-dots/kitty/.config/kitty/themes/earthsong.conf  (actual file)
```

Linux resolves this transparently. Kitty reads the final file content through the chain.

---

## Current Config Notes

The current `kitty.conf` includes:

- JetBrains Mono Nerd Font Mono
- theme include via `current-theme.conf`
- `allow_remote_control yes`
- `shell_integration no-cursor`
- hidden window decorations to fit the Niri setup

Important note:

- transparency is intentionally not managed in `kitty.conf`; the repository expects Niri window rules to handle that side of the presentation

---

## Available Themes

Current theme files:

- `ayu` — orange and blue accents with high contrast, good visibility for coding
- `catppuccin` — lavender and pink pastels, easy on the eyes for long sessions
- `earthsong` — beige and brown natural tones, calming warm colors for focused work (default)
- `everforest` — forest-inspired green palette, low contrast to reduce eye strain
- `flatland` — gray-based minimalist design, clean and professional
- `gruvbox` — yellow, orange, and green warm retro colors, popular among programmers
- `night-owl` — deep blue-purple background with bright accents, designed for night work
- `nord` — blue and gray cool color palette inspired by Nordic winter
- `palenight` — purple and pink Material Design style, modern and polished
- `shades-of-purple` — bold vivid purple, distinctive and creative
- `solarized` — scientifically designed 16-color palette, optimized contrast ratios
- `tokyo-night` — deep navy with neon colors, modern Tokyo nighttime atmosphere

These names are mostly aligned with the Waybar theme set. Waybar's `original` theme does not have a Kitty equivalent.

Theme sources and attribution are documented in `THEMES.md`.

---

## Adding a New Theme

1. add a new `themes/<name>.conf`
2. verify it loads correctly in Kitty
3. if you want unified switching, add a matching Waybar theme with the same base name

Minimal Kitty theme requirements:

- `background`
- `foreground`
- `cursor`
- `selection_background`
- `color0` through `color15`

---

## Dependencies

Common runtime dependencies for this Kitty setup:

- `kitty`
- `fuzzel`
- `notify-send`
- `pgrep`
- `ln`

If live theme application does not work, check whether Kitty is running and whether remote control is available.

---

## Troubleshooting

### Theme does not apply to running Kitty windows

```bash
kitty @ ls
~/.config/kitty/scripts_for_kitty/switch-theme.sh
```

### Theme link was not created

```bash
ls -l ~/.config/kitty/current-theme.conf
~/.config/kitty/scripts_for_kitty/switch-theme.sh earthsong
```

### Need to verify available themes

```bash
~/.config/kitty/scripts_for_kitty/list-themes.sh
```

---

## Resources

- [Kitty Official Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Remote Control](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Kitty Color Themes](https://github.com/kovidgoyal/kitty-themes)
- [Niri Compositor](https://github.com/YaLTeR/niri)
