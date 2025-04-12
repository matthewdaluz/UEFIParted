#!/bin/bash
set -e

echo -n "Enter ISO filename (e.g. UEFIParted-v2.iso): "
read ISO_FILE

if [[ ! -f "$ISO_FILE" ]]; then
  echo "[!] File '$ISO_FILE' not found."
  exit 1
fi

echo "[+] Extracting ISO: $ISO_FILE"

# Extract ISO contents using 7z
7z x "$ISO_FILE"

echo "[+] Searching for filesystem.squashfs..."
SQUASHFS_PATH=$(find . -type f -name 'filesystem.squashfs' | head -n 1)

if [[ -z "$SQUASHFS_PATH" ]]; then
  echo "[!] filesystem.squashfs not found!"
  exit 1
fi

echo "[+] Unsquashing $SQUASHFS_PATH into squashfs-root/..."
sudo unsquashfs -d squashfs-root "$SQUASHFS_PATH"

echo "[✓] Done. You can now chroot with ./enter-chroot.sh"
