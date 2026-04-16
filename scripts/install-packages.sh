#!/bin/bash

set -euo pipefail

# Script to install required packages for niri environment
# Run with sudo privileges if necessary
# Target: Arch Linux or Arch based distributions (paru or yay is required for AUR packages)
#
# Usage:
#   ./install-packages.sh              # Install packages only
#   INSTALL_NIX=1 ./install-packages.sh # Install packages and Nix via Determinate installer
#   INSTALL_AMD_GPU=1 ./install-packages.sh # Include AMD GPU packages
#   INSTALL_JAPANESE=1 ./install-packages.sh # Include Japanese input packages

INSTALL_NIX="${INSTALL_NIX:-0}"
INSTALL_AMD_GPU="${INSTALL_AMD_GPU:-0}"
INSTALL_JAPANESE="${INSTALL_JAPANESE:-0}"

require_command() {
	local cmd="$1"

	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: required command '$cmd' not found" >&2
		exit 1
	fi
}

# Function to install Nix via Determinate Systems installer
install_nix() {
	if command -v nix &>/dev/null; then
		echo "✓ Nix already installed - skipping"
		return 0
	fi

	require_command curl

	echo "================================"
	echo "Installing Nix via Determinate installer..."
	echo "================================"

	if curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; then
		echo "✓ Nix installation complete"
		echo "Note: You may need to start a new shell or re-login to use Nix"
	else
		echo "Error: failed to install Nix via Determinate installer" >&2
		exit 1
	fi
}

# Official repository packages
PKGS_OFFICIAL=(
	# === Desktop Environment ===
	ly                 # Display manager (TUI-based)
	niri               # Window manager
	xwayland-satellite # XWayland satellite
	waybar             # Status bar
	fuzzel             # Alternative launcher
	ghostty            # GPU-accelerated terminal emulator
	wlogout            # Logout screen for Wayland (provides UI for logout, reboot, shutdown, etc.)
	swayidle           # Idle management daemon for Wayland
	swaylock           # Screen locker used by swayidle
	wl-clipboard       # Clipboard manager for Wayland
	cliphist           # Clipboard history manager for Wayland (stores/recalls with dmenu/rofi/wofi/fuzzel)
	clipse             # Configurable TUI clipboard manager with multi-select, pinning, and auto-paste
	networkmanager     # Network management
	nemo               # File manager
	superfile          # TUI file manager

	# === Terminal & Shell ===
	kitty    # Terminal emulator
	starship # Prompt
	zoxide   # Fast directory jumper
	zk       # Note-taking tool
	sheldon  # Shell plugin manager

	# === Editors ===
	neovim   # Advanced terminal-based text/code editor
	mousepad # Lightweight graphical text editor (XFCE)

	# === Development & Languages ===
	zed # Modern GUI code editor (fast, collaborative)
	go  # Go language

	# === CLI Tools ===
	eza             # Alternative to ls
	fd              # Fast file search
	fzf             # Command-line fuzzy finder
	ripgrep         # Fast grep
	git-delta       # git diff viewer
	lazygit         # Terminal git client
	tree-sitter-cli # Tree-sitter CLI used by the Neovim 0.12+ setup
	go-yq           # YAML processor
	chafa           # Terminal image viewer
	trash-cli       # rm alternative (moves files to trash)
	jq              # JSON processor for niri helper scripts

	# === Version Control & APIs ===
	git        # Version control
	github-cli # GitHub CLI

	# === Dotfiles Management ===
	stow # Symlink farm manager

	# === System & File Management ===
	xdg-user-dirs          # User directory management
	xdg-utils              # XDG utilities
	xdg-desktop-portal-wlr # XDG desktop portal for wlroots
	snapper                # btrfs snapshot management
	clamav                 # Virus scanner
	rclone                 # Cloud storage integration
	flatpak                # Universal package manager
	gnome-keyring          # GNOME keyring (credentials manager)
	blueman                # Bluetooth manager
	kvantum                # Kvantum manager (official, recommended for theme configuration)
	kvantum-qt5            # Qt theme engine (Kvantum, official)
	libnotify              # notify-send support for desktop notifications
	lm_sensors             # sensors command for hardware telemetry
	brightnessctl          # Backlight control for media keys
	playerctl              # MPRIS control used by Waybar and key actions
	python                 # python3 runtime for custom Waybar modules
	qt5ct                  # Qt5 configuration tool
	qt6ct                  # Qt6 configuration tool

	# === System Monitoring ===
	fastfetch # System info display
	btop      # System monitor opened from Waybar modules
	htop      # Process viewer
	nvtop     # GPU process viewer
	gdu       # Disk usage analyzer

	# === Multimedia & Applications ===
	pavucontrol # Audio volume control
	mpv         # Media player
	totem       # Media player (GNOME)
	loupe       # Image viewer
	kdenlive    # Video editing
	obs-studio  # Streaming/recording
	mako        # Notification daemon
	scrcpy      # Android screen mirroring
	steam       # Game platform
	protonup-qt # Proton/Wine management for gaming
	vivaldi     # Vivaldi browser
	mpv-mpris   # MPRIS plugin for MPV

	# === Communication ===
	geary # Email client

	# === Fonts ===
	ttf-jetbrains-mono-nerd # JetBrains Mono Nerd Font
	ttf-firacode-nerd       # FiraCode Nerd Font
	ttf-moralerspace        # MoralerSpace Font
	ttf-rounded-mplus       # Rounded M+ Font

	# === Development Tools ===
	github-copilot-cli # GitHub Copilot CLI

	# === Virtualization ===
	docker       # Container management
	virt-manager # Virtual machine manager
	qemu-desktop # QEMU virtualization (desktop)

	# === Printing ===
	avahi       # mDNS/DNS-SD service discovery (for network printers)
	cups        # Printer management system
	nss-mdns    # mDNS hostname resolution via glibc NSS
	ghostscript # PostScript/PDF interpreter for printing
)

