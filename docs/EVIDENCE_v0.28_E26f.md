# EVIDENCE v0.28 — E26f: E26-ext 완결, 상수 지배형 실물 모델(Deep AutoEncoder)

- 실험 ID: **E26f**
- 날짜: 2026-09-09
- 층: **E26-ext**(`docs/plans/E26_boundary_utility.md` §0.1) — **E26의 판정(v0.25)을 바꾸지 않는다.**
- 플랫폼 등급: **결정론적**(HAL 할당자 통계, 계약 수치). 지연값은 인용하지 않는다.
- 산출물: `results/e26_boundary_utility/x86_64/ext_b3_deepae/`

## 0. 판정

**E26-ext의 마지막 채택 모델을 실행했고, E26-core의 결론이 여기서도 성립한다.** 계획서 §1.1이
B3를 넣은 이유는 **상수:per-call 비가 극단**이라는 것이었고(B2 ≈ 1:1, canonical ≈ 11:1),
실측 비는 **171.3 : 1**이다.

| 질문 | 결과 |
|---|---|
| Q1 `peak ≤ bounded` | **4셀 위반 0** |
| Q2 분기 가설 | **반증 0** |
| Q3 `B−1`→DENY, `B`·`B+1`→ADMIT | **PASS** |

- **CI 실측**(커밋 `f7be746`, 워크플로 run 73): `full` **266/266 + 1 SKIP**(PyYAML 미설치) · `without-iree` **159/159 + 15 SKIP** · `stdlib-only` **159/159 + 15 SKIP**. 이 컨테이너(267/267)와 `full`의 차이 1건은 PyYAML 유무이며, D34의 교훈에 따라 추정하지 않고 두 수치를 조건과 함께 병기한다.

## 1. 반입과 계약

MLPerf Tiny Deep AutoEncoder(ToyADMOS 계열 이상 탐지). `mlcommons/tiny` @ `4addd0fa`의
`ad01_fp32.tflite`(1,067,648 B)를 계획서 §1.4의 TensorFlow-없는 경로로 반입했다 —
`tflite2onnx` → ONNX `graph.name = "infer"` → `iree-import-onnx --opset-version 17` →
`iree-opt`로 torch→linalg 사전 lowering → **한 번의 `iree-compile`**. 변환은 이 세션에서
직접 수행했다(조사 보고서의 산출물을 그대로 쓰지 않았다). 남은 torch op **0개**,
entry는 `@infer(tensor<1x640xf32>) -> tensor<1x640xf32>`, op는 `Gemm`·`Relu`뿐이다.

| 항목 | 값 |
|---|---|
| `static_io_bytes` | 5,120 (입력 2,560 + 출력 2,560) |
| `static_transient_bytes` | 1,088 |
| `static_per_call_bytes` | **6,208** |
| `module_resident_constant_bytes` | **1,063,424** |
| `bounded_bytes` | **1,069,632** |
| `dispatches` | 10 |
| `kernel_task_stack_bytes` | 24 |
| 오버라이드 | **0개** |

이 수치는 계획서 §1.1이 조사에서 인용해 둔 값과 **정확히 같다** — 다른 세션의 독립 재현이다.

## 2. 핵심 관측 — 배포 의존성의 가장 큰 사례

| 배포 | HAL `device_bytes_peak` | 분기 | tightness (`bounded/peak`) |
|---|---|---|---|
| pip `iree.runtime` (local-sync) | **6,208** | `mapped` | **172.30×** |
| 소스 빌드 C 런타임 (`native_learner`) | **1,069,632** | `allocated` | **1.00×** |

같은 vmfb인데 관측 피크가 **172배** 다르다. 차이는 정확히 `module_resident_constant_bytes`
1,063,424 B이고, E26 §3이 규명한 `try_map` 두 분기 그대로다.

E26-core의 tightness 범위는 1.00×~45.50×였다. B3가 그 상한을 **172.30×로 넓힌다.** 방향은
같다 — 상수가 클수록, 그리고 상수를 map하는 데 성공하는 배포일수록 정적 계약은 보수적이다.
**이것이 계약의 결함이 아니라 계약이 무엇인지를 말해 준다**: 계약은 두 분기의 최댓값이고,
런타임 계측은 자기가 탄 분기만 안다. 172배는 "런타임 계측으로 얻은 상한을 다른 배포에 그대로
쓰면 얼마나 틀릴 수 있는가"의 이 저장소 최대 실측치다.

## 3. Q3 — 예산 경계

| 예산 | 결과 |
|---|---|
| `bounded − 1` = 1,069,631 | **DENY** (`rc=3`, `reason=not admitted`, `cleanup_calls=0`) |
| `bounded` = 1,069,632 | ADMIT, 250회 호출(warmup 200 + 50) 전부 완료, `cleanup_calls=1` |
| `bounded + 1` = 1,069,633 | ADMIT |
| 2 MiB | ADMIT |

`fail_input`·`fail_invoke`·`fail_output` 전부 0.

## 4. E26-ext 종합 (E26e + E26f)

| 모델 | 상수:per-call | tightness 범위 | Q1 | Q2 반증 | Q3 |
|---|---|---|---|---|---|
| B2 ResNet (CIFAR-10) | 1.00 : 1 | 1.00× ~ 2.00× | 위반 0 | 0 | PASS |
| B3 Deep AutoEncoder | 171.3 : 1 | 1.00× ~ 172.30× | 위반 0 | 0 | PASS |

**두 실물 모델은 할당 구조가 정반대인데 결론이 같다.** tightness는 상수 비중을 그대로 따라가고,
분기 가설은 어느 쪽에서도 반증되지 않았으며, 예산 경계 동작은 동일하다.

## 5. 주장하지 않음

- **정확도·AUC** — 평가 데이터셋(ToyADMOS)이 이 환경에서 접근 불가다. 여기서 쓴 것은 가중치와
  그래프 구조뿐이고, 답한 질문은 "메모리 계약이 성립하는가"다.
- **cFS 배포** — 이 모델의 cFS 셀은 돌리지 않았다. 두 배포(pip·native C)까지다.
- **E26 판정 변경** — ext는 판정을 산출하지 않는다(§0.1).
- **172.30×의 일반화** — 이 모델·이 두 배포에서의 관측이다. 분기를 무엇이 정하는지는 E26에서
  네 후보를 배제하고 **미확정으로 남긴 상태 그대로**다.
