#!/usr/bin/env bash
# E14 Stage 1: host-side preparation of a bootable AArch64 Linux guest for
# qemu-system-aarch64 (proposal QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md SS7.1).
#
#   - installs qemu-system-aarch64 + UEFI firmware (AAVMF) + cloud-image-utils
#   - fetches the Ubuntu 24.04 (noble) arm64 cloud image (single download, kept
#     pristine as a read-only backing file)
#   - creates a qcow2 OVERLAY on top of it (so the guest can be reset to a clean
#     state by deleting the overlay) and a cloud-init NoCloud seed that injects
#     an SSH key, a password, and the POSIX mqueue limit cFS needs
#
# Nothing here boots the guest; see scripts/71_boot_guest_aarch64.sh.
set -euo pipefail
GUEST_DIR="${1:-$HOME/onair-mlir-bench/ext/guest}"
IMG_URL="${IMG_URL:-https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img}"
OVERLAY_SIZE="${OVERLAY_SIZE:-12G}"
mkdir -p "$GUEST_DIR" && cd "$GUEST_DIR"

if ! command -v qemu-system-aarch64 >/dev/null || ! command -v cloud-localds >/dev/null; then
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    qemu-system-arm qemu-utils qemu-efi-aarch64 cloud-image-utils openssh-client
fi

BASE="noble-server-cloudimg-arm64.img"
[ -s "$BASE" ] || wget -q -O "$BASE" "$IMG_URL"
sha256sum "$BASE" | tee base_image.sha256

[ -f id_ed25519 ] || ssh-keygen -q -t ed25519 -N "" -f id_ed25519 -C "onair-e14-guest"

# UEFI: use the pflash pair (code read-only + a private writable copy of the
# vars image). Functionally equivalent to the proposal's `-bios QEMU_EFI.fd`
# example, but lets the firmware persist boot variables across reboots.
FW_CODE=/usr/share/AAVMF/AAVMF_CODE.fd
FW_VARS=/usr/share/AAVMF/AAVMF_VARS.fd
[ -f "$FW_CODE" ] || { echo "AAVMF firmware not found at $FW_CODE"; exit 1; }
[ -f efi_vars.fd ] || cp "$FW_VARS" efi_vars.fd

# Overlay disk on the pristine base image.
if [ ! -f aarch64-linux.qcow2 ]; then
  qemu-img create -q -f qcow2 -F qcow2 -b "$BASE" aarch64-linux.qcow2 "$OVERLAY_SIZE"
fi

# cloud-init NoCloud seed (first boot only; instance-id fixed so it is not re-run).
PUB="$(cat id_ed25519.pub)"
cat > user-data <<UD
#cloud-config
hostname: onair-aarch64
manage_etc_hosts: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    ssh_authorized_keys:
      - $PUB
disable_root: false
ssh_pwauth: true
chpasswd:
  expire: false
  users:
    - name: ubuntu
      password: onair
      type: text
package_update: false
package_upgrade: false
write_files:
  # cFS: cFE SB pipes are POSIX message queues; default msg_max=10 breaks
  # pipe creation (errno=22). Same fix as scripts/00_env.sh on the host.
  - path: /etc/sysctl.d/99-cfs-mqueue.conf
    content: |
      fs.mqueue.msg_max = 512
      fs.mqueue.queues_max = 1024
runcmd:
  - sysctl --system
  - systemctl disable --now snapd.service snapd.socket snapd.seeded.service || true
  - systemctl disable --now unattended-upgrades.service apt-daily.timer apt-daily-upgrade.timer || true
UD
cat > meta-data <<MD
instance-id: onair-e14-guest
local-hostname: onair-aarch64
MD
cloud-localds seed.img user-data meta-data
echo "guest dir prepared: $GUEST_DIR"
ls -la "$GUEST_DIR"
