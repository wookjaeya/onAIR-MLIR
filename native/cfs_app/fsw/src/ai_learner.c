/* E12: AI_LEARNER cFS app -- compiled IREE Learner inside cFS.
 *
 * Init: admission (contract bounded_bytes vs AI_LEARNER_BUDGET_BYTES) BEFORE the
 *       IREE runtime is created; refuse app init if not admitted.
 * Loop: subscribe to CFE_ES_HK_TLM_MID (periodic ES housekeeping telemetry) and
 *       run one inference per received packet, using packet bytes as features.
 *       Every 50 inferences emit an EVS event with latency/HAL stats and print
 *       one JSON line to stdout for the harness.
 */
#include "cfe.h"
#include "cfe_es_msgids.h"
#include "iree/runtime/api.h"
#include <string.h>
#include <stdlib.h>
#include <time.h>

#define AI_LEARNER_PIPE_DEPTH 8
#define AI_LEARNER_REPORT_EVERY 5
#define AI_LEARNER_MODEL_FILE "/cf/model.vmfb"

static struct {
  CFE_SB_PipeId_t pipe;
  iree_runtime_instance_t* instance; iree_hal_device_t* device; iree_runtime_session_t* session;
  void* blob; long blob_len; iree_hal_buffer_view_t* x;
  uint32 n_infer; double lat_sum_us; double lat_max_us; double lat_last_us; float out0;
  long rss_kb_init0, rss_kb_init1;
} g;

static long rss_kb(void) {
  FILE* f = fopen("/proc/self/status", "r"); char line[256]; long v = -1;
  while (f && fgets(line, sizeof line, f)) if (!strncmp(line, "VmRSS:", 6)) { sscanf(line + 6, "%ld", &v); break; }
  if (f) fclose(f); return v;
}
static double now_us(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e6 + t.tv_nsec / 1e3; }

