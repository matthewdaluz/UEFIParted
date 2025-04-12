#!/bin/bash
set -e

echo "[+] Cleaning UEFIParted live system..."

sudo chroot squashfs-root /bin/bash <<'EOF'
apt clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/* /var/tmp/*
rm -f /etc/machine-id /var/lib/dbus/machine-id
rm -f /root/.bash_history /root/.nano_history
rm -rf /home/*
EOF

echo "[+] Unmounting bound filesystems..."
sudo umount squashfs-root/dev
sudo umount squashfs-root/proc
sudo umount squashfs-root/sys
sudo rm -f squashfs-root/etc/resolv.conf

echo "[+] Cleanup complete."
