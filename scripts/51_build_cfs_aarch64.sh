#!/usr/bin/env bash
# E14 Stage 1: cross-compile the cFS bundle for aarch64-linux-gnu WITH the AI_LEARNER app
# and produce a deployable exe tree for the QEMU guest (Ubuntu 24.04 arm64, glibc 2.39;
# the host cross toolchain gcc-13-aarch64-linux-gnu targets the same glibc 2.39, so the
# dynamically linked core-cpu1 / cf/*.so run unchanged in the guest).
#
#   bash scripts/51_build_cfs_aarch64.sh [CFS_ROOT] [IREE_B_AARCH64] [CONTRACT_HEADER] \
#        [BUDGET_BYTES] [STACK_BASE_BYTES] [KERNEL_STACK_BYTES] [OUT_TAG]
#
#   CFS_ROOT            cFS bundle checkout (nasa/cFS 78c23b0 + submodules), already built once
#                       natively is NOT required; build-native_std is never touched.
#   IREE_B_AARCH64      IREE runtime cross build dir from scripts/61_ (.../iree-src/build-rt-aarch64).
#                       Refused unless its archives are ELF AArch64 (so the x86 build-rt can't slip in).
#   CONTRACT_HEADER     contract_gen.h from harness/gen_contract_header.py, generated from the
#                       contract of the SAME iree-compile invocation as the vmfb to deploy.
#   BUDGET_BYTES        -> AI_LEARNER_BUDGET_BYTES (admission budget), default 1048576
#   STACK_BASE_BYTES    -> AI_LEARNER_STACK_BASE_BYTES, default 262144 (E12 value)
#   KERNEL_STACK_BYTES  AArch64 dispatch-function stack frame (ELF analysis, 16 on cortex-a53);
#                       default = CONTRACT_KERNEL_STACK_BYTES parsed from CONTRACT_HEADER
#   OUT_TAG             variant name; exe tree lands in $OUT_ROOT/<OUT_TAG>/cpu1
#
#   env: OUT_ROOT (default <ext>/cfs-aarch64-exe), JOBS (nproc), REPORT_EVERY (AI_LEARNER_REPORT_EVERY),
#        MODEL_VMFB (optional: copied to <out>/cpu1/cf/model.vmfb and hashed against the header),
#        DROP_APPS (space list of MISSION_GLOBAL_APPLIST apps to leave out of the aarch64 build;
#        default none -- only for apps that fail to cross-compile and are not needed).
#
# What this does to the bundle (all idempotent, nothing under build-native_std is touched):
#   * sample_defs/toolchain-aarch64-linux-gnu.cmake  <- native/cfs_app/toolchain-aarch64-linux-gnu.cmake
#   * aarch64_defs/  = fresh copy of sample_defs/ + patches (own MISSIONCONFIG so the x86 tree's
#     sample_defs/ + apps/ai_learner are never modified by this script and vice versa):
#       - toolchain file (again) and aarch64-linux-gnu_osconfig.cmake (= native_osconfig.cmake,
#         so OSAL is configured exactly like native_std: permissive mode, utility task prio 10, DNS)
#       - targets.cmake: ai_learner appended to MISSION_GLOBAL_APPLIST (same line scripts/50 patches);
#         sbn/sbn_udp/sbn_f_remap stay native-only (the bundle guards them on SIMULATION == native);
#         cpu2 dropped for SIMULATION=aarch64-linux-gnu (it is a second full copy of every app that the
#         experiment never deploys; native_std still builds it)
#       - generate_startup.cmake: CFE_APP ai_learner entry with stack = STACK_BASE + KERNEL_STACK
#   * apps_aarch64/ai_learner/  = native/cfs_app copy with CMakeLists pointing at IREE_B_AARCH64 and the
#     given contract header installed as fsw/src/contract_gen.h; found first via -DCFS_APP_PATH.
#   * target-configs.mk: config "aarch64_std" (O=build-aarch64_std, ARCH=aarch64-linux-gnu,
#     PREP_OPTS mirroring native_std except ENABLE_UNIT_TESTS=FALSE and MISSIONCONFIG=aarch64), so the
#     bundle's own wrapper runs it: make aarch64_std.prep && make aarch64_std.install.
#   * AI_LEARNER_BUDGET_BYTES / _STACK_BASE_BYTES are CMake cache vars of the app; the mission-level
#     cmake does not forward -D to the arch tree (see native/cfs_app/WIRING.md), so they are set by
#     re-configuring build-aarch64_std/aarch64-linux-gnu/default_cpu1 between prep and install.
set -euo pipefail
BENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT_DEFAULT="${ONAIR_EXT:-$HOME/onair-mlir-bench/ext}"
if [ ! -d "$EXT_DEFAULT" ] && [ -d /home/user/onair-ext ]; then EXT_DEFAULT=/home/user/onair-ext; fi

