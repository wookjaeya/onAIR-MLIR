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

# Register the app: bundle build (add app + link order + startup script entry).
grep -q "ai_learner" sample_defs/targets.cmake || \
  sed -i 's/^list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib)/list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner)/' \
    sample_defs/targets.cmake
grep -q "ai_learner" sample_defs/generate_startup.cmake || \
  sed -i 's|        "CFE_APP, sample_app,  SAMPLE_APP_Main,    SAMPLE_APP,   50,   32768, 0x0, 0;\\n"|        "CFE_APP, sample_app,  SAMPLE_APP_Main,    SAMPLE_APP,   50,   32768, 0x0, 0;\\n"\n        "CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   262144, 0x0, 0;\\n"|' \
    sample_defs/generate_startup.cmake

# cFS applies -std=c99 -pedantic -Werror to apps; IREE headers need gnu11.
grep -q "target_compile_options(ai_learner" apps/ai_learner/CMakeLists.txt || cat >> apps/ai_learner/CMakeLists.txt <<'CM'
target_compile_options(ai_learner PRIVATE -std=gnu11 -Wno-pedantic -Wno-error -Wno-unused-result)
CM

make native_std.prep
make native_std.install

MODEL_SRC="$BENCH_DIR/native/model_16384_baked.vmfb"
EXE_DIR="build-native_std/exe/cpu1"
if [ -f "$MODEL_SRC" ]; then
  cp "$MODEL_SRC" "$EXE_DIR/cf/model.vmfb"
fi
echo "ai_learner.so: $(ls -la "$EXE_DIR/cf/ai_learner.so" 2>/dev/null || echo NOT FOUND)"
echo "Run: (cd $CFS_ROOT/$EXE_DIR && ./core-cpu1)"
echo "NOTE: /proc/sys/fs/mqueue/msg_max must be >= 512 first (see scripts/00_env.sh)."
