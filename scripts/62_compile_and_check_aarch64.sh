#!/usr/bin/env bash
# E14 Stage 0, reproducible: cross-compile a model for AArch64/Cortex-A53 in
# ONE iree-compile invocation (contract + IR dump + executable dump + vmfb
# together -- see EVIDENCE_v0.7_E13.md SS1.3 for why this matters), then
# statically cross-compile native_learner and run it under qemu-aarch64
# (user-mode quick check only -- timing/RSS from this run are NOT evidence,
# per QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md SS14/SS19).
set -euo pipefail
BENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="${1:-$HOME/onair-mlir-bench/ext}"
OUT="${2:-$BENCH_DIR/e14/aarch64}"
MLIR="${3:-$BENCH_DIR/e14/m16k_baked.mlir}"
mkdir -p "$OUT/dump"

iree-compile "$MLIR" \
  --iree-hal-target-backends=llvm-cpu \
  --iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu \
  --iree-llvmcpu-target-cpu=cortex-a53 \
  --mlir-print-ir-after=iree-stream-layout-slices \
  --iree-hal-dump-executable-files-to="$OUT/dump" \
  -o "$OUT/model.vmfb" 2> "$OUT/layout_ir.txt"

sha256sum "$OUT/model.vmfb"
python3 "$BENCH_DIR/harness/static_mem_bound.py" "$MLIR" --shape 9 16384 2 \
  --extra="--iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu --iree-llvmcpu-target-cpu=cortex-a53" \
  --baked 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print('bounded_bytes (IR-only, no run):', d.get('static_total_bytes_incl_inputs',0)+d.get('static_constant_bytes_module_resident',0))" || true

IREE_SRC="$ROOT/iree-src"; IREE_B="$IREE_SRC/build-rt-aarch64"
[ -d "$IREE_B" ] || { echo "run scripts/61_build_iree_runtime_aarch64.sh first"; exit 1; }
LIBS=$(find "$IREE_B/runtime" -name "*.a" | tr '\n' ' ')
LIBS="$LIBS $IREE_B/build_tools/third_party/flatcc/libflatcc_parsing.a"
LIBS="$LIBS $IREE_B/build_tools/third_party/flatcc/libflatcc_runtime.a"
LIBS="$LIBS $IREE_B/build_tools/third_party/printf/libprintf_printf.a"

WORK="$OUT/native"; mkdir -p "$WORK"; cd "$WORK"
cp "$BENCH_DIR/native/native_learner.c" "$BENCH_DIR/native/sha256.h" .
python3 - "$OUT/model.vmfb" <<'PY'
import json, hashlib, sys
b = open(sys.argv[1], "rb").read()
json.dump({"resources": {"bounded_bytes": 786476, "static_per_call_bytes": 65580,
                         "module_resident_constant_bytes": 720896},
          "artifact": {"bytes": len(b), "sha256": hashlib.sha256(b).hexdigest()},
          "validity": {"input": {"shape": [1, 9]}, "output": {"shape": [1, 2]},
                       "driver": "local-sync"}},
          open("contract_aarch64.json", "w"))
PY
python3 "$BENCH_DIR/harness/gen_contract_header.py" contract_aarch64.json contract_gen.h

aarch64-linux-gnu-gcc -O2 -std=gnu11 -static \
  -I"$IREE_SRC/runtime/src" -I"$IREE_B/runtime/src" -I. \
  -DIREE_ALLOCATOR_SYSTEM_CTL=iree_allocator_libc_ctl \
  native_learner.c -o native_learner_aarch64 \
  -Wl,--start-group $LIBS -Wl,--end-group -lm -lpthread

echo "=== qemu-user quick check: ADMIT + run (timing NOT evidence) ==="
qemu-aarch64 ./native_learner_aarch64 "$OUT/model.vmfb" 1048576 500
echo "=== boundary B-1 (expect NOT_ADMITTED) ==="
qemu-aarch64 ./native_learner_aarch64 "$OUT/model.vmfb" 786475 5 | grep verdict
echo "=== boundary B, B+1 (expect ADMIT) ==="
qemu-aarch64 ./native_learner_aarch64 "$OUT/model.vmfb" 786476 5 | grep -m1 verdict
qemu-aarch64 ./native_learner_aarch64 "$OUT/model.vmfb" 786477 5 | grep -m1 verdict
