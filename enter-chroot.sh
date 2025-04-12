#!/bin/bash
set -e

echo "[*] Checking if squashfs-root is already mounted..."

MOUNT_DEV=$(mountpoint -q squashfs-root/dev && echo "yes" || echo "no")
MOUNT_PROC=$(mountpoint -q squashfs-root/proc && echo "yes" || echo "no")
MOUNT_SYS=$(mountpoint -q squashfs-root/sys && echo "yes" || echo "no")

if [[ "$MOUNT_DEV" == "yes" && "$MOUNT_PROC" == "yes" && "$MOUNT_SYS" == "yes" ]]; then
  echo "[+] Already mounted. Skipping mount steps."
else
  echo "[+] Mounting /dev, /proc, /sys into squashfs-root..."
  [[ "$MOUNT_DEV" == "no" ]] && sudo mount --bind /dev squashfs-root/dev
  [[ "$MOUNT_PROC" == "no" ]] && sudo mount --bind /proc squashfs-root/proc
  [[ "$MOUNT_SYS" == "no" ]] && sudo mount --bind /sys squashfs-root/sys
fi

# Always copy resolv.conf for DNS
sudo cp /etc/resolv.conf squashfs-root/etc/resolv.conf

echo "[+] Attempting to enter chroot..."
if ! sudo chroot squashfs-root /bin/bash; then
  echo "[!] Failed to enter chroot. Trying to fix with fix-sudo.sh..."
  if [[ -x ./fix-sudo.sh ]]; then
    ./fix-sudo.sh
  else
    echo "[!] fix-sudo.sh not found or not executable!"
    exit 1
  fi
  echo "[+] Retrying chroot after fix..."
  sudo chroot squashfs-root /bin/bash
fi
