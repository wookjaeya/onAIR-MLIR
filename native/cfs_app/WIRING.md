# AI_LEARNER cFS app — wiring (verified on cFS bundle native_std, 2026-09-08)

1. Copy this directory to `<cFS>/apps/ai_learner/`.
2. `sample_defs/targets.cmake`: `list(APPEND MISSION_GLOBAL_APPLIST sample_app sample_lib ai_learner)`
3. `sample_defs/generate_startup.cmake`: add after sample_app
   `"CFE_APP, ai_learner,  AI_LEARNER_AppMain, AI_LEARNER,   55,   262144, 0x0, 0;\n"`
4. IREE runtime built from the SAME commit as the compiler (here e4a3b04), minimal config,
   `-DCMAKE_POSITION_INDEPENDENT_CODE=ON` (cFS apps are shared objects). ~22 s build.
5. `make native_std.prep && make native_std.install`; copy the vmfb to `exe/cpu1/cf/model.vmfb`.
6. `/proc/sys/fs/mqueue/msg_max` must be >= 512 (container default 10 breaks cFE SB pipes).

Pitfalls hit and fixed:
- cFS compiles apps with `-std=c99 -pedantic -Werror`; IREE headers need gnu11 -> relaxed for this app only.
- `CFE_ES_HK_TLM_MID` needs `#include "cfe_es_msgids.h"`.
- `/cf/...` is an OSAL virtual path; use `OS_TranslatePath` before `fopen`.
- `OS_printf` truncates long lines (~170 chars); JSON split into two lines.
- Module bytes are referenced zero-copy: free only after `iree_runtime_session_release` (D4).
