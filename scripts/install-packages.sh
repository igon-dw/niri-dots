#!/bin/sh

# Script to install required packages for niri environment
# Run with sudo privileges if necessary
# Target: Arch Linux or Arch based distributions (paru or yay is required for AUR packages)

# Official repository packages
PKGS_OFFICIAL=(
  # === Desktop Environment ===
  niri               # Window manager
  xwayland-satellite # XWayland satellite
  waybar             # Status bar
  fuzzel             # Alternative launcher
  wlogout            # Logout screen for Wayland (provides UI for logout, reboot, shutdown, etc.)
  swayidle           # Idle management daemon for Wayland
  wl-clipboard       # Clipboard manager for Wayland
  networkmanager     # Network management
  nemo               # File manager

  # === Terminal & Shell ===
  kitty              # Terminal emulator
  starship           # Prompt
  zoxide             # Fast directory jumper

  # === Editors ===
  neovim             # Advanced terminal-based text/code editor
  mousepad           # Lightweight graphical text editor (XFCE)

  # === Development & Languages ===
  zed                # Modern GUI code editor (fast, collaborative)
  go                 # Go language

  # === CLI Tools ===
  eza                # Alternative to ls
  fd                 # Fast file search
  fzf                # Command-line fuzzy finder
  ripgrep            # Fast grep
  git-delta          # git diff viewer
  lazygit            # Terminal git client
  go-yq              # YAML processor
  chafa              # Terminal image viewer

  # === Version Control & APIs ===
  git                # Version control
  github-cli         # GitHub CLI

  # === Dotfiles Management ===
  stow               # Symlink farm manager

  # === System & File Management ===
  xdg-user-dirs      # User directory management
  xdg-utils          # XDG utilities
  xdg-desktop-portal-wlr   # XDG desktop portal for wlroots
  snapper            # btrfs snapshot management
  clamav             # Virus scanner
  rclone             # Cloud storage integration
  flatpak            # Universal package manager
  gnome-keyring      # GNOME keyring (credentials manager)
  blueman            # Bluetooth manager
  kvantum            # Kvantum manager (official, recommended for theme configuration)
  kvantum-qt5        # Qt theme engine (Kvantum, official)
  qt5ct              # Qt5 configuration tool
  qt6ct              # Qt6 configuration tool

  # === System Monitoring ===
  fastfetch          # System info display
  htop               # Process viewer
  nvtop              # GPU process viewer
  gdu                # Disk usage analyzer

  # === Multimedia & Applications ===
  pavucontrol        # Audio volume control
  mpv                # Media player
  totem              # Media player (GNOME)
  loupe              # Image viewer
  kdenlive           # Video editing
  obs-studio         # Streaming/recording
  mako               # Notification daemon
  scrcpy             # Android screen mirroring
  steam              # Game platform
  protonup-qt        # Proton/Wine management for gaming
  vivaldi            # Vivaldi browser
  mpv-mpris          # MPRIS plugin for MPV

  # === Communication ===
  geary              # Email client

  # === Fonts ===
  ttf-jetbrains-mono-nerd # JetBrains Mono Nerd Font
  ttf-firacode-nerd  # FiraCode Nerd Font
  ttf-moralerspace   # MoralerSpace Font
  ttf-rounded-mplus  # Rounded M+ Font

  # === Development Tools ===
  github-copilot-cli # GitHub Copilot CLI

  # === Virtualization ===
  docker             # Container management
  virt-manger        # Virtual machine manager
  qemu-desktop       # QEMU virtualization (desktop)
)

# AUR packages
PKGS_AUR=(
  google-chrome      # Google Chrome browser (AUR)
  swww               # Image switching / wallpaper (AUR)
  nwg-look           # GTK theme settings (AUR)
  obs-vkcapture      # OBS Vulkan capture plugin (AUR)
  visual-studio-code-bin # Visual Studio Code (AUR)
  losslesscut-bin    # Video editing tool (AUR)
)

# Flatpak packages
FLATPAK_PKGS=(
    org.upscayl.Upscayl # AI image upscaler
)

# AMD GPU additional packages
PKGS_AMD_GPU=(
  libva-utils        # VA-API utilities
  bc                 # Calculator (required for some scripts)
)

# Additional packages for Japanese language environment
PKGS_JAPANESE=(
  fcitx5-configtool  # Fcitx5 configuration tool
  fcitx5-gtk         # Fcitx5 GTK integration
  fcitx5-qt          # Fcitx5 Qt integration
  fcitx5-mozc-ut     # Mozc engine for Fcitx5
)

echo "Official packages to be installed:"
for pkg in "${PKGS_OFFICIAL[@]}"; do
  echo "  $pkg"
done
echo "--------------------------------"

echo "AUR packages to be installed:"
for pkg in "${PKGS_AUR[@]}"; do
  echo "  $pkg"
done
echo "--------------------------------"

echo "================================"
echo "Installing official and AUR packages..."
echo "================================"

# Install both official and AUR packages using paru
paru -Syu --needed "${PKGS_OFFICIAL[@]}" "${PKGS_AUR[@]}"

echo "✓ Official and AUR packages installed"

echo "================================"
echo "Installing Flatpak packages..."
echo "================================"

if command -v flatpak &> /dev/null; then
  flatpak install flathub -y "${FLATPAK_PKGS[@]}"
  echo "✓ Flatpak packages installed"
else
  echo "⚠ Flatpak not found - skipping Flatpak package installation"
fi

echo "================================"
echo "Package installation complete!"
echo "================================"
