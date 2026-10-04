#!/usr/bin/env bash
# E65 guest-side runner for Q3 and Q6 (plan docs/plans/E65_producer_revision_and_plugin_option.md, 7b67d89).
# Same shape as results/e62_onair_output_release/run_e62.sh: the official OnAIR loader, one cell per process.
set -u
cd "$HOME/e65/repo"
export PYTHONPATH="$HOME/e57/pylib"
OUT="$HOME/e65/out"; mkdir -p "$OUT"
{ echo "uname: $(uname -a)"; echo "nproc: $(nproc)"; free -b | head -2
  python3 -c "import sys,numpy,iree.runtime as rt;print('python',sys.version.split()[0],'numpy',numpy.__version__,'iree.runtime',rt.__file__)"
  echo "--- Q6: iree/_runtime_libs/version.py of the guest's IREE Python runtime"
  cat "$HOME/e57/pylib/iree/_runtime_libs/version.py"
  echo "--- dist-info"
  grep -E "^(Name|Version):" "$HOME/e57/pylib/iree_base_runtime-3.11.0.dist-info/METADATA"; } > "$OUT/guest_env.txt" 2>&1
for dep in "$@"; do
  echo "== $dep $(date -u +%H:%M:%S)"
  python3 harness/onair_integration_check.py --deployment "$dep" \
    --config configs/deployments/onair_deployments_e65_aarch64.json \
    --onair "$HOME/e57/OnAIR" --timeout 14400 --out "$OUT/$dep" 2>&1 | tail -3
done
echo "== done $(date -u +%H:%M:%S)"
