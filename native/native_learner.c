/* E11 / E14 Stage 1 (native variant, standalone): the compiled Learner as a C program.
 *
 * What this measures that the Python plugin path cannot:
 *   - process memory decomposition WITHOUT Python/NumPy resident
 *   - IREE runtime residual in C (instance + device + session)
 *   - admission at startup: refuse to load if contract bounded_bytes > budget
 *     (or if the contract has no static bound at all: UNKNOWN_BOUND)
 *   - contract-artifact binding: sha256 of the exact bytes handed to IREE
 *   - per-call HAL allocator peak vs contract static_per_call_bytes
 *   - safe load failure: a corrupted artifact whose hash matches the contract
 *     (A5) must fail inside IREE without aborting, and every resource must be
 *     released (cleanup order: buffer -> session -> device -> instance -> blob, D4)
 *
 * Everything model-specific comes from contract_gen.h, generated from the
 * contract.json of the SAME iree-compile invocation that produced the deployed
 * vmfb (harness/gen_contract_header.py, EVIDENCE_v0.7 §1.3). Nothing here is
 * hard-coded to a particular model: shapes, element counts, entry name, driver,
 * kernel task-stack bytes and the artifact hash are all macros.
 *
 * Gate order (must not change): admission -> hash the exact bytes -> runtime
 * creation -> the SAME bytes handed to the session.
 *
 * Exit codes: 0 ok, 2 usage, 3 NOT_ADMITTED, 4 cannot open/read artifact,
 * 5 CONTRACT_ARTIFACT_MISMATCH, 6 UNKNOWN_BOUND, 7 runtime load failed (cleaned up),
 * 8 loaded but no inference completed (per-call failures; first status in the run line),
 * 9 bound known but the contract interface is not the single-f32-in/single-f32-out
 *   shape this runtime hardcodes (EVIDENCE_v0.10 Phase 3 / R3 defense-in-depth --
 *   gen_contract_header.py already refuses to emit such a header for a bound-known
 *   contract, so this should be unreachable for any header it produced; it only
 *   fires on a stale or hand-edited contract_gen.h).
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "iree/runtime/api.h"
#include "contract_gen.h"   /* generated from contract.json */
#include "sha256.h"

/* The header must carry the full Stage 1 macro set; an old header would
 * otherwise silently default the gate (e.g. an unknown bound must refuse). */
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

#define WARMUP_CALLS 200

/* All runtime objects live here so that one cleanup routine can release them
 * in the D4 order from every failure point. cleanup_calls is reported. */
static struct {
  iree_runtime_instance_t* instance;
  iree_hal_device_t* device;
  iree_runtime_session_t* session;
  iree_hal_buffer_view_t* x;
  void* blob; long blob_len;
  int module_ptr_mod64; long hal_peak_after_append; int conditional_map;
  int cleanup_calls;
} g;

static long rss_kb(void) {
  FILE* f = fopen("/proc/self/status", "r"); char line[256]; long v = -1;
  while (f && fgets(line, sizeof line, f)) if (!strncmp(line, "VmRSS:", 6)) { sscanf(line + 6, "%ld", &v); break; }
  if (f) fclose(f);
  return v;
}
static double now_us(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e6 + t.tv_nsec / 1e3; }
static int cmp_d(const void* a, const void* b) { double x = *(double*)a, y = *(double*)b; return (x > y) - (x < y); }

/* Release everything that exists, in the order buffer -> session -> device ->
 * instance -> blob. The blob is referenced zero-copy by the session and must be
 * freed only after the session is released (D4). Idempotent; counts calls. */
static void cleanup(void) {
  g.cleanup_calls++;
  if (g.x) { iree_hal_buffer_view_release(g.x); g.x = NULL; }
  if (g.session) { iree_runtime_session_release(g.session); g.session = NULL; }
  if (g.device) { iree_hal_device_release(g.device); g.device = NULL; }
  if (g.instance) { iree_runtime_instance_release(g.instance); g.instance = NULL; }
  if (g.blob) { free(g.blob); g.blob = NULL; }
  printf("{\"stage\":\"cleanup\",\"released\":true,\"cleanup_calls\":%d}\n", g.cleanup_calls);
}

