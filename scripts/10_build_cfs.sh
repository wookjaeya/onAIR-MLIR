#!/usr/bin/env bash
# Build NASA cFS, bundle default target native_std. Verified working.
set -euo pipefail
ROOT="${1:-$HOME/onair-mlir-bench/ext}"
mkdir -p "$ROOT" && cd "$ROOT"
[ -d cFS ] || git clone --recurse-submodules --shallow-submodules https://github.com/nasa/cFS.git
cd cFS
# Pitfall: do NOT copy cfe/cmake/Makefile.sample + cfe/cmake/sample_defs over
# the bundle's own Makefile/sample_defs. That sample references apps (e.g. hs)
# that are not registered in that configuration and prep fails with
# "Target \"hs\" not found" in add_cfe_tables_impl.cmake.
make native_std.prep
make native_std.install
echo "artifacts: $PWD/build-native_std/exe/cpu1"
