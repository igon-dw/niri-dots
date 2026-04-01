# Waybar Configuration

This directory contains the Waybar configuration used by this repository, including theme switching, terminal-aware config variants, and custom Niri integration modules.

> **日本語版はこちら / Japanese version available**: [README.ja.md](README.ja.md)

---

## Overview

The current Waybar setup is built around:

- a taskbar-style custom Niri window list
- terminal-specific config variants for Kitty and Ghostty
- template-based CSS theme switching
- a clickable theme indicator
- MPRIS integration and notification controls

Main files:

- `config.jsonc`
- `config.jsonc.kitty`
- `config.jsonc.ghostty`
- `base.css`
- `style.css.template`
- `themes/`
- `scripts_for_waybar/`

Notes:

- `style.css` is generated at runtime and is not meant to be edited directly.
- `config.jsonc` is the active tracked config and may be switched between the Kitty and Ghostty variants.

---

## Directory Structure

```text
waybar/.config/waybar/
|- config.jsonc
|- config.jsonc.kitty
|- config.jsonc.ghostty
|- base.css
|- style.css
|- style.css.template
|- themes/
|  |- ayu.css
|  |- catppuccin.css
|  |- earthsong.css
|  |- everforest.css
|  |- flatland.css
|  |- gruvbox.css
|  |- night-owl.css
|  |- nord.css
|  |- original.css
|  |- palenight.css
|  |- shades-of-purple.css
|  |- solarized.css
|  `- tokyo-night.css
`- scripts_for_waybar/
   |- switch-theme.sh
   |- get-current-theme.sh
   |- get-mpris.sh
   |- niri-taskbar.py
   |- niri-taskbar-watcher.sh
   `- pomo.sh
```

---

## Config Variants

This repository keeps two Waybar config variants:

- `config.jsonc.kitty`: monitoring modules open tools in Kitty
- `config.jsonc.ghostty`: monitoring modules open tools in Ghostty

The active `config.jsonc` is intended to point at one of these profiles. Repository-level switching is handled by:

```bash
bash niri/.config/niri/scripts_for_niri/switch-terminal.sh
```

After switching, reload Niri config if needed:

```bash
niri msg action reload-config
```

---

## Theme Switching

### Interactive mode

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
```

