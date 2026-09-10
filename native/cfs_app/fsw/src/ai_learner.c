/* E12 / E14 Stage 1 / E15 Phase 3 (EVIDENCE_v0.10 §Phase 3, R4/R8): AI_LEARNER
 * cFS app -- compiled IREE Learner inside cFS.
 *
 * Init (gate order must not change):
 *   1. task-stack gate: ES-reported task stack size vs AI_LEARNER_STACK_BASE_BYTES
 *      + CONTRACT_KERNEL_STACK_BYTES (AArch64 dispatch functions carry a stack
 *      frame; it is budgeted on the task stack, not in the HAL contract). This
 *      is an actual rejection now (D15/EVIDENCE_v0.9 §11.5: it used to be
 *      computed AFTER every other resource was already acquired and reported
 *      as telemetry only, never enforced) -- it runs first because it costs
 *      nothing to acquire (CFE_ES_GetAppInfo, no allocation) and is the one
 *      check native_learner.c cannot exercise at all (it has no ES task).
 *   2. admission: contract bounded_bytes vs AI_LEARNER_BUDGET_BYTES, still
 *      before the IREE runtime is created and before the artifact is even
 *      opened. A contract without a static bound (CONTRACT_BOUND_KNOWN == 0)
 *      is refused as UNKNOWN_BOUND at the same point. A bound-known contract
 *      whose interface is not the single-f32-in/single-f32-out shape this app
 *      hardcodes (CONTRACT_NUM_INPUTS/OUTPUTS != 1) is refused here too --
 *      defense-in-depth: gen_contract_header.py already refuses to emit such a
 *      header for a bound-known contract (E15), so this should be unreachable
 *      for any header it produced.
 *   3. binding: sha256 of the exact bytes read from /cf/model.vmfb vs the
 *      contract; CONTRACT_ARTIFACT_MISMATCH refuses before any runtime
 *      allocation. The file size is compared against contract.artifact.bytes
 *      BEFORE malloc() (R8/EVIDENCE_v0.9 §11.9): a file whose size already
 *      disagrees cannot hash-match, so this removes the unbounded allocation
 *      that used to happen first for such a file without changing behavior
 *      for one that does match.
 *   4. runtime creation (instance -> device -> session), then the SAME bytes are
 *      handed to the session. Any IREE failure here (A5: corrupted artifact whose
 *      hash matches the contract) is an ERROR event + cleanup + init failure; every
 *      IREE status is checked, reported and freed (no abort-on-status macro is used).
 * Loop: subscribe to CFE_ES_HK_TLM_MID (periodic ES housekeeping telemetry) and
 *       run one inference per received packet, using packet payload bytes as
 *       features. Every AI_LEARNER_REPORT_EVERY inferences emit an EVS event and
 *       "run"/"mem" JSON lines for the harness.
 * Cleanup order (D4): input buffer -> session -> device -> instance -> blob.
 *       Init releases everything it acquired on its own failure paths; AppMain
 *       runs cleanup only after a successful Init, so cleanup_calls is exactly 1
 *       on every path (the E12 double-cleanup on the mismatch path is gone).
 *
 * Everything model-specific comes from contract_gen.h (harness/gen_contract_header.py,
 * generated from the contract of the SAME iree-compile invocation as the vmfb).
 * Build-time knobs (CMake cache variables, see CMakeLists.txt / WIRING.md):
 *   AI_LEARNER_BUDGET_BYTES, AI_LEARNER_STACK_BASE_BYTES, AI_LEARNER_REPORT_EVERY.
 */
#include "cfe.h"
#include "cfe_es_msgids.h"
#include "iree/runtime/api.h"
#include "contract_gen.h"   /* generated from contract.json (gen_contract_header.py) */
#include "sha256.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#if !defined(CONTRACT_BOUND_KNOWN) || !defined(CONTRACT_INPUT_RANK) || !defined(CONTRACT_INPUT_SHAPE) || \
    !defined(CONTRACT_OUTPUT_ELEMS) || !defined(CONTRACT_ENTRY) || !defined(CONTRACT_KERNEL_STACK_BYTES) || \
    !defined(CONTRACT_MODEL_NAME) || !defined(CONTRACT_TARGET_TRIPLE) || !defined(CONTRACT_DRIVER) || \
    !defined(CONTRACT_NUM_INPUTS) || !defined(CONTRACT_NUM_OUTPUTS) || !defined(CONTRACT_DTYPES_ALL_F32)
#error "contract_gen.h is missing Stage 1 macros: regenerate it with harness/gen_contract_header.py"
#endif
/* A contract whose shapes are not all static cannot carry a static bound; refuse it as
 * UNKNOWN_BOUND even if the generator did not already clear CONTRACT_BOUND_KNOWN. */
#ifndef CONTRACT_SHAPES_STATIC
#define CONTRACT_SHAPES_STATIC 1
#endif
#define GATE_BOUND_KNOWN (CONTRACT_BOUND_KNOWN && CONTRACT_SHAPES_STATIC)
#ifndef AI_LEARNER_BUDGET_BYTES
#error "AI_LEARNER_BUDGET_BYTES must be defined (CMake cache variable AI_LEARNER_BUDGET_BYTES)"
#endif
#ifndef AI_LEARNER_STACK_BASE_BYTES
#define AI_LEARNER_STACK_BASE_BYTES 262144   /* base task stack used by the startup script since E12 */
#endif
#ifndef AI_LEARNER_REPORT_EVERY
#define AI_LEARNER_REPORT_EVERY 5
#endif
#define AI_LEARNER_PIPE_DEPTH 8
#define AI_LEARNER_MODEL_FILE "/cf/model.vmfb"
#define AI_LEARNER_E25_INPUTS  "/cf/e25_inputs.bin"   /* E25: optional equivalence input set */
#define AI_LEARNER_E25_OUTPUTS "/cf/e25_outputs.bin"
#define AI_LEARNER_HDR_BYTES 16   /* CCSDS primary + telemetry secondary header skipped before features */

