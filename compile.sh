#!/bin/bash
set -e

# Ask for ISO filename
read -p "Enter desired ISO output filename (e.g. UEFIParted-v2.iso): " ISO_NAME
if [[ -z "$ISO_NAME" ]]; then
  echo "[!] No ISO name entered. Exiting."
  exit 1
fi

# Ask for volume ID
read -p "Enter ISO volume ID (VOLID, e.g. UEFIPARTED): " VOLID
if [[ -z "$VOLID" ]]; then
  echo "[!] No VOLID entered. Exiting."
  exit 1
fi

SQUASHFS_PATH="live/filesystem.squashfs"
CHROOT_DIR="squashfs-root"

# Check for mounts
echo "[*] Checking for mounts..."
if mountpoint -q "$CHROOT_DIR/dev" || mountpoint -q "$CHROOT_DIR/proc" || mountpoint -q "$CHROOT_DIR/sys"; then
    echo "[!] Error: One or more chroot mountpoints are still mounted. Run cleanup.sh first."
    exit 1
fi

# Delete old squash
echo "[+] Removing old squashfs (if any)..."
sudo rm -f "$SQUASHFS_PATH"

# Rebuild squashfs
echo "[+] Creating new filesystem.squashfs..."
sudo mksquashfs "$CHROOT_DIR" "$SQUASHFS_PATH" -comp xz -b 1048576 -Xbcj x86 -noappend

# Compile ISO with xorriso
echo "[+] Compiling ISO: $ISO_NAME with VOLID: $VOLID"
xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "$VOLID" \
  -output "$ISO_NAME" \
  -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
  -eltorito-alt-boot \
    -e EFI/BOOT/BOOTx64.EFI \
    -no-emul-boot \
  -isohybrid-gpt-basdat \
  -isohybrid-apm-hfsplus \
  -m 'squashfs-root' \
  -m '*.sh' \
  -m '*.iso' \
  -m '.git' \
  -m '.DS_Store' \
  -m '*~' \
  .

echo "[✓] ISO build complete: $ISO_NAME"
