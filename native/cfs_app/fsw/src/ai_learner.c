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
#define AI_LEARNER_HDR_BYTES 16   /* CCSDS primary + telemetry secondary header skipped before features */

enum {
  EID_NOT_ADMITTED = 1, EID_NO_FILE = 2, EID_INIT_OK = 3, EID_REPORT = 4, EID_MISMATCH = 5,
  EID_UNKNOWN_BOUND = 6, EID_LOAD_FAILED = 7, EID_STACK = 8, EID_INIT_FAIL = 9, EID_INFER_FAIL = 10,
  EID_STACK_REJECT = 11, EID_INTERFACE_MISMATCH = 12
};

static struct {
  CFE_SB_PipeId_t pipe; bool pipe_created;
  iree_runtime_instance_t* instance; iree_hal_device_t* device; iree_runtime_session_t* session;
  void* blob; long blob_len; iree_hal_buffer_view_t* x;
  uint32 n_attempt, n_infer, n_fail_input, n_fail_invoke, n_fail_output, n_cleanup;
  bool first_fail_reported;
  double lat_sum_us, lat_max_us, lat_last_us; float out[CONTRACT_OUTPUT_ELEMS];
  long rss_kb_init0, rss_kb_init1;
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
  AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"admission\",\"verdict\":\"%s\",\"model\":\"%s\",\"target\":\"%s\","
                  "\"bounded\":%ld,\"budget\":%ld,\"per_call\":%ld,\"constants\":%ld,\"kernel_stack_bytes\":%ld,\"bound_known\":%s}\n",
                  verdict, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE, (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES,
                  (long)CONTRACT_PER_CALL_BYTES, (long)CONTRACT_CONST_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES,
                  GATE_BOUND_KNOWN ? "true" : "false");
}

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
    CFE_EVS_SendEvent(EID_NOT_ADMITTED, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER NOT_ADMITTED: contract bounded=%ld > budget=%ld; app will not start",
      (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES);
    AI_LEARNER_AdmissionJson("NOT_ADMITTED");
    AI_LEARNER_Cleanup();
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  AI_LEARNER_AdmissionJson("ADMIT");
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
  g.blob = malloc((size_t)g.blob_len);
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

  /* ---- module load: the SAME verified bytes (zero-copy; blob freed after session release) ---- */
  st = iree_runtime_session_append_bytecode_module_from_memory(g.session, iree_make_const_byte_span(g.blob, (size_t)g.blob_len), iree_allocator_null());
  if (!iree_status_is_ok(st)) return AI_LEARNER_LoadFailed("append_bytecode_module", st);

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
  const uint8* raw = (const uint8*)buf; float feat[CONTRACT_INPUT_ELEMS];
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
  iree_hal_buffer_view_t* ret = NULL; float out[CONTRACT_OUTPUT_ELEMS]; int ok = 0;
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
    char outs[CONTRACT_OUTPUT_ELEMS * 16 + 8]; AI_LEARNER_FormatOut(outs, sizeof outs);
    CFE_EVS_SendEvent(EID_REPORT, CFE_EVS_EventType_INFORMATION, "AI_LEARNER completed=%u/%u mean=%.1fus max=%.1fus hal_peak=%ld within_bounded=%d",
                      (unsigned)g.n_infer, (unsigned)g.n_attempt, g.lat_sum_us / g.n_infer, g.lat_max_us, (long)stats.device_bytes_peak, within);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"run\",\"model\":\"%s\",\"target\":\"%s\",\"attempted\":%u,\"completed\":%u,\"fail_input\":%u,\"fail_invoke\":%u,\"fail_output\":%u,"
                    "\"mean_us\":%.2f,\"max_us\":%.2f,\"last_us\":%.2f,\"out0\":%.5f,\"out\":[%s]}\n",
                    CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE,
                    (unsigned)g.n_attempt, (unsigned)g.n_infer, (unsigned)g.n_fail_input, (unsigned)g.n_fail_invoke, (unsigned)g.n_fail_output,
                    g.lat_sum_us / g.n_infer, g.lat_max_us, g.lat_last_us, g.out[0], outs);
    AI_LEARNER_Json("{\"app\":\"AI_LEARNER\",\"stage\":\"mem\",\"model\":\"%s\",\"target\":\"%s\",\"completed\":%u,\"hal_peak\":%ld,\"peak_within_bounded\":%s,"
                    "\"hal_bytes_per_call_amortized\":%.1f,\"process_rss_kb\":%ld,\"process_rss_delta_init_kb\":%ld}\n",
                    CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE,
                    (unsigned)g.n_infer, (long)stats.device_bytes_peak, within ? "true" : "false",
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
