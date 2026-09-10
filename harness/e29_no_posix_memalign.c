/* E29 test shim: make posix_memalign() fail so the module image falls back to
 * plain malloc() -- i.e. the pre-E29 behaviour, which glibc hands out at 16 mod
 * 64 for allocations this size and which therefore lands on the copy arm of
 * `stream.resource.try_map`.
 *
 * Used two ways:
 *   1. to record the BEFORE half of E29's before/after pair with one binary
 *      (the same executable, only the allocator's alignment differs), and
 *   2. to reach the conditional tier's refusal path -- admitted on the map
 *      arm's bound, then handed the copy arm -- which cannot otherwise be
 *      produced from inside the app, since the app enforces alignment itself.
 *
 * Build: gcc -shared -fPIC -o e29_no_posix_memalign.so harness/e29_no_posix_memalign.c
 * Use:   LD_PRELOAD=./e29_no_posix_memalign.so ./native_learner_<model> ...
 */
#define _GNU_SOURCE
#include <errno.h>
#include <stddef.h>

int posix_memalign(void** memptr, size_t alignment, size_t size) {
  (void)memptr; (void)alignment; (void)size;
  return ENOMEM;   /* callers must fall back; free() stays the libc free() */
}
