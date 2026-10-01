# EVIDENCE v0.75.4 — D113 기록 확장: 운영체제 계층의 태스크 스택 추가분과 GSFC 개정판 I 단서의 문구

**경위**: 원고 v39를 다섯 관점(교차 일관성 · 형식 논리 · 수치 · 근거 범위 · 논증 비약)으로 다시 감사했다. 원고 쪽 수정은 문장의 정밀화이고
(원고 v40, 저장소 밖), **평가 수치·판정은 바뀌지 않는다.** 그 감사가 저장소 쪽에서 두 가지를 찾았다.

1. 원고 V.E의 *"the operating-system layer adds its minimum thread stack to the configured size, at most 135,152 B beyond $R_x$ with
   4 KiB pages"*에 대응하는 기록이 **저장소 어디에도 없었다**(`grep 135152` 0건). 수치는 맞다. 소스를 읽어 원고에 넣었지만
   그 판독이 기록으로 남지 않았던 것이다(D113이 막으려던 형태).
2. GSFC 개정판 I의 기록 문구가 원고와 어긋났다. 원고는 H를 *"not hard limits"*로, I를 *"the qualification that they are not uniform
   hard limits"*로 적으면서 I가 그 단서를 *"retains"*한다고 했다. 같은 단서를 두 가지로 적은 셈이다. 원고 v40은 I 쪽을
   *"and that qualification"*으로 바꿔 H의 단서를 그대로 가리키게 했고, 기록의 사용처 문구도 그에 맞춘다.

**새 실행 0.**

## 1. 기록 `os_task_stack_addition`

- **소스 판독**: OSAL `osal/src/os/posix/src/os-impl-tasks.c`(커밋 `8111e4a`, sha256 `76497fef…`)
  - 58–59행: `PTHREAD_STACK_MIN`이 정의돼 있으면 `OS_IMPL_STACK_EXTRA`가 그 값이다.
  - 501행: 설정 스택 크기에 그 값을 더한다.
  - 503–504행: 페이지 크기의 배수로 올림한다.
- **상수**:
  - AArch64 빌드는 이 파일을 `-D_XOPEN_SOURCE=600 -std=c99`로 컴파일한다(`_GNU_SOURCE` 없음, `compile_commands.json`).
  - 따라서 `PTHREAD_STACK_MIN`은 glibc의 동적 `sysconf` 형태가 아니라 교차 툴체인 헤더의 상수 **131,072**다
    (`/usr/aarch64-linux-gnu/include/bits/pthread_stack_min.h`, sha256 `6f9e3fe3…`). 의존성 파일에도 이 헤더가 포함돼 있다.
- **설정 스택**:
  - `budgets.json`의 $R_x$ 항(기본 할당 262,144 + 디스패치 요구량)에서 구한다.
  - 네 평가 빌드의 `build_info.json`이 기록한 시작 스크립트 스택(`startup_script_stack_bytes`)과 4/4 일치한다.

| 모델 | 설정 스택 | `pthread` 스택 | 추가분 |
|---|---:|---:|---:|
| ResNet | 263,376 | 397,312 | 133,936 |
| DeepAE | 262,160 | 397,312 | **135,152** |
| SmartCam | 264,063 | 397,312 | 133,249 |
| WGAN | 263,024 | 397,312 | 134,288 |

- 최댓값 135,152 B(DeepAE)가 원고 수치다.
- 원고가 함께 적는 두 누락분의 합(135,152 + 8,192 = 143,344 B)은 가장 빡빡한 셀의 여유(GiB 판독 161,792,139 B, 십진 판독 124,921,227 B)보다
  870배 이상 작다.

## 2. GSFC 개정판 I 기록의 사용처 문구

- `review_confirmations.gsfc_std_1000i.manuscript_uses[2]`를 다음으로 바꿨다: *"revision I retains the qualification cited from revision H that the
  values are not hard limits (manuscript v40: 'and that qualification'; the review's words: the table values are not uniform hard limits)"*.
- 검토자의 표현(*"일률적인 hard limit은 아니라는 설명이 유지되어 있다"*)은 원고가 H에서 인용한 단서가 I에 **유지된다**는 확인이다.
  원고 v40은 그 확인만 쓴다.
- 바이트·해시 없음(D113 원칙)과 `not_confirmed_here`는 그대로다.

## 3. 가드

- `d113/13`: 기록 = 재유도, 설정 스택 = 네 빌드의 시작 스크립트 스택(4/4), 추가분을 생성기와 따로 계산(4/4), 최댓값 `{b3_deepae, 135152}`.
- `d113/13b`: 기록한 소스 다섯 줄·헤더 상수·두 파일의 sha256이 지금도 그대로인지 확인한다. cFS 체크아웃과 AArch64 교차 툴체인이 있을 때만 돈다.
  CI에는 둘 다 없으므로 정직하게 SKIP된다.
- **되돌림 실측**:
  - 기록의 최댓값을 바꾸면 `d113/1`·`/13`이 FAIL한다.
  - 생성기에 기록한 소스 한 줄을 바꾸면 `d113/1`·`/13`·`/13b`가 FAIL한다(기록과 재유도가 달라지므로 `/13`도 걸린다).
  - 원복하면 `d113` 묶음 16건이 전부 PASS다.
- 회귀 시험: 이 컨테이너 **1027/1027 + 2 SKIP → 1029/1029 + 2 SKIP**.

## 4. 주장하지 않음

- 게스트에서 실제 스레드 스택 크기를 재지 않았다. 이 기록은 **소스와 빌드 설정의 판독**이다(원고도 *"by its source code"*로 적는다).
- 게스트의 페이지 크기를 직접 기록한 원자료는 없다. 커널은 Ubuntu `6.8.0-138-generic`(E64 `guest_environment.json`)으로 4 KiB 페이지 구성이지만,
  원고는 이 값을 *"with 4 KiB pages"*라는 **조건**으로 적는다.
- GSFC 개정판 I의 원문 표현은 이 환경에서 확인하지 못했다(호스트 000). 원고는 검토자가 확인한 범위, 곧 H의 단서가 유지된다는 것만 쓴다.
