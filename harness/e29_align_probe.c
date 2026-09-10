/* E29 -- conditional contract: which deployment property decides the
 * stream.resource.try_map branch?
 *
 * E26 (docs/EVIDENCE_v0.25_E26.md) established that IREE wraps module-resident
 * constants in `stream.resource.try_map` + `scf.if(%did_map)`: the success arm
 * allocates nothing on the HAL device, the failure arm allocates the whole
 * constant block.  `bounded = per_call + constants` is the max over both arms,
 * so soundness is structural and only tightness follows the branch.  E26 ruled
 * out four candidate determinants by measurement and left the actual one
 * UNDETERMINED (SS "분기 결정 요인").  E26e/E26f then measured the same vmfb taking
 * different arms in different deployments (up to 172.30x apart).
 *
 * This probe answers that question by controlling exactly one variable: the
 * 64-byte alignment of the pointer the module image is loaded from.  It loads
 * the SAME file bytes at (page-aligned base + delta) for a list of deltas and
 * reports the HAL allocator peak right after `append_bytecode_module` -- the
 * point at which the constants are either mapped in place or copied, and
 * BEFORE any input buffer or inference exists, so the number isolates the
 * constant block alone.
 *
 * Reading the output: `init_peak == 0` is the map arm (nothing allocated on the
 * device for constants); `init_peak == <contract constants>` is the copy arm.
 * Any other value would refute the two-arm model -- e.g. a partial mapping --
 * which is why this probe reports the raw number instead of a classification.
 * The classification and the per-model comparison against the contract live in
 * harness/e29_collect.py.
 *
 * No fail-closed guards belong here: this is a measurement instrument, and a
 * guard that refused an unexpected value would hide exactly the observation the
 * experiment is looking for (same rule as the E27 baselines).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "iree/runtime/api.h"

typedef struct {
  long ptr_mod64;
  int  append_ok;
  long init_peak;
  long init_allocated;
  char err[512];
} probe_result_t;

static void probe_one(const char* path, size_t delta, const char* driver, probe_result_t* out) {
  memset(out, 0, sizeof *out);
  out->init_peak = -1; out->init_allocated = -1;

  FILE* f = fopen(path, "rb");
  if (!f) { snprintf(out->err, sizeof out->err, "cannot open %s", path); return; }
  fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET);
  void* base = NULL;
  /* page-aligned base, then + delta: the delta alone sets the alignment class */
  if (posix_memalign(&base, 4096, (size_t)n + 8192) != 0) {
    fclose(f); snprintf(out->err, sizeof out->err, "posix_memalign failed"); return;
  }
  char* blob = (char*)base + delta;
  if (fread(blob, 1, (size_t)n, f) != (size_t)n) {
    fclose(f); free(base); snprintf(out->err, sizeof out->err, "short read"); return;
  }
  fclose(f);
  out->ptr_mod64 = (long)(((uintptr_t)blob) % 64);

  iree_runtime_instance_options_t io; iree_runtime_instance_options_initialize(&io);
  iree_runtime_instance_options_use_all_available_drivers(&io);
  iree_runtime_instance_t* inst = NULL;
  iree_hal_device_t* dev = NULL;
  iree_runtime_session_t* sess = NULL;
  iree_status_t st = iree_runtime_instance_create(&io, iree_allocator_system(), &inst);
  if (iree_status_is_ok(st))
    st = iree_runtime_instance_try_create_default_device(inst, iree_make_cstring_view(driver), &dev);
  if (iree_status_is_ok(st)) {
    iree_runtime_session_options_t so; iree_runtime_session_options_initialize(&so);
    st = iree_runtime_session_create_with_device(inst, &so, dev,
        iree_runtime_instance_host_allocator(inst), &sess);
  }
  if (iree_status_is_ok(st)) {
    st = iree_runtime_session_append_bytecode_module_from_memory(
        sess, iree_make_const_byte_span(blob, (size_t)n), iree_allocator_null());
    if (iree_status_is_ok(st)) {
      iree_hal_allocator_statistics_t s;
      iree_hal_allocator_query_statistics(iree_runtime_session_device_allocator(sess), &s);
      out->append_ok = 1;
      out->init_peak = (long)s.device_bytes_peak;
      out->init_allocated = (long)s.device_bytes_allocated;
    }
  }
  if (!iree_status_is_ok(st)) {
    char* buf = NULL; iree_host_size_t len = 0;
    iree_allocator_t ha = iree_allocator_system();
    if (iree_status_is_ok(iree_status_to_string(st, &ha, &buf, &len)) && buf) {
      snprintf(out->err, sizeof out->err, "%.*s", (int)len, buf);
      iree_allocator_free(ha, buf);
    } else {
      snprintf(out->err, sizeof out->err, "status not ok (no string)");
    }
    iree_status_ignore(st);
  }
  if (sess) iree_runtime_session_release(sess);
  if (dev) iree_hal_device_release(dev);
  if (inst) iree_runtime_instance_release(inst);
  free(base);
}

static void json_escape(const char* s, char* dst, size_t cap) {
  size_t j = 0;
  for (size_t i = 0; s[i] && j + 2 < cap; ++i) {
    char c = s[i];
    if (c == '"' || c == '\\') { dst[j++] = '\\'; dst[j++] = c; }
    else if (c == '\n' || c == '\r' || c == '\t') { if (j + 2 < cap) { dst[j++] = ' '; } }
    else dst[j++] = c;
  }
  dst[j] = '\0';
}

int main(int argc, char** argv) {
  if (argc < 3) {
    fprintf(stderr, "usage: e29_align_probe VMFB DELTA [DELTA...]   (env PROBE_DRIVER, default local-sync)\n");
    return 2;
  }
  const char* driver = getenv("PROBE_DRIVER"); if (!driver) driver = "local-sync";
  for (int i = 2; i < argc; ++i) {
    size_t d = (size_t)strtoul(argv[i], NULL, 10);
    probe_result_t r;
    probe_one(argv[1], d, driver, &r);
    char esc[1024]; json_escape(r.err, esc, sizeof esc);
    printf("{\"vmfb\":\"%s\",\"driver\":\"%s\",\"delta\":%zu,\"blob_ptr_mod64\":%ld,"
           "\"append_ok\":%s,\"init_peak\":%ld,\"init_allocated\":%ld,\"error\":%s%s%s}\n",
           argv[1], driver, d, r.ptr_mod64, r.append_ok ? "true" : "false",
           r.init_peak, r.init_allocated,
           esc[0] ? "\"" : "", esc[0] ? esc : "null", esc[0] ? "\"" : "");
    fflush(stdout);
  }
  return 0;
}
