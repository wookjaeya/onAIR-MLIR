#!/usr/bin/env bash
# AArch64 cross-toolchain + QEMU user-mode (for quick native-binary checks only,
# per QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md SS6: "qemu-aarch64 user-mode is used
# only for quick pre-check of native executables"). This does NOT set up
# qemu-system-aarch64 (system emulation, needed for the cFS-in-guest stage) --
# see scripts/70_setup_qemu_system_aarch64.md for that.
set -euo pipefail
apt-get update -qq
apt-get install -y -qq \
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu \
  qemu-user qemu-user-static
echo "=== versions (record in environment manifest) ==="
aarch64-linux-gnu-gcc --version | head -1
aarch64-linux-gnu-objdump --version | head -1
aarch64-linux-gnu-readelf --version | head -1
qemu-aarch64 --version | head -1
