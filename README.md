![UEFIParted Logo White](https://github.com/user-attachments/assets/7dc87181-03e6-43fc-a715-84dbac0c8d36)

### (Notice: UEFIParted used to be only for me, and this is it's first ever public release. Expect issues.)
**UEFIParted** is a minimalist, Debian-based live environment designed to simplify disk partitioning, UEFI firmware management, and Secure Boot-compatible OS deployment. Built with a fast XFCE4 desktop, UEFIParted provides a user-friendly interface with powerful tools for system recovery, disk prep, and bootloader configuration.

---

## 🧰 Features

- ✅ Debian-based Live ISO
- ✅ Fully UEFI + Secure Boot Compatible
- ✅ XFCE4 Desktop
- ✅ Graphical partition editors (GParted)
- ✅ Preinstalled UEFI tools: `efibootmgr`, `fwupd`, `mokutil`(Unconfirmed, I will need to check later.)
- ✅ Encrypted persistence support (`overlayfs`, `casper-rw`)
- ✅ Modular toolsets for recovery, forensics, and installation
- ✅ USB bootable

---

## 📦 Default Toolkit

- `GParted`, `parted`, `lsblk`, `blkid`, `mkfs`, etc.
- `efibootmgr`, `mokutil`, `fwupd`
- `plymouth`, `grub-efi`, `shim` (optional)
- `xfce4-terminal`, `Thunar`, `mousepad`

---

## 🧪 Use Cases

- Preparing disks for Linux installation with GPT
- Troubleshooting UEFI firmware boot entries
- Secure disk layout management with encryption
- OS deployment in educational or enterprise settings

---

## 🛠️ Build From Source

You can fully rebuild or customize UEFIParted using the provided Bash scripts:

```bash
./extract-iso.sh        # Extract ISO and squashfs
./enter-chroot.sh       # Mount + chroot into squashfs-root
./cleanup.sh            # Clean up and unmount
./sign-efi.sh           # Sign EFI binaries for Secure Boot
./compile.sh            # Rebuild squashfs + ISO
```

---

## 💬 License

UEFIParted is open source and MIT-licensed. Feel free to fork, customize, or contribute.
