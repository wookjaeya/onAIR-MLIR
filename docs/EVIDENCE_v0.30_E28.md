# EVIDENCE v0.30 — E28: admission 게이트 자신의 fail-open (D52)

- 실험 ID: **E28**
- 날짜: 2026-09-09
- 입력: 여섯 번째 외부 검토(`docs/reviews/ONAIR_MLIR_SCI_REVIEW_20260909.md`) §4.3·§10 검증 중 발견
- 플랫폼 등급: **결정론적**(계약 매크로 산술, cFS 실행의 생존/사망)
- 산출물: `results/e28_stack_failopen/`

## 0. 판정

**수정.** 이 저장소의 **핵심 논증 그 자체**에 있던 fail-open을 재현·수정했다.

> cFS 태스크 스택 게이트가 스택 충분성을 **certify한 뒤**, 첫 추론에서 프로세스가 **SIGSEGV로
> 죽는다.**

지금까지의 결함(D47·D48·D49)은 전부 유형 (B) 과잉 거부였다 — 정직한 모델이 배치되지 못하는
문제다. **D52는 방향이 반대다**: 배치되면 안 되는 구성을 게이트가 통과시킨다. 그리고 그 게이트는
주변 방어가 아니라 *"실행 전 메모리 admission"*이라는 이 연구의 주장 그 자체다.

- 이 컨테이너 실측: **284/284**(직전 276/276), 신규 8건.
- 보관 14개 계약 **diff 0**.
- 부수: 검토서 §4.3이 P0로 지목한 **B2·B3의 cFS x86-64 셀을 코드 수정 없이 완주**시켰다(§4).

## 1. 재현

`AI_LEARNER_Init`의 스택 게이트(`native/cfs_app/fsw/src/ai_learner.c:203`):

```c
long stack_needed = (long)AI_LEARNER_STACK_BASE_BYTES + (long)CONTRACT_KERNEL_STACK_BYTES;
int  stack_accounted = es_stack >= stack_needed;
```

그런데 추론 경로는 **계약이 크기를 정하는 버퍼 세 개를 같은 스택에** 잡고 있었다.

| 버퍼 | 크기 | 게이트 공식에 있는가 |
|---|---|---|
| `feat[CONTRACT_INPUT_ELEMS]` | 4 B × 입력 원소 | **없음** |
| `out[CONTRACT_OUTPUT_ELEMS]` | 4 B × 출력 원소 | **없음** |
| `outs[CONTRACT_OUTPUT_ELEMS * 16 + 8]` | **16 B × 출력 원소** + 8 | **없음** |

OPS-SAT급 계약(`CONTRACT_INPUT_ELEMS = 150528`, 즉 224×224×3)으로 실제 cFS를 기동했다.
부여 스택은 `base 262,144 + kernel 16 = 262,160`이고, 계상되지 않은 버퍼는 **602,160 B**다.

```
{"stage":"stack","es_stack_size":262160,"stack_base_bytes":262144,
 "contract_kernel_stack_bytes":16,"kernel_stack_accounted":true}
{"stage":"admission","verdict":"ADMIT","bounded":602184,"budget":602184, ...}
{"stage":"binding","verdict":"MATCH","artifact_sha256":"0af715cd290c5066", ...}
{"stage":"mem_init", ... "peak_within_bounded":true,"inferences_so_far":0, ...}
→ Segmentation fault (EXIT=139).  추론 보고 0건. 정상 종료 없음.
```

**admission도 binding도 통과했다.** 실패한 것은 계약이 아니라 게이트다 — 계약이 준 숫자를
게이트가 자기 소요 계산에 넣지 않았다.

## 2. 수정 — 게이트를 가르치지 않고, 게이트의 공식을 참으로 만든다

세 버퍼를 `static`으로 옮겼다. **같은 파일 `:322`의 `zeros[CONTRACT_INPUT_ELEMS]`가 이미
그렇게 돼 있다** — 새 패턴이 아니라 이미 있던 패턴을 나머지에 적용한 것이다.

**게이트 공식에 I/O 바이트를 더하는 쪽은 채택하지 않았다.** 검토서 §10 권고 2가 그 방향인데,
부여 스택 공식(`scripts/50_wire_cfs_ai_learner.sh`의 `base + kernel`)을 그대로 두면 부여량이
정확히 `base + kernel`이라 **무엇을 더하든 항상 초과**한다. 즉 오늘 도는 모델이 전부 DENY된다 —
유형 (B) 결함을 새로 심는 것이다. `static`으로 옮기면 게이트의 기존 공식이 **참이 되므로**
어떤 정직한 입력도 새로 거부되지 않는다.