static int32 AI_LEARNER_Init(void) {
  CFE_EVS_Register(NULL, 0, CFE_EVS_EventFilter_BINARY);
  /* ---- admission gate: contract vs app budget, before any runtime allocation ---- */
  if ((long)CONTRACT_BOUNDED_BYTES > (long)AI_LEARNER_BUDGET_BYTES) {
    CFE_EVS_SendEvent(1, CFE_EVS_EventType_CRITICAL,
      "AI_LEARNER NOT_ADMITTED: contract bounded=%ld > budget=%ld; app will not start",
      (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES);
    OS_printf("{\"app\":\"AI_LEARNER\",\"stage\":\"admission\",\"verdict\":\"NOT_ADMITTED\",\"bounded\":%ld,\"budget\":%ld}\n",
      (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES);
    return CFE_STATUS_EXTERNAL_RESOURCE_FAIL;
  }
  OS_printf("{\"app\":\"AI_LEARNER\",\"stage\":\"admission\",\"verdict\":\"ADMIT\",\"bounded\":%ld,\"budget\":%ld,\"per_call\":%ld,\"constants\":%ld}\n",
    (long)CONTRACT_BOUNDED_BYTES, (long)AI_LEARNER_BUDGET_BYTES, (long)CONTRACT_PER_CALL_BYTES, (long)CONTRACT_CONST_BYTES);

  g.rss_kb_init0 = rss_kb();
  iree_runtime_instance_options_t io; iree_runtime_instance_options_initialize(&io);
  iree_runtime_instance_options_use_all_available_drivers(&io);
  if (!iree_status_is_ok(iree_runtime_instance_create(&io, iree_allocator_system(), &g.instance))) return -1;
  if (!iree_status_is_ok(iree_runtime_instance_try_create_default_device(g.instance, iree_make_cstring_view("local-sync"), &g.device))) return -1;
  iree_runtime_session_options_t so; iree_runtime_session_options_initialize(&so);
  if (!iree_status_is_ok(iree_runtime_session_create_with_device(g.instance, &so, g.device, iree_runtime_instance_host_allocator(g.instance), &g.session))) return -1;

  char local_path[OS_MAX_LOCAL_PATH_LEN];
  if (OS_TranslatePath(AI_LEARNER_MODEL_FILE, local_path) != OS_SUCCESS) return -1;  /* /cf -> host path */
  FILE* f = fopen(local_path, "rb");
  if (!f) { CFE_EVS_SendEvent(2, CFE_EVS_EventType_ERROR, "AI_LEARNER: cannot open %s", AI_LEARNER_MODEL_FILE); return -1; }
  fseek(f, 0, SEEK_END); g.blob_len = ftell(f); fseek(f, 0, SEEK_SET);
  g.blob = malloc(g.blob_len); if (fread(g.blob, 1, g.blob_len, f) != (size_t)g.blob_len) { fclose(f); return -1; } fclose(f);
  if (!iree_status_is_ok(iree_runtime_session_append_bytecode_module_from_memory(g.session, iree_make_const_byte_span(g.blob, g.blob_len), iree_allocator_null()))) return -1;

  static const iree_hal_dim_t xshape[2] = {1, 9}; float zeros[9] = {0};
  if (!iree_status_is_ok(iree_hal_buffer_view_allocate_buffer_copy(g.device, iree_runtime_session_device_allocator(g.session), 2, xshape,
      IREE_HAL_ELEMENT_TYPE_FLOAT_32, IREE_HAL_ENCODING_TYPE_DENSE_ROW_MAJOR,
      (iree_hal_buffer_params_t){.type = IREE_HAL_MEMORY_TYPE_DEVICE_LOCAL, .access = IREE_HAL_MEMORY_ACCESS_ALL, .usage = IREE_HAL_BUFFER_USAGE_DEFAULT},
      iree_make_const_byte_span(zeros, sizeof zeros), &g.x))) return -1;
  g.rss_kb_init1 = rss_kb();

  if (CFE_SB_CreatePipe(&g.pipe, AI_LEARNER_PIPE_DEPTH, "AI_LEARNER_PIPE") != CFE_SUCCESS) return -1;
  if (CFE_SB_Subscribe(CFE_SB_ValueToMsgId(CFE_ES_HK_TLM_MID), g.pipe) != CFE_SUCCESS) return -1;
  CFE_EVS_SendEvent(3, CFE_EVS_EventType_INFORMATION, "AI_LEARNER initialized: model %ld B, rss_delta_init=%ld KB",
                    g.blob_len, g.rss_kb_init1 - g.rss_kb_init0);
  return CFE_SUCCESS;
}

static void AI_LEARNER_Infer(const CFE_SB_Buffer_t* buf) {
  /* features: first 9 bytes after the header, scaled to [0,1) */
  const uint8* raw = (const uint8*)buf; float feat[9];
  for (int i = 0; i < 9; ++i) feat[i] = (float)raw[16 + i] / 256.0f;
  iree_hal_buffer_map_write(iree_hal_buffer_view_buffer(g.x), 0, feat, sizeof feat);
  iree_runtime_call_t call;
  if (!iree_status_is_ok(iree_runtime_call_initialize_by_name(g.session, iree_make_cstring_view("module.infer"), &call))) return;
  iree_runtime_call_inputs_push_back_buffer_view(&call, g.x);
  double t0 = now_us();
  iree_status_t st = iree_runtime_call_invoke(&call, 0);
  iree_hal_buffer_view_t* ret = NULL; float out[2] = {0, 0};
  if (iree_status_is_ok(st) && iree_status_is_ok(iree_runtime_call_outputs_pop_front_buffer_view(&call, &ret))) {
    iree_hal_buffer_map_read(iree_hal_buffer_view_buffer(ret), 0, out, sizeof out); iree_hal_buffer_view_release(ret);
  }
  double dt = now_us() - t0;
  iree_runtime_call_deinitialize(&call);
  g.n_infer++; g.lat_sum_us += dt; g.lat_last_us = dt; if (dt > g.lat_max_us) g.lat_max_us = dt; g.out0 = out[0];
  if (g.n_infer % AI_LEARNER_REPORT_EVERY == 0) {
    iree_hal_allocator_statistics_t s; iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(g.session), &s);
    int within = (long)s.device_bytes_peak <= (long)CONTRACT_BOUNDED_BYTES;
    CFE_EVS_SendEvent(4, CFE_EVS_EventType_INFORMATION, "AI_LEARNER n=%u mean=%.1fus max=%.1fus hal_peak=%ld within_contract=%d",
                      (unsigned)g.n_infer, g.lat_sum_us / g.n_infer, g.lat_max_us, (long)s.device_bytes_peak, within);
    OS_printf("{\"app\":\"AI_LEARNER\",\"stage\":\"run\",\"n\":%u,\"mean_us\":%.2f,\"max_us\":%.2f,\"last_us\":%.2f,\"out0\":%.5f}\n",
              (unsigned)g.n_infer, g.lat_sum_us / g.n_infer, g.lat_max_us, g.lat_last_us, g.out0);
    OS_printf("{\"app\":\"AI_LEARNER\",\"stage\":\"mem\",\"n\":%u,\"hal_peak\":%ld,\"hal_bytes_per_call\":%.1f,\"peak_within_bounded\":%s,\"rss_kb\":%ld,\"rss_delta_init_kb\":%ld}\n",
              (unsigned)g.n_infer, (long)s.device_bytes_peak, (double)s.device_bytes_allocated / g.n_infer,
              within ? "true" : "false", rss_kb(), g.rss_kb_init1 - g.rss_kb_init0);
  }
}

void AI_LEARNER_AppMain(void) {
  uint32 run = CFE_ES_RunStatus_APP_RUN;
  if (AI_LEARNER_Init() != CFE_SUCCESS) run = CFE_ES_RunStatus_APP_ERROR;
  while (CFE_ES_RunLoop(&run) == true) {
    CFE_SB_Buffer_t* buf = NULL;
    int32 st = CFE_SB_ReceiveBuffer(&buf, g.pipe, 1000);
    if (st == CFE_SUCCESS) AI_LEARNER_Infer(buf);
    else if (st != CFE_SB_TIME_OUT) run = CFE_ES_RunStatus_APP_ERROR;
  }
  CFE_ES_ExitApp(run);
}
