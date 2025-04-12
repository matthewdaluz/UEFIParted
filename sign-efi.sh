#!/bin/bash
set -e

KEY="db.key"
CERT="db.crt"

# Auto-generate cert if missing
if [[ ! -f "$KEY" || ! -f "$CERT" ]]; then
  echo "[!] Missing $KEY or $CERT. Generating new Secure Boot keypair..."

  openssl req -new -x509 -newkey rsa:2048 \
    -keyout "$KEY" -out "$CERT" -days 3650 -nodes \
    -subj "/CN=UEFIParted Secure Boot/"

  echo "[+] Created:"
  echo "    → $KEY"
  echo "    → $CERT"
fi

echo "[+] Signing EFI files..."

# List of EFI files to sign
FILES_TO_SIGN=(
  "EFI/BOOT/BOOTx64.EFI"
  "EFI/BOOT/BOOTIA32.EFI"
  "boot/grub/x86_64-efi/monolithic/grubx64.efi"
  "boot/grub/x86_64-efi/monolithic/gcdx64.efi"
)

for file in "${FILES_TO_SIGN[@]}"; do
  if [[ -f "$file" ]]; then
    echo "  → Signing $file"
    sbsign --key "$KEY" --cert "$CERT" --output "$file" "$file"
  else
    echo "  → Skipping $file (not found)"
  fi
done

echo "[✓] All done signing EFI binaries."
