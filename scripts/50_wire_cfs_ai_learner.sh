#!/usr/bin/env bash
# Wires native/cfs_app into a cFS bundle checkout as the `ai_learner` app,
# and builds cFS with it included. Requires:
#   - cFS already cloned+built once via scripts/10_build_cfs.sh (or this
#     script will do the clone itself)
#   - IREE runtime built via scripts/40_setup_iree_source_runtime.sh
# Verified 2026-09-08 on cFS bundle commit 78c23b0 (nasa/cFS main).
set -euo pipefail
CFS_ROOT="${1:-$HOME/onair-mlir-bench/ext/cFS}"
IREE_B="${2:-$HOME/onair-mlir-bench/ext/iree-src/build-rt}"
BENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$CFS_ROOT" ]; then
  mkdir -p "$(dirname "$CFS_ROOT")"
  git clone --recurse-submodules --shallow-submodules https://github.com/nasa/cFS.git "$CFS_ROOT"
fi
cd "$CFS_ROOT"

mkdir -p apps/ai_learner/fsw/src
cp "$BENCH_DIR"/native/cfs_app/CMakeLists.txt apps/ai_learner/CMakeLists.txt
cp "$BENCH_DIR"/native/cfs_app/fsw/src/*.c "$BENCH_DIR"/native/cfs_app/fsw/src/*.h apps/ai_learner/fsw/src/
# CMakeLists.txt references the IREE runtime by absolute path; point it at
# the actual build directory on this machine.
sed -i "s#set(IREE_SRC \"/tmp/iree-src\")#set(IREE_SRC \"$(dirname "$IREE_B")\")#" apps/ai_learner/CMakeLists.txt

# EVIDENCE_v0.10 Phase 3 (D15/EVIDENCE_v0.9 §11.5): AI_LEARNER_Init() now
# actually REJECTS init if the ES-reported task stack is below
# AI_LEARNER_STACK_BASE_BYTES + CONTRACT_KERNEL_STACK_BYTES (it used to be
# telemetry-only). This script used to hardcode the startup-script stack at
# exactly AI_LEARNER_STACK_BASE_BYTES (262144), ignoring the header's kernel
# stack figure entirely -- WIRING.md §4 always said the entry must be
# base + CONTRACT_KERNEL_STACK_BYTES; only scripts/51_build_cfs_aarch64.sh
# actually did that. On x86-64 this was a latent bug: for any model with a
# nonzero kernel_task_stack_bytes it would now start the app 1 kernel-stack
# short of what its own gate demands. Compute it from whichever
# contract_gen.h has just been copied in (falls back to 0, same as script 51,
# if the header predates the Stage 1 macro set).
CONTRACT_HEADER="apps/ai_learner/fsw/src/contract_gen.h"
KERNEL_STACK_BYTES="$(sed -n 's/^#define[[:space:]]\+CONTRACT_KERNEL_STACK_BYTES[[:space:]]\+\([0-9]\+\).*/\1/p' "$CONTRACT_HEADER" | head -1)"
KERNEL_STACK_BYTES="${KERNEL_STACK_BYTES:-0}"
STACK_BASE_BYTES="${AI_LEARNER_STACK_BASE_BYTES:-262144}"
STARTUP_STACK=$((STACK_BASE_BYTES + KERNEL_STACK_BYTES))
echo "ai_learner startup stack: base=$STACK_BASE_BYTES + kernel=$KERNEL_STACK_BYTES = $STARTUP_STACK"

# Register the app: bundle build (add app + link order + startup script entry).
grep -q "ai_learner" sample_defs/targets.cmake || \
  sed -i 's/^list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib)/list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner)/' \
    sample_defs/targets.cmake
sed -i '/CFE_APP, ai_learner,/d' sample_defs/generate_startup.cmake
sed -i 's|^\(        "CFE_APP, sample_app,  SAMPLE_APP_Main,    SAMPLE_APP,   50,   32768, 0x0, 0;\\n"\)$|\1\n        "CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   '"$STARTUP_STACK"', 0x0, 0;\\n"|' \
  sample_defs/generate_startup.cmake
grep -q "CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   $STARTUP_STACK, 0x0, 0;" sample_defs/generate_startup.cmake \
  || { echo "ERROR: startup entry patch failed (stack $STARTUP_STACK) in sample_defs/generate_startup.cmake" >&2; exit 1; }

# cFS applies -std=c99 -pedantic -Werror to apps; IREE headers need gnu11.
grep -q "target_compile_options(ai_learner" apps/ai_learner/CMakeLists.txt || cat >> apps/ai_learner/CMakeLists.txt <<'CM'
target_compile_options(ai_learner PRIVATE -std=gnu11 -Wno-pedantic -Wno-error -Wno-unused-result)
CM