**버킷 이동**: 태스크 스택 → BSS. 둘 다 HAL 계약(`bounded_bytes`) 밖이므로 **계약 수치는
불변**이다. 재진입 안전성은 `zeros[]`가 이미 의존하던 것과 같다(이 앱은 추론 태스크가 하나다).

## 3. revert-and-confirm-fail

같은 계약, 같은 스택(262,144 + 16), 같은 아티팩트(`0af715cd`). 차이는 세 배열의 저장 위치뿐이다.

| 상태 | 게이트 | admission | 추론 보고 | 종료 |
|---|---|---|---|---|
| **수정 전** | `accounted=true` | ADMIT | **0건** | **SIGSEGV, EXIT=139** |
| **수정 후** | `accounted=true` | ADMIT | **10/10** | 정상(`delete callback`) |

수정 후 `hal_peak=602184`, `within_bounded=1`이다.

**과잉 거부 확인**: 같은 수정 위에서 `b2_resnet`을 재빌드·기동해 ADMIT → MATCH → **5/5 완주**
(`hal_peak=618856 within_bounded=1`). 정직한 모델이 새로 거부되지 않는다.

## 4. 부수 소득 — 검토서 §4.3의 P0가 닫혔다

검토서는 *"실제 모델이 cFS와 AArch64 경로를 통과하지 않았다"*를 P0로 지목했다. 확인해 보니
**막고 있던 것이 없었다** — 그냥 실행하지 않았을 뿐이다. 코드 수정 0건으로 두 셀을 완주시켰다.

| 모델 | admission | binding | 완주 | HAL peak | 분기 |
|---|---|---|---|---|---|
| B2 ResNet | ADMIT (budget 618,856) | MATCH | 5/5 | **618,856** | `allocated` |
| B3 Deep AutoEncoder | ADMIT (budget 1,069,632) | MATCH | 5/5 | **1,069,632** | `allocated` |

두 모델 다 **peak = bounded 정확히 일치**하며, E26e·E26f의 native C 런타임과 같은 분기다.
이로써 두 실물 모델의 배포가 셋으로 늘었다(pip 런타임 / 소스 빌드 C 런타임 / cFS). 분기 가설
반증은 여전히 **0건**이고, 각 ext summary에 셀이 추가됐다.

**AArch64 cFS 셀은 여전히 미실행**이다 — 검토서 §4.3의 나머지 절반은 열려 있다.

## 5. 왜 이것이 주변이 아니라 핵심인가

이 저장소는 손상 아티팩트·공급망 축을 **부록으로 강등**했다
(`docs/ASSUMPTIONS_AND_SCOPE.md`, 2026-09-09). D52는 그 축이 아니다.

논문의 주장은 *"컴파일러가 산출한 정적 계약으로 실행 전에 배치 가능성을 판정한다"*이다.
게이트가 통과시킨 구성이 첫 추론에서 죽으면 그 문장이 직접 반증된다. 계약은 옳았고
(`bounded=602,184`, 관측 peak 602,112 ≤ bounded), **게이트가 계약이 준 숫자를 쓰지 않았다.**

교훈은 이 저장소가 반복해 온 것과 같은 계열이되 방향이 반대다 — 지금까지는 *"신호의 부재를
신호로 읽지 말라"*였고, 여기서는 ***"계약이 준 숫자를 게이트가 실제로 쓰는지 확인하라"***다.
헤더에 `CONTRACT_INPUT_ELEMS`가 있고 코드가 그것으로 배열을 잡는데, 게이트만 그것을 몰랐다.

## 6. 주장하지 않음

- **모든 스택 소요를 계상한다** — 계상한 것은 계약이 크기를 정하는 세 버퍼다. 컴파일러가
  잡는 지역 변수·저장된 레지스터는 여전히 `CONTRACT_KERNEL_STACK_BYTES`의 몫이고, 그 값의
  건전성은 E14/E26a의 ELF 분석이 담당한다.
- **OPS-SAT 모델을 배치했다** — 여기서 쓴 것은 그 **입력 형상**(224×224×3)을 가진 프로브
  아티팩트다. 실제 SmartCam MobileNetV2 반입은 별개이며 미착수다.
- **AArch64 cFS에서도 같다** — 미실행이다.
- **게이트가 이제 완전하다** — D52는 재현된 한 경로를 닫았다.


---

## 정오표 (v0.32.1 / D55)

이 문서가 인용한 raw log 2건(`results/e28_stack_failopen/opssat_probe_{before,after}_fix.log`)은 v0.32.1까지 **저장소에 없었다** — `.gitignore`의 `*.log`가 무시했고 summary.json만 커밋돼 있었다. 파일은 디스크에 남아 있었고 v0.32.1에서 커밋됐다. 수치·판정은 그대로다(`CHANGELOG.md` [v0.32.1], `EXPERIMENT_LOG.md` D55).