CFS_ROOT="${1:-$EXT_DEFAULT/cFS}"
IREE_B="${2:-$EXT_DEFAULT/iree-src/build-rt-aarch64}"
CONTRACT_HEADER="${3:-$BENCH_DIR/native/cfs_app/fsw/src/contract_gen.h}"
BUDGET_BYTES="${4:-1048576}"
STACK_BASE_BYTES="${5:-262144}"
KERNEL_STACK_BYTES="${6:-}"
OUT_TAG="${7:-default}"
OUT_ROOT="${OUT_ROOT:-$EXT_DEFAULT/cfs-aarch64-exe}"
JOBS="${JOBS:-$(nproc)}"
REPORT_EVERY="${REPORT_EVERY:-}"
MODEL_VMFB="${MODEL_VMFB:-}"
DROP_APPS="${DROP_APPS:-}"

CFG=aarch64_std
SIM=aarch64-linux-gnu
CROSS=aarch64-linux-gnu-
MARK_BEGIN="# >>> onAIR-MLIR E14 Stage 1: AArch64 cross config (scripts/51_build_cfs_aarch64.sh)"
MARK_END="# <<< onAIR-MLIR E14 Stage 1"

die() { echo "51_build_cfs_aarch64: ERROR: $*" >&2; exit 1; }
is_int() { [[ "$1" =~ ^[0-9]+$ ]]; }
hdr_macro() { # $1 macro name -> raw token after it (strip trailing L and quotes)
  local v
  v="$(sed -n "s/^#define[[:space:]]\+$1[[:space:]]\+\(.*\)$/\1/p" "$CONTRACT_HEADER" | head -1)"
  v="${v%%[[:space:]]*}"; v="${v%L}"; v="${v%\"}"; v="${v#\"}"
  printf '%s' "$v"
}

# ---------------------------------------------------------------- 0. sanity checks
for t in gcc g++ ar readelf objdump nm strip; do
  command -v "${CROSS}$t" >/dev/null || die "${CROSS}$t not found (run scripts/60_setup_aarch64_cross.sh)"
done
command -v cmake >/dev/null && command -v make >/dev/null && command -v file >/dev/null || die "cmake/make/file required"
[ -d "$CFS_ROOT/cfe" ] && [ -f "$CFS_ROOT/target-configs.mk" ] || die "not a cFS bundle: $CFS_ROOT"
[ -d "$CFS_ROOT/sample_defs" ] || die "no sample_defs in $CFS_ROOT"
[ -f "$CONTRACT_HEADER" ] || die "contract header not found: $CONTRACT_HEADER"
grep -q "^#define CONTRACT_ARTIFACT_SHA256" "$CONTRACT_HEADER" || die "not a contract_gen.h: $CONTRACT_HEADER"
is_int "$BUDGET_BYTES" || die "BUDGET_BYTES must be an integer: $BUDGET_BYTES"
is_int "$STACK_BASE_BYTES" || die "STACK_BASE_BYTES must be an integer: $STACK_BASE_BYTES"
[[ "$OUT_TAG" =~ ^[A-Za-z0-9._-]+$ ]] || die "OUT_TAG must be [A-Za-z0-9._-]+: $OUT_TAG"

