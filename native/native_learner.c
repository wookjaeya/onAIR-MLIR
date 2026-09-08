/* E11 / A1 (native variant, standalone): the compiled Learner as a C program.
 *
 * What this measures that the Python plugin path cannot:
 *   - process memory decomposition WITHOUT Python/NumPy resident
 *   - IREE runtime residual in C (instance + device + session)
 *   - admission at startup: refuse to load if contract bounded_bytes > budget
 *   - per-call HAL allocator peak vs contract static_per_call_bytes
 *
 * Contract numbers come in as compile-time defines generated from
 * contract.json (see build.sh). The vmfb is embedded by objcopy or read
 * from disk (argv[1]).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "iree/runtime/api.h"
#include "contract_gen.h"   /* generated from contract.json */
#include "sha256.h"

static long rss_kb(void) {
  FILE* f = fopen("/proc/self/status", "r"); char line[256]; long v = -1;
  while (f && fgets(line, sizeof line, f)) if (!strncmp(line, "VmRSS:", 6)) { sscanf(line + 6, "%ld", &v); break; }
  if (f) fclose(f); return v;
}
static double now_us(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e6 + t.tv_nsec / 1e3; }
static int cmp_d(const void* a, const void* b) { double x = *(double*)a, y = *(double*)b; return (x > y) - (x < y); }

