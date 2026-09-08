#!/usr/bin/env bash
# E14 Stage 1, proposal SS10: run the statically linked AArch64 native_learner
# binaries INSIDE the guest (not qemu-user) for every model and record JSON logs.
# Usage (host): bash scripts/82_run_native_guest.sh <staging_dir> <out_dir>
#   <staging_dir>/native/<model>/native_learner_aarch64        (contract = that model's contract)
#   <staging_dir>/native/<model>/native_learner_aarch64_corruptsha  (contract hash = corrupted vmfb's hash)
#   <staging_dir>/native/<model>/contract.json                 (for B)
#   <staging_dir>/models/<model>.vmfb, <model>_swap.vmfb
# Exit codes (native_learner): 0 ok, 3 NOT_ADMITTED, 4 cannot open, 5 CONTRACT_ARTIFACT_MISMATCH,
# 6 UNKNOWN_BOUND, 7 runtime load failed (safe cleanup).
set -euo pipefail
STAGE="$1"; OUT="$2"; ITERS="${ITERS:-10000}"
GUEST_DIR="${GUEST_DIR:-$HOME/onair-mlir-bench/ext/guest}"; export GUEST_DIR
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="bash $HERE/72_guest_ssh.sh"
mkdir -p "$OUT"
$G ssh 'rm -rf native_e14 && mkdir -p native_e14'
$G scp "$STAGE/native" native_e14/native
$G scp "$STAGE/models" native_e14/models
run() { # name, binary, vmfb, budget, iters
  local name=$1 bin=$2 vmfb=$3 budget=$4 iters=$5
  $G ssh "cd native_e14 && (MALLOC_CHECK_=3 $bin $vmfb $budget $iters; echo EXIT=\$?)" > "$OUT/$name.log" 2>&1 || true
  printf "%-36s exit=%s %s\n" "$name" "$(grep -o 'EXIT=[0-9]*' "$OUT/$name.log" | tail -1)" "$(grep -o '"verdict":"[A-Z_]*"' "$OUT/$name.log" | tr '\n' ' ')"
}
for d in "$STAGE"/native/*/; do
  m=$(basename "$d"); c="$d/contract.json"
  B=$(python3 -c "import json,sys; r=json.load(open('$c'))['resources']; print(r.get('bounded_bytes') if r.get('bounded_bytes') is not None else -1)")
  bin="native/$m/native_learner_aarch64"
  if [ "$B" = "-1" ]; then
    run "${m}_unknown_bound" "$bin" "models/$m.vmfb" 1048576 10
    continue
  fi
  run "${m}_match_1MiB"        "$bin" "models/$m.vmfb"       1048576  "$ITERS"
  run "${m}_boundary_Bm1"      "$bin" "models/$m.vmfb"       $((B-1)) 5
  run "${m}_boundary_B"        "$bin" "models/$m.vmfb"       "$B"     5
  run "${m}_boundary_Bp1"      "$bin" "models/$m.vmfb"       $((B+1)) 5
  run "${m}_swap_mismatch"     "$bin" "models/${m}_swap.vmfb" 1048576 5
  run "${m}_missing_file"      "$bin" "models/does_not_exist.vmfb" 1048576 5
  $G ssh "cd native_e14 && cp models/$m.vmfb models/${m}_corrupt.vmfb && python3 -c \"p='models/${m}_corrupt.vmfb';b=bytearray(open(p,'rb').read());b[4096]^=0xFF;open(p,'wb').write(bytes(b))\""
  run "${m}_corrupt_gate"      "$bin" "models/${m}_corrupt.vmfb" 1048576 5
  [ -f "$d/native_learner_aarch64_corruptsha" ] && run "${m}_corrupt_runtime" "native/$m/native_learner_aarch64_corruptsha" "models/${m}_corrupt.vmfb" 1048576 5
done
$G ssh 'uname -m; nproc' > "$OUT/guest_identity.txt"
echo "logs in $OUT"