# AUR packages
PKGS_AUR=(
	google-chrome          # Google Chrome browser (AUR)
	swww                   # Image switching / wallpaper (AUR)
	nwg-look               # GTK theme settings (AUR)
	obs-vkcapture          # OBS Vulkan capture plugin (AUR)
	visual-studio-code-bin # Visual Studio Code (AUR)
	losslesscut-bin        # Video editing tool (AUR)
	tty-clock              # Terminal clock (AUR)
	frogmouth              # Markdown Browser (AUR)
	appimagelauncher       # AppImage launcher (AUR)
)

# Flatpak packages
FLATPAK_PKGS=(
	org.upscayl.Upscayl # AI image upscaler
)

# AMD GPU additional packages
PKGS_AMD_GPU=(
	libva-utils # VA-API utilities
	bc          # Calculator (required for some scripts)
)

# Additional packages for Japanese language environment
PKGS_JAPANESE=(
	fcitx5-configtool # Fcitx5 configuration tool
	fcitx5-gtk        # Fcitx5 GTK integration
	fcitx5-qt         # Fcitx5 Qt integration
	fcitx5-mozc-ut    # Mozc engine for Fcitx5
)

EXTRA_PKGS=()

if [ "$INSTALL_AMD_GPU" = "1" ]; then
	EXTRA_PKGS+=("${PKGS_AMD_GPU[@]}")
fi

if [ "$INSTALL_JAPANESE" = "1" ]; then
	EXTRA_PKGS+=("${PKGS_JAPANESE[@]}")
fi

require_command paru

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

if [ "$INSTALL_AMD_GPU" = "1" ]; then
	echo "AMD GPU packages to be installed:"
	for pkg in "${PKGS_AMD_GPU[@]}"; do
		echo "  $pkg"
	done
	echo "--------------------------------"
fi

if [ "$INSTALL_JAPANESE" = "1" ]; then
	echo "Japanese language packages to be installed:"
	for pkg in "${PKGS_JAPANESE[@]}"; do
		echo "  $pkg"
	done
	echo "--------------------------------"
fi

echo "================================"
echo "Installing official and AUR packages..."
echo "================================"

# Install official, AUR, and optional packages using paru
paru -Syu --needed "${PKGS_OFFICIAL[@]}" "${PKGS_AUR[@]}" "${EXTRA_PKGS[@]}"

echo "✓ Official and AUR packages installed"

echo "================================"
echo "Installing Flatpak packages..."
echo "================================"

if command -v flatpak &>/dev/null; then
	if flatpak install flathub -y "${FLATPAK_PKGS[@]}"; then
		echo "✓ Flatpak packages installed"
	else
		echo "Error: failed to install Flatpak packages" >&2
		exit 1
	fi
else
	echo "⚠ Flatpak not found - skipping Flatpak package installation"
fi

# Install Nix if requested
if [ "$INSTALL_NIX" = "1" ]; then
	install_nix
fi

echo "================================"
echo "Package installation complete!"
echo "================================"