HDR_KERNEL="$(hdr_macro CONTRACT_KERNEL_STACK_BYTES)"
if [ -z "$KERNEL_STACK_BYTES" ]; then
  if is_int "$HDR_KERNEL"; then KERNEL_STACK_BYTES="$HDR_KERNEL"
  else echo "WARNING: header has no CONTRACT_KERNEL_STACK_BYTES (pre-Stage-1 header?); kernel stack defaults to 0" >&2; KERNEL_STACK_BYTES=0; fi
fi
is_int "$KERNEL_STACK_BYTES" || die "KERNEL_STACK_BYTES must be an integer: $KERNEL_STACK_BYTES"
if is_int "$HDR_KERNEL" && [ "$HDR_KERNEL" != "$KERNEL_STACK_BYTES" ]; then
  echo "WARNING: KERNEL_STACK_BYTES=$KERNEL_STACK_BYTES differs from header CONTRACT_KERNEL_STACK_BYTES=$HDR_KERNEL" >&2
fi
STARTUP_STACK=$((STACK_BASE_BYTES + KERNEL_STACK_BYTES))

# The IREE runtime archives MUST be the AArch64 build (never build-rt, the x86-64 one).
RT_LIB="$IREE_B/runtime/src/iree/runtime/libiree_runtime_impl.a"
[ -f "$RT_LIB" ] || die "IREE runtime archive missing: $RT_LIB (run scripts/61_build_iree_runtime_aarch64.sh)"
for a in build_tools/third_party/flatcc/libflatcc_parsing.a build_tools/third_party/flatcc/libflatcc_runtime.a build_tools/third_party/printf/libprintf_printf.a; do
  [ -f "$IREE_B/$a" ] || die "IREE third-party archive missing: $IREE_B/$a"
done
IREE_MACHINES="$(${CROSS}readelf -h "$RT_LIB" | sed -n 's/^[[:space:]]*Machine:[[:space:]]*//p' | sort -u | tr '\n' ',' | sed 's/,$//')"
[ "$IREE_MACHINES" = "AArch64" ] || die "IREE archives in $IREE_B are '$IREE_MACHINES', not AArch64 -- refusing (is this the x86 build-rt?)"
IREE_SRC="$(cd "$IREE_B/.." && pwd)"
[ -f "$IREE_SRC/runtime/src/iree/runtime/api.h" ] || die "IREE source tree not at $IREE_SRC (expected IREE_B inside it)"

DEST="$OUT_ROOT/$OUT_TAG"
mkdir -p "$DEST"
LOG="$DEST/build.log"
: > "$LOG"
echo "== 51_build_cfs_aarch64: tag=$OUT_TAG budget=$BUDGET_BYTES stack_base=$STACK_BASE_BYTES kernel=$KERNEL_STACK_BYTES startup_stack=$STARTUP_STACK" | tee -a "$LOG"
echo "   cfs=$CFS_ROOT iree_b=$IREE_B ($IREE_MACHINES) header=$CONTRACT_HEADER jobs=$JOBS" | tee -a "$LOG"

cd "$CFS_ROOT"

# ---------------------------------------------------------------- 1. toolchain file into sample_defs/
cp "$BENCH_DIR/native/cfs_app/toolchain-$SIM.cmake" "sample_defs/toolchain-$SIM.cmake"

# ---------------------------------------------------------------- 2. aarch64_defs = sample_defs + patches
rm -rf aarch64_defs
cp -a sample_defs aarch64_defs
{ echo "# aarch64-linux-gnu OSAL addendum: identical to native_osconfig.cmake so the AArch64 build is"
  echo "# configured exactly like native_std (E14 Stage 1, written by scripts/51_build_cfs_aarch64.sh)."
  cat sample_defs/native_osconfig.cmake; } > "aarch64_defs/${SIM}_osconfig.cmake"

