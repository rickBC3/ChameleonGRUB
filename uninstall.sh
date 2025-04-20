#!/bin/bash

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root (sudo)" >&2
  exit 1
fi

echo "Uninstalling ChameleonGRUB..."

# Remove files
echo "→ Removing themes..."
rm -rf /usr/share/grub/themes/*
echo "→ Removing scripts..."
rm -f /usr/local/bin/ChameleonGRUB
rm -rf /etc/ChameleonGRUB

# Kali Linux cleanup
rm -f /etc/default/grub.d/kali-themes.cfg 2>/dev/null

# Disable service
echo "→ Removing systemd service..."
systemctl disable --now ChameleonGRUB.service
rm -f /etc/systemd/system/ChameleonGRUB.service
systemctl daemon-reload

# Reset GRUB config
echo "→ Restoring GRUB defaults..."
sed -i 's/^GRUB_THEME=/#GRUB_THEME=/' /etc/default/grub 2>/dev/null
if command -v update-grub &>/dev/null; then
  update-grub
else
  grub-mkconfig -o /boot/grub/grub.cfg
fi

echo -e "\n✅ ChameleonGRUB completely uninstalled!\nGRUB has been restored to default settings."
