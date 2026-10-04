#!/usr/bin/env bash
# E68 guest-side runner (plan docs/plans/E68_onair_artifact_linkage.md, c51ad37).
# Same shape as results/e66_plugin_document_rules/guest/run_e66.sh: the official OnAIR loader, one cell per process.
set -u
cd "$HOME/e68/repo"
export PYTHONPATH="$HOME/e57/pylib"
OUT="$HOME/e68/out"; mkdir -p "$OUT"
{ echo "uname: $(uname -a)"; echo "nproc: $(nproc)"; free -b | head -2
  python3 -c "import sys,numpy,iree.runtime as rt;print('python',sys.version.split()[0],'numpy',numpy.__version__,'iree.runtime',rt.__file__)"
  echo "--- sha256 of the plugin files this run imports"
  sha256sum plugins/compiled_learner/*.py
  echo "--- sha256 of the file each cell loads (links followed)"
  for f in results/e66_plugin_document_rules/docs/b2_resnet/b2_resnet.vmfb results/e68_onair_linkage/art/*/b2_resnet.vmfb; do
    echo "$(sha256sum < "$(readlink -f "$f")" | cut -d' ' -f1)  $(stat -L -c %s "$f")  $f"; done
} > "$OUT/guest_env.txt" 2>&1
for dep in "$@"; do
  echo "== $dep $(date -u +%H:%M:%S)"
  python3 harness/onair_integration_check.py --deployment "$dep" \
    --config configs/deployments/onair_deployments_e68_aarch64.json \
    --onair "$HOME/e57/OnAIR" --timeout 14400 --out "$OUT/$dep" 2>&1 | tail -3
done
echo "== done $(date -u +%H:%M:%S)"
