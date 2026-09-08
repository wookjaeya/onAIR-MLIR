#!/usr/bin/env bash
# Boot (or reboot) the AArch64 guest prepared by scripts/70_setup_qemu_system_aarch64.sh.
#
#   SMP=4 MEM=2048 bash scripts/71_boot_guest_aarch64.sh   # setup/build boots
#   SMP=1 MEM=1024 bash scripts/71_boot_guest_aarch64.sh   # experiment boots (proposal SS5)
#
# Host port forwards: ssh 2222->22, CI_LAB command uplink udp 1234->1234.
# The guest runs detached; the serial console is a UNIX socket (server=on,
# wait=off) at $GUEST_DIR/serial.sock so scripts/73_console.sh can both read
# and write it (needed to drive an emergency-mode shell, "Enter for
# maintenance", etc.) -- a plain `-serial file:` sink is output-only and
# cannot do that. A background socat tees the socket to $GUEST_DIR/serial.log
# for grepping. A QMP-style human monitor socket is left at
# $GUEST_DIR/monitor.sock.
set -euo pipefail
GUEST_DIR="${GUEST_DIR:-$HOME/onair-mlir-bench/ext/guest}"
SMP="${SMP:-1}"; MEM="${MEM:-1024}"; SSH_PORT="${SSH_PORT:-2222}"
cd "$GUEST_DIR"
if [ -f qemu.pid ] && kill -0 "$(cat qemu.pid)" 2>/dev/null; then
  echo "guest already running (pid $(cat qemu.pid)); stop it first: bash scripts/72_guest_ssh.sh stop"; exit 1
fi
rm -f qemu.pid monitor.sock serial.sock
: > serial.log
if [ -f tee.pid ] && kill -0 "$(cat tee.pid)" 2>/dev/null; then kill "$(cat tee.pid)"; fi
qemu-system-aarch64 \
  -machine virt,gic-version=3 -cpu cortex-a53 -smp "$SMP" -m "$MEM" \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd \
  -drive if=pflash,format=raw,file=efi_vars.fd \
  -drive if=virtio,file=aarch64-linux.qcow2,format=qcow2 \
  -drive if=virtio,file=seed.img,format=raw \
  -device virtio-net-device,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22,hostfwd=udp::1234-:1234 \
  -device virtio-rng-device \
  -display none \
  -chardev socket,id=serial0,path=serial.sock,server=on,wait=off \
  -serial chardev:serial0 \
  -monitor unix:monitor.sock,server,nowait \
  -pidfile qemu.pid -daemonize
# give qemu a moment to create the socket before socat dials it
for i in $(seq 1 20); do [ -S serial.sock ] && break; sleep 0.5; done
( setsid socat -u UNIX-CONNECT:serial.sock,retry=5 STDOUT >> serial.log 2>/dev/null & echo $! > tee.pid ) &
disown
echo "qemu-system-aarch64 started: pid $(cat qemu.pid), smp=$SMP mem=${MEM}MiB, ssh port $SSH_PORT"
echo "waiting for sshd ..."
for i in $(seq 1 240); do
  if ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        -i id_ed25519 -p "$SSH_PORT" ubuntu@127.0.0.1 true 2>/dev/null; then
    echo "guest up after ~$((i*5)) s"; ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i id_ed25519 -p "$SSH_PORT" ubuntu@127.0.0.1 'uname -a; nproc; free -m | head -2'; exit 0
  fi
  sleep 5
done
echo "guest did not come up in 20 min; see $GUEST_DIR/serial.log or scripts/73_console.sh"; exit 1
