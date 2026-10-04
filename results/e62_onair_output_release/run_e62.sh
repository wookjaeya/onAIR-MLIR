#!/usr/bin/env bash
# E62 guest-side runner (plan docs/plans/E62_onair_output_release.md, commit 046a7af).
# Probe cells first (one mode per process), then OnAIR official-loader cells, sequential.
set -u
cd "$HOME/e62/repo"
export PYTHONPATH="$HOME/e57/pylib"
OUT="$HOME/e62/out"; mkdir -p "$OUT/probe"
{ echo "uname: $(uname -a)"; echo "nproc: $(nproc)"; free -b | head -2; python3 -c "import sys,numpy,iree.runtime as rt;print('python',sys.version.split()[0],'numpy',numpy.__version__,'iree.runtime',rt.__file__)"; } > "$OUT/guest_env.txt" 2>&1
V=results/e36b_aarch64_models/b3_deepae/b3_deepae.vmfb
C=results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json
X=results/e34_two_models/b3_deepae/fixture/inputs/synthetic_00.nchw.npy
for m in refcount_asarray refcount_bufproto loop_asarray loop_buffer_protocol; do
  echo "== probe $m $(date -u +%H:%M:%S)"
  python3 harness/e62_readback_probe.py "$V" "$C" "$X" "$m" 20 > "$OUT/probe/$m.json" 2> "$OUT/probe/$m.stderr"
  echo "rc=$?"
done
for dep in "$@"; do
  echo "== $dep $(date -u +%H:%M:%S)"
  python3 harness/onair_integration_check.py --deployment "$dep" \
    --config configs/deployments/onair_deployments_e62_aarch64.json \
    --onair "$HOME/e57/OnAIR" --timeout 14400 --out "$OUT/$dep" 2>&1 | tail -3
done
echo "== done $(date -u +%H:%M:%S)"
