#!/bin/bash

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root (sudo)" >&2
  exit 1
fi

# Install dependencies
if command -v apt-get &> /dev/null; then
  apt-get install -y curl unzip sed grub2-common
elif command -v pacman &> /dev/null; then
  pacman -S --noconfirm curl unzip sed grub
fi

# Copy themes
mkdir -p /usr/share/grub/themes/
cp -r themes/* /usr/share/grub/themes/

# Install main script
install -Dm755 shuffle-grub-theme /usr/local/bin/shuffle-grub-theme

# Create config dir
mkdir -p /etc/grub-theme-shuffler/
[ ! -f /etc/grub-theme-shuffler/exclude.conf ] && 
  cp exclude.conf.example /etc/grub-theme-shuffler/exclude.conf

# Systemd service
cat > /etc/systemd/system/shuffle-grub-theme.service <<EOF
[Unit]
Description=Shuffle GRUB theme at boot
Before=grub-update.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/shuffle-grub-theme

[Install]
WantedBy=sysinit.target
EOF

systemctl daemon-reload
systemctl enable shuffle-grub-theme.service

# First run
/usr/local/bin/shuffle-grub-theme

echo "Installed! Themes will shuffle on reboot."
