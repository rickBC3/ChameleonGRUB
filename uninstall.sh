#!/bin/bash

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root (sudo)" >&2
  exit 1
fi

# Remove files
rm -rf /usr/share/grub/themes/*
rm -f /usr/local/bin/shuffle-grub-theme
rm -rf /etc/grub-theme-shuffler

# Disable service
systemctl disable --now shuffle-grub-theme.service
rm -f /etc/systemd/system/shuffle-grub-theme.service
systemctl daemon-reload

# Reset GRUB config
sed -i 's/^GRUB_THEME=/#GRUB_THEME=/' /etc/default/grub
update-grub 2>/dev/null || grub-mkconfig -o /boot/grub/grub.cfg

echo "Uninstalled! GRUB restored to default."
