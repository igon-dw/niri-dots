# niri-dots

[![Beta](https://img.shields.io/badge/status-beta-orange)](https://github.com/igon-dw/niri-dots)

> ⚠️ **Beta Notice**: This project is currently in beta. Features, configurations, and scripts may change significantly. Please review changes before updating.

Dotfiles and helper scripts for a Niri-based Wayland desktop on Arch Linux.

This repository focuses on a practical daily-driver setup built around Niri, Waybar, terminal theme switching, Neovim, Fish, and a small set of workflow scripts for launching files, switching windows, managing wallpapers, and keeping terminal/bar themes in sync.

> **Japanese version available**: [README.ja.md](README.ja.md)

---

## Overview

Main pieces included in this repository:

- **Niri**: compositor, keybindings, startup programs, window rules, and wallpaper/theme helpers
- **Waybar**: taskbar-oriented bar with multiple terminal-aware profiles and theme switching
- **Kitty / Ghostty**: terminal configurations with separate theme switching workflows
- **Fuzzel**: launcher used by Niri scripts and interactive selectors
- **Fish + Starship**: interactive shell setup, abbreviations, and prompt
- **Neovim**: current config in `nvim`, built around Snacks, Agentic, and the actively maintained setup
- **Utility configs**: `fastfetch`, `lazygit`, `mako`, MIME associations, and local helper scripts
- **Bootstrap scripts**: package installation, Docker setup, and GNOME/libadwaita-related settings
- **OpenCode config**: local editor/CLI assistant configuration under `opencode/`

The repository is designed around GNU Stow, so most directories map cleanly into `~/.config` or `~/.local/bin`.

---

## Repository Structure

```text
niri-dots/
|- README.md
|- README.ja.md
|- setup.sh
|- scripts/
|  |- install-packages.sh
|  |- setup-docker.sh
|  `- setup_gnome_settings.sh
|- niri/
|  `- .config/niri/
|     |- config.kdl
|     |- config.kdl.kitty
|     |- config.kdl.ghostty
|     `- scripts_for_niri/
|- waybar/
|  `- .config/waybar/
|     |- config.jsonc
|     |- config.jsonc.kitty
|     |- config.jsonc.ghostty
|     |- style.css.template
|     |- themes/
|     `- scripts_for_waybar/
|- kitty/
|  `- .config/kitty/
|     |- kitty.conf
|     |- themes/
|     `- scripts_for_kitty/
|- ghostty/
|  `- .config/ghostty/
|     |- config
|     |- theme.conf
|     `- scripts_for_ghostty/
|- fuzzel/
|- fish/
|- starship/
|- nvim/
|- fastfetch/
|- lazygit/
|- mako/
|- misc/
|  |- .config/mimeapps.list
|  `- .local/bin/update-arch
`- opencode/
```

Notes:

- `config.kdl` and `waybar/.config/waybar/config.jsonc` are the active tracked profiles.
- Terminal-specific variants also exist as `config.kdl.kitty`, `config.kdl.ghostty`, `config.jsonc.kitty`, and `config.jsonc.ghostty`.
- Ghostty uses `theme.conf`, which is generated and updated by the theme switcher script.
- Kitty uses `current-theme.conf`, which is generated as a symlink on first theme selection.

---

## Quick Start

```bash
git clone https://github.com/igon-dw/niri-dots.git
cd niri-dots

# Review the install script first.
bash scripts/install-packages.sh

# Deploy the configs you want.
stow niri waybar kitty ghostty fuzzel fish starship fastfetch lazygit mako misc

# Optional Neovim setup
stow nvim
```

Then log out, choose the Niri session in your display manager, and sign back in.

---

## Installation

### Prerequisites

- Arch Linux or an Arch-based distribution
- `paru` available in `PATH` (the package installer currently requires `paru`)
- A display manager/session launcher that can start Niri

**Note**: GNU Stow is installed by `install-packages.sh`, so run the package installation script before deploying dotfiles with Stow.

### Bootstrap Script

`setup.sh` runs the repository bootstrap in this order:

1. `scripts/install-packages.sh`
2. `scripts/setup-docker.sh`
3. `scripts/setup_gnome_settings.sh`

Run it if you want the full bootstrap flow:

```bash
sh setup.sh
```

### Package Installation Script

The main installer is `scripts/install-packages.sh`.

Basic usage:

```bash
bash scripts/install-packages.sh
```

Optional flags:

```bash
INSTALL_NIX=1 bash scripts/install-packages.sh
INSTALL_AMD_GPU=1 bash scripts/install-packages.sh
INSTALL_JAPANESE=1 bash scripts/install-packages.sh
```

What it installs:

- Wayland desktop tools such as `ly`, `niri`, `waybar`, `fuzzel`, `swayidle`, `wl-clipboard`, `cliphist`, and `clipse`
- Terminal and shell tools such as `kitty`, `ghostty`, `starship`, `zoxide`, `zk`, and `sheldon`
- Editors and development tools such as `neovim`, `zed`, `mousepad`, `go`, `git`, and `github-cli`
- Utilities such as `fd`, `fzf`, `ripgrep`, `git-delta`, `lazygit`, `fastfetch`, `trash-cli`, `jq`, `rclone`, and `tree-sitter-cli`
- Desktop applications and desktop-side helpers such as `mako`, `mpv`, `kdenlive`, `obs-studio`, `steam`, `vivaldi`, `geary`, `playerctl`, and `brightnessctl`
- Fonts including JetBrains Mono Nerd Font and FiraCode Nerd Font

Important details:

- The script installs official packages and AUR packages with `paru -Syu --needed ...`.
- It also installs `org.upscayl.Upscayl` via Flatpak if `flatpak` is available.
- Docker setup and GNOME setting tweaks are handled by separate scripts, not by Stow.

### Deploying Dotfiles with Stow

Recommended deployment:

```bash
stow niri waybar kitty ghostty fuzzel fish starship fastfetch lazygit mako misc
```

Add Neovim as needed:

```bash
stow nvim
```

You can also stow individual components, for example:

```bash
stow niri
stow waybar
stow kitty
stow ghostty
stow fish
stow misc
```

---

## Terminal Profiles

This repository supports two terminal-oriented desktop profiles:

- **Kitty profile**: Kitty is the main terminal and Waybar launches monitoring commands in Kitty
- **Ghostty profile**: Ghostty is the main terminal and Waybar launches monitoring commands in Ghostty

The switching helper is `niri/.config/niri/scripts_for_niri/switch-terminal.sh`.

Run it from the repository checkout:

```bash
bash niri/.config/niri/scripts_for_niri/switch-terminal.sh
```

What it changes:

- switches `niri/.config/niri/config.kdl` between `config.kdl.kitty` and `config.kdl.ghostty`
- switches `waybar/.config/waybar/config.jsonc` between `config.jsonc.kitty` and `config.jsonc.ghostty`

After switching, reload Niri config:

```bash
niri msg action reload-config
```

Operational note:

- This script edits symlinks inside the repository itself. Run it from the checked-out repo that your Stow deployment points to.

---

## Component Notes

### Niri

Main config:

- `niri/.config/niri/config.kdl`

Enabled startup programs in the active config include:

- `waybar`
- `niri-taskbar-watcher.sh`
- `fcitx5 -d`
- `swww-daemon` and `swww restore`
- `swayidle`
- `wl-paste --watch cliphist store`
- `clipse -listen`

Useful built-in keybindings in the current config:

- `Mod+Return`: launch terminal
- `Alt+Space`: launch `fuzzel`
- `Mod+W`: fuzzy window picker
- `Mod+A`: MIME-aware file launcher
- `Mod+Shift+A`: floating `fzf` quick opener
- `Mod+Shift+W`: wallpaper selector in a floating terminal
- `Mod+T`: switch Waybar theme
- `Mod+Alt+T`: switch terminal theme
- `Mod+Ctrl+Alt+T`: switch Waybar + terminal theme together
- `Mod+Semicolon`: open `clipse`
- `Print`, `Ctrl+Print`, `Alt+Print`: screenshot actions

### Waybar

Files:

- `waybar/.config/waybar/config.jsonc`
- `waybar/.config/waybar/style.css.template`
- `waybar/.config/waybar/themes/`
- `waybar/.config/waybar/scripts_for_waybar/`

Current Waybar setup includes:

- taskbar-style custom Niri window list via `niri-taskbar.py`
- MPRIS module
- notification status module with dismiss-all and DND toggle actions
- clipboard status module with quick open and clear actions
- theme indicator and theme switcher
- separate config variants for Kitty and Ghostty

Switch theme:

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
```

### Kitty

Files:

- `kitty/.config/kitty/kitty.conf`
- `kitty/.config/kitty/themes/`
- `kitty/.config/kitty/scripts_for_kitty/`

Kitty details:

- `kitty.conf` includes `./current-theme.conf`
- `current-theme.conf` is created automatically on first theme switch
- remote control is enabled so the switcher can apply colors to running Kitty instances

Switch theme:

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
~/.config/kitty/scripts_for_kitty/switch-theme.sh tokyo-night
~/.config/kitty/scripts_for_kitty/list-themes.sh
```

### Ghostty

Files:

- `ghostty/.config/ghostty/config`
- `ghostty/.config/ghostty/theme.conf`
- `ghostty/.config/ghostty/scripts_for_ghostty/`

Ghostty details:

- `config` includes `~/.config/ghostty/theme.conf`
- `theme.conf` is generated by the switcher script
- theme names are validated against `ghostty +list-themes`

Switch theme:

```bash
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh "Catppuccin Mocha"
~/.config/ghostty/scripts_for_ghostty/list-themes.sh
```

### Fish and Starship

Fish config lives in `fish/.config/fish/config.fish` and includes:

- Starship initialization
- Zoxide initialization
- shell abbreviations for `eza`, `lazygit`, `opencode`, video encoding helpers, and more
- PATH additions for `~/.local/bin` and Mason-managed Neovim tools
- optional local overrides from `fish/.config/fish/options.fish`

Starship config is in `starship/.config/starship.toml`.

### Neovim

Current setup:

- `nvim/.config/nvim/`: current Neovim config

The current Neovim config includes plugins for LSP, Treesitter, formatting, linting, DAP, which-key, Snacks, Noice, Agentic, and Copilot Vim integration.

### Miscellaneous Config

- `fastfetch/.config/fastfetch/config.jsonc`: styled fastfetch output
- `lazygit/.config/lazygit/config.yml`: Lazygit settings
- `mako/.config/mako/config`: notification daemon config with DND mode support
- `misc/.config/mimeapps.list`: default app associations
- `misc/.local/bin/update-arch`: local update helper
- `opencode/opencode.jsonc`: OpenCode model, formatter, and permission settings

---

## Workflow Scripts

### MIME-aware file launcher

Files:

- `niri/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.sh`
- `niri/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.toml`

What it does:

1. searches files from `$HOME` using `fd`
2. filters selection through `fuzzel`
3. detects MIME type with `file`
4. looks up candidate apps in TOML config
5. opens GUI apps directly
6. opens CLI apps inside the configured terminal

Run it directly:

```bash
~/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.sh
```

The current TOML config includes mappings for text, Markdown, JSON, YAML, images, audio, video, and directories.

### FZF quick opener

Files:

- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener.sh`
- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener_core.sh`
- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener_icons.sh`

What it does:

1. launches `f3-opener` from a floating Kitty or Ghostty terminal
2. lists files from `$HOME` using `fd`
3. shows icons, file kind labels, and a preview through `fzf`
4. asks which app to use after selecting a path
5. reuses the same TOML app mappings as `f2_launcher`

Run it directly:

```bash
$HOME/Projects/f3-launcher/bin/f3-opener
```

Niri binds this action to `$HOME/Projects/f3-launcher/bin/f3-opener` in both Kitty and Ghostty profiles.

### Fuzzy window picker

File:

- `niri/.config/niri/scripts_for_niri/niri-window-picker.sh`

This script queries Niri over `niri msg --json`, formats windows with `jq`, and lets you jump to a window through `fuzzel`.

### Theme synchronization

File:

- `niri/.config/niri/scripts_for_niri/change-all-themes.sh`

This helper:

- selects one Waybar theme via `fuzzel`
- applies the matching Waybar theme
- applies the same theme to Kitty if a matching `.conf` exists
- tries to apply the same theme to Ghostty, otherwise falls back to Ghostty's interactive selector

Run it with:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

### Wallpaper selection

Files:

- `niri/.config/niri/scripts_for_niri/wallpaper_selector.sh`
- `niri/.config/niri/scripts_for_niri/wallpaper_selector_tui.sh`
- `niri/.config/niri/scripts_for_niri/wallpaper_selector_tui_chafa.sh`

The current Niri keybinding opens the TUI wallpaper selector in a floating terminal.

---

## Operational Notes

### Japanese input

The active Niri config starts `fcitx5 -d` automatically.

If you want a Japanese input environment, install the optional package set:

```bash
INSTALL_JAPANESE=1 bash scripts/install-packages.sh
```

### Docker

`scripts/setup-docker.sh` enables and starts Docker with systemd, then attempts to add the sudo user to the `docker` group.

You may need to log out and back in after running it.

### GNOME/libadwaita backend settings

`scripts/setup_gnome_settings.sh` applies a few `gsettings` values, including:

- color scheme
- text scaling
- animation toggle
- sound theme and event sounds

This is mainly for portal/libadwaita integration; theme and icon appearance are still expected to be managed elsewhere.

### Extra runtime tools used by scripts

Several workflows in this repo assume extra tools are available, including:

- `jq`
- `playerctl`
- `brightnessctl`
- `swaylock`
- `sensors`
- `python3`
- `btop`
- `notify-send`

If a keybinding or module does nothing, check whether the relevant command is installed on your system.

---

## Troubleshooting

### Niri does not pick up profile changes

```bash
niri msg action reload-config
```

### Waybar is missing or stale

```bash
pkill -x waybar
waybar
```

### Kitty theme does not update

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
kitty @ ls
```

### Ghostty theme does not update

```bash
ghostty +list-themes
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh
```

### File launcher or window picker fails

Check for these commands first:

```bash
command -v fd fuzzel file yq jq
```

---

## Acknowledgments

This project was developed by the project maintainer using **GitHub Copilot** and **OpenCode**. Project management, architectural decisions, and overall structure are designed and planned by the maintainer. These AI tools have assisted with code completion, implementation details, documentation refinement, and commit message composition. All AI-assisted output has been reviewed and validated by the maintainer, who retains full responsibility for the project's direction, quality, and technical decisions.

---

## Resources

- [Niri GitHub Repository](https://github.com/YaLTeR/niri)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Ghostty](https://ghostty.org/)
- [Fuzzel Codeberg](https://codeberg.org/dnkl/fuzzel)
- [Arch Linux Wiki](https://wiki.archlinux.org/)

---

## License

This project is licensed under the MIT License. See `LICENSE`.
