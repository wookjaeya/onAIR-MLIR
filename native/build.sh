#!/usr/bin/env bash
# Build the native learner against the minimal IREE runtime (local-sync, embedded ELF, no threading).
set -euo pipefail
IREE_SRC="${IREE_SRC:-/tmp/iree-src}"; B="$IREE_SRC/build-rt"
CONTRACT="${1:-../contracts/contract.filled.example.json}"
BOUNDED=$(python3 -c "import json;print(json.load(open('$CONTRACT'))['resources']['bounded_bytes'])")
PERCALL=$(python3 -c "import json;print(json.load(open('$CONTRACT'))['resources']['static_per_call_bytes'])")
CONSTB=$(python3 -c "import json;print(json.load(open('$CONTRACT'))['resources']['module_resident_constant_bytes'])")
LIBS="$(find "$B/runtime" -name "*.a" | tr "\n" " ") $B/build_tools/third_party/flatcc/libflatcc_parsing.a $B/build_tools/third_party/flatcc/libflatcc_runtime.a $B/build_tools/third_party/printf/libprintf_printf.a"
gcc -O2 -std=gnu11 -I"$IREE_SRC/runtime/src" -I"$B/runtime/src" \
  -DIREE_ALLOCATOR_SYSTEM_CTL=iree_allocator_libc_ctl -DCONTRACT_BOUNDED_BYTES=$BOUNDED -DCONTRACT_PER_CALL_BYTES=$PERCALL -DCONTRACT_CONST_BYTES=$CONSTB \
  native_learner.c -o native_learner -Wl,--start-group $LIBS -Wl,--end-group -lm -ldl -lpthread
echo "built native_learner (bounded=$BOUNDED per_call=$PERCALL const=$CONSTB)"; ls -l native_learner | awk '{print "binary bytes:",$5}'
