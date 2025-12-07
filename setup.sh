#!/bin/sh

# Main setup script for niri environment
# This script orchestrates all setup scripts in the correct order
# Run with sudo privileges if necessary
# Target: Arch Linux or Arch based distributions

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  Niri Environment Setup"
echo "========================================"
echo ""

# Function to run a script and handle errors
run_script() {
  local script_path="$1"
  local script_name="$(basename "$script_path")"

  if [ -f "$script_path" ]; then
    echo ">>> Running: $script_name"
    if sh "$script_path"; then
      echo "✓ $script_name completed successfully"
      echo ""
    else
      echo "✗ $script_name failed"
      exit 1
    fi
  else
    echo "⚠ Warning: $script_path not found - skipping"
    echo ""
  fi
}

# Step 1: Install packages
run_script "${SCRIPT_DIR}/scripts/install-packages.sh"

# Step 2: Set up Docker
run_script "${SCRIPT_DIR}/scripts/setup-docker.sh"

# Step 3: Configure GNOME settings (for nwg-look-independent settings)
run_script "${SCRIPT_DIR}/scripts/setup_gnome_settings.sh"

# Add more setup scripts here as needed
# run_script "${SCRIPT_DIR}/scripts/setup-fonts.sh"
# run_script "${SCRIPT_DIR}/scripts/setup-something.sh"

echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  - Log out and log back in for group changes to take effect"
echo "  - Run 'stow' to symlink your dotfiles"
echo ""
