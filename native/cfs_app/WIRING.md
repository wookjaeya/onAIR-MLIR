# AI_LEARNER cFS app — wiring (verified on cFS bundle native_std, 2026-09-08; Stage 1 update)

1. Generate the contract header FIRST, from the contract of the SAME `iree-compile` invocation that
   produced the vmfb you will deploy (EVIDENCE_v0.7 §1.3):
   `python3 harness/gen_contract_header.py <contract.json> native/cfs_app/fsw/src/contract_gen.h`
   The app refuses to compile (`#error`) against a header that lacks the Stage 1 macros
   (`CONTRACT_BOUND_KNOWN`, `CONTRACT_INPUT_RANK/SHAPE`, `CONTRACT_ENTRY`, `CONTRACT_KERNEL_STACK_BYTES`,
   `CONTRACT_MODEL_NAME`, `CONTRACT_TARGET_TRIPLE`, ...). Nothing model-specific is in the C source.
2. Copy this directory to `<cFS>/apps/ai_learner/` (`scripts/50_wire_cfs_ai_learner.sh` does 2–5).
3. `sample_defs/targets.cmake`: `list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner)`
4. `sample_defs/generate_startup.cmake`: add after sample_app
   `"CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   <STACK>, 0x0, 0;\n"`
   where **`<STACK> = AI_LEARNER_STACK_BASE_BYTES + CONTRACT_KERNEL_STACK_BYTES`** (E12 used 262144
   with a 0-byte kernel frame on x86-64; on AArch64 the contract carries the 16-byte AAPCS64 frame of
   the dispatch functions, so the entry becomes 262160). The app proves the accounting reached the
   running system with one JSON line after a successful init:
   `{"app":"AI_LEARNER","stage":"stack","es_stack_size":<CFE_ES_GetAppInfo().StackSize>,"stack_base_bytes":262144,"contract_kernel_stack_bytes":16,"kernel_stack_accounted":true}`
   (`kernel_stack_accounted` = `es_stack_size >= base + kernel`). This is task-stack budget evidence,
   NOT part of the HAL contract (`bounded_bytes`).
5. IREE runtime built from the SAME commit as the compiler (here e4a3b04), minimal config,
   `-DCMAKE_POSITION_INDEPENDENT_CODE=ON` (cFS apps are shared objects). ~22 s build.
   `CMakeLists.txt` points at it via `set(IREE_SRC "/tmp/iree-src")` (the wiring script `sed`s that line).
6. `make native_std.prep && make native_std.install`; copy the vmfb to `exe/cpu1/cf/model.vmfb`.
7. `/proc/sys/fs/mqueue/msg_max` must be >= 512 (container default 10 breaks cFE SB pipes).

## Build-time knobs (CMake cache variables in `CMakeLists.txt`)

| variable | default | meaning |
|---|---|---|
| `AI_LEARNER_BUDGET_BYTES` | 1048576 | budget the admission gate compares with `CONTRACT_BOUNDED_BYTES` |
| `AI_LEARNER_STACK_BASE_BYTES` | 262144 | base task stack; the startup-script stack must be base + `CONTRACT_KERNEL_STACK_BYTES` |
| `AI_LEARNER_REPORT_EVERY` | 5 | emit `run`/`mem` JSON lines + EVS event every N completed inferences |

**How a `-D` reaches the app.** cFS configures each CPU target in a *separate* CMake process
(`cfe/cmake/mission_build.cmake` → `execute_process(cmake ... -DTARGETSYSTEM=... ${CFE_SOURCE_DIR})`),
so a `-D` given to the top-level/mission `cmake` (or `make prep`) does NOT propagate to
`apps/ai_learner/CMakeLists.txt`. Two routes that do work:

- Re-configure the arch build tree after `prep` (the cache there persists, so this is a one-liner):
  `cmake -DAI_LEARNER_BUDGET_BYTES=786475 -DAI_LEARNER_STACK_BASE_BYTES=262144 -DAI_LEARNER_REPORT_EVERY=5 build-native_std/native/default_cpu1`
  then `make native_std.install` (for the AArch64 target the tree is `build-<config>/<toolchain>/default_cpu1`).