enum {
  EID_NOT_ADMITTED = 1, EID_NO_FILE = 2, EID_INIT_OK = 3, EID_REPORT = 4, EID_MISMATCH = 5,
  EID_UNKNOWN_BOUND = 6, EID_LOAD_FAILED = 7, EID_STACK = 8, EID_INIT_FAIL = 9, EID_INFER_FAIL = 10,
  EID_STACK_REJECT = 11, EID_INTERFACE_MISMATCH = 12, EID_MAP_PRECONDITION = 13
};

static struct {
  CFE_SB_PipeId_t pipe; bool pipe_created;
  iree_runtime_instance_t* instance; iree_hal_device_t* device; iree_runtime_session_t* session;
  void* blob; long blob_len; iree_hal_buffer_view_t* x;
  int module_ptr_mod64; long hal_peak_after_append; int conditional_map;
  uint32 n_attempt, n_infer, n_fail_input, n_fail_invoke, n_fail_output, n_cleanup;
  bool first_fail_reported;
  double lat_sum_us, lat_max_us, lat_last_us; float out[CONTRACT_OUTPUT_ELEMS];
  long rss_kb_init0, rss_kb_init1, rss_kb_after_session;
} g;

static long rss_kb(void) {
  FILE* f = fopen("/proc/self/status", "r"); char line[256]; long v = -1;
  while (f && fgets(line, sizeof line, f)) if (!strncmp(line, "VmRSS:", 6)) { sscanf(line + 6, "%ld", &v); break; }
  if (f) fclose(f);
  return v;
}
static double now_us(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e6 + t.tv_nsec / 1e3; }

/* One JSON object per line on the process stdout. OS_printf truncates at
 * OS_BUFFER_SIZE (172 B in this OSAL configuration) and the Stage 1 lines are
 * longer, so the line is formatted here and handed to write(2) in ONE call:
 * atomic for lines shorter than PIPE_BUF and on the same fd (STDOUT_FILENO)
 * the OSAL console task writes to. Human-readable status still goes via EVS. */
static void AI_LEARNER_Json(const char* fmt, ...) {
  char line[768]; va_list ap; int n;
  va_start(ap, fmt); n = vsnprintf(line, sizeof line, fmt, ap); va_end(ap);
  if (n < 0) return;
  if (n >= (int)sizeof line) { n = (int)sizeof line - 1; line[n - 1] = '\n'; }
  ssize_t w = write(STDOUT_FILENO, line, (size_t)n); (void)w;
}

/* Copy an IREE status message into a JSON-safe C string (escapes " \ and control chars). */
static void AI_LEARNER_StatusJson(iree_status_t st, char* out, size_t cap) {
  iree_allocator_t a = iree_allocator_system(); char* buf = NULL; iree_host_size_t len = 0;
  const char* src = iree_status_code_string(iree_status_code(st)); size_t n = strlen(src), o = 0;
  if (iree_status_to_string(st, &a, &buf, &len)) { src = buf; n = (size_t)len; }
  for (size_t i = 0; i < n && o + 7 < cap; ++i) {
    unsigned char c = (unsigned char)src[i];
    if (c == '"' || c == '\\') { out[o++] = '\\'; out[o++] = (char)c; }
    else if (c == '\n') { out[o++] = '\\'; out[o++] = 'n'; }
    else if (c < 0x20) { o += (size_t)snprintf(out + o, cap - o, "\\u%04x", c); }
    else out[o++] = (char)c;
  }
  out[o] = 0;
  if (buf) iree_allocator_free(a, buf);
}

static void AI_LEARNER_FormatOut(char* b, size_t cap) {
  size_t o = 0;
  for (int k = 0; k < CONTRACT_OUTPUT_ELEMS && o < cap; ++k) o += (size_t)snprintf(b + o, cap - o, "%s%.6f", k ? "," : "", g.out[k]);
}

/* Release everything that exists: input buffer -> session -> device -> instance
 * -> blob (the blob is referenced zero-copy by the session, D4), then the SB
 * pipe. Idempotent; the call count is reported as evidence. */
static void AI_LEARNER_Cleanup(void) {
  g.n_cleanup++;
  if (g.x) { iree_hal_buffer_view_release(g.x); g.x = NULL; }
  if (g.session) { iree_runtime_session_release(g.session); g.session = NULL; }
  if (g.device) { iree_hal_device_release(g.device); g.device = NULL; }
  if (g.instance) { iree_runtime_instance_release(g.instance); g.instance = NULL; }
  if (g.blob) { free(g.blob); g.blob = NULL; }   /* after session release: zero-copy reference (D4) */
  if (g.pipe_created) { CFE_SB_DeletePipe(g.pipe); g.pipe_created = false; }
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"cleanup\",\"released\":true,\"cleanup_calls\":%u}\n", (unsigned)g.n_cleanup);
}

/* A5 path: IREE refused the artifact (or device/session creation failed) AFTER
 * admission and binding passed. ERROR event, JSON line with the IREE status,
 * full cleanup, init failure. The app never reaches the run loop. */
static int32 AI_LEARNER_LoadFailed(const char* step, iree_status_t st) {
  char msg[400]; AI_LEARNER_StatusJson(st, msg, sizeof msg);
  const char* code = iree_status_code_string(iree_status_code(st));
  iree_status_free(st);
  CFE_EVS_SendEvent(EID_LOAD_FAILED, CFE_EVS_EventType_ERROR,
    "AI_LEARNER runtime load failed at %s: %s; releasing resources, app will not start", step, code);
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"runtime_load_failed\",\"step\":\"%s\",\"status\":\"%s\",\"model\":\"%s\",\"target\":\"%s\"}\n",
                  step, msg, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE);
  AI_LEARNER_Cleanup();
  return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
}

