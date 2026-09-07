#!/usr/bin/env bash
set -euo pipefail
pip3 install --break-system-packages -q iree-base-compiler iree-base-runtime
python3 -c "import iree.compiler, iree.runtime; print('iree compiler + runtime OK')"
