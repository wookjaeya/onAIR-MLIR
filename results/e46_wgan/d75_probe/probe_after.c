#include <stdio.h>
#include <string.h>
#define CONTRACT_OUTPUT_ELEMS 150528
extern int sink(void*, unsigned long);
int replay_loop(long nvec, FILE* fo) {
  long done = 0;
  for (long v = 0; v < nvec; ++v) {
    static float yv[CONTRACT_OUTPUT_ELEMS];
    if (sink(yv, sizeof yv)) break;
    fwrite(yv, sizeof yv, 1, fo); done++;
  }
  return (int)done;
}