static void AI_LEARNER_AdmissionJson(const char* verdict) {
  /* F11 (external review, 2026-09; not a code defect -- CLAUDE.md priority 5
   * already documents this scope, and resources.scope/bound_assumptions in
   * the contract JSON already say it): this verdict compares CONTRACT_BOUNDED_BYTES
   * against AI_LEARNER_BUDGET_BYTES only -- a per-app local budget, not a
   * check that the whole onboard computer can fit this model alongside
   * everything else running on it. "scope" here propagates that same
   * disclosure into the runtime telemetry, not just the offline contract. */
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"admission\",\"verdict\":\"%s\",\"model\":\"%s\",\"target\":\"%s\","
                  "\"bounded\":%ld,\"budget\":%ld,\"per_call\":%ld,\"constants\":%ld,\"kernel_stack_bytes\":%ld,\"bound_known\":%s,"
                  "\"scope\":\"per_app_local_budget\"}\n",
                  verdict, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE, (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES,
                  (long)CONTRACT_PER_CALL_BYTES, (long)CONTRACT_CONST_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES,
                  GATE_BOUND_KNOWN ? "true" : "false");
}

/* ---- E29 (docs/EVIDENCE_v0.31_E29.md): module image alignment ----------------
 * IREE emits module-resident constants as `stream.resource.try_map` + an
 * `scf.if(%did_map)`: the map arm allocates nothing on the HAL device, the copy
 * arm allocates the whole constant block.  `CONTRACT_BOUNDED_BYTES` is the max
 * over both arms, so admission on it stays sound whichever arm runs -- E26
 * measured up to 172.30x between them for the SAME vmfb and left the
 * determinant undetermined.
 *
 * E29 identified it: iree_hal_heap_buffer_wrap() (runtime/src/iree/hal/
 * buffer_heap.c) returns OUT_OF_RANGE unless the imported span is aligned to
 * IREE_HAL_HEAP_BUFFER_ALIGNMENT (64, runtime/src/iree/base/config.h), and the
 * map arm is exactly that import.  harness/e29_collect.py measured 64/64 cells
 * (8 models x 8 alignment classes): map <=> 64-byte aligned, and the peak was
 * always either 0 or exactly the contract's constant block -- never a third
 * value.  plain malloc() gave this app a 16 mod 64 pointer, which is why every
 * cFS cell in E26/E26e/E26f landed on the copy arm.
 *
 * Allocating the image aligned therefore lowers the observed peak to the
 * contract's per-call term without touching admission: the bound does not
 * change, only which arm the deployment lands on.  A failed posix_memalign
 * falls back to malloc -- correct, merely less tight -- and the arm actually
 * taken is measured after append rather than assumed. */
static void* AI_LEARNER_AllocModuleImage(size_t n, int* out_mod64) {
  void* p = NULL;
  if (posix_memalign(&p, 64, n) != 0) p = NULL;
  if (!p) p = malloc(n);                    /* correct, only less tight */
  *out_mod64 = p ? (int)(((uintptr_t)p) % 64) : -1;
  return p;
}

/* Opt-in conditional admission (E29).  Default 0: every existing deployment
 * keeps the unconditional decision on CONTRACT_BOUNDED_BYTES byte for byte.
 * Set to 1 only for an integrator that accepts the map precondition; the app
 * then admits a budget that covers CONTRACT_PER_CALL_BYTES but not
 * CONTRACT_BOUNDED_BYTES, enforces the precondition by construction (aligned
 * image above) and VERIFIES it right after append, refusing before a single
 * inference if the copy arm ran instead.  The transient that a failed
 * verification has already paid is bounded by CONTRACT_BOUNDED_BYTES, which is
 * why the conditional tier is never allowed to skip that check. */
#ifndef AI_LEARNER_ALLOW_CONDITIONAL_MAP
#define AI_LEARNER_ALLOW_CONDITIONAL_MAP 0
#endif

