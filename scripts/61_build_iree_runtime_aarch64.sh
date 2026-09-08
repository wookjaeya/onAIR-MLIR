#!/usr/bin/env bash
# Cross-builds the minimal IREE C runtime for aarch64-linux-gnu, mirroring
# scripts/40_setup_iree_source_runtime.sh (x86-64 host build) but with a CMake
# cross-toolchain file. Requires scripts/40_ to have already cloned+patched
# the IREE source tree (same commit as the installed iree-compile) and
# scripts/60_setup_aarch64_cross.sh to have installed the cross-compiler.
set -euo pipefail
ROOT="${1:-$HOME/onair-mlir-bench/ext}"
IREE_SRC="$ROOT/iree-src"
[ -d "$IREE_SRC" ] || { echo "run scripts/40_setup_iree_source_runtime.sh first"; exit 1; }
cd "$IREE_SRC"

mkdir -p build-rt-aarch64 && cd build-rt-aarch64
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
  -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
  -DCMAKE_ASM_COMPILER=aarch64-linux-gnu-gcc \
  -DCMAKE_FIND_ROOT_PATH=/usr/aarch64-linux-gnu \
  -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DIREE_BUILD_COMPILER=OFF -DIREE_BUILD_TESTS=OFF -DIREE_BUILD_SAMPLES=OFF \
  -DIREE_BUILD_PYTHON_BINDINGS=OFF -DIREE_BUILD_BINDINGS_TFLITE=OFF \
  -DIREE_HAL_DRIVER_DEFAULTS=OFF -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
  -DIREE_HAL_EXECUTABLE_LOADER_DEFAULTS=OFF -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON \
  -DIREE_HAL_EXECUTABLE_PLUGIN_DEFAULTS=OFF -DIREE_ENABLE_THREADING=OFF \
  -DIREE_BUILD_UKERNELS=OFF

ninja iree_runtime_impl iree_hal_drivers_local_sync_sync_driver \
      iree_hal_local_loaders_embedded_elf_loader iree_vm_bytecode_module \
      iree_modules_hal_hal flatcc_parsing flatcc_runtime printf_printf

echo "aarch64 IREE runtime built at: $PWD"
find . -name "*.a" | wc -l | xargs echo "static libs:"
