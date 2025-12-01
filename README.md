# niri-dots

A comprehensive dotfiles repository for setting up an integrated Niri desktop environment on Arch Linux systems.

**niri-dots** provides configuration files, automation scripts, and installation guides to streamline the deployment of a modern, productivity-focused Niri-based desktop environment with complementary applications and utilities.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Package Installation](#package-installation)
  - [Dotfiles Deployment](#dotfiles-deployment)
- [Component Configuration](#component-configuration)
  - [Niri](#niri)
  - [Waybar](#waybar)
  - [Kitty](#kitty)
  - [Fuzzel](#fuzzel)
- [Automation Scripts](#automation-scripts)
  - [f2_launcher](#f2_launcher)
- [Post-Installation Setup](#post-installation-setup)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

**Niri** is a modern Wayland compositor designed for productivity. This repository provides a complete integration setup that includes:

- **Niri Compositor**: The core window manager
- **Waybar**: Status bar with system information and quick actions, with dynamic theme switching
- **Kitty**: High-performance terminal emulator with theme support
- **Fuzzel**: Application launcher
- **Automation Scripts**: Tools to streamline configuration management
- **System Integration**: Utilities for system monitoring, file management, and development tools

The configurations are designed to work seamlessly together, providing a cohesive desktop experience optimized for productivity and usability.

---

## Repository Structure

```
niri-dots/
├── README.md                      # This file (English version)
├── README.ja.md                   # Japanese documentation
├── LICENSE                        # MIT License
├── .gitignore                     # Git exclusion settings
├── install-packages.sh            # Package installation script
│
├── niri/                          # Niri compositor configuration
│   └── .config/
│       └── niri/
│           ├── config.kdl         # Main Niri configuration
│           └── scripts_for_niri/
│               ├── f2_launcher.sh           # File opener script
│               ├── f2_launcher.toml         # File opener settings
│               ├── wallpaper_selector.sh    # Wallpaper selector script
│               └── change-all-themes.sh     # Batch theme change script
│
├── waybar/                        # Waybar status bar configuration
│   └── .config/waybar/
│       ├── README.md              # Waybar detailed documentation
│       ├── config.jsonc           # Waybar modules and layout
│       ├── base.css               # Waybar theme-independent style
│       ├── style.css              # Waybar style (Git-managed)
│       ├── switch-theme.sh        # Waybar theme switcher script
│       └── themes/                # Waybar theme collection
│           ├── catppuccin.css
│           ├── gruvbox.css
│           ├── nord.css
│           ├── original.css
│           ├── solarized.css
│           └── tokyo-night.css
│
├── kitty/                         # Kitty terminal configuration
│   └── .config/kitty/
│       ├── README.md              # Kitty detailed documentation
│       ├── kitty.conf             # Main Kitty configuration
│       ├── themes/                # Kitty theme collection (12+ themes)
│       │   ├── ayu.conf
│       │   ├── catppuccin-mocha.conf
│       │   ├── Earthsong.conf
│       │   ├── gruvbox-dark.conf
│       │   ├── nord.conf
│       │   └── ...
│       └── scripts/
│           ├── switch-theme.sh    # Kitty theme switcher
│           └── list-themes.sh     # List available themes
│
├── fuzzel/                        # Fuzzel application launcher configuration
│   └── .config/fuzzel/
│       └── fuzzel.toml
│
├── nvim/                          # Neovim configuration (OSS core)
│   └── .config/nvim/
│       ├── init.lua               # Entry point
│       └── lua/
│           ├── config/            # Core settings
│           └── plugins/           # Plugin configurations
│
├── nvim-copilot/                  # Neovim AI addon (optional, requires GitHub Copilot subscription)
│   └── .config/nvim/
│       └── lua/plugins/
│           ├── copilot.lua        # GitHub Copilot integration
│           └── copilotchat.lua    # CopilotChat integration
│
└── misc/                          # Additional configuration and utilities
    ├── .config/
    │   └── (other configuration files)
    └── .local/bin/
        └── update-arch            # Arch system update script
```

---

## Quick Start

For experienced users, here's the minimal setup:

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/niri-dots.git
cd niri-dots

# 2. Install required packages
sudo bash install-packages.sh

# 3. Deploy configuration files
# Using GNU Stow (recommended):
stow niri waybar kitty fuzzel misc

# 4. Start Niri
# Log out and select "Niri" from the login manager (SDDM/GDM) session selection
```

---

## Installation

### Prerequisites

- **Distribution**: Arch Linux or Arch-based distribution (Manjaro, EndeavourOS, etc.)
- **AUR Helper**: `paru` or `yay` (for AUR package installation)
- **Base System**: Updated system with essential build tools
- **Login Manager**: SDDM or GDM (required for Niri session)

#### Checking Prerequisites

```bash
# Verify Arch-based system
cat /etc/os-release

# Check for paru or yay
which paru
which yay

# Check login manager status
systemctl status sddm    # or gdm
```

### Package Installation

The `install-packages.sh` script installs all dependencies and recommended tools:

```bash
sudo bash install-packages.sh
```

**What gets installed:**

- **Desktop Environment**: `niri`, `xwayland-satellite`, `waybar`, `fuzzel`, `wlogout`, `wl-clipboard`, `networkmanager`, `nemo`
- **Terminal & Shell**: `kitty` (terminal emulator), `starship` (shell prompt customization tool), `zoxide` (fast directory jumper)
- **Development**: `neovim`, `zed`, `mousepad`, `git`, `github-cli`, `go`
- **CLI Utilities**: `eza`, `fd`, `fzf`, `ripgrep`, `delta`, `lazygit`, `go-yq`, `chafa`
- **System Utilities**: `docker`, `snapper`, `flatpak`, `gnome-keyring`, `stow`, `xdg-user-dirs`, `xdg-utils`
- **Multimedia**: `kdenlive`, `obs-studio`, `steam`, Proton-related packages
- **Fonts & Input**: `fcitx5-mozc` (Japanese input), Nerd Fonts

**Note**: Some packages are installed from the AUR. Review the script before running, especially if you prefer to use `yay` instead of `paru`.

### Dotfiles Deployment

#### Option 1: Using GNU Stow (Recommended)

GNU Stow symlinks configuration files to your home directory, making updates simple:

```bash
# Install stow if not already installed
sudo pacman -S stow

# Deploy all configurations
cd niri-dots
stow niri waybar kitty fuzzel misc

# Deploy individual components
stow niri          # Only Niri config
stow waybar        # Only Waybar config
stow kitty         # Only Kitty config
stow fuzzel        # Only Fuzzel config
stow misc          # Only utilities and commands
```

#### Option 2: Manual Deployment

```bash
# Copy configuration files to home directory
mkdir -p ~/.config ~/.local/bin
cp -r niri/.config/niri ~/.config/
cp -r waybar/.config/waybar ~/.config/
cp -r kitty/.config/kitty ~/.config/
cp -r fuzzel/.config/fuzzel ~/.config/
cp -r misc/.config/* ~/.config/ 2>/dev/null || true
cp -r misc/.local/bin/* ~/.local/bin/ 2>/dev/null || true
chmod +x ~/.config/*/scripts/*.sh ~/.local/bin/* 2>/dev/null || true
```

---

## Component Configuration

### Niri

Niri is the Wayland compositor and window manager at the heart of this setup.

**Configuration File**: `~/.config/niri/config.kdl`

**Key Features**:

- Tiling and floating window layouts
- Custom keybindings
- Per-application window rules (opacity, default width, etc.)
- Monitor and resolution settings
- Focus ring and border customization

**Getting Started**:

1. Review the default configuration in this repository
2. Customize keybindings to match your preferences
3. Adjust per-application window rules (opacity, default width, etc.)
4. Configure output settings if using multiple displays

**Documentation**: [Niri GitHub](https://github.com/YaLTeR/niri)

### Waybar

Waybar displays system information and provides quick access to common functions.

**Configuration File**: `~/.config/waybar/config.jsonc`, `~/.config/waybar/style.css`

**Theme System**: Supports multiple themes including Catppuccin, Gruvbox, Nord, Solarized, and Tokyo Night.

```bash
# Switch themes (interactive)
~/.config/waybar/switch-theme.sh

# Switch to specific theme
~/.config/waybar/switch-theme.sh gruvbox
```

**Documentation**: [Waybar Configuration Guide](./waybar/.config/waybar/README.md)

### Kitty

Kitty is a high-performance terminal emulator with theme support.

**Configuration File**: `~/.config/kitty/kitty.conf`

**Theme System**: Supports 12+ themes with auto-initialization on first use.

```bash
# Switch themes (interactive)
~/.config/kitty/scripts/switch-theme.sh

# Switch to specific theme
~/.config/kitty/scripts/switch-theme.sh tokyo-night

# List available themes
~/.config/kitty/scripts/list-themes.sh
```

**Documentation**: [Kitty Configuration Guide](./kitty/.config/kitty/README.md)

### Fuzzel

Fuzzel is a modern application launcher.

**Configuration File**: `~/.config/fuzzel/fuzzel.toml`

**Documentation**: [Fuzzel Codeberg](https://codeberg.org/dnkl/fuzzel)

### Neovim

Modern Neovim configuration with lazy.nvim plugin manager, LSP support, and modular architecture.

**Configuration File**: `~/.config/nvim/init.lua`

**Key Features**:

- Modular plugin architecture with lazy.nvim
- LSP support with auto-installation (Mason)
- Telescope for fuzzy finding
- Treesitter for syntax highlighting
- Which-key for discoverable keybindings

**Deployment**:

#### Pattern 1: OSS Core Only (Recommended - Simple)

```bash
cd niri-dots
stow nvim
```

#### Pattern 2: OSS Core + GitHub Copilot (Recommended - Safe Method)

```bash
cd niri-dots
stow nvim nvim-copilot  # Deploy both simultaneously
```

⚠️ **Note**: If you run `stow nvim` first and then `stow nvim-copilot` later, stow will automatically adjust the symlink structure when detecting existing directories. This is normal behavior, but for certainty, simultaneous deployment (Pattern 2) is recommended.

**AI Addon (Optional)**:

The `nvim-copilot` addon provides GitHub Copilot integration.

**Requirements**:
- GitHub Copilot subscription
- GitHub CLI tool (`github-cli` package)
- GitHub CLI authentication

**Setup Steps**:

1. **Authenticate with GitHub CLI (first time only)**:

```bash
gh auth login
# Follow the prompts to complete authentication
```

2. **Deploy nvim-copilot**:

```bash
cd niri-dots
stow nvim nvim-copilot  # Deploy both OSS core and Copilot addon
```

3. **Verify authentication in Neovim**:

```bash
nvim
# :checkhealth copilot
```

**Usage**:

| Keymap | Function |
|--------|----------|
| `Ctrl+y` | Accept full Copilot suggestion |
| `Ctrl+i` | Accept next word of Copilot suggestion |
| `<leader>ai` | Open CopilotChat |

**Troubleshooting**:

```bash
# Check authentication status
gh auth status

# Re-authenticate if needed
gh auth logout
gh auth login
```

**Managing Symlinks**:

```bash
# Check deployment status
stow -d niri-dots --list-only nvim
stow -d niri-dots --list-only nvim-copilot

# Add nvim-copilot after initial deployment
cd niri-dots
stow nvim-copilot

# Remove nvim-copilot only (keep OSS core)
stow -D nvim-copilot

# Remove entire nvim setup
stow -D nvim nvim-copilot

# Complete reset
stow -D nvim
stow -D nvim-copilot
# Then redeploy if needed
stow nvim
```

**Documentation**: [Neovim Design Philosophy](./nvim/docs/DESIGN_PHILOSOPHY.md)

---

## Automation Scripts

### f2_launcher

Advanced Fuzzy File Launcher with MIME-type support. Select applications to open files based on their MIME types.

**Location**: `~/.config/niri/scripts_for_niri/f2_launcher.sh`

**Configuration File**: `~/.config/niri/scripts_for_niri/f2_launcher.toml`

**Features**:

- **MIME-type based application selection**: Configure multiple candidate applications for each MIME type
- **Automatic CLI/GUI detection**: CLI apps like `nvim` and `nano` automatically launch in terminal; GUI apps like `zed` launch directly
- **User selection dialog**: Choose from multiple candidates via Fuzzel
- **Configuration-driven**: Easy customization using TOML format

**Usage**:

```bash
# Run the script
~/.config/niri/scripts_for_niri/f2_launcher.sh

# Register in Niri keybindings
Mod+A { spawn-sh "~/.config/niri/scripts_for_niri/f2_launcher.sh"; }
```

**Configuration Example**:

```toml
[app_metadata]
nvim = "cli"
nano = "cli"
zed = "gui"
code = "gui"

[mime_types]
"text/plain" = ["zed", "code", "nvim"]
"text/x-shellscript" = ["zed", "code", "nano"]
"text/x-python" = ["zed", "code", "nvim"]
```

**Workflow**:

1. Select file using `fd` and `fuzzel`
2. Detect MIME type using `file` command
3. Get candidate applications from configuration
4. Filter by installed applications
5. Display candidates in Fuzzel (if multiple available)
6. Detect if application is CLI or GUI and launch accordingly
   - **CLI**: Launch in terminal (foot/kitty/alacritty/xterm)
   - **GUI**: Launch directly

---

## Post-Installation Setup

After deploying configurations, perform these additional setup steps:

### 1. Start Niri

```bash
# Via login manager (recommended, verified with SDDM/GDM)
# Log out and select "Niri" from the session selection screen at login
```

### 2. Configure Displays (Multi-Monitor Setup)

Edit `~/.config/niri/config.kdl` to specify display settings:

```kdl
output "HDMI-A-1" {
    position x=0 y=0
}

output "DP-1" {
    position x=2560 y=0
}
```

You can specify resolution and refresh rate with the `mode` option if needed.

### 3. Set Up Waybar Autostart

Add to your Niri configuration to start Waybar automatically:

```kdl
spawn-at-startup "waybar"
```

### 4. Keyboard Configuration

Customize keyboard settings in `~/.config/niri/config.kdl`:

```kdl
input {
    keyboard {
        xkb {
            # layout "us"  # Specify layout if needed
            # layout "jp"  # For Japanese
            options "ctrl:nocaps"  # Change CapsLock to Ctrl
        }
    }
}
```

### 5. Set Up Japanese Input (Optional)

If you installed fcitx5-mozc for Japanese input, configure environment variables:

```bash
# Set environment variables
echo 'export GTK_IM_MODULE=fcitx' >> ~/.bashrc
echo 'export QT_IM_MODULE=fcitx' >> ~/.bashrc
echo 'export XMODIFIERS=@im=fcitx' >> ~/.bashrc
```

Niri configuration already includes:

```kdl
spawn-at-startup "fcitx5" "-d"
```

### 6. Customize Niri Keybindings

Edit keybindings in `~/.config/niri/config.kdl`. Default bindings include:

```kdl
binds {
    Mod+Return { spawn "kitty"; }                    # Launch terminal
    Alt+Space { spawn "fuzzel"; }                    # Application launcher
    Mod+Q { close-window; }                          # Close window
    Mod+W { spawn-sh "~/.config/niri/scripts_for_niri/wallpaper_selector.sh"; }
    Mod+T { spawn-sh "~/.config/waybar/switch-theme.sh"; }
    Mod+Alt+T { spawn-sh "~/.config/kitty/scripts/switch-theme.sh"; }
}
```

---

## Customization

### Changing Themes

#### Waybar Theme

For details, see [Waybar README](./waybar/.config/waybar/README.md).

```bash
# Interactive theme selection
~/.config/waybar/switch-theme.sh

# Direct theme selection
~/.config/waybar/switch-theme.sh nord

# Accessible via Niri keybinding (default: Mod+T)
```

#### Kitty Theme

For details, see [Kitty README](./kitty/.config/kitty/README.md).

```bash
# Interactive theme selection
~/.config/kitty/scripts/switch-theme.sh

# Direct theme selection
~/.config/kitty/scripts/switch-theme.sh palenight

# List available themes
~/.config/kitty/scripts/list-themes.sh

# Accessible via Niri keybinding (default: Mod+Alt+T)
```

#### Initial Theme Setup

```bash
# Initialize Waybar theme
~/.config/waybar/switch-theme.sh

# Initialize Kitty theme (auto-initializes on first use)
~/.config/kitty/scripts/switch-theme.sh
```

### Adjusting Waybar Modules

Edit `~/.config/waybar/config.jsonc` to add, remove, or reorder modules.

### Configuring Niri Layout

Customize layout settings in `~/.config/niri/config.kdl`:

```kdl
layout {
    gaps 5

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }

    default-column-width { proportion 0.5; }

    focus-ring {
        width 3.2
        active-color "violet"
        inactive-color "#505050"
    }
}
```

---

## Troubleshooting

### Waybar Not Showing

```bash
# Check if Waybar is running
pgrep waybar

# Start Waybar manually
waybar

# Check logs
journalctl -u waybar -n 50
```

### Niri Crashes or Won't Start

```bash
# Check Niri logs
journalctl -u niri -n 50

# Verify configuration syntax
niri validate-config

# Try with minimal configuration (backup your config first)
mv ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak
niri  # Will use default configuration
```

### Input Method Issues

```bash
# Restart fcitx5
killall fcitx5
fcitx5 &

# Check fcitx5 status
fcitx5-diagnose
```

### Kitty Theme Not Applying

```bash
# Verify script is executable
ls -la ~/.config/kitty/scripts/switch-theme.sh

# Manually reinitialize
~/.config/kitty/scripts/switch-theme.sh Earthsong
```

---

## Contributing

Contributions are welcome! If you have improvements to configurations or scripts:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request with a clear description

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

This project was developed by the project maintainer with assistance from **GitHub Copilot**, an AI-powered code completion and generation tool. The project management, architectural decisions, and overall structure have been designed and planned by the project maintainer. GitHub Copilot has specifically assisted with:

- Code completion and refinement
- Small-scale processing and implementation details
- Documentation content refinement and organization
- Commit message composition

All work assisted by AI has undergone thorough review, modification, and validation by the project maintainer. The project maintainer maintains complete control over the project's direction, quality standards, and technical decisions. This collaboration represents a pragmatic approach to modern development, where AI tools enhance productivity while the human maintainer retains full responsibility for the final product's accuracy, completeness, and quality assurance.

---

## Resources & Documentation

- [Niri GitHub Repository](https://github.com/YaLTeR/niri)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Fuzzel Codeberg](https://codeberg.org/dnkl/fuzzel)
- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Wayland Documentation](https://wayland.freedesktop.org/)

---

## Support

For issues or questions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review component documentation (Waybar, Kitty) for detailed information
3. Open an issue on GitHub with detailed information about your setup and the problem
