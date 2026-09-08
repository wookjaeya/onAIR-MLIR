#!/usr/bin/env bash
# Builds a minimal IREE C RUNTIME (not the compiler) from source, pinned to the
# EXACT commit the installed iree-compiler wheel was built from. This runtime
# is what native/native_learner.c and native/cfs_app link against.
#
# Why pin to the compiler's commit: the .vmfb format and HAL ABI must match
# between the compiler that produced the artifact and the runtime that loads
# it. Get the compiler's commit with:
#   iree-compile --version
# and update IREE_COMMIT below if it differs from what's recorded here.
#
# Verified 2026-09-08: iree-base-compiler/runtime 3.11.0 (3.11.0rc20260316),
# commit e4a3b0405d7d23554da26403658d0e8c3c5ecf25.
set -euo pipefail
IREE_COMMIT="${IREE_COMMIT:-e4a3b0405d7d23554da26403658d0e8c3c5ecf25}"
ROOT="${1:-$HOME/onair-mlir-bench/ext}"
mkdir -p "$ROOT" && cd "$ROOT"

if [ ! -d iree-src ]; then
  git clone https://github.com/iree-org/iree.git iree-src
fi
cd iree-src
git fetch --depth 1 origin "$IREE_COMMIT"
git checkout -q FETCH_HEAD

# Runtime-only submodules actually needed for this minimal config.
# (IREE's top-level `git submodule update --init` pulls everything, including
#  the compiler's LLVM checkout, which is unnecessary and very large here.)
git submodule update --init --depth 1 --jobs 4 \
  third_party/flatcc third_party/musl third_party/hsa-runtime-headers \
  third_party/benchmark third_party/googletest third_party/printf third_party/tracy

# Pitfall (hit 2026-09-08): this IREE commit's x86_64 ukernel CMakeLists uses
# check_c_source_compiles() without including the CMake module that defines
# it. Patch it in; harmless if already present in a newer commit.
UK=runtime/src/iree/builtins/ukernel/arch/x86_64/CMakeLists.txt
grep -q "include(CheckCSourceCompiles)" "$UK" || sed -i '1i include(CheckCSourceCompiles)' "$UK"

mkdir -p build-rt && cd build-rt
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_ASM_COMPILER=gcc \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DIREE_BUILD_COMPILER=OFF -DIREE_BUILD_TESTS=OFF -DIREE_BUILD_SAMPLES=OFF \
  -DIREE_BUILD_PYTHON_BINDINGS=OFF -DIREE_BUILD_BINDINGS_TFLITE=OFF \
  -DIREE_HAL_DRIVER_DEFAULTS=OFF -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
  -DIREE_HAL_EXECUTABLE_LOADER_DEFAULTS=OFF -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON \
  -DIREE_HAL_EXECUTABLE_PLUGIN_DEFAULTS=OFF -DIREE_ENABLE_THREADING=OFF \
  -DIREE_BUILD_UKERNELS=OFF

# Target names verified against this commit's ninja graph 2026-09-08.
# If they change upstream: `ninja -t targets all | grep -i iree_runtime` to relist.
ninja iree_runtime_impl iree_hal_drivers_local_sync_sync_driver \
      iree_hal_local_loaders_embedded_elf_loader iree_vm_bytecode_module \
      iree_modules_hal_hal flatcc_parsing flatcc_runtime printf_printf

echo "IREE runtime built at: $PWD"
find . -name "*.a" | wc -l | xargs echo "static libs:"