TGT=aarch64_defs/targets.cmake
if ! grep -q "ai_learner" "$TGT"; then
  sed -i 's/^list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib)/list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner)/' "$TGT"
fi
grep -q "MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner" "$TGT" || die "could not register ai_learner in $TGT"
# cpu2 is a second copy of every app that the experiment never deploys: skip it on this SIMULATION only.
sed -i 's/^if (NOT SIMULATION STREQUAL "i686-rtems5")$/if (NOT SIMULATION STREQUAL "i686-rtems5" AND NOT SIMULATION STREQUAL "aarch64-linux-gnu")/' "$TGT"
grep -q 'NOT SIMULATION STREQUAL "aarch64-linux-gnu"' "$TGT" || die "cpu2 guard patch failed in $TGT"
for app in $DROP_APPS; do
  case "$app" in ci_lab|to_lab|sch_lab|sample_app|sample_lib|ai_learner) die "DROP_APPS: $app is required by the experiment";; esac
  sed -i "/^LIST(APPEND MISSION_GLOBAL_APPLIST $app)$/d" "$TGT"
  echo "   dropped app from aarch64 APPLIST: $app" | tee -a "$LOG"
done

GEN=aarch64_defs/generate_startup.cmake
sed -i '/CFE_APP, ai_learner,/d' "$GEN"
sed -i 's|^\(        "CFE_APP, sample_app,  SAMPLE_APP_Main,    SAMPLE_APP,   50,   32768, 0x0, 0;\\n"\)$|\1\n        "CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   '"$STARTUP_STACK"', 0x0, 0;\\n"|' "$GEN"
grep -q "CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   $STARTUP_STACK, 0x0, 0;" "$GEN" || die "startup entry patch failed in $GEN"

