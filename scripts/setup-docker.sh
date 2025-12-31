#!/bin/sh

# Script to set up Docker service
# Run with sudo privileges if necessary
# Target: Systems with systemd

echo "================================"
echo "Setting up Docker service..."
echo "================================"

# Enable and start Docker service
if command -v systemctl &> /dev/null; then
  if systemctl is-active --quiet docker; then
    echo "✓ Docker service is already running"
  else
    echo "Enabling and starting Docker service..."
    if sudo systemctl enable docker; then
      echo "✓ Docker service enabled"
      if sudo systemctl start docker; then
        echo "✓ Docker service started successfully"
      else
        echo "✗ Failed to start Docker service"
        exit 1
      fi
    else
      echo "✗ Failed to enable Docker service"
      exit 1
    fi
  fi

  # Check if user is already in docker group
  if [ -n "$SUDO_USER" ]; then
    if groups "$SUDO_USER" 2>/dev/null | grep -q docker; then
      echo "✓ User $SUDO_USER is already in docker group"
    else
      echo "Adding user $SUDO_USER to docker group..."
      if sudo usermod -aG docker "$SUDO_USER" 2>/dev/null; then
        echo "✓ User added to docker group"
        echo "⚠ Note: You need to log out and log back in for group changes to take effect"
      else
        echo "⚠ Could not add user to docker group (may require manual setup)"
      fi
    fi
  fi
else
  echo "⚠ systemctl not found - skipping Docker service setup"
fi

echo "================================"
echo "Docker setup complete!"
echo "================================"