/* Copy an IREE status message into a JSON-safe C string (escapes " \ and control chars). */
static void status_to_json(iree_status_t st, char* out, size_t cap) {
  iree_allocator_t a = iree_allocator_system(); char* buf = NULL; iree_host_size_t len = 0;
  const char* src = iree_status_code_string(iree_status_code(st)); size_t n = strlen(src);
  if (iree_status_to_string(st, &a, &buf, &len)) { src = buf; n = (size_t)len; }
  size_t o = 0;
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

/* ---- E29 (docs/EVIDENCE_v0.31_E29.md): module image alignment ----------------
 * IREE emits module-resident constants as `stream.resource.try_map` + an
 * `scf.if(%did_map)`: the map arm allocates nothing on the HAL device, the copy
 * arm allocates the whole constant block.  CONTRACT_BOUNDED_BYTES is the max
 * over both, so admission on it stays sound whichever arm runs; E26 measured up
 * to 172.30x between them for the SAME vmfb and left the determinant open.
 *
 * E29 identified it: iree_hal_heap_buffer_wrap() (runtime/src/iree/hal/
 * buffer_heap.c) refuses an imported span that is not aligned to
 * IREE_HAL_HEAP_BUFFER_ALIGNMENT (64), and the map arm is exactly that import.
 * harness/e29_collect.py measured 64/64 cells (8 models x 8 alignment classes):
 * map <=> 64-byte aligned, peak always 0 or exactly the constant block, never a
 * third value.  plain malloc() handed this runtime a 16 mod 64 pointer, which is
 * why every native/cFS cell in E26/E26e/E26f took the copy arm.
 *
 * A failed posix_memalign falls back to malloc -- correct, only less tight --
 * and the arm actually taken is measured after append, never assumed. */
static void* alloc_module_image(size_t n, int* out_mod64) {
  void* p = NULL;
  if (posix_memalign(&p, 64, n) != 0) p = NULL;
  if (!p) p = malloc(n);
  *out_mod64 = p ? (int)(((uintptr_t)p) % 64) : -1;
  return p;
}

/* A5 path: IREE refused the artifact AFTER admission and binding passed (the
 * contract hash matched a corrupted artifact, or device/session creation
 * failed). Report, release every resource, exit 7. No abort. */
static int runtime_load_failed(const char* step, iree_status_t st) {
  char msg[512]; status_to_json(st, msg, sizeof msg);
  iree_status_fprint(stderr, st);          /* full annotations, before the status is freed */
  iree_status_free(st);
  printf("{\"stage\":\"runtime_load_failed\",\"step\":\"%s\",\"status\":\"%s\",\"model\":\"%s\",\"target\":\"%s\"}\n",
         step, msg, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE);
  fflush(stdout);
  cleanup();
  printf("{\"stage\":\"exit\",\"reason\":\"runtime load failed; resources released\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
  return 7;
}

int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: %s model.vmfb budget_bytes iters [inputs.bin outputs.bin]\n"
                          "  env ONAIR_CONDITIONAL_MAP=1 admits on the map arm's bound (per-call only) when the\n"
                          "  budget does not cover bounded_bytes; the precondition is enforced and then verified\n"
                          "  after module append, refusing before any inference if the copy arm ran (E29).\n", argv[0]); return 2; }
  const char* vmfb_path = argv[1]; long budget = atol(argv[2]); int iters = atoi(argv[3]);
  { const char* cm = getenv("ONAIR_CONDITIONAL_MAP"); g.conditional_map = (cm && *cm == '1'); }
  if (iters < 1) iters = 1;

  /* ---- admission (before touching the runtime or even the artifact) ---- */
  long bounded = (long)CONTRACT_BOUNDED_BYTES;
  /* E29 conditional tier: opt-in, and only when the budget does not already
   * cover the unconditional bound. It is the same contract read under a
   * precondition this runtime enforces (aligned module image) and then verifies
   * after append -- not a weaker check. */
  if (g.conditional_map && !(bounded <= budget) && (long)CONTRACT_PER_CALL_BYTES <= budget) {
    /* stays conditional */
  } else {
    g.conditional_map = 0;
  }
  const char* verdict = !GATE_BOUND_KNOWN ? "UNKNOWN_BOUND"
                      : (bounded <= budget ? "ADMIT"
                      : (g.conditional_map ? "ADMIT_CONDITIONAL_MAP" : "NOT_ADMITTED"));
  printf("{\"stage\":\"admission\",\"verdict\":\"%s\",\"model\":\"%s\",\"target\":\"%s\","
         "\"bounded_bytes\":%ld,\"budget_bytes\":%ld,\"per_call\":%ld,\"constants\":%ld,"
         "\"kernel_stack_bytes\":%ld,\"bound_known\":%s}\n",
         verdict, CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE, bounded, budget,
         (long)CONTRACT_PER_CALL_BYTES, (long)CONTRACT_CONST_BYTES, (long)CONTRACT_KERNEL_STACK_BYTES,
         GATE_BOUND_KNOWN ? "true" : "false");
  if (!GATE_BOUND_KNOWN) {
    printf("{\"stage\":\"exit\",\"reason\":\"bound unknown: contract has no static bound; refused before artifact access\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
    return 6;
  }
  if (bounded > budget && !g.conditional_map) { printf("{\"stage\":\"exit\",\"reason\":\"not admitted\",\"cleanup_calls\":%d}\n", g.cleanup_calls); return 3; }
  /* EVIDENCE_v0.10 Phase 3 (R3 defense-in-depth): this runtime pushes exactly
   * one f32 input and pops exactly one f32 output (below). gen_contract_header.py
   * already refuses to emit a bound-known header whose interface is not that
   * shape, so this should never fire for a header it produced -- it only
   * catches a stale or hand-edited contract_gen.h. */
  /* F7 (external review, 2026-09): the message and comment above already
   * called this a "single-f32" check while the condition only ever checked
   * input/output COUNT -- there was no macro carrying dtype for C to test.
   * CONTRACT_DTYPES_ALL_F32 (gen_contract_header.py) closes that. */
  if (CONTRACT_NUM_INPUTS != 1 || CONTRACT_NUM_OUTPUTS != 1 || !CONTRACT_DTYPES_ALL_F32) {
    printf("{\"stage\":\"exit\",\"reason\":\"bound known but interface is not the single-f32-input/single-f32-output "
           "shape this runtime hardcodes\",\"num_inputs\":%d,\"num_outputs\":%d,\"dtypes_all_f32\":%d,\"cleanup_calls\":%d}\n",
           CONTRACT_NUM_INPUTS, CONTRACT_NUM_OUTPUTS, CONTRACT_DTYPES_ALL_F32, g.cleanup_calls);
    return 9;
  }

  /* ---- artifact binding: hash the exact bytes that will be handed to IREE ---- */
  FILE* f = fopen(vmfb_path, "rb"); if (!f) { printf("{\"stage\":\"exit\",\"reason\":\"cannot open artifact\",\"cleanup_calls\":%d}\n", g.cleanup_calls); return 4; }
  fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET);
  if (n <= 0) { fclose(f); printf("{\"stage\":\"exit\",\"reason\":\"cannot read artifact\",\"cleanup_calls\":%d}\n", g.cleanup_calls); return 4; }
  /* R8/EVIDENCE_v0.9 §11.9, EVIDENCE_v0.10 Phase 3: compare the file size
   * against the contract BEFORE allocating a buffer sized by an unverified
   * file. An artifact whose size already disagrees with the contract cannot
   * possibly hash-match it, so this is not a behavior change for any file
   * that DOES match (the hash check below still runs); it only removes the
   * unbounded malloc()+fread() that used to happen first for one that does not. */
  if (n != (long)CONTRACT_ARTIFACT_BYTES) {
    fclose(f);
    printf("{\"stage\":\"binding\",\"verdict\":\"CONTRACT_ARTIFACT_MISMATCH\",\"artifact_bytes\":%ld,"
           "\"contract_artifact_bytes\":%ld,\"reason\":\"size mismatch, refused before allocation\"}\n",
           n, (long)CONTRACT_ARTIFACT_BYTES);
    printf("{\"stage\":\"exit\",\"reason\":\"contract does not describe this artifact; runtime not created\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
    return 5;
  }
  g.blob = alloc_module_image((size_t)n, &g.module_ptr_mod64); g.blob_len = n;
  if (!g.blob || fread(g.blob, 1, (size_t)n, f) != (size_t)n) {
    fclose(f); cleanup();
    printf("{\"stage\":\"exit\",\"reason\":\"cannot read artifact\",\"cleanup_calls\":%d}\n", g.cleanup_calls); return 4;
  }
  fclose(f);
  char hex[65]; sha256_hex(g.blob, (size_t)n, hex);
  int bound_ok = (strcmp(hex, CONTRACT_ARTIFACT_SHA256) == 0);   /* size already verified above */
  printf("{\"stage\":\"binding\",\"verdict\":\"%s\",\"artifact_bytes\":%ld,\"artifact_sha256\":\"%.16s...\",\"contract_sha256\":\"%.16s...\"}\n",
         bound_ok ? "MATCH" : "CONTRACT_ARTIFACT_MISMATCH", n, hex, CONTRACT_ARTIFACT_SHA256);
  if (!bound_ok) {
    cleanup();  /* only the blob exists; runtime never created */
    printf("{\"stage\":\"exit\",\"reason\":\"contract does not describe this artifact; runtime not created\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
    return 5;
  }

  long rss0 = rss_kb();
  /* ---- runtime bring-up (every failure is reported and cleaned up; no abort) ---- */
  iree_status_t st;
  iree_runtime_instance_options_t io; iree_runtime_instance_options_initialize(&io);
  iree_runtime_instance_options_use_all_available_drivers(&io);
  st = iree_runtime_instance_create(&io, iree_allocator_system(), &g.instance);
  if (!iree_status_is_ok(st)) return runtime_load_failed("instance_create", st);
  st = iree_runtime_instance_try_create_default_device(g.instance, iree_make_cstring_view(CONTRACT_DRIVER), &g.device);
  if (!iree_status_is_ok(st)) return runtime_load_failed("device_create", st);
  iree_runtime_session_options_t so; iree_runtime_session_options_initialize(&so);
  st = iree_runtime_session_create_with_device(g.instance, &so, g.device, iree_runtime_instance_host_allocator(g.instance), &g.session);
  if (!iree_status_is_ok(st)) return runtime_load_failed("session_create", st);
  long rss1 = rss_kb();

  /* ---- module load: the SAME verified bytes (zero-copy; blob freed after session release) ---- */
  st = iree_runtime_session_append_bytecode_module_from_memory(g.session, iree_make_const_byte_span(g.blob, (size_t)n), iree_allocator_null());
  if (!iree_status_is_ok(st)) return runtime_load_failed("append_bytecode_module", st);
  /* E29: the try_map arm is decided during append and nowhere else -- before any
   * input buffer or inference exists, so this peak is the constant block alone. */
  {
    iree_hal_allocator_statistics_t s0;
    iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &s0);
    g.hal_peak_after_append = (long)s0.device_bytes_peak;
    const char* arm = (g.hal_peak_after_append == 0) ? "map"
                    : ((g.hal_peak_after_append == (long)CONTRACT_CONST_BYTES) ? "copy" : "other");
    printf("{\"stage\":\"map_branch\",\"model\":\"%s\",\"module_ptr_mod64\":%d,\"hal_peak_after_append\":%ld,"
           "\"contract_const_bytes\":%ld,\"contract_per_call_bytes\":%ld,\"arm\":\"%s\",\"admission_mode\":\"%s\"}\n",
           CONTRACT_MODEL_NAME, g.module_ptr_mod64, g.hal_peak_after_append,
           (long)CONTRACT_CONST_BYTES, (long)CONTRACT_PER_CALL_BYTES, arm,
           g.conditional_map ? "conditional_map" : "unconditional");
    if (g.conditional_map && g.hal_peak_after_append > (long)CONTRACT_PER_CALL_BYTES) {
      printf("{\"stage\":\"map_branch\",\"verdict\":\"MAP_PRECONDITION_FAILED\",\"hal_peak_after_append\":%ld,"
             "\"contract_per_call_bytes\":%ld}\n", g.hal_peak_after_append, (long)CONTRACT_PER_CALL_BYTES);
      cleanup();
      printf("{\"stage\":\"exit\",\"reason\":\"map precondition failed; refused before any inference\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
      return 10;
    }
  }
  long rss2 = rss_kb();

  /* ---- input buffer (contract shape, f32), allocated once and reused ---- */
  static const iree_hal_dim_t in_shape[CONTRACT_INPUT_RANK] = CONTRACT_INPUT_SHAPE;
  static float xdata[CONTRACT_INPUT_ELEMS];
  for (int i = 0; i < CONTRACT_INPUT_ELEMS; ++i) xdata[i] = 0.1f * (float)(i % 10);   /* canonical native input */
  st = iree_hal_buffer_view_allocate_buffer_copy(g.device, iree_runtime_session_device_allocator(g.session),
      CONTRACT_INPUT_RANK, in_shape, IREE_HAL_ELEMENT_TYPE_FLOAT_32, IREE_HAL_ENCODING_TYPE_DENSE_ROW_MAJOR,
      (iree_hal_buffer_params_t){.type = IREE_HAL_MEMORY_TYPE_DEVICE_LOCAL, .access = IREE_HAL_MEMORY_ACCESS_ALL, .usage = IREE_HAL_BUFFER_USAGE_DEFAULT},
      iree_make_const_byte_span(xdata, sizeof xdata), &g.x);
  if (!iree_status_is_ok(st)) return runtime_load_failed("input_buffer_allocate", st);

  /* E26: allocator state at the END of initialisation, BEFORE any inference and BEFORE
   * the E25 block below. Without it the only observable HAL numbers were the post-run
   * totals, so "module load + input buffer" could not be separated from "inference",
   * and with E25 mode on the split was destroyed entirely (64 inferences run first).
   * init / first-call / steady is the split E26 measures (review SS6, SS8.2). */
  iree_hal_allocator_statistics_t st_init;
  iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &st_init);
  int e25_mode_active = (argc >= 6);

  /* ---- E25 equivalence mode (optional): argv[4] = inputs.bin, argv[5] = outputs.bin ----
   * Reads N raw float32 vectors of CONTRACT_INPUT_ELEMS each, runs one inference per
   * vector, writes N raw float32 vectors of CONTRACT_OUTPUT_ELEMS. Deliberately placed
   * AFTER every gate above (stack, admission, interface, artifact size + sha256), so the
   * numbers this mode produces come from the same fully-gated deployment path the app
   * uses -- not from a bare inference harness. Absent argv[4..5] nothing changes.
   * (E25 / docs/plans/E25_same_model_equivalence.md) */
  if (argc >= 6) {
    const char* e25_in = argv[4]; const char* e25_out = argv[5];
    FILE* fi = fopen(e25_in, "rb");
    if (!fi) { fprintf(stderr, "E25: cannot open %s\n", e25_in); return 4; }
    fseek(fi, 0, SEEK_END); long ib = ftell(fi); fseek(fi, 0, SEEK_SET);
    long nvec = ib / (long)(CONTRACT_INPUT_ELEMS * sizeof(float));
    if (nvec <= 0 || ib % (long)(CONTRACT_INPUT_ELEMS * sizeof(float)) != 0) {
      fprintf(stderr, "E25: %s is %ld B, not a multiple of %zu B (%d f32)\n",
              e25_in, ib, CONTRACT_INPUT_ELEMS * sizeof(float), CONTRACT_INPUT_ELEMS);
      fclose(fi); return 2;
    }
    float* xin = (float*)malloc((size_t)ib);
    if (!xin || fread(xin, 1, (size_t)ib, fi) != (size_t)ib) { fprintf(stderr, "E25: read failed\n"); fclose(fi); return 4; }
    fclose(fi);
    FILE* fo = fopen(e25_out, "wb");
    if (!fo) { fprintf(stderr, "E25: cannot open %s for writing\n", e25_out); free(xin); return 4; }
    static float e25_y[CONTRACT_OUTPUT_ELEMS];
    long done = 0;
    for (long v = 0; v < nvec; ++v) {
      iree_hal_buffer_view_t* xv = NULL;
      st = iree_hal_buffer_view_allocate_buffer_copy(g.device, iree_runtime_session_device_allocator(g.session),
          CONTRACT_INPUT_RANK, in_shape, IREE_HAL_ELEMENT_TYPE_FLOAT_32, IREE_HAL_ENCODING_TYPE_DENSE_ROW_MAJOR,
          (iree_hal_buffer_params_t){.type = IREE_HAL_MEMORY_TYPE_DEVICE_LOCAL, .access = IREE_HAL_MEMORY_ACCESS_ALL, .usage = IREE_HAL_BUFFER_USAGE_DEFAULT},
          iree_make_const_byte_span(xin + v * CONTRACT_INPUT_ELEMS, CONTRACT_INPUT_ELEMS * sizeof(float)), &xv);
      if (!iree_status_is_ok(st)) { iree_status_free(st); break; }
      iree_runtime_call_t c2; iree_hal_buffer_view_t* r2 = NULL;
      st = iree_runtime_call_initialize_by_name(g.session, iree_make_cstring_view(CONTRACT_ENTRY), &c2);
      if (!iree_status_is_ok(st)) { iree_status_free(st); iree_hal_buffer_view_release(xv); break; }
      st = iree_runtime_call_inputs_push_back_buffer_view(&c2, xv);
      if (iree_status_is_ok(st)) st = iree_runtime_call_invoke(&c2, 0);
      if (iree_status_is_ok(st)) st = iree_runtime_call_outputs_pop_front_buffer_view(&c2, &r2);
      if (iree_status_is_ok(st)) {
        st = iree_hal_device_transfer_d2h(g.device, iree_hal_buffer_view_buffer(r2), 0, e25_y,
                                          sizeof e25_y, IREE_HAL_TRANSFER_BUFFER_FLAG_DEFAULT,
                                          iree_infinite_timeout());
      }
      if (iree_status_is_ok(st)) { fwrite(e25_y, sizeof e25_y, 1, fo); done++; }
      else iree_status_free(st);
      if (r2) iree_hal_buffer_view_release(r2);
      iree_runtime_call_deinitialize(&c2);
      iree_hal_buffer_view_release(xv);
    }
    fclose(fo); free(xin);
    printf("{\"stage\":\"e25_equivalence\",\"inputs\":%ld,\"completed\":%ld,"
           "\"artifact_sha256\":\"%.16s...\",\"input_elems\":%d,\"output_elems\":%d}\n",
           nvec, done, hex, CONTRACT_INPUT_ELEMS, CONTRACT_OUTPUT_ELEMS);
    fflush(stdout);
    if (done != nvec) { fprintf(stderr, "E25: only %ld/%ld inferences completed\n", done, nvec); return 8; }
  }

  iree_hal_allocator_t* alloc = iree_runtime_session_device_allocator(g.session);
  iree_hal_allocator_statistics_t st_warm = {0};
  iree_hal_allocator_statistics_t st_first = {0}; int st_first_valid = 0;   /* E26 */

  /* ---- inference loop: WARMUP_CALLS warmup calls, then `iters` measured calls ---- */
  double* lat = malloc(sizeof(double) * (size_t)iters);
  static float out[CONTRACT_OUTPUT_ELEMS];
  int attempted = 0, completed = 0, fail_input = 0, fail_invoke = 0, fail_output = 0;
  /* First per-call failure is kept verbatim (step + IREE status) as evidence; later ones are only counted. */
  const char* first_fail_step = ""; char first_fail_status[512] = "";
#define NOTE_FAIL(step, status_expr) do { iree_status_t s_ = (status_expr); \
    if (!first_fail_step[0]) { first_fail_step = (step); status_to_json(s_, first_fail_status, sizeof first_fail_status); } \
    iree_status_free(s_); } while (0)
  for (int i = 0; i < iters + WARMUP_CALLS; ++i) {
    if (i == WARMUP_CALLS) iree_hal_allocator_query_statistics(alloc, &st_warm);  /* steady-state baseline */
    if (i == 1) { iree_hal_allocator_query_statistics(alloc, &st_first); st_first_valid = 1; }  /* E26: after exactly one call */
    iree_runtime_call_t call; int ok = 0; iree_hal_buffer_view_t* ret = NULL; iree_status_t s;
    attempted++;
    s = iree_runtime_call_initialize_by_name(g.session, iree_make_cstring_view(CONTRACT_ENTRY), &call);
    if (!iree_status_is_ok(s)) { fail_input++; NOTE_FAIL("call_initialize", s); if (i >= WARMUP_CALLS) lat[i - WARMUP_CALLS] = -1.0; continue; }
    s = iree_runtime_call_inputs_push_back_buffer_view(&call, g.x);
    if (!iree_status_is_ok(s)) { fail_input++; NOTE_FAIL("inputs_push_back", s); iree_runtime_call_deinitialize(&call); if (i >= WARMUP_CALLS) lat[i - WARMUP_CALLS] = -1.0; continue; }
    double t0 = now_us();
    iree_status_t st_inv = iree_runtime_call_invoke(&call, 0);
    if (!iree_status_is_ok(st_inv)) { fail_invoke++; NOTE_FAIL("invoke", st_inv); }
    else {
      s = iree_runtime_call_outputs_pop_front_buffer_view(&call, &ret);
      if (iree_status_is_ok(s)) s = iree_hal_buffer_map_read(iree_hal_buffer_view_buffer(ret), 0, out, sizeof out);
      if (!iree_status_is_ok(s)) { fail_output++; NOTE_FAIL("output", s); } else ok = 1;
    }
    double t1 = now_us();
    if (ret) iree_hal_buffer_view_release(ret);
    iree_runtime_call_deinitialize(&call);
    if (ok) completed++;
    if (i >= WARMUP_CALLS) lat[i - WARMUP_CALLS] = ok ? (t1 - t0) : -1.0;
  }
  long rss3 = rss_kb();
  iree_hal_allocator_statistics_t stats; iree_hal_allocator_query_statistics(alloc, &stats);
  qsort(lat, (size_t)iters, sizeof(double), cmp_d);
  long peak = (long)stats.device_bytes_peak;
  /* reviewer v0.6 §4: the HAL peak includes constants in this runtime configuration,
     so it is compared with the BOUNDED figure. Steady-state per-call allocation is
     the counter difference across the measured window (reviewer §5). */
  int peak_within_bounded = peak <= (long)CONTRACT_BOUNDED_BYTES;
  double steady_per_call = (double)(stats.device_bytes_allocated - st_warm.device_bytes_allocated) / iters;
  int steady_within_per_call = steady_per_call <= (double)CONTRACT_PER_CALL_BYTES;

  printf("{\"stage\":\"run\",\"model\":\"%s\",\"target\":\"%s\",\"iters\":%d,\"warmup\":%d,"
         "\"attempted\":%d,\"completed\":%d,\"fail_input\":%d,\"fail_invoke\":%d,\"fail_output\":%d,"
         "\"median_us\":%.2f,\"p99_us\":%.2f,\"max_us\":%.2f,\"out0\":%.6f,\"out\":[",
         CONTRACT_MODEL_NAME, CONTRACT_TARGET_TRIPLE, iters, WARMUP_CALLS,
         attempted, completed, fail_input, fail_invoke, fail_output,
         lat[iters / 2], lat[(int)(iters * 0.99)], lat[iters - 1], out[0]);
  for (int k = 0; k < CONTRACT_OUTPUT_ELEMS; ++k) printf("%s%.6f", k ? "," : "", out[k]);
  printf("],\"hal_device_bytes_peak\":%ld,\"peak_within_bounded\":%s,"
         "\"hal_bytes_per_call_amortized\":%.1f,\"hal_bytes_per_call_steady\":%.1f,\"steady_within_per_call\":%s,"
         "\"rss_kb\":{\"start\":%ld,\"after_runtime\":%ld,\"after_module\":%ld,\"after_run\":%ld},"
         "\"rss_delta_kb\":{\"runtime_bringup\":%ld,\"module_load\":%ld,\"inference\":%ld,\"total\":%ld},"
         "\"vmfb_bytes\":%ld,\"kernel_stack_bytes\":%ld,"
         /* E26: the contract-region peak at three points, so soundness/tightness can be
            attributed to a phase instead of only to the whole run. e25_mode_active is
            recorded so a memory run can PROVE the equivalence mode was off. */
         "\"phase_hal\":{\"after_init\":{\"peak\":%ld,\"allocated\":%ld},"
         "\"after_first_call\":{\"peak\":%ld,\"allocated\":%ld,\"observed\":%s},"
         "\"steady_baseline\":{\"peak\":%ld,\"allocated\":%ld}},"
         "\"e25_mode_active\":%s,"
         "\"first_fail_step\":\"%s\",\"first_fail_status\":\"%s\"}\n",
         peak, peak_within_bounded ? "true" : "false",
         (double)(stats.device_bytes_allocated) / (iters + WARMUP_CALLS), steady_per_call, steady_within_per_call ? "true" : "false",
         rss0, rss1, rss2, rss3, rss1 - rss0, rss2 - rss1, rss3 - rss2, rss3 - rss0, n, (long)CONTRACT_KERNEL_STACK_BYTES,
         (long)st_init.device_bytes_peak, (long)st_init.device_bytes_allocated,
         (long)st_first.device_bytes_peak, (long)st_first.device_bytes_allocated,
         st_first_valid ? "true" : "false",
         (long)st_warm.device_bytes_peak, (long)st_warm.device_bytes_allocated,
         e25_mode_active ? "true" : "false",
         first_fail_step, first_fail_status);

  fflush(stdout);
  free(lat);
  cleanup();  /* buffer -> session -> device -> instance -> blob (D4) */
  if (completed == 0) {  /* loaded but never inferred (e.g. hash-matching corruption caught only at invoke): not "ok" */
    printf("{\"stage\":\"exit\",\"reason\":\"no inference completed\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
    return 8;
  }
  printf("{\"stage\":\"exit\",\"reason\":\"ok\",\"cleanup_calls\":%d}\n", g.cleanup_calls);
  return 0;
}