int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: %s model.vmfb budget_bytes iters\n", argv[0]); return 2; }
  const char* vmfb_path = argv[1]; long budget = atol(argv[2]); int iters = atoi(argv[3]);

  /* ---- admission (before touching the runtime) ---- */
  long bounded = CONTRACT_BOUNDED_BYTES;
  const char* verdict = bounded <= budget ? "ADMIT" : "NOT_ADMITTED";
  printf("{\"stage\":\"admission\",\"verdict\":\"%s\",\"bounded_bytes\":%ld,\"budget_bytes\":%ld,"
         "\"per_call\":%d,\"constants\":%d}\n", verdict, bounded, budget, CONTRACT_PER_CALL_BYTES, CONTRACT_CONST_BYTES);
  if (bounded > budget) { printf("{\"stage\":\"exit\",\"reason\":\"not admitted\"}\n"); return 3; }

  /* ---- artifact binding: hash the exact bytes that will be handed to IREE ---- */
  FILE* f = fopen(vmfb_path, "rb"); if (!f) { printf("{\"stage\":\"exit\",\"reason\":\"cannot open artifact\"}\n"); return 4; }
  fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET);
  void* blob = malloc(n); if (fread(blob, 1, n, f) != (size_t)n) { fclose(f); free(blob); return 4; } fclose(f);
  char hex[65]; sha256_hex(blob, n, hex);
  int bound_ok = (n == CONTRACT_ARTIFACT_BYTES) && (strcmp(hex, CONTRACT_ARTIFACT_SHA256) == 0);
  printf("{\"stage\":\"binding\",\"verdict\":\"%s\",\"artifact_bytes\":%ld,\"artifact_sha256\":\"%.16s...\",\"contract_sha256\":\"%.16s...\"}\n",
         bound_ok ? "MATCH" : "CONTRACT_ARTIFACT_MISMATCH", n, hex, CONTRACT_ARTIFACT_SHA256);
  if (!bound_ok) { printf("{\"stage\":\"exit\",\"reason\":\"contract does not describe this artifact; runtime not created\"}\n"); free(blob); return 5; }

  long rss0 = rss_kb();
  /* ---- runtime bring-up ---- */
  iree_runtime_instance_options_t io; iree_runtime_instance_options_initialize(&io);
  iree_runtime_instance_options_use_all_available_drivers(&io);
  iree_runtime_instance_t* instance = NULL;
  IREE_CHECK_OK(iree_runtime_instance_create(&io, iree_allocator_system(), &instance));
  iree_hal_device_t* device = NULL;
  IREE_CHECK_OK(iree_runtime_instance_try_create_default_device(instance, iree_make_cstring_view("local-sync"), &device));
  iree_runtime_session_options_t so; iree_runtime_session_options_initialize(&so);
  iree_runtime_session_t* session = NULL;
  IREE_CHECK_OK(iree_runtime_session_create_with_device(instance, &so, device, iree_runtime_instance_host_allocator(instance), &session));
  long rss1 = rss_kb();

  /* ---- module load: the SAME verified bytes ---- */
  IREE_CHECK_OK(iree_runtime_session_append_bytecode_module_from_memory(session, iree_make_const_byte_span(blob, n), iree_allocator_null()));
  long rss2 = rss_kb();

  /* ---- input buffer (1x9 f32), allocated once and reused ---- */
  iree_hal_buffer_view_t* x = NULL;
  static const iree_hal_dim_t xshape[2] = {1, 9};
  float xdata[9]; for (int i = 0; i < 9; ++i) xdata[i] = 0.1f * i;
  IREE_CHECK_OK(iree_hal_buffer_view_allocate_buffer_copy(device, iree_runtime_session_device_allocator(session),
      2, xshape, IREE_HAL_ELEMENT_TYPE_FLOAT_32, IREE_HAL_ENCODING_TYPE_DENSE_ROW_MAJOR,
      (iree_hal_buffer_params_t){.type = IREE_HAL_MEMORY_TYPE_DEVICE_LOCAL, .access = IREE_HAL_MEMORY_ACCESS_ALL, .usage = IREE_HAL_BUFFER_USAGE_DEFAULT},
      iree_make_const_byte_span(xdata, sizeof xdata), &x));

  iree_hal_allocator_t* alloc = iree_runtime_session_device_allocator(session);
  iree_hal_allocator_statistics_t st_warm = {0};

  /* ---- inference loop: 200 warmup calls, then `iters` measured calls ---- */
  double* lat = malloc(sizeof(double) * iters); float out[2] = {0, 0};
  int attempted = 0, completed = 0, fail_invoke = 0, fail_output = 0;
  for (int i = 0; i < iters + 200; ++i) {
    if (i == 200) iree_hal_allocator_query_statistics(alloc, &st_warm);  /* steady-state baseline */
    iree_runtime_call_t call;
    IREE_CHECK_OK(iree_runtime_call_initialize_by_name(session, iree_make_cstring_view("module.infer"), &call));
    IREE_CHECK_OK(iree_runtime_call_inputs_push_back_buffer_view(&call, x));
    double t0 = now_us(); attempted++;
    iree_status_t st_inv = iree_runtime_call_invoke(&call, 0);
    iree_hal_buffer_view_t* ret = NULL; int ok = 0;
    if (!iree_status_is_ok(st_inv)) { fail_invoke++; iree_status_ignore(st_inv); }
    else if (!iree_status_is_ok(iree_runtime_call_outputs_pop_front_buffer_view(&call, &ret)) ||
             !iree_status_is_ok(iree_hal_buffer_map_read(iree_hal_buffer_view_buffer(ret), 0, out, sizeof out))) { fail_output++; }
    else ok = 1;
    double t1 = now_us();
    if (ret) iree_hal_buffer_view_release(ret);
    iree_runtime_call_deinitialize(&call);
    if (ok) completed++;
    if (i >= 200) lat[i - 200] = ok ? (t1 - t0) : -1.0;
  }
  long rss3 = rss_kb();
  iree_hal_allocator_statistics_t st; iree_hal_allocator_query_statistics(alloc, &st);
  qsort(lat, iters, sizeof(double), cmp_d);
  long peak = (long)st.device_bytes_peak;
  /* reviewer v0.6 §4: the HAL peak includes constants in this runtime configuration,
     so it is compared with the BOUNDED figure. Steady-state per-call allocation is
     the counter difference across the measured window (reviewer §5). */
  int peak_within_bounded = peak <= CONTRACT_BOUNDED_BYTES;
  double steady_per_call = (double)(st.device_bytes_allocated - st_warm.device_bytes_allocated) / iters;
  int steady_within_per_call = steady_per_call <= (double)CONTRACT_PER_CALL_BYTES;

  printf("{\"stage\":\"run\",\"iters\":%d,\"attempted\":%d,\"completed\":%d,\"fail_invoke\":%d,\"fail_output\":%d,"
         "\"median_us\":%.2f,\"p99_us\":%.2f,\"max_us\":%.2f,\"out0\":%.6f,"
         "\"hal_device_bytes_peak\":%ld,\"peak_within_bounded\":%s,"
         "\"hal_bytes_per_call_amortized\":%.1f,\"hal_bytes_per_call_steady\":%.1f,\"steady_within_per_call\":%s,"
         "\"rss_kb\":{\"start\":%ld,\"after_runtime\":%ld,\"after_module\":%ld,\"after_run\":%ld},"
         "\"rss_delta_kb\":{\"runtime_bringup\":%ld,\"module_load\":%ld,\"inference\":%ld,\"total\":%ld},"
         "\"vmfb_bytes\":%ld}\n",
         iters, attempted, completed, fail_invoke, fail_output,
         lat[iters / 2], lat[(int)(iters * 0.99)], lat[iters - 1], out[0],
         peak, peak_within_bounded ? "true" : "false",
         (double)(st.device_bytes_allocated) / (iters + 200), steady_per_call, steady_within_per_call ? "true" : "false",
         rss0, rss1, rss2, rss3, rss1 - rss0, rss2 - rss1, rss3 - rss2, rss3 - rss0, n);

  fflush(stdout);
  iree_hal_buffer_view_release(x); free(lat);
  iree_runtime_session_release(session); iree_hal_device_release(device); iree_runtime_instance_release(instance);
  free(blob);  /* module data is referenced zero-copy until the session is released */
  return 0;
}