### Direct theme selection

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
~/.config/waybar/scripts_for_waybar/switch-theme.sh tokyo-night
```

### Unified theme switching

To switch Waybar together with terminal themes:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

This flow selects one Waybar theme, applies it to Waybar, then applies the same name to Kitty or Ghostty when possible.

### How it works

- `switch-theme.sh` copies `style.css.template` to `style.css`
- it rewrites the selected `@import "themes/<name>.css";` line
- it restarts Waybar
- it sends a desktop notification with the selected theme name

The current theme name shown in the bar comes from `scripts_for_waybar/get-current-theme.sh`.

---

## Custom Modules

### `custom/taskbar`

The taskbar is backed by `scripts_for_waybar/niri-taskbar.py`.

It:

- queries `niri msg -j windows`, `workspaces`, and `outputs`
- sorts windows by monitor position, workspace index, and column position
- renders a compact icon-based taskbar using Pango markup
- highlights the focused window

The click action opens the Niri fuzzy window picker:

```bash
~/.config/niri/scripts_for_niri/niri-window-picker.sh
```

### `niri-taskbar-watcher.sh`

This watcher subscribes to the Niri event stream and sends `SIGRTMIN+8` to Waybar when relevant window or workspace events occur.

The intended use is to run it from Niri startup so the taskbar can refresh on events instead of relying only on short polling.

### `custom/mpris`

This module uses `scripts_for_waybar/get-mpris.sh` to show a compact player icon and track title.

It also supports:

- click: play/pause
- scroll up/down: volume control through `playerctl`

### `custom/theme`

This module displays the current theme and opens the theme selector on click.

### `custom/makoDismiss`

This module dismisses all notifications via `makoctl dismiss -a`.

---

## Current Module Layout

Left side:

- `custom/appmenu`
- `cpu`
- `temperature`
- `disk`
- `memory`
- `custom/gpu`
- `custom/taskbar`

Center:

- `clock`
- `niri/workspaces`
- `custom/makoDismiss`

Right side:

- `custom/mpris`
- `custom/theme`
- `niri/language`
- `tray`
- `pulseaudio`
- `custom/wlogout`

---

## Available Themes

Current theme files:

- `ayu` — orange and blue accents with high contrast, good visibility for coding
- `catppuccin` — lavender and pink pastels, easy on the eyes for long sessions
- `earthsong` — beige and brown natural tones, calming warm colors for focused work
- `everforest` — forest-inspired green palette, low contrast to reduce eye strain
- `flatland` — gray-based minimalist design, clean and professional
- `gruvbox` — yellow, orange, and green warm retro colors, popular among programmers
- `night-owl` — deep blue-purple background with bright accents, designed for night work
- `nord` — blue and gray cool color palette inspired by Nordic winter
- `original` — repository-specific custom theme, balanced general-purpose colors
- `palenight` — purple and pink Material Design style, modern and polished
- `shades-of-purple` — bold vivid purple, distinctive and creative
- `solarized` — scientifically designed 16-color palette, optimized contrast ratios
- `tokyo-night` — deep navy with neon colors, modern Tokyo nighttime atmosphere

Most theme names are aligned with the Kitty theme set. `original` is Waybar-only.

---

## Adding a New Theme

1. Add a new file under `themes/`, for example `themes/my-theme.css`
2. Define all the color variables expected by `base.css` (see list below)
3. Run the theme switcher and select the new theme
4. If you want unified terminal switching, add matching Kitty and/or Ghostty themes too

### Required Color Variables

New themes must define all of the following `@define-color` variables. Use an existing theme file as a starting point.

#### Basic Colors

```css
@define-color bar_bg           /* Bar background */
@define-color module_bg        /* Module background */
@define-color module_border    /* Module border */
@define-color global_fg        /* Default text color */
@define-color tooltip_bg       /* Tooltip background */
@define-color tooltip_border; /* Tooltip border */
```

#### App Menu

```css
@define-color appmenu_fg       /* App menu text */
@define-color appmenu_hover_fg; /* App menu hover text */
```

#### System Monitoring Modules

```css
@define-color cpu_fg           /* CPU text */
@define-color temperature_fg   /* Temperature text */
@define-color disk_fg          /* Disk text */
@define-color gpu_fg           /* GPU text */
@define-color memory_fg; /* Memory text */
```

#### Taskbar

```css
@define-color taskbar_btn_bg           /* Button background */
@define-color taskbar_btn_border       /* Button border */
@define-color taskbar_btn_hover_bg     /* Hover background */
@define-color taskbar_btn_hover_border /* Hover border */
@define-color taskbar_btn_active_bg    /* Active background */
@define-color taskbar_btn_active_border; /* Active border */
```

#### Clock, Tray, and Logout

```css
@define-color clock_fg         /* Clock text */
@define-color tray_hover_fg    /* System tray hover text */
@define-color logout_fg        /* Logout button text */
@define-color logout_hover_fg; /* Logout button hover text */
```

#### Menu Items

```css
@define-color menuitem_fg       /* Menu text */
@define-color menuitem_bg       /* Menu background */
@define-color menuitem_hover_bg /* Menu hover background */
@define-color menuitem_hover_fg; /* Menu hover text */
```

#### Theme Button and Media Player

```css
@define-color theme_fg         /* Theme indicator text */
@define-color mpris_fg; /* MPRIS module text */
```

---

## Dependencies

Common runtime dependencies for this Waybar setup:

- `waybar`
- `fuzzel`
- `niri`
- `python3`
- `playerctl`
- `makoctl`
- `notify-send`
- `btop`
- `nvtop`
- `sensors`
- `pavucontrol`
- `wlogout`

If the taskbar, theme button, or MPRIS module does not behave as expected, check whether the corresponding helper command exists.

---

## Troubleshooting

### Theme change did not apply

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
pkill -x waybar
waybar
```

### Taskbar is empty or stale

```bash
python3 ~/.config/waybar/scripts_for_waybar/niri-taskbar.py
pgrep -af niri-taskbar-watcher.sh
```

### MPRIS module is empty

```bash
playerctl metadata
playerctl status
```

---

## Resources

- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Styling Guide](https://github.com/Alexays/Waybar/wiki/Styling)
- [Niri Compositor](https://github.com/YaLTeR/niri)
