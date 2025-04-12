#!/bin/bash

echo "[*] Attempting to fix 'sudo: unable to allocate pty: No such device'..."

su -c '
  echo "[+] Unmounting chroot devices..."

  if mountpoint -q squashfs-root/dev; then
    echo "  → Unmounting /dev"
    umount squashfs-root/dev
  fi

  if mountpoint -q squashfs-root/proc; then
    echo "  → Unmounting /proc"
    umount squashfs-root/proc
  fi

  if mountpoint -q squashfs-root/sys; then
    echo "  → Unmounting /sys"
    umount squashfs-root/sys
  fi

  echo "[✓] Unmount complete. Try entering chroot again with ./enter-chroot.sh"
'

exit 0
