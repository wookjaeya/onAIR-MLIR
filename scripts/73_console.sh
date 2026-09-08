#!/usr/bin/env bash
# Interact with the guest's serial console (input+output) via its UNIX socket,
# for cases ssh cannot reach: emergency-mode shell, GRUB, boot hangs. Requires
# scripts/71 to have started qemu with -chardev socket,...,server=on,wait=off.
#   scripts/73_console.sh send 'journalctl -xb --no-pager | tail -100'   # sends text + Enter, prints the reply
#   scripts/73_console.sh send ''                                        # just press Enter
#   scripts/73_console.sh raw <<< 'some multi-line input'                # pipe raw bytes, no auto-Enter
set -euo pipefail
GUEST_DIR="${GUEST_DIR:-$HOME/onair-mlir-bench/ext/guest}"
SOCK="$GUEST_DIR/serial.sock"
[ -S "$SOCK" ] || { echo "no serial socket at $SOCK (guest not running with scripts/71?)"; exit 1; }
case "${1:-}" in
  send)
    shift
    { printf '%s\r' "$*"; sleep 3; } | socat - UNIX-CONNECT:"$SOCK" > /tmp/console_reply.$$ 2>/dev/null || true
    cat /tmp/console_reply.$$; rm -f /tmp/console_reply.$$ ;;
  raw)
    socat - UNIX-CONNECT:"$SOCK" ;;
  *) echo "usage: $0 send 'text' | raw"; exit 2 ;;
esac
