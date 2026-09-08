#!/usr/bin/env bash
# Thin wrappers around the guest: `... ssh <cmd>`, `... scp <src> <dst>` (dst
# relative to the guest home), `... stop` (ACPI powerdown, then hard kill).
set -euo pipefail
GUEST_DIR="${GUEST_DIR:-$HOME/onair-mlir-bench/ext/guest}"; SSH_PORT="${SSH_PORT:-2222}"
OPTS=(-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -i "$GUEST_DIR/id_ed25519")
case "${1:-}" in
  ssh)  shift; exec ssh "${OPTS[@]}" -p "$SSH_PORT" ubuntu@127.0.0.1 "$@" ;;
  scp)  shift; exec scp "${OPTS[@]}" -P "$SSH_PORT" -r "$1" "ubuntu@127.0.0.1:$2" ;;
  scpback) shift; exec scp "${OPTS[@]}" -P "$SSH_PORT" -r "ubuntu@127.0.0.1:$1" "$2" ;;
  stop)
    cd "$GUEST_DIR"
    if [ -f qemu.pid ] && kill -0 "$(cat qemu.pid)" 2>/dev/null; then
      echo system_powerdown | socat - UNIX-CONNECT:monitor.sock >/dev/null 2>&1 || true
      for i in $(seq 1 30); do kill -0 "$(cat qemu.pid)" 2>/dev/null || break; sleep 2; done
      kill -0 "$(cat qemu.pid)" 2>/dev/null && kill "$(cat qemu.pid)" || true
      sleep 1; rm -f qemu.pid; echo "guest stopped"
    else echo "guest not running"; fi ;;
  *) echo "usage: $0 ssh <cmd> | scp <src> <dst> | scpback <src> <dst> | stop"; exit 2 ;;
esac
