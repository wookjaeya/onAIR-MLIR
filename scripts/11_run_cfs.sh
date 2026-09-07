#!/usr/bin/env bash
# cFS must run from its exe dir to find cfe_es_startup.scr and the app .so files.
set -euo pipefail
EXE="${1:-$HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1}"
cd "$EXE"
exec ./core-cpu1
