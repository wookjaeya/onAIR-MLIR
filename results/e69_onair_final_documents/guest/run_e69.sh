#!/usr/bin/env bash
# E69 guest-side runner (plan docs/plans/E69_onair_readback_final_documents.md, f2ffe7a).
# Same shape as results/e62_onair_output_release/run_e62.sh: probe cells first (one mode per process),
# then OnAIR official-loader cells, one cell per process.
set -u
cd "$HOME/e69/repo"
export PYTHONPATH="$HOME/e57/pylib"
OUT="$HOME/e69/out"; mkdir -p "$OUT/probe"
{ echo "uname: $(uname -a)"; echo "nproc: $(nproc)"; free -b | head -2
  python3 -c "import sys,numpy,iree.runtime as rt;print('python',sys.version.split()[0],'numpy',numpy.__version__,'iree.runtime',rt.__file__)"
  echo "--- sha256 of the plugin files this run imports"
  sha256sum plugins/compiled_learner/*.py
  echo "--- sha256 of the artifacts behind the document links"
  for f in results/e66_plugin_document_rules/docs/*/*.vmfb; do echo "$(sha256sum < "$(readlink -f "$f")" | cut -d' ' -f1)  $f"; done
} > "$OUT/guest_env.txt" 2>&1
if [ "${E69_PROBE:-1}" = 1 ]; then
V=results/e36b_aarch64_models/b3_deepae/b3_deepae.vmfb
C=results/e66_plugin_document_rules/docs/b3_deepae/b3_deepae.contract.json
X=results/e34_two_models/b3_deepae/fixture/inputs/synthetic_00.nchw.npy
for m in refcount_asarray refcount_bufproto loop_asarray loop_buffer_protocol; do
  echo "== probe $m $(date -u +%H:%M:%S)"
  python3 harness/e62_readback_probe.py "$V" "$C" "$X" "$m" 20 > "$OUT/probe/$m.json" 2> "$OUT/probe/$m.stderr"
  echo "rc=$?"
done
fi
for dep in "$@"; do
  echo "== $dep $(date -u +%H:%M:%S)"
  python3 harness/onair_integration_check.py --deployment "$dep" \
    --config configs/deployments/onair_deployments_e69_aarch64.json \
    --onair "$HOME/e57/OnAIR" --timeout 14400 --out "$OUT/$dep" 2>&1 | tail -3
done
echo "== done $(date -u +%H:%M:%S)"
