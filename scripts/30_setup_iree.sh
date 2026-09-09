#!/usr/bin/env bash
set -euo pipefail
# jsonschema is NOT optional (N6/E24): make_contract.py refuses to write any
# contract without it (E15/D13, exit 3), so a checkout bootstrapped through
# scripts/99_bootstrap_all.sh could not generate a single contract. requirements.txt
# has pinned it since E22; this path installed only the two IREE packages.
pip3 install --break-system-packages -q iree-base-compiler iree-base-runtime jsonschema
python3 -c "import iree.compiler, iree.runtime; print('iree compiler + runtime OK')"
