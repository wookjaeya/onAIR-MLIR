#!/usr/bin/env bash
# OnAIR (NASA, NOSA GSC-19165-1). Ships csv / redis / sbn_adapter data sources
# and kalman / generic / csv_output / reporter plugins.
set -euo pipefail
ROOT="${1:-$HOME/onair-mlir-bench/ext}"
mkdir -p "$ROOT" && cd "$ROOT"
[ -d OnAIR ] || git clone https://github.com/nasa/OnAIR.git
pip3 install --break-system-packages -q numpy redis simdkalman pytest pytest-mock
cd OnAIR && python3 driver.py onair/config/kalman_csv_output_example.ini | tail -3
