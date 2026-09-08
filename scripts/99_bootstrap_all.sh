#!/usr/bin/env bash
# One-shot environment bootstrap, in dependency order. Idempotent: safe to
# re-run; each step skips work that's already done where practical.
# Run from anywhere; paths default to $HOME/onair-mlir-bench/ext.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$HERE/00_env.sh"
bash "$HERE/10_build_cfs.sh"
bash "$HERE/20_setup_onair.sh"
bash "$HERE/30_setup_iree.sh"
bash "$HERE/40_setup_iree_source_runtime.sh"
bash "$HERE/50_wire_cfs_ai_learner.sh"
echo
echo "=== Bootstrap complete. Smoke tests: ==="
echo "1) python3 $HERE/../harness/platform_check.py     # timing-grade gate"
echo "2) cd $HERE/../native && bash build.sh && ./native_learner model_16384_baked.vmfb 1048576 100"
echo "3) cd \$HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && ./core-cpu1"
