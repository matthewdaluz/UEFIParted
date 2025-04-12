#!/bin/bash
set -e

BOOT_DIR="boot/grub"
EFI_DIR="EFI/BOOT"

echo "[+] Resetting boot files..."

# Remove boot files but keep grub.cfg
find "$BOOT_DIR" -mindepth 1 ! -name 'grub.cfg' -exec rm -rf {} +

# Also clean EFI binaries
rm -f "$EFI_DIR"/BOOTx64.EFI "$EFI_DIR"/BOOTIA32.EFI

# Reinstall GRUB to ISO folders (x86_64 EFI target only)
echo "[+] Reinstalling GRUB bootloader files..."
grub-mkimage -O x86_64-efi -o "$BOOT_DIR/x86_64-efi/monolithic/grubx64.efi" \
  -p /boot/grub \
  part_gpt part_msdos fat iso9660 normal linux search gfxterm all_video jpeg echo test \
  configfile loopback linuxefi boot

# Copy GRUB binary to EFI/BOOT (as BOOTx64.EFI)
cp "$BOOT_DIR/x86_64-efi/monolithic/grubx64.efi" "$EFI_DIR/BOOTx64.EFI"

# Optionally copy BOOTIA32 if supporting IA32
# cp "$EFI_DIR/BOOTx64.EFI" "$EFI_DIR/BOOTIA32.EFI"

echo "[+] Bootloader files reset and reinstalled."
