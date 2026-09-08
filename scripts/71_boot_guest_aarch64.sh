#!/usr/bin/env bash
# Boot (or reboot) the AArch64 guest prepared by scripts/70_setup_qemu_system_aarch64.sh.
#
#   SMP=4 MEM=2048 bash scripts/71_boot_guest_aarch64.sh   # setup/build boots
#   SMP=1 MEM=1024 bash scripts/71_boot_guest_aarch64.sh   # experiment boots (proposal SS5)
#
# Host port forwards: ssh 2222->22, CI_LAB command uplink udp 1234->1234.
# The guest runs detached; serial console goes to $GUEST_DIR/serial.log and a
# QMP-style monitor socket is left at $GUEST_DIR/monitor.sock.
set -euo pipefail
GUEST_DIR="${GUEST_DIR:-$HOME/onair-mlir-bench/ext/guest}"
SMP="${SMP:-1}"; MEM="${MEM:-1024}"; SSH_PORT="${SSH_PORT:-2222}"
cd "$GUEST_DIR"
if [ -f qemu.pid ] && kill -0 "$(cat qemu.pid)" 2>/dev/null; then
  echo "guest already running (pid $(cat qemu.pid)); stop it first: bash scripts/72_guest_ssh.sh stop"; exit 1
fi
rm -f qemu.pid monitor.sock
: > serial.log
qemu-system-aarch64 \
  -machine virt,gic-version=3 -cpu cortex-a53 -smp "$SMP" -m "$MEM" \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd \
  -drive if=pflash,format=raw,file=efi_vars.fd \
  -drive if=virtio,file=aarch64-linux.qcow2,format=qcow2 \
  -drive if=virtio,file=seed.img,format=raw \
  -device virtio-net-device,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22,hostfwd=udp::1234-:1234 \
  -device virtio-rng-device \
  -display none -serial file:serial.log \
  -monitor unix:monitor.sock,server,nowait \
  -pidfile qemu.pid -daemonize
echo "qemu-system-aarch64 started: pid $(cat qemu.pid), smp=$SMP mem=${MEM}MiB, ssh port $SSH_PORT"
echo "waiting for sshd ..."
for i in $(seq 1 240); do
  if ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        -i id_ed25519 -p "$SSH_PORT" ubuntu@127.0.0.1 true 2>/dev/null; then
    echo "guest up after ~$((i*5)) s"; ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i id_ed25519 -p "$SSH_PORT" ubuntu@127.0.0.1 'uname -a; nproc; free -m | head -2'; exit 0
  fi
  sleep 5
done
echo "guest did not come up in 20 min; see $GUEST_DIR/serial.log"; exit 1