- Or write the values into the arch cache before the first configure: `set(AI_LEARNER_BUDGET_BYTES 786475 CACHE STRING "" FORCE)`
  in a file included by the arch build (e.g. via `${MISSION_DEFS}/<target>/install_custom.cmake` is too late —
  use the re-configure route above, it is what the wiring scripts do).

One `.so` per (contract header, budget) variant: regenerate `fsw/src/contract_gen.h`, re-configure with the
`-D`s, rebuild, and copy `exe/cpu1/cf/ai_learner.so` aside under a variant name.

## Init/run contract of the app (what the harness parses, one JSON object per line on stdout)

Gate order (unchanged since v0.7): admission → sha256 of the exact bytes → runtime creation → the SAME
bytes to the session. Cleanup order (D4): input buffer → session → device → instance → blob → SB pipe.

| stage | when | key fields |
|---|---|---|
| `admission` | always, first | `verdict` ∈ `ADMIT` / `NOT_ADMITTED` / `UNKNOWN_BOUND`, `model`, `target`, `bounded`, `budget`, `per_call`, `constants`, `kernel_stack_bytes`, `bound_known` |
| `binding` | after ADMIT | `verdict` ∈ `MATCH` / `CONTRACT_ARTIFACT_MISMATCH` / `ARTIFACT_MISSING`, `artifact_bytes`, `artifact_sha256`, `contract_sha256` |
| `runtime_load_failed` | IREE refused the (hash-matching) artifact, or device/session creation failed | `step`, `status` (IREE status text), `model`, `target`; ERROR event 7; app does not start |
| `stack` | after successful init | see §4 above |
| `infer_failed` | first per-call failure only | `step`, `status`, `attempted`; ERROR event 10; later failures are only counted |
| `run` / `mem` | every `AI_LEARNER_REPORT_EVERY` completed inferences | E12 field names plus `model`, `target`, `out` (all `CONTRACT_OUTPUT_ELEMS` values) |
| `cleanup` | exactly once per app lifetime | `released`, `cleanup_calls` (expected 1 on every path) |

`UNKNOWN_BOUND` (contract `bound_method == "NONE"` / any size unresolved / non-static shapes) is refused
before the artifact is opened: CRITICAL event 6, `CFE_STATUS_EXTERNAL_RESOURCE_FAIL`, no runtime created.
Features: `CFE_MSG_GetSize()` gives the packet size; bytes after the 16-byte header are wrapped
(`raw[16 + i % (size-16)] / 256.0f`) to fill `CONTRACT_INPUT_ELEMS`; packets of <= 16 bytes count as `fail_input`.

Double-cleanup fix (E12 known issue): `AI_LEARNER_Init` releases everything it acquired on every one of its
failure paths and `AI_LEARNER_AppMain` runs cleanup only after a successful init, so `cleanup_calls` is 1 on
every path (mismatch, missing file, load failure, not admitted, unknown bound, normal exit).

Pitfalls hit and fixed:
- cFS compiles apps with `-std=c99 -pedantic -Werror`; IREE headers need gnu11 -> relaxed for this app only.
- `CFE_ES_HK_TLM_MID` needs `#include "cfe_es_msgids.h"`.
- `/cf/...` is an OSAL virtual path; use `OS_TranslatePath` before `fopen`.
- `OS_printf` truncates at `OS_BUFFER_SIZE` (172 B in this OSAL config); the Stage 1 JSON lines are longer,
  so the app formats each line itself and emits it with ONE `write(STDOUT_FILENO, ...)` (atomic below PIPE_BUF,
  same fd the OSAL console task uses). EVS events remain the human-readable channel.
- Module bytes are referenced zero-copy: free only after `iree_runtime_session_release` (D4).
- No `IREE_CHECK_OK` anywhere in the app: every IREE status is checked, reported and freed.
