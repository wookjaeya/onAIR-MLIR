#include <stdio.h>
#include <stdint.h>
#define CONTRACT_OUTPUT_ELEMS 150528
static char* seen;
int sink(void* p, unsigned long n){ (void)n; seen=(char*)p; return 1; }
int replay_before(long nvec){ for(long v=0;v<nvec;++v){ float yv[CONTRACT_OUTPUT_ELEMS]; if(sink(yv,sizeof yv)) break; } return 0; }
int replay_after(long nvec){ for(long v=0;v<nvec;++v){ static float yv[CONTRACT_OUTPUT_ELEMS]; if(sink(yv,sizeof yv)) break; } return 0; }
int main(void){
  char here; char* top=&here;
  long GATE = 262144 + 511;
  replay_before(1);
  long disp_b = top - seen;                 /* 스택은 아래로 자란다: 양수면 스택 안 */
  int on_stack_b = (seen < top) && (disp_b < (1L<<30));
  replay_after(1);
  char* after_ptr = seen;
  int on_stack_a = (after_ptr < top) && ((top - after_ptr) < (1L<<30));
  printf("before: 버퍼가 스택 위에 있는가 = %s\n", on_stack_b ? "예" : "아니오");
  printf("        스택 변위 = %ld B  (게이트 허용 %ld B)  초과 = %s\n",
         disp_b, GATE, disp_b > GATE ? "예" : "아니오");
  printf("after : 버퍼가 스택 위에 있는가 = %s  (정적 저장기간 -> .bss)\n", on_stack_a ? "예" : "아니오");
  printf("        스택 변위는 정의되지 않는다 -- 이 버퍼는 스택에 없다\n");
  return 0;
}
