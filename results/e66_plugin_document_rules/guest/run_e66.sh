#!/usr/bin/env bash
# E66 guest-side runner (plan docs/plans/E66_plugin_document_rules.md, ae115f3).
# Same shape as results/e65_producer_check/guest/run_e65_onair.sh: the official OnAIR loader, one cell per process.
set -u
cd "$HOME/e66/repo"
export PYTHONPATH="$HOME/e57/pylib"
OUT="$HOME/e66/out"; mkdir -p "$OUT"
{ echo "uname: $(uname -a)"; echo "nproc: $(nproc)"; free -b | head -2
  python3 -c "import sys,numpy,iree.runtime as rt;print('python',sys.version.split()[0],'numpy',numpy.__version__,'iree.runtime',rt.__file__)"
  echo "--- sha256 of the plugin files this run imports"
  sha256sum plugins/compiled_learner/*.py
  echo "--- sha256 of the artifacts behind the document links"
  sha256sum -L results/e66_plugin_document_rules/docs/*/*.vmfb 2>/dev/null || for f in results/e66_plugin_document_rules/docs/*/*.vmfb; do sha256sum "$(readlink -f "$f")"; done
} > "$OUT/guest_env.txt" 2>&1
for dep in "$@"; do
  echo "== $dep $(date -u +%H:%M:%S)"
  python3 harness/onair_integration_check.py --deployment "$dep" \
    --config configs/deployments/onair_deployments_e66_aarch64.json \
    --onair "$HOME/e57/OnAIR" --timeout 14400 --out "$OUT/$dep" 2>&1 | tail -3
done
echo "== done $(date -u +%H:%M:%S)"