make native_std.prep
ARCH_DIR="build-native_std/native/default_cpu1"
# D61 / E38: ALWAYS pass the conditional opt-in explicitly. build-native_std is a persistent
# tree shared across invocations, so `${VAR:+-D...}` does NOT mean "previous default" -- it
# means "whatever the last build left in CMakeCache.txt". Script 51 was fixed for this in E36;
# this one had the same shape. Default 0: every existing x86-64 deployment keeps the
# unconditional decision byte for byte.
ALLOW_CONDITIONAL_MAP="${AI_LEARNER_ALLOW_CONDITIONAL_MAP:-0}"
cmake ${AI_LEARNER_BUDGET_BYTES:+-DAI_LEARNER_BUDGET_BYTES="$AI_LEARNER_BUDGET_BYTES"} \
      ${AI_LEARNER_STACK_BASE_BYTES:+-DAI_LEARNER_STACK_BASE_BYTES="$AI_LEARNER_STACK_BASE_BYTES"} \
      -DAI_LEARNER_ALLOW_CONDITIONAL_MAP="$ALLOW_CONDITIONAL_MAP" \
      "$ARCH_DIR"
make native_std.install

# E38: verify the opt-in reached the compile AND the shipped binary, the same two ways
# script 51 does -- a stale cache must fail the BUILD, not surface as a cell that quietly
# admitted (or refused) with a setting nobody recorded.
CC_JSON="$ARCH_DIR/compile_commands.json"
if [ -f "$CC_JSON" ]; then
  AI_CMD="$(python3 - "$CC_JSON" <<'PYCC'
import json,sys
for e in json.load(open(sys.argv[1])):
    if e["file"].endswith("ai_learner.c"): print(e["command"]); break
PYCC
)"
  case "$AI_CMD" in
    *"-DAI_LEARNER_ALLOW_CONDITIONAL_MAP=$ALLOW_CONDITIONAL_MAP"*) ;;
    *) echo "ERROR: AI_LEARNER_ALLOW_CONDITIONAL_MAP=$ALLOW_CONDITIONAL_MAP did not reach the ai_learner.c compile (stale CMakeCache?): $AI_CMD" >&2; exit 1;;
  esac
else
  echo "NOTE: no $CC_JSON -- skipping the compile-command check (the binary witness below still runs)"
fi
HDR_PER_CALL="$(sed -n 's/^#define[[:space:]]\+CONTRACT_PER_CALL_BYTES[[:space:]]\+\([0-9-]\+\).*/\1/p' "$CONTRACT_HEADER" | head -1)"
HDR_BOUNDED="$(sed -n 's/^#define[[:space:]]\+CONTRACT_BOUNDED_BYTES[[:space:]]\+\([0-9-]\+\).*/\1/p' "$CONTRACT_HEADER" | head -1)"
if [ -n "${HDR_PER_CALL:-}" ] && [ "${HDR_PER_CALL}" -gt 0 ] 2>/dev/null; then
  python3 "$BENCH_DIR/harness/optin_witness.py" "build-native_std/exe/cpu1/cf/ai_learner.so" \
    --per-call "$HDR_PER_CALL" --bounded "$HDR_BOUNDED" --expect "$ALLOW_CONDITIONAL_MAP" \
    --out "build-native_std/exe/cpu1/optin_witness.json" >/dev/null \
    || { echo "ERROR: the built ai_learner.so does not witness AI_LEARNER_ALLOW_CONDITIONAL_MAP=$ALLOW_CONDITIONAL_MAP" >&2; exit 1; }
  echo "optin witness: ai_learner.so shows AI_LEARNER_ALLOW_CONDITIONAL_MAP=$ALLOW_CONDITIONAL_MAP"
else
  echo "NOTE: contract has no positive CONTRACT_PER_CALL_BYTES -- the conditional tier cannot apply, no witness to read"
fi

MODEL_SRC="${MODEL_VMFB:-$BENCH_DIR/native/model_16384_baked.vmfb}"
EXE_DIR="build-native_std/exe/cpu1"
if [ -f "$MODEL_SRC" ]; then
  cp "$MODEL_SRC" "$EXE_DIR/cf/model.vmfb"
fi
echo "ai_learner.so: $(ls -la "$EXE_DIR/cf/ai_learner.so" 2>/dev/null || echo NOT FOUND)"
echo "Run: (cd $CFS_ROOT/$EXE_DIR && ./core-cpu1)"
echo "NOTE: /proc/sys/fs/mqueue/msg_max must be >= 512 first (see scripts/00_env.sh)."