# ---------------------------------------------------------------- 3. app copy (own dir, own IREE build, own header)
APPDIR=apps_aarch64/ai_learner
mkdir -p "$APPDIR/fsw/src"
cp "$BENCH_DIR/native/cfs_app/CMakeLists.txt" "$APPDIR/CMakeLists.txt"
cp "$BENCH_DIR"/native/cfs_app/fsw/src/*.c "$BENCH_DIR"/native/cfs_app/fsw/src/*.h "$APPDIR/fsw/src/"
cp "$CONTRACT_HEADER" "$APPDIR/fsw/src/contract_gen.h"
sed -i "s#^set(IREE_SRC .*#set(IREE_SRC \"$IREE_SRC\")#" "$APPDIR/CMakeLists.txt"
sed -i "s#^set(IREE_B .*#set(IREE_B   \"$IREE_B\")#" "$APPDIR/CMakeLists.txt"
grep -q "^set(IREE_B   \"$IREE_B\")" "$APPDIR/CMakeLists.txt" || die "could not point $APPDIR/CMakeLists.txt at $IREE_B"
grep -q "target_compile_options(ai_learner" "$APPDIR/CMakeLists.txt" || cat >> "$APPDIR/CMakeLists.txt" <<'CM'
target_compile_options(ai_learner PRIVATE -std=gnu11 -Wno-pedantic -Wno-error -Wno-unused-result)
CM
if grep -q "AI_LEARNER_BUDGET_BYTES" "$APPDIR/CMakeLists.txt"; then
  KNOB_ROUTE=cache
else
  KNOB_ROUTE=compile_definitions
  cat >> "$APPDIR/CMakeLists.txt" <<CM
target_compile_definitions(ai_learner PRIVATE AI_LEARNER_BUDGET_BYTES=$BUDGET_BYTES AI_LEARNER_STACK_BASE_BYTES=$STACK_BASE_BYTES${REPORT_EVERY:+ AI_LEARNER_REPORT_EVERY=$REPORT_EVERY})
CM
fi

# ---------------------------------------------------------------- 4. make-wrapper config "aarch64_std"
sed -i "/^$(printf '%s' "$MARK_BEGIN" | sed 's/[][\/.*^$]/\\&/g')$/,/^$(printf '%s' "$MARK_END" | sed 's/[][\/.*^$]/\\&/g')$/d" target-configs.mk
cat >> target-configs.mk <<MK
$MARK_BEGIN
# Mirrors native_std (goal-configs.mk / target-rules.mk apply the same -S cfe, /exe prefix,
# mission- sub-targets) with: no unit tests (they cannot run on the host), MISSIONCONFIG=aarch64
# (aarch64_defs/ = sample_defs/ + patches), CFS_APP_PATH so apps_aarch64/ai_learner wins the search.
CONFIG_NAMES     += $CFG
CFS_CONFIG_NAMES += $CFG
O_$CFG            = build-$CFG
ARCH_$CFG         = $SIM
PREP_OPTS_$CFG   += -DENABLE_UNIT_TESTS=FALSE
PREP_OPTS_$CFG   += -DSIMULATION=\$(ARCH)
PREP_OPTS_$CFG   += -DCFE_EDS_ENABLED=OFF
PREP_OPTS_$CFG   += -DMISSIONCONFIG=aarch64
PREP_OPTS_$CFG   += -DCMAKE_BUILD_TYPE=debug
PREP_OPTS_$CFG   += -DCFS_APP_PATH=\$(CURDIR)/apps_aarch64
PLATFORM_$CFG     = default_cpu1
$MARK_END
MK

# ---------------------------------------------------------------- 5. prep -> app knobs -> install
T0=$(date +%s)
make "$CFG.prep" 2>&1 | tee -a "$LOG"
T1=$(date +%s)
ARCH_DIR="build-$CFG/$SIM/default_cpu1"
[ -f "$ARCH_DIR/CMakeCache.txt" ] || die "arch build tree not configured: $ARCH_DIR"
grep -q "toolchain-$SIM.cmake" "$ARCH_DIR/CMakeCache.txt" || die "arch tree $ARCH_DIR was not configured with toolchain-$SIM.cmake"
if [ "$KNOB_ROUTE" = cache ]; then
  cmake -DAI_LEARNER_BUDGET_BYTES="$BUDGET_BYTES" -DAI_LEARNER_STACK_BASE_BYTES="$STACK_BASE_BYTES" \
        ${REPORT_EVERY:+-DAI_LEARNER_REPORT_EVERY="$REPORT_EVERY"} "$ARCH_DIR" 2>&1 | tee -a "$LOG"
fi
T2=$(date +%s)
make -j"$JOBS" "$CFG.install" 2>&1 | tee -a "$LOG"
T3=$(date +%s)
echo "== build time: prep $((T1-T0)) s, install $((T3-T2)) s, total $((T3-T0)) s" | tee -a "$LOG"

# ---------------------------------------------------------------- 6. verify the exe tree
EXE="build-$CFG/exe/cpu1"
[ -x "$EXE/core-cpu1" ] || die "no $EXE/core-cpu1"
[ -f "$EXE/cf/ai_learner.so" ] || die "no $EXE/cf/ai_learner.so"
[ -f "$EXE/cf/cfe_es_startup.scr" ] || die "no startup script"
# glibc only. ld-linux-aarch64.so.1 is glibc's own loader: on aarch64 the libc.so linker script
# pulls it in via AS_NEEDED for dl* users (libdl/libpthread/librt merged into libc since glibc 2.34).
ALLOWED_NEEDED='^(libc\.so\.6|libm\.so\.6|libdl\.so\.2|libpthread\.so\.0|librt\.so\.1|ld-linux-aarch64\.so\.1)$'
check_elf() { # $1 path; prints "file" description; fails unless aarch64
  local d; d="$(file -b "$1")"
  printf '%s: %s\n' "$1" "$d"
  case "$d" in *"ELF 64-bit LSB"*"ARM aarch64"*) ;; *) die "$1 is not ELF 64-bit ARM aarch64";; esac
}
needed() { ${CROSS}readelf -d "$1" | sed -n 's/.*(NEEDED)[[:space:]]*Shared library: \[\(.*\)\]/\1/p'; }
check_needed() { local n; for n in $(needed "$1"); do [[ "$n" =~ $ALLOWED_NEEDED ]] || die "$1 needs non-glibc library $n"; done; }
N_SO="$(ls "$EXE"/cf/*.so | wc -l)"   # (the block below runs in a pipe subshell; set counters outside it)
{
  echo "== file(1)"
  check_elf "$EXE/core-cpu1"
  for so in "$EXE"/cf/*.so; do check_elf "$so"; done
  echo "== NEEDED core-cpu1"; ${CROSS}readelf -d "$EXE/core-cpu1" | grep NEEDED
  echo "== NEEDED cf/ai_learner.so"; ${CROSS}readelf -d "$EXE/cf/ai_learner.so" | grep NEEDED || echo "(none)"
  check_needed "$EXE/core-cpu1"
  for so in "$EXE"/cf/*.so; do check_needed "$so"; done
  echo "== startup script"; grep -n "ai_learner\|sample_app" "$EXE/cf/cfe_es_startup.scr"
  grep -q "ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   $STARTUP_STACK," "$EXE/cf/cfe_es_startup.scr" || die "startup script lacks the ai_learner entry with stack $STARTUP_STACK"
  ls "$EXE"/cf/sbn*.so 2>/dev/null && die "sbn must not be built for SIMULATION=$SIM" || echo "sbn*.so absent (native-only) -- OK"
} 2>&1 | tee -a "$LOG"

# Evidence that the knobs and the contract reached the compiled app
CC_JSON="$ARCH_DIR/compile_commands.json"
[ -f "$CC_JSON" ] || die "no $CC_JSON"
N_CC="$(grep -c '"command"' "$CC_JSON")"
N_MCPU="$(grep -c -- '-mcpu=cortex-a53' "$CC_JSON")"
AI_CMD="$(python3 - "$CC_JSON" <<'PY'
import json,sys
for e in json.load(open(sys.argv[1])):
    if e["file"].endswith("ai_learner.c"): print(e["command"]); break
PY
)"
[ -n "$AI_CMD" ] || die "ai_learner.c not in compile_commands.json"
grep -q -- "-DAI_LEARNER_BUDGET_BYTES=$BUDGET_BYTES\b" <<<"$AI_CMD" || die "AI_LEARNER_BUDGET_BYTES=$BUDGET_BYTES did not reach the ai_learner.c compile: $AI_CMD"
grep -q -- "-DAI_LEARNER_STACK_BASE_BYTES=$STACK_BASE_BYTES\b" <<<"$AI_CMD" || die "AI_LEARNER_STACK_BASE_BYTES did not reach the ai_learner.c compile"
grep -q -- "-mcpu=cortex-a53" <<<"$AI_CMD" || die "-mcpu=cortex-a53 missing from the ai_learner.c compile"
grep -q -- "apps_aarch64/ai_learner/fsw/src/ai_learner.c" <<<"$AI_CMD" || die "ai_learner.c was not taken from apps_aarch64/"
HDR_SHA="$(hdr_macro CONTRACT_ARTIFACT_SHA256)"
N_SHA_IN_SO="$(strings -n 64 "$EXE/cf/ai_learner.so" | grep -c "^$HDR_SHA$" || true)"
[ "$N_SHA_IN_SO" -ge 1 ] || die "contract sha256 $HDR_SHA not found in ai_learner.so (wrong header compiled in?)"
N_IREE_SYMS="$(${CROSS}nm "$EXE/cf/ai_learner.so" | grep -c ' [Tt] iree_' || true)"
[ "$N_IREE_SYMS" -ge 1 ] || die "no iree_* symbols in ai_learner.so -- runtime archives not linked"
echo "== compile evidence: $N_MCPU/$N_CC compile commands carry -mcpu=cortex-a53; ai_learner.so has $N_IREE_SYMS iree_* text symbols and the header sha256 ($N_SHA_IN_SO occurrence)" | tee -a "$LOG"

# ---------------------------------------------------------------- 7. copy the exe tree out + record
rm -rf "$DEST/cpu1"
cp -a "$EXE" "$DEST/cpu1"
cp "$CONTRACT_HEADER" "$DEST/contract_gen.h"
cp "$APPDIR/CMakeLists.txt" "$DEST/ai_learner.CMakeLists.txt"
VMFB_MATCH=null
if [ -n "$MODEL_VMFB" ]; then
  [ -f "$MODEL_VMFB" ] || die "MODEL_VMFB not found: $MODEL_VMFB"
  cp "$MODEL_VMFB" "$DEST/cpu1/cf/model.vmfb"
  VMFB_SHA="$(sha256sum "$DEST/cpu1/cf/model.vmfb" | cut -d' ' -f1)"
  if [ "$VMFB_SHA" = "$HDR_SHA" ]; then VMFB_MATCH=true; else VMFB_MATCH=false; echo "NOTE: model.vmfb sha256 $VMFB_SHA != header $HDR_SHA (binding mismatch scenario?)" | tee -a "$LOG"; fi
fi

CORE_BYTES="$(stat -c %s "$DEST/cpu1/core-cpu1")"; CORE_SHA="$(sha256sum "$DEST/cpu1/core-cpu1" | cut -d' ' -f1)"
APP_BYTES="$(stat -c %s "$DEST/cpu1/cf/ai_learner.so")"; APP_SHA="$(sha256sum "$DEST/cpu1/cf/ai_learner.so" | cut -d' ' -f1)"
export BI_TAG="$OUT_TAG" BI_DEST="$DEST" BI_CFS_ROOT="$CFS_ROOT" BI_CFS_COMMIT="$(git -C "$CFS_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
export BI_CFG="$CFG" BI_SIM="$SIM" BI_PREP_OPTS="$(cat "build-$CFG/stamp.prep" 2>/dev/null || true)"
export BI_IREE_B="$IREE_B" BI_IREE_MACHINES="$IREE_MACHINES" BI_KNOB_ROUTE="$KNOB_ROUTE"
export BI_HEADER="$CONTRACT_HEADER" BI_HEADER_SHA="$(sha256sum "$CONTRACT_HEADER" | cut -d' ' -f1)"
export BI_MODEL="$(hdr_macro CONTRACT_MODEL_NAME)" BI_TRIPLE="$(hdr_macro CONTRACT_TARGET_TRIPLE)"
export BI_BOUNDED="$(hdr_macro CONTRACT_BOUNDED_BYTES)" BI_BOUND_KNOWN="$(hdr_macro CONTRACT_BOUND_KNOWN)" BI_HDR_SHA="$HDR_SHA" BI_HDR_KERNEL="$HDR_KERNEL"
export BI_BUDGET="$BUDGET_BYTES" BI_STACK_BASE="$STACK_BASE_BYTES" BI_KERNEL="$KERNEL_STACK_BYTES" BI_STARTUP_STACK="$STARTUP_STACK" BI_REPORT_EVERY="$REPORT_EVERY"
export BI_CORE_BYTES="$CORE_BYTES" BI_CORE_SHA="$CORE_SHA" BI_APP_BYTES="$APP_BYTES" BI_APP_SHA="$APP_SHA"
export BI_CORE_NEEDED="$(needed "$DEST/cpu1/core-cpu1" | tr '\n' ' ')" BI_APP_NEEDED="$(needed "$DEST/cpu1/cf/ai_learner.so" | tr '\n' ' ')"
export BI_SO_LIST="$(cd "$DEST/cpu1/cf" && ls *.so | tr '\n' ' ')" BI_N_SO="$N_SO" BI_N_CC="$N_CC" BI_N_MCPU="$N_MCPU" BI_N_IREE_SYMS="$N_IREE_SYMS"
export BI_T_PREP="$((T1-T0))" BI_T_INSTALL="$((T3-T2))" BI_T_TOTAL="$((T3-T0))" BI_JOBS="$JOBS" BI_DROP_APPS="$DROP_APPS"
export BI_VMFB="$MODEL_VMFB" BI_VMFB_MATCH="$VMFB_MATCH" BI_STARTUP_LINE="$(grep ai_learner "$DEST/cpu1/cf/cfe_es_startup.scr")"
python3 - <<'PY'
import json, os, time
e = os.environ
g = lambda k: e.get("BI_" + k, "")
def num(k):
    v = g(k)
    try: return int(v)
    except ValueError: return None if v in ("", "null") else v
info = {
  "tag": g("TAG"), "built_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "cfs": {"root": g("CFS_ROOT"), "commit": g("CFS_COMMIT"), "config": g("CFG"), "simulation": g("SIM"),
          "prep_opts": g("PREP_OPTS").strip(), "dropped_apps": g("DROP_APPS").split(), "cpu2_built": False,
          "unit_tests": False},
  "iree_runtime": {"build_dir": g("IREE_B"), "elf_machine": g("IREE_MACHINES")},
  "contract_header": {"path": g("HEADER"), "sha256": g("HEADER_SHA"), "model_name": g("MODEL"),
                      "target_triple": g("TRIPLE"), "bound_known": num("BOUND_KNOWN"), "bounded_bytes": num("BOUNDED"),
                      "artifact_sha256": g("HDR_SHA"), "kernel_stack_bytes_in_header": num("HDR_KERNEL")},
  "app_knobs": {"route": g("KNOB_ROUTE"), "AI_LEARNER_BUDGET_BYTES": num("BUDGET"),
                "AI_LEARNER_STACK_BASE_BYTES": num("STACK_BASE"), "AI_LEARNER_REPORT_EVERY": num("REPORT_EVERY")},
  "task_stack": {"stack_base_bytes": num("STACK_BASE"), "kernel_stack_bytes": num("KERNEL"),
                 "startup_script_stack_bytes": num("STARTUP_STACK"), "startup_line": g("STARTUP_LINE").strip(),
                 "note": "task-stack budget bucket (AAPCS64 frame of the dispatch functions), not part of the HAL contract"},
  "exe": {"dir": g("DEST") + "/cpu1", "core_cpu1_bytes": num("CORE_BYTES"), "core_cpu1_sha256": g("CORE_SHA"),
          "core_cpu1_needed": g("CORE_NEEDED").split(), "ai_learner_so_bytes": num("APP_BYTES"),
          "ai_learner_so_sha256": g("APP_SHA"), "ai_learner_so_needed": g("APP_NEEDED").split(),
          "shared_objects": g("SO_LIST").split(), "n_shared_objects": num("N_SO"),
          "iree_text_symbols_in_app": num("N_IREE_SYMS"),
          "model_vmfb": g("VMFB") or None, "model_vmfb_matches_header": None if g("VMFB_MATCH") == "null" else g("VMFB_MATCH") == "true"},
  "compile_commands": {"total": num("N_CC"), "with_mcpu_cortex_a53": num("N_MCPU")},
  "build_seconds": {"prep": num("T_PREP"), "install": num("T_INSTALL"), "total": num("T_TOTAL"), "jobs": num("JOBS")},
}
p = os.path.join(g("DEST"), "build_info.json")
json.dump(info, open(p, "w"), indent=2); open(p, "a").write("\n")
print("wrote", p)
PY

echo "== DONE: exe tree $DEST/cpu1  core-cpu1 $CORE_BYTES B  cf/ai_learner.so $APP_BYTES B  (build $((T3-T0)) s)" | tee -a "$LOG"
echo "   deploy: scp -r $DEST/cpu1 into the guest; needs /proc/sys/fs/mqueue/msg_max >= 512 there (scripts/00_env.sh)"