static int32 AI_LEARNER_Init(void) {
  CFE_EVS_Register(NULL, 0, CFE_EVS_EventFilter_BINARY);

  /* ---- task-stack gate: ES-reported task stack vs base + kernel dispatch frame.
   * Runs FIRST -- before admission, before the artifact, before any IREE call --
   * because CFE_ES_GetAppID()/GetAppInfo() acquire nothing that needs releasing,
   * so there is no cost to checking it before anything else exists to clean up.
   * D15/EVIDENCE_v0.9 §11.5: previously this was computed after the IREE
   * runtime, session, input buffer and SB pipe were already created, and its
   * result (kernel_stack_accounted) was reported but never enforced -- an
   * insufficient stack could not stop the app from starting. It now can. */
  CFE_ES_AppId_t app_id; CFE_ES_AppInfo_t info; long es_stack = -1;
  memset(&info, 0, sizeof info);
  if (CFE_ES_GetAppID(&app_id) == CFE_SUCCESS && CFE_ES_GetAppInfo(&info, app_id) == CFE_SUCCESS) es_stack = (long)info.StackSize;
  long stack_needed = (long)AI_LEARNER_STACK_BASE_BYTES + (long)CONTRACT_KERNEL_STACK_BYTES;
  int stack_accounted = es_stack >= stack_needed;
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"stack\",\"es_stack_size\":%ld,\"stack_base_bytes\":%ld,\"contract_kernel_stack_bytes\":%ld,\"kernel_stack_accounted\":%s}\n",
                  es_stack, (long)AI_LEARNER_STACK_BASE_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES, stack_accounted ? "true" : "false");
  if (!stack_accounted) {
    CFE_EVS_SendEvent(EID_STACK_REJECT, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER stack insufficient: es=%ld needed=%ld (base=%ld+kernel=%ld); app will not start",
      es_stack, stack_needed, (long)AI_LEARNER_STACK_BASE_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES);
    AI_LEARNER_Cleanup();
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  CFE_EVS_SendEvent(EID_STACK, CFE_EVS_EventType_INFORMATION, "AI_LEARNER stack: es=%ld base=%ld kernel=%ld accounted=%d",
                    es_stack, (long)AI_LEARNER_STACK_BASE_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES, stack_accounted);

  /* ---- admission gate: contract vs app budget, before any runtime allocation and before the artifact is opened ---- */
  if (!GATE_BOUND_KNOWN) {
    CFE_EVS_SendEvent(EID_UNKNOWN_BOUND, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER UNKNOWN_BOUND: contract for %s has no static bound (bound_method NONE); app will not start", CONTRACT_MODEL_NAME);
    AI_LEARNER_AdmissionJson("UNKNOWN_BOUND");
    AI_LEARNER_Cleanup();
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  if ((long)CONTRACT_BOUNDED_BYTES > (long)AI_LEARNER_BUDGET_BYTES) {
    /* E29: the conditional tier, when the integrator opted in, admits on the
     * map arm's bound (per-call only).  It is not a weaker check -- it is the
     * same contract read under a precondition this app enforces and then
     * verifies after append (below), refusing before any inference if the arm
     * it got was the copy arm. */
    if (AI_LEARNER_ALLOW_CONDITIONAL_MAP && (long)CONTRACT_PER_CALL_BYTES <= (long)AI_LEARNER_BUDGET_BYTES) {
      g.conditional_map = 1;
    } else {
      CFE_EVS_SendEvent(EID_NOT_ADMITTED, CFE_EVS_EventType_CRITICAL,
        "AI_LEARNER NOT_ADMITTED: contract bounded=%ld > budget=%ld; app will not start",
        (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES);
      AI_LEARNER_AdmissionJson("NOT_ADMITTED");
      AI_LEARNER_Cleanup();
      return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
    }
  }
  AI_LEARNER_AdmissionJson(g.conditional_map ? "ADMIT_CONDITIONAL_MAP" : "ADMIT");
  /* EVIDENCE_v0.10 Phase 3 (R3 defense-in-depth): this app pushes exactly one
   * f32 input and pops exactly one f32 output (AI_LEARNER_Infer below).
   * gen_contract_header.py already refuses to emit a bound-known header whose
   * interface is not that shape (E15), so this should be unreachable for any
   * header it produced -- it only catches a stale or hand-edited contract_gen.h. */
  /* F7 (external review, 2026-09): the message above already claimed to check
   * "single-f32" while the condition only ever checked input/output COUNT --
   * there was no macro carrying dtype for C to test. CONTRACT_DTYPES_ALL_F32
   * (gen_contract_header.py) closes that: now the condition matches the name. */
  if (CONTRACT_NUM_INPUTS != 1 || CONTRACT_NUM_OUTPUTS != 1 || !CONTRACT_DTYPES_ALL_F32) {
    CFE_EVS_SendEvent(EID_INTERFACE_MISMATCH, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER: bound known but interface is not single-f32-in/single-f32-out (num_inputs=%d num_outputs=%d dtypes_all_f32=%d); app will not start",
      (int)CONTRACT_NUM_INPUTS, (int)CONTRACT_NUM_OUTPUTS, (int)CONTRACT_DTYPES_ALL_F32);
    AI_LEARNER_Cleanup();
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }

  /* ---- artifact binding: hash the exact bytes to be handed to IREE, before any runtime allocation ---- */
  char local_path[OS_MAX_LOCAL_PATH_LEN];
  if (OS_TranslatePath(AI_LEARNER_MODEL_FILE, local_path) != OS_SUCCESS) {
    CFE_EVS_SendEvent(EID_NO_FILE, CFE_EVS_EventType_ERROR, "AI_LEARNER: cannot translate %s", AI_LEARNER_MODEL_FILE);
    AI_LEARNER_Cleanup(); return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  FILE* f = fopen(local_path, "rb");
  if (!f) {
    CFE_EVS_SendEvent(EID_NO_FILE, CFE_EVS_EventType_ERROR, "AI_LEARNER: cannot open %s", AI_LEARNER_MODEL_FILE);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"binding\",\"verdict\":\"ARTIFACT_MISSING\",\"file\":\"%s\"}\n", AI_LEARNER_MODEL_FILE);
    AI_LEARNER_Cleanup(); return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  fseek(f, 0, SEEK_END); g.blob_len = ftell(f); fseek(f, 0, SEEK_SET);
  /* R8/EVIDENCE_v0.9 §11.9, EVIDENCE_v0.10 Phase 3: compare the file size
   * against contract.artifact.bytes BEFORE allocating a buffer sized by an
   * unverified file. A file whose size already disagrees cannot possibly
   * hash-match the contract, so this changes nothing for a file that DOES
   * match (the hash check below still runs for it); it only removes the
   * unbounded malloc()+fread() that used to happen first for a file whose
   * size alone already proves the mismatch. */
  if (g.blob_len != (long)CONTRACT_ARTIFACT_BYTES) {
    fclose(f);
    CFE_EVS_SendEvent(EID_MISMATCH, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER CONTRACT_ARTIFACT_MISMATCH: %s is %ld B, contract expects %ld B; refused before allocation",
      AI_LEARNER_MODEL_FILE, g.blob_len, (long)CONTRACT_ARTIFACT_BYTES);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"binding\",\"verdict\":\"CONTRACT_ARTIFACT_MISMATCH\",\"artifact_bytes\":%ld,"
                    "\"contract_artifact_bytes\":%ld,\"reason\":\"size mismatch, refused before allocation\"}\n",
                    g.blob_len, (long)CONTRACT_ARTIFACT_BYTES);
    AI_LEARNER_Cleanup(); return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  g.blob = AI_LEARNER_AllocModuleImage((size_t)g.blob_len, &g.module_ptr_mod64);
  if (!g.blob || fread(g.blob, 1, (size_t)g.blob_len, f) != (size_t)g.blob_len) {
    fclose(f);
    CFE_EVS_SendEvent(EID_NO_FILE, CFE_EVS_EventType_ERROR, "AI_LEARNER: cannot read %s (%ld B)", AI_LEARNER_MODEL_FILE, g.blob_len);
    AI_LEARNER_Cleanup(); return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  fclose(f);
  char hex[65]; sha256_hex(g.blob, (size_t)g.blob_len, hex);
  int bound = (strcmp(hex, CONTRACT_ARTIFACT_SHA256) == 0);   /* size already verified above */
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"binding\",\"verdict\":\"%s\",\"artifact_bytes\":%ld,\"artifact_sha256\":\"%.16s\",\"contract_sha256\":\"%.16s\"}\n",
                  bound ? "MATCH" : "CONTRACT_ARTIFACT_MISMATCH", g.blob_len, hex, CONTRACT_ARTIFACT_SHA256);
  if (!bound) {
    CFE_EVS_SendEvent(EID_MISMATCH, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER CONTRACT_ARTIFACT_MISMATCH: %s is not the artifact this contract describes; app will not start", AI_LEARNER_MODEL_FILE);
    AI_LEARNER_Cleanup(); return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }

  /* E29b (D54, seventh external review SS4.1-4.2): in the conditional tier the
   * map precondition is decided by the alignment of the image just allocated
   * (E29: map <=> 64-byte aligned, 64/64 cells), so it is checkable BEFORE the
   * runtime exists. Refusing here means the copy arm's constant-block
   * allocation never happens -- no transient above B_map at all. */
  if (g.conditional_map && g.module_ptr_mod64 != 0) {
    CFE_EVS_SendEvent(EID_MAP_PRECONDITION, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER MAP_PRECONDITION_UNMET: admitted on per_call=%ld but module image is %d mod 64; "
      "refused before runtime creation", (long)CONTRACT_PER_CALL_BYTES, g.module_ptr_mod64);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"map_branch\",\"verdict\":\"MAP_PRECONDITION_UNMET\","
                    "\"module_ptr_mod64\":%d,\"contract_per_call_bytes\":%ld}\n", g.module_ptr_mod64, (long)CONTRACT_PER_CALL_BYTES);
    AI_LEARNER_Cleanup();
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }

  /* ---- runtime bring-up: every failure is an ERROR event + cleanup (no abort) ---- */
  g.rss_kb_init0 = rss_kb();
  iree_status_t st;
  iree_runtime_instance_options_t io; iree_runtime_instance_options_initialize(&io);
  iree_runtime_instance_options_use_all_available_drivers(&io);
  st = iree_runtime_instance_create(&io, iree_allocator_system(), &g.instance);
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("instance_create", st);
  st = iree_runtime_instance_try_create_default_device(g.instance, iree_make_cstring_view(CONTRACT_DRIVER), &g.device);
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("device_create", st);
  iree_runtime_session_options_t so; iree_runtime_session_options_initialize(&so);
  st = iree_runtime_session_create_with_device(g.instance, &so, g.device, iree_runtime_instance_host_allocator(g.instance), &g.session);
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("session_create", st);
  /* E26: the runtime context (instance+device+session) is OUTSIDE the memory contract --
   * the contract covers per-call buffers + module-resident constants only. Probing here
   * lets E26 attribute that bucket separately instead of folding it into one number
   * (docs/plans/E25_closeout_E26_E27.md, review SS8.2 "separate accounting"). */
  g.rss_kb_after_session = rss_kb();

  /* ---- module load: the SAME verified bytes (zero-copy; blob freed after session release) ---- */
  st = iree_runtime_session_append_bytecode_module_from_memory(g.session, iree_make_const_byte_span(g.blob, (size_t)g.blob_len), iree_allocator_null());
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("append_bytecode_module", st);
  /* E29: the try_map arm is decided here and nowhere else -- constants are
   * either wrapped in place or copied during append, before any input buffer or
   * inference exists, so this peak is the constant block alone.  Reported for
   * every run (not only the conditional tier) so the arm a deployment landed on
   * is in the record instead of inferred from the end-of-run peak. */
  {
    iree_hal_allocator_statistics_t s0;
    iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &s0);
    g.hal_peak_after_append = (long)s0.device_bytes_peak;
  }
  {
    const char* arm = (g.hal_peak_after_append == 0) ? "map"
                    : ((g.hal_peak_after_append == (long)CONTRACT_CONST_BYTES) ? "copy" : "other");
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"map_branch\",\"model\":\"%s\",\"module_ptr_mod64\":%d,"
                    "\"hal_peak_after_append\":%ld,\"contract_const_bytes\":%ld,\"contract_per_call_bytes\":%ld,"
                    "\"arm\":\"%s\",\"admission_mode\":\"%s\"}\n",
                    CONTRACT_MODEL_NAME, g.module_ptr_mod64, g.hal_peak_after_append,
                    (long)CONTRACT_CONST_BYTES, (long)CONTRACT_PER_CALL_BYTES, arm,
                    g.conditional_map ? "conditional_map" : "unconditional");
    /* E29b (D54): E29 compared `> CONTRACT_PER_CALL_BYTES` here. A copy arm
     * allocates exactly `constants` at append, so for any model with
     * constants < per_call the check passed and the app ran on the copy arm it
     * had itself just labelled -- ending at per_call + constants over the budget
     * it was admitted on (bigact: 59,460 on 45,444). B_map holds only on the
     * map arm, whose append peak is exactly 0 (E29: 32/32 map cells), so the
     * verification is "map arm, or refuse", not a size comparison. */
    if (g.conditional_map && g.hal_peak_after_append != 0) {
      CFE_EVS_SendEvent(EID_MAP_PRECONDITION, CFE_EVS_EventType_CRITICAL,
        "AI_LEARNER MAP_PRECONDITION_FAILED: admitted on per_call=%ld but append peak=%ld (arm=%s, ptr%%64=%d); "
        "app will not start", (long)CONTRACT_PER_CALL_BYTES, g.hal_peak_after_append, arm, g.module_ptr_mod64);
      AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"map_branch\",\"verdict\":\"MAP_PRECONDITION_FAILED\","
                      "\"hal_peak_after_append\":%ld,\"contract_per_call_bytes\":%ld}\n",
                      g.hal_peak_after_append, (long)CONTRACT_PER_CALL_BYTES);
      AI_LEARNER_Cleanup();
      return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
    }
  }

  /* ---- input buffer (contract shape, f32), allocated once and rewritten per packet ---- */
  static const iree_hal_dim_t in_shape[CONTRACT_INPUT_RANK] = CONTRACT_INPUT_SHAPE;
  static float zeros[CONTRACT_INPUT_ELEMS];
  memset(zeros, 0, sizeof zeros);
  st = iree_hal_buffer_view_allocate_buffer_copy(g.device, iree_runtime_session_device_allocator(g.session), CONTRACT_INPUT_RANK, in_shape,
      IREE_HAL_ELEMENT_TYPE_FLOAT_32, IREE_HAL_ENCODING_TYPE_DENSE_ROW_MAJOR,
      (iree_hal_buffer_params_t){.type = IREE_HAL_MEMORY_TYPE_DEVICE_LOCAL, .access = IREE_HAL_MEMORY_ACCESS_ALL, .usage = IREE_HAL_BUFFER_USAGE_DEFAULT},
      iree_make_const_byte_span(zeros, sizeof zeros), &g.x);
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("input_buffer_allocate", st);
  g.rss_kb_init1 = rss_kb();

  /* E26: allocator state at the END of initialisation and BEFORE any inference has run.
   * Until E26 the only HAL statistics the app emitted came from the run loop (every
   * AI_LEARNER_REPORT_EVERY inferences), so "what did merely loading the module and
   * allocating the input buffer cost" was not observable at all -- and with E25 mode
   * enabled it was not even observable indirectly, because 64 inferences ran first.
   * This record is the init/first-call/steady split E26 measures against. */
  {
    iree_hal_allocator_statistics_t st0;
    iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &st0);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"mem_init\",\"model\":\"%s\",\"target\":\"%s\","
                    "\"hal_peak\":%ld,\"hal_allocated\":%ld,\"bounded\":%ld,\"peak_within_bounded\":%s,"
                    "\"inferences_so_far\":0,\"process_rss_kb\":%ld,\"rss_kb_before_runtime\":%ld,"
                    "\"rss_kb_after_session\":%ld,\"rss_kb_after_init\":%ld}\n",
                    CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE,
                    (long)st0.device_bytes_peak, (long)st0.device_bytes_allocated,
                    (long)CONTRACT_BOUNDED_BYTES,
                    ((long)st0.device_bytes_peak <= (long)CONTRACT_BOUNDED_BYTES) ? "true" : "false",
                    rss_kb(), g.rss_kb_init0, g.rss_kb_after_session, g.rss_kb_init1);
  }

  /* ---- E25 equivalence mode (optional) ------------------------------------
   * If /cf/e25_inputs.bin exists, run one inference per f32 vector in it and write
   * the outputs to /cf/e25_outputs.bin, then continue normal startup. Placed AFTER
   * every gate above (stack, admission, interface, artifact size + sha256) so the
   * numbers come from the same fully-gated deployment path the app normally uses.
   * Absent the file nothing changes. (E25, docs/plans/E25_same_model_equivalence.md) */
  {
    bool e25_active = false;
    char e25_in[OS_MAX_LOCAL_PATH_LEN], e25_out[OS_MAX_LOCAL_PATH_LEN];
    if (OS_TranslatePath(AI_LEARNER_E25_INPUTS, e25_in) == OS_SUCCESS &&
        OS_TranslatePath(AI_LEARNER_E25_OUTPUTS, e25_out) == OS_SUCCESS) {
      FILE* fi = fopen(e25_in, "rb");
      if (fi) {
        e25_active = true;
        fseek(fi, 0, SEEK_END); long ib = ftell(fi); fseek(fi, 0, SEEK_SET);
        long nvec = ib / (long)(CONTRACT_INPUT_ELEMS * sizeof(float));
        float* xin = (nvec > 0) ? (float*)malloc((size_t)ib) : NULL;
        long done = 0;
        if (xin && fread(xin, 1, (size_t)ib, fi) == (size_t)ib) {
          FILE* fo = fopen(e25_out, "wb");
          if (fo) {
            for (long v = 0; v < nvec; ++v) {
              float yv[CONTRACT_OUTPUT_ELEMS];
              iree_status_t s2 = iree_hal_buffer_map_write(iree_hal_buffer_view_buffer(g.x), 0,
                  xin + v * CONTRACT_INPUT_ELEMS, CONTRACT_INPUT_ELEMS * sizeof(float));
              if (!iree_status_is_ok(s2)) { iree_status_free(s2); break; }
              iree_runtime_call_t c2; iree_hal_buffer_view_t* r2 = NULL;
              s2 = iree_runtime_call_initialize_by_name(g.session, iree_make_cstring_view(CONTRACT_ENTRY), &c2);
              if (!iree_status_is_ok(s2)) { iree_status_free(s2); break; }
              s2 = iree_runtime_call_inputs_push_back_buffer_view(&c2, g.x);
              if (iree_status_is_ok(s2)) s2 = iree_runtime_call_invoke(&c2, 0);
              if (iree_status_is_ok(s2)) s2 = iree_runtime_call_outputs_pop_front_buffer_view(&c2, &r2);
              if (iree_status_is_ok(s2)) s2 = iree_hal_buffer_map_read(iree_hal_buffer_view_buffer(r2), 0, yv, sizeof yv);
              if (iree_status_is_ok(s2)) { fwrite(yv, sizeof yv, 1, fo); done++; }
              else iree_status_free(s2);
              if (r2) iree_hal_buffer_view_release(r2);
              iree_runtime_call_deinitialize(&c2);
            }
            fclose(fo);
          }
        }
        if (xin) free(xin);
        fclose(fi);
        AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"e25_equivalence\",\"inputs\":%ld,\"completed\":%ld,"
                        "\"model\":\"%s\",\"target\":\"%s\",\"artifact_sha256\":\"%.16s...\"}\n",
                        nvec, done, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE, CONTRACT_ARTIFACT_SHA256);
        CFE_EVS_SendEvent(EID_REPORT, CFE_EVS_EventType_INFORMATION,
                          "AI_LEARNER: E25 equivalence %ld/%ld inferences written", done, nvec);
      }
    }
    /* E26 hygiene, always emitted: a memory measurement run must be able to PROVE that
     * the equivalence mode did not fire, not merely assume the file was absent. With it
     * enabled the first `mem` record of the run loop already reflects 64 inferences, so
     * init / first-call / steady would silently blur together (review SS6, "measurement
     * prerequisite"). Harness expect key: "e25_mode_active": false. */
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"e25_mode\",\"active\":%s,\"inputs_path\":\"%s\"}\n",
                    e25_active ? "true" : "false", AI_LEARNER_E25_INPUTS);
  }

  int32 sb = CFE_SB_CreatePipe(&g.pipe, AI_LEARNER_PIPE_DEPTH, "AI_LEARNER_PIPE");
  if (sb != CFE_SUCCESS) {
    CFE_EVS_SendEvent(EID_INIT_FAIL, CFE_EVS_EventType_ERROR, "AI_LEARNER: CFE_SB_CreatePipe failed 0x%08lX", (unsigned long)sb);
    AI_LEARNER_Cleanup(); return sb;
  }
  g.pipe_created = true;
  sb = CFE_SB_Subscribe(CFE_SB_ValueToMsgId(CFE_ES_HK_TLM_MID), g.pipe);
  if (sb != CFE_SUCCESS) {
    CFE_EVS_SendEvent(EID_INIT_FAIL, CFE_EVS_EventType_ERROR, "AI_LEARNER: CFE_SB_Subscribe failed 0x%08lX", (unsigned long)sb);
    AI_LEARNER_Cleanup(); return sb;
  }

  CFE_EVS_SendEvent(EID_INIT_OK, CFE_EVS_EventType_INFORMATION, "AI_LEARNER initialized: model %s (%ld B), rss_delta_init=%ld KB",
                    CONTRACT_MODEL_NAME, g.blob_len, g.rss_kb_init1 - g.rss_kb_init0);
  return CFE_SUCCESS;
}

