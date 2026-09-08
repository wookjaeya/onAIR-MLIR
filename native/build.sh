#!/usr/bin/env bash
# Build the native learner against the minimal IREE runtime (local-sync, embedded ELF, no threading).
set -euo pipefail
IREE_SRC="${IREE_SRC:-/tmp/iree-src}"; B="$IREE_SRC/build-rt"
CONTRACT="${1:-../contracts/contract.filled.example.json}"
python3 ../harness/gen_contract_header.py "$CONTRACT" contract_gen.h >/dev/null
LIBS="$(find "$B/runtime" -name "*.a" | tr "\n" " ") $B/build_tools/third_party/flatcc/libflatcc_parsing.a $B/build_tools/third_party/flatcc/libflatcc_runtime.a $B/build_tools/third_party/printf/libprintf_printf.a"
gcc -O2 -std=gnu11 -I"$IREE_SRC/runtime/src" -I"$B/runtime/src" \
  -DIREE_ALLOCATOR_SYSTEM_CTL=iree_allocator_libc_ctl -I. \
  native_learner.c -o native_learner -Wl,--start-group $LIBS -Wl,--end-group -lm -ldl -lpthread
echo "built native_learner (contract header generated from $CONTRACT)"; ls -l native_learner | awk '{print "binary bytes:",$5}'