/* Report the first per-call failure verbatim (ERROR event + JSON line); later ones are only counted. */
static void AI_LEARNER_NoteFail(const char* step, iree_status_t st) {
  if (!g.first_fail_reported) {
    g.first_fail_reported = true;
    char msg[400]; AI_LEARNER_StatusJson(st, msg, sizeof msg);
    CFE_EVS_SendEvent(EID_INFER_FAIL, CFE_EVS_EventType_ERROR, "AI_LEARNER inference failed at %s: %s (first occurrence; later ones counted)",
                      step, iree_status_code_string(iree_status_code(st)));
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"infer_failed\",\"step\":\"%s\",\"status\":\"%s\",\"attempted\":%u}\n", step, msg, (unsigned)g.n_attempt);
  }
  iree_status_free(st);
}

static void AI_LEARNER_Infer(const CFE_SB_Buffer_t* buf) {
  /* D52: these three buffers are sized by the CONTRACT and used to be automatic, i.e. on the
   * task stack, while the stack gate at :203 counts only AI_LEARNER_STACK_BASE_BYTES +
   * CONTRACT_KERNEL_STACK_BYTES. The gate therefore certified stack sufficiency for inputs it
   * could not fit: an OPS-SAT-sized contract (CONTRACT_INPUT_ELEMS=150528) needs 602,112 B for
   * feat[] alone against a 262,144 B base, and the app reported kernel_stack_accounted=true and
   * then died in the first inference. Made static -- the same thing zeros[] at :322 already is
   * -- so the gate's formula becomes true instead of the gate being taught a new number. This
   * app runs one inference task at a time (zeros[] already depends on that), and changing the
   * gate's arithmetic instead would DENY every model that runs today (measured: 4/4).
   * These bytes leave the task-stack bucket and land in BSS; neither is HAL memory, so
   * bounded_bytes is unaffected. The mem_init/last_mem records report the figure. */
  const uint8* raw = (const uint8*)buf; static float feat[CONTRACT_INPUT_ELEMS];
  CFE_MSG_Size_t sz = 0;
  g.n_attempt++;
  /* features: payload bytes after the 16-byte header, wrapped to fill the contract input */
  if (CFE_MSG_GetSize(&buf->Msg, &sz) != CFE_SUCCESS || sz <= AI_LEARNER_HDR_BYTES) { g.n_fail_input++; return; }
  size_t payload = (size_t)sz - AI_LEARNER_HDR_BYTES;
  for (int i = 0; i < CONTRACT_INPUT_ELEMS; ++i) feat[i] = (float)raw[AI_LEARNER_HDR_BYTES + ((size_t)i % payload)] / 256.0f;

  iree_status_t s = iree_hal_buffer_map_write(iree_hal_buffer_view_buffer(g.x), 0, feat, sizeof feat);
  if (!iree_status_is_ok(s)) { g.n_fail_input++; AI_LEARNER_NoteFail("input_write", s); return; }
  iree_runtime_call_t call;
  s = iree_runtime_call_initialize_by_name(g.session, iree_make_cstring_view(CONTRACT_ENTRY), &call);
  if (!iree_status_is_ok(s)) { g.n_fail_input++; AI_LEARNER_NoteFail("call_initialize", s); return; }
  s = iree_runtime_call_inputs_push_back_buffer_view(&call, g.x);
  if (!iree_status_is_ok(s)) { g.n_fail_input++; AI_LEARNER_NoteFail("inputs_push_back", s); iree_runtime_call_deinitialize(&call); return; }
  double t0 = now_us();
  iree_status_t st = iree_runtime_call_invoke(&call, 0);
  iree_hal_buffer_view_t* ret = NULL; static float out[CONTRACT_OUTPUT_ELEMS]; int ok = 0;  /* D52: was automatic */
  if (!iree_status_is_ok(st)) { g.n_fail_invoke++; AI_LEARNER_NoteFail("invoke", st); }
  else {
    s = iree_runtime_call_outputs_pop_front_buffer_view(&call, &ret);
    if (iree_status_is_ok(s)) s = iree_hal_buffer_map_read(iree_hal_buffer_view_buffer(ret), 0, out, sizeof out);
    if (!iree_status_is_ok(s)) { g.n_fail_output++; AI_LEARNER_NoteFail("output", s); } else ok = 1;
  }
  double dt = now_us() - t0;
  if (ret) iree_hal_buffer_view_release(ret);
  iree_runtime_call_deinitialize(&call);
  if (!ok) return;
  g.n_infer++; g.lat_sum_us += dt; g.lat_last_us = dt; if (dt > g.lat_max_us) g.lat_max_us = dt;
  memcpy(g.out, out, sizeof g.out);
  if (g.n_infer % AI_LEARNER_REPORT_EVERY == 0) {
    iree_hal_allocator_statistics_t stats; iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &stats);
    int within = (long)stats.device_bytes_peak <= (long)CONTRACT_BOUNDED_BYTES;
    /* E32 / D59: `within` says the UNCONDITIONAL contract held. It does not say this
     * deployment stayed inside the budget it was ADMITTED on, and in the conditional
     * tier those are different numbers (per_call vs bounded). Reporting only `within`
     * lets a conditional app run over its approved budget and still log "true" --
     * D53's rule ("compare the number you admitted on") applied to the post-hoc check.
     * Both are kept: one is about contract soundness, the other about this deployment. */
    long admitted_budget = g.conditional_map ? (long)CONTRACT_PER_CALL_BYTES
                                             : (long)AI_LEARNER_BUDGET_BYTES;
    int within_budget = (long)stats.device_bytes_peak <= admitted_budget;
    if (!within_budget) {
      CFE_EVS_SendEvent(EID_REPORT, CFE_EVS_EventType_ERROR,
                        "AI_LEARNER budget overrun: hal_peak=%ld > admitted=%ld (mode=%s)",
                        (long)stats.device_bytes_peak, admitted_budget,
                        g.conditional_map ? "conditional_map" : "unconditional");
    }
    static char outs[CONTRACT_OUTPUT_ELEMS * 16 + 8]; AI_LEARNER_FormatOut(outs, sizeof outs);  /* D52: was automatic, 16 B per output element */
    CFE_EVS_SendEvent(EID_REPORT, CFE_EVS_EventType_INFORMATION, "AI_LEARNER completed=%u/%u mean=%.1fus max=%.1fus hal_peak=%ld within_bounded=%d",
                      (unsigned)g.n_infer, (unsigned)g.n_attempt, g.lat_sum_us / g.n_infer, g.lat_max_us, (long)stats.device_bytes_peak, within);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"run\",\"model\":\"%s\",\"target\":\"%s\",\"attempted\":%u,\"completed\":%u,\"fail_input\":%u,\"fail_invoke\":%u,\"fail_output\":%u,"
                    "\"mean_us\":%.2f,\"max_us\":%.2f,\"last_us\":%.2f,\"out0\":%.5f,\"out\":[%s]}\n",
                    CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE,
                    (unsigned)g.n_attempt, (unsigned)g.n_infer, (unsigned)g.n_fail_input, (unsigned)g.n_fail_invoke, (unsigned)g.n_fail_output,
                    g.lat_sum_us / g.n_infer, g.lat_max_us, g.lat_last_us, g.out[0], outs);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"mem\",\"model\":\"%s\",\"target\":\"%s\",\"completed\":%u,\"hal_peak\":%ld,\"peak_within_bounded\":%s,"
                    "\"admitted_budget_bytes\":%ld,\"peak_within_admitted_budget\":%s,\"admission_mode\":\"%s\","
                    "\"hal_bytes_per_call_amortized\":%.1f,\"process_rss_kb\":%ld,\"process_rss_delta_init_kb\":%ld}\n",
                    CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE,
                    (unsigned)g.n_infer, (long)stats.device_bytes_peak, within ? "true" : "false",
                    admitted_budget, within_budget ? "true" : "false",
                    g.conditional_map ? "conditional_map" : "unconditional",
                    (double)stats.device_bytes_allocated / g.n_infer, rss_kb(), g.rss_kb_init1 - g.rss_kb_init0);
  }
}

void AI_LEARNER_AppMain(void) {
  uint32 run = CFE_ES_RunStatus_APP_RUN;
  bool init_ok = (AI_LEARNER_Init() == CFE_SUCCESS);
  if (!init_ok) run = CFE_ES_RunStatus_APP_ERROR;   /* Init already released everything it acquired */
  while (CFE_ES_RunLoop(&run) == true) {
    CFE_SB_Buffer_t* buf = NULL;
    int32 st = CFE_SB_ReceiveBuffer(&buf, g.pipe, 1000);
    if (st == CFE_SUCCESS) AI_LEARNER_Infer(buf);
    else if (st != CFE_SB_TIME_OUT) run = CFE_ES_RunStatus_APP_ERROR;
  }
  if (init_ok) AI_LEARNER_Cleanup();   /* exactly one cleanup per app lifetime on every path */
  CFE_ES_ExitApp(run);
}
