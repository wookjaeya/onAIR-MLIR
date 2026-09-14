# onAIR-MLIR 연구 현황 검토

> 검토 기준: `wookjaeya/onAIR-MLIR` 기본 브랜치 `claude/review-and-proceed-4y1sag`  
> 기준 커밋: [`35bc851`](https://github.com/wookjaeya/onAIR-MLIR/commit/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b)  
> 저장소 표기 버전: **v0.48**  
> 검토일: 2026-09-11  
> 방법: 최신 코드·EVIDENCE 문서·결과 JSON·커밋 이력의 정적 대조. 실험 자체는 재실행하지 않았다.

## 1. 종합 판단

연구는 초기의 합성 모델·x86 중심 도구 검증을 넘어, 다음 구조를 실제로 구현하고 검증한 단계에 도달했다.

> **IREE 컴파일 산출물의 할당 계획에서 앱별 부분 메모리 계약을 생성하고, NASA OnAIR/cFS가 AI 런타임의 자원을 획득하기 전에 계약과 앱 예산을 비교하여 실행 여부를 판정한다.**

현재까지 확보된 핵심 성과는 다음과 같다.

- OPS-SAT SmartCam, MLPerf Tiny ResNet, Deep AutoEncoder를 AArch64 QEMU의 cFS에서 실행했다.
- 세 모델에서 계약 기반 `ADMIT/NOT_ADMITTED`와 동일 회계 영역의 HAL peak를 확인했다.
- NASA 공식 OnAIR loader에서 코어 수정 없이 계약 적용 경로를 실행했다.
- 순수 OnAIR+LiteRT, OnAIR+IREE, 계약 적용 OnAIR를 구분한 기준선 실험이 추가됐다.
- CIFAR-10, 실제 log-mel, OPS-SAT 이미지 등 공개 실입력을 사용한 의미 비교가 추가됐다.
- OPS-SAT WGAN 영상 복원 모델을 네 번째 실물 모델로 반입했다.
- 계약의 분석 영역, 지원 조건, 예산 출처와 물리 메모리 예약 여부를 명시했다.

따라서 구현 가능성과 기본 시스템 연계는 충분히 입증됐다. 연구 완성의 핵심은 새로운 기능을 계속 추가하는 데 있지 않다. 다음 세 공백을 닫는 것이 우선이다.

1. **실입력 결과를 AArch64 cFS까지 종단 연결**
2. **DeepAE 실제 입력에서 발생한 수치 불일치의 해석과 주장 범위 확정**
3. **가까운 선행연구 원문 대조를 통한 신규성 검증**

---

## 2. 버전 및 정본 상태

README에는 아직 “현재 버전 v0.42”라고 적혀 있지만, `CHANGELOG.md`는 v0.48까지 진행돼 있다. 최신 커밋도 E44 결과를 반영하고 있다. 연구 현황을 판단할 때 README의 버전 문구보다 `CHANGELOG.md`, 최신 EVIDENCE 문서와 결과 JSON을 기준으로 해야 한다.

### 근거

- [README.md](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/README.md)
- [CHANGELOG.md](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/CHANGELOG.md)
- [최신 커밋](https://github.com/wookjaeya/onAIR-MLIR/commit/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b)

### 권고

README의 버전과 현재 상태 요약을 v0.48에 맞춰 갱신하는 것이 좋다. 이는 연구 결과를 바꾸는 작업이 아니라 독자가 잘못된 상태를 정본으로 인식하는 것을 막는 문서 정리다.

---

## 3. v0.43–v0.48에서 추가된 핵심 연구 증거

| 버전·실험 | 추가된 내용 | 연구적 의미 |
|---|---|---|
| v0.43 / E40 | `analysis_domain`, `accounting_rules` | 계약값이 유효한 분석 조건과 회계 경계를 계약 자체에 명시 |
| v0.44 / E41 | 동시 호출, 출력 수명, driver 조건 시험 | 상한 전제의 실제 영향과 게이트로 강제할 조건을 구분 |
| v0.45 / E45 | 실제 공개 입력 반입 | 합성 입력으로 드러나지 않던 변환·수치 문제 확인 |
| v0.46 / E46 | OPS-SAT WGAN denoiser | 작업 메모리 지배형·대형 출력 모델로 적용 범위 확장 |
| v0.47 / E42·E43 | 순수 OnAIR 기준선 O0–O3 | 제안 구조가 OnAIR 실행 경로에 추가하는 기능을 분리 |
| v0.48 / E44 | 예산 출처 및 예약 의미 | 앱 예산과 물리 RAM 예약을 구분 |

---

## 4. 메모리 계약 방법의 현재 상태

### 4.1 확보된 구조

현재 계약은 다음 두 영역을 합한 **앱별 부분 메모리 계약**이다.

\[
B_{bounded}=B_{per\_call}+B_{constants}
\]

- `per_call`: 추론 호출에 필요한 분석 대상 stream/HAL 할당
- `constants`: 모듈 상주 상수의 packed 크기

계약은 전체 프로세스 RSS, IREE VM/HAL context, cFS/OSAL 자체 메모리, 태스크 스택, wrapper I/O 전체를 포함하지 않는다. 따라서 현재 결과는 **전체 OBC 메모리 수용성 보장**이 아니다.

E40은 다음을 구분했다.

- `analysis_domain.derived`: 컴파일 산출물에서 계산한 사실
- `analysis_domain.required_premises`: 배포가 지켜야 할 조건
- `accounting_rules`: 각 계약 성분이 실제로 무엇을 합산하는지에 대한 규칙

현재 주요 전제는 다음과 같다.

- 고정 형상
- 지원되는 resource operation
- 최대 동시 추론 호출 1개
- 다음 호출 전 출력 해제
- 계약에 선언된 HAL driver 사용

### 4.2 E41이 확인한 전제의 실제 영향

동시 호출 프로브 결과는 `max_in_flight_calls: 1`이 장식적인 가정이 아님을 보여준다.

| 모델 | `bounded` | N=1 HAL peak | N=2 HAL peak | 해석 |
|---|---:|---:|---:|---|
| ResNet | 618,856 B | 309,416 B | 618,832 B | N=2까지는 bounded 이내 |
| SmartCam | 18,222,796 B | 9,382,092 B | 18,764,184 B | N=2에서 bounded 초과 |
| DeepAE | 1,069,632 B | 6,208 B | 12,416 B | 상수 지배형이라 bounded 여유가 큼 |

이 결과는 계약이 단일 in-flight 호출 조건에 묶인다는 점을 실제 데이터로 뒷받침한다. 다만 이 프로브는 x86-64 Python IREE 경로이며 AArch64 cFS의 동시 호출 실험은 아니다.

### 4.3 현재 판단

계약의 범위와 전제는 이전보다 훨씬 명확해졌다. 다만 학술적 “상한” 주장은 관측값만으로 완성되지 않는다. 지원 연산별 할당, 별칭, 재사용, 수명, map/copy 분기가 상한 식에 어떻게 반영되는지 코드와 수식의 대응 관계를 방법론으로 정리해야 한다.

### 근거

- [E40: 분석 영역과 회계 규칙](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.43_E40.md)
- [E41: 분석 영역의 다섯 조건](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.44_E41.md)
- [static_mem_bound.py](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/harness/static_mem_bound.py)

---

## 5. AArch64 cFS 증거

기존 세 모델은 AArch64 QEMU 게스트의 cFS에서 다음 항목까지 확보했다.

| 모델 | 계약값 | AArch64 의미 비교 | cFS 승인·거부 | HAL peak |
|---|---:|---|---|---:|
| SmartCam | 18,222,796 B | 확보 | 확보 | 9,382,092 B |
| ResNet | 618,856 B | 확보 | 확보 | 309,416 B |
| DeepAE | 1,069,632 B | 확보 | 확보 | 6,208 B |

ResNet과 DeepAE의 기존 AArch64 의미 비교 입력은 합성 32개와 경계 입력 2개였다. E45에서 새로 확보한 공개 실입력은 아직 이 AArch64 cFS 경로에서 재실행되지 않았다.

### 현재 AArch64 증거가 지지하는 주장

- AArch64 대상으로 컴파일된 VMFB와 계약을 생성할 수 있다.
- cFS 앱이 계약과 예산을 비교해 실행 전에 승인·거부한다.
- 승인된 실행에서 동일 회계 영역의 HAL peak를 관측할 수 있다.
- 기존 합성·경계 입력에서 기준 출력과 의미 동치가 성립했다.

### 아직 지지하지 않는 주장

- 모든 공개 실입력에서 AArch64 의미 동치가 성립한다.
- WGAN이 AArch64 cFS에서 계약대로 실행됐다.
- QEMU 결과가 실물 하드웨어의 지연·전력·열 특성을 대표한다.

### 근거

- [E36b AArch64 모델 결과](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e36b_aarch64_models/summary.json)
- [AArch64 cFS 결과 디렉터리](https://github.com/wookjaeya/onAIR-MLIR/tree/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e36b_aarch64_models)

---

## 6. 실제 공개 입력 실험 E45

E45는 합성 입력을 실제 공개 데이터로 교체해 원본 LiteRT와 IREE 실행 결과를 비교했다.

| 모델 | 실제 입력 | 표본·원소 | 결과 |
|---|---|---:|---|
| ResNet | CIFAR-10 | 200장·2,000원소 | PASS, 실패 원소 0, argmax 200/200 일치 |
| SmartCam | OPS-SAT 썸네일 | 19장·57원소 | PASS, 실패 원소 0, argmax 19/19 일치 |
| DeepAE | 실제 ad01 log-mel | 34창·21,760원소 | **FAIL, 94원소 실패** |

판정 기준은 E25에서 사전 정의한 다음 규칙을 그대로 사용했다.

\[
abs\_err \leq 10^{-4}\quad\text{OR}\quad rel\_err \leq 10^{-5}
\]

### 6.1 DeepAE FAIL의 의미

DeepAE는 합성 입력에서는 PASS였지만 실제 log-mel 입력에서 실패했다. 추가 특성화에서는 170개 입력 중 10개가 같은 기준을 만족하지 않았다. 재실행 결과 두 구현의 출력은 각각 결정적이었고 입력 해시와 비교기 회귀도 확인됐다.

따라서 현재 증거가 지지하는 해석은 다음과 같다.

> 특정 실제 값 영역에서 LiteRT와 IREE 출력 사이에 사전 정의 허용오차를 넘는 수치 차이가 관측됐다.

현재 증거만으로 어느 구현이 잘못됐는지, 변환기·연산 구현·부동소수점 축약 중 무엇이 원인인지 단정할 수 없다. 이 FAIL은 메모리 계약의 실패도 아니다.

### 6.2 연구에 미치는 영향

- “세 모델 모두 실제 입력에서 의미 동치”라는 주장은 사용할 수 없다.
- 메모리 계약값과 admission 결과는 입력에 따라 변하지 않으므로 별도의 메모리 주장으로 유지할 수 있다.
- 모델별 허용오차를 사후에 완화해 PASS로 바꾸는 것은 피해야 한다.
- 독립적 근거가 있는 모델별 수치 기준을 새로 설계할 수는 있지만, 기존 E45 결과와 구분해야 한다.

### 6.3 실입력의 연구적 가치

실제 입력은 합성 입력이 놓친 레이아웃 결함을 강하게 드러냈다. ResNet의 잘못된 reshape는 합성 입력에서 argmax 0/34만 탐지됐지만 실제 CIFAR-10에서는 180/200이 탐지됐다. SmartCam도 실제 입력에서 18/19가 탐지됐다. 이는 공개 데이터가 단순한 외형적 보강이 아니라 검증 민감도를 높였음을 보여준다.

### 근거

- [E45 EVIDENCE](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.45_E45.md)
- [E45 summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e45_real_inputs/summary.json)

---

## 7. 네 번째 실물 모델: OPS-SAT WGAN

E46은 OPS-SAT onboard image denoiser의 `wgan_fpn50_f.tflite`를 반입했다.

| 항목 | 결과 |
|---|---:|
| 입력·출력 | `[1,224,224,3]` f32 |
| 전체 계약 `bounded` | 135,666,432 B |
| `per_call` | 131,382,784 B |
| `constants` | 4,283,648 B |
| HAL peak | 131,382,784 B |
| 의미 비교 | 실제 이미지 9장 + 경계 2개, 1,655,808원소 실패 0 |

### 연구적 가치

기존 DeepAE는 상수 지배형이고 WGAN은 호출당 작업 메모리 지배형이다. 동일한 계약 형식이 `per_call/constants` 비율 0.006부터 30.7까지 표현한다. 모델 구조에 따라 조건부 map 계층의 예산 절감 효과가 약 172.3배에서 약 1.03배까지 달라진다는 한계도 드러났다.

이 결과는 “항상 tight하다”는 주장을 지지하지 않는다. 계약의 보수성과 조건부 계층의 효과가 모델의 상수 비중과 배포 경로에 따라 달라짐을 보여준다.

### 추가로 발견된 구현 문제

대형 출력이 cFS 앱의 자동 배열 `yv`에 배치되면서 스택 게이트가 계상하지 않는 602,112 B 프레임이 생기는 문제가 발견됐다. 현재 코드는 이를 `static` 저장영역으로 옮겼다.

이 수정은 전체 RAM 사용량을 줄인 것이 아니다. 스택에서 정적 저장영역으로 위치를 바꾸고 단일 호출 전제와 맞춘 것이다.

### 남은 한계

- WGAN 의미 비교와 HAL 관측은 x86-64이다.
- WGAN을 AArch64 cFS 또는 OnAIR에서 실행하지 않았다.
- cFS 게스트에서 수정 전 스택 문제에 의한 실제 SIGSEGV를 관측한 것은 아니다.

### 근거

- [E46 EVIDENCE](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.46_E46.md)
- [WGAN 비교 결과](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e46_wgan/cell/comparison.json)
- [cFS AI Learner](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/native/cfs_app/fsw/src/ai_learner.c)

---

## 8. 순수 OnAIR 기준선 E42/E43

현재 저장소에는 다음 네 경로의 비교가 존재한다.

| ID | 경로 | admission | 런타임 생성 | 추론 |
|---|---|---|---:|---:|
| O0 | OnAIR + LiteRT | 단계 없음 | 예 | 5회 |
| O1 | OnAIR + IREE, 예산 없음 | `NOT_EVALUATED` | 예 | 5회 |
| O2 | OnAIR + IREE + 계약, 예산 B | `ADMIT` | 예 | 5회 |
| O3 | OnAIR + IREE + 계약, 예산 B−1 | `NOT_ADMITTED` | 아니오 | 0회 |

O0·O1은 E43에서 새로 측정했고 O2·O3은 이전 E33/E41 결과를 인용했다. 이를 신규 네 셀로 계산하지 않은 처리도 적절하다.

### 이 비교가 지지하는 주장

- 순수 OnAIR 실행에는 이 연구가 정의한 계약 admission 단계가 없다.
- 계약 적용 경로는 충분한 예산에서 기존 실행 결과를 유지한다.
- 부족한 예산에서는 추론을 시작하지 않는다.
- 공식 OnAIR loader를 사용하며 OnAIR core를 수정하지 않는다.

### 표현상 주의

“OnAIR가 계약을 위반했다”거나 “OnAIR가 메모리를 관리하지 못한다”고 표현하면 안 된다. 순수 OnAIR 경로에는 애초에 이 연구의 계약이 없다. 제안 구조가 추가하는 것은 **compiler-derived 계약을 이용한 실행 전 판정 단계**다.

코드상 `_decide_admission()`은 `_load_artifact()`보다 먼저 호출된다. 다만 입력용 NumPy 배열은 그 이전에 생성되므로 “어떤 메모리도 할당하기 전에 거부한다”는 표현은 틀리다. 정확한 표현은 **IREE runtime 및 모델 artifact 자원을 획득하기 전 판정**이다.

### 근거

- [E42/E43 EVIDENCE](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.47_E42_E43.md)
- [E43 summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e43_pure_onair/summary.json)
- [compiled_learner_plugin.py](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/plugins/compiled_learner/compiled_learner_plugin.py)

---

## 9. 예산의 의미 E44

현재 admission 예산은 물리 RAM을 예약하는 메커니즘이 아니라 계약값과 비교하는 **선언된 앱 예산**이다.

| 경로 | 예산 출처 |
|---|---|
| OnAIR | deployment JSON의 `budget_bytes` |
| native executor | 명령행 인자 |
| cFS 앱 | compile-time macro 또는 실험용 override |

저장소는 메모리 예약 관련 호출을 소스 85개에서 검색해 0건으로 기록했다. 따라서 E44의 A5 분류는 `declared`이며 `enforced reservation`이 아니다.

이는 결함이라기보다 현재 연구 질문의 경계다. 논문에서는 “예산을 예약한다”가 아니라 “정책으로 주어진 앱 예산과 계약을 비교한다”고 써야 한다.

### 근거

- [E44 EVIDENCE](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.48_E44.md)
- [E44 summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e44_budget_provenance/summary.json)

---

## 10. 신규성 검증 상태

E39는 다음 선행연구 축을 비교했다.

- OnAIR
- TinyIREE
- MLIR
- TensorFlow Lite Micro
- TVM USMP
- ExecuTorch memory planning
- TASO
- Quilt
- Futureproof Static Memory Planning
- VISORS 비행 소프트웨어 메모리 예산 사례
- cFS 자료

비교축도 분석 입력, 회계 경계, 정적 상한, 실행 전 판정, 예약, 비행 소프트웨어 연계, 타깃 환경, 실행 관측 대조로 잘 구성돼 있다.

그러나 현재 비교표 스스로 다음 한계를 명시한다.

- 전체 원문 확인: 0건
- 부분 원문 확인: 1건
- 대부분 검색 결과 요약 기반
- 회계 경계의 `불명` 항목 10개

따라서 현재 E39가 지지하는 것은 다음 문장까지다.

> 실행한 검색 범위에서 컴파일러 IR 분석, 실행 전 판정, cFS/OnAIR 연계, 동일 회계 영역 실행 관측을 모두 결합한 선행연구는 확인되지 않았다.

“최초”, “선행연구가 이 문제를 해결하지 못했다”, “MLIR이 유일하다”는 문장은 아직 지지하지 않는다.

### MLIR 기여에 대한 현재 판단

E35/E27 결과에서는 정상 조건에서 MLIR 기반 경로와 artifact-only 분석이 같은 계약값과 판정을 냈다. 따라서 수치적 우월성을 주장할 수 없다.

현재 방어 가능한 기여는 다음이다.

> **컴파일러의 post-layout 할당 계획에서 부분 메모리 계약을 추출하고, 독립적인 계약 산출물로 외부화하여 OnAIR/cFS의 실행 전 admission에 연결하는 방법.**

TECS와 같은 임베디드 시스템 학술지를 목표로 한다면, OnAIR/cFS를 중심 기여로 두기보다 이 계약 추출·소비 방법을 일반화하고 OnAIR/cFS를 적용 사례로 두어야 한다.

### 근거

- [E39 선행연구 비교표](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/results/e39_prior_art/prior_art.md)
- [E39 사전 검색 계획](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/plans/E39_novelty_audit.md)
- [E27 MLIR baseline](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.29_E27.md)
- [E35 fair baseline](https://github.com/wookjaeya/onAIR-MLIR/blob/35bc851a5fe16cd97c21c431ef543e28dbb8fe3b/docs/EVIDENCE_v0.38_E35.md)

---

## 11. 코드 및 실험 품질 평가

### 강점

- 실험 기준을 구현·측정 전에 커밋하는 절차가 반복적으로 사용된다.
- 실패를 숨기지 않고 DeepAE FAIL과 기존 주장 정정을 보존한다.
- raw log, 결과 JSON, 생성기, EVIDENCE 문서를 연결한다.
- 기존 결과를 인용한 셀과 새로 측정한 셀을 구분한다.
- `null`, `0`, `SKIP`, “측정하지 않음”을 구분하려는 규칙이 강하다.
- 모델별 하네스 분기를 늘리기보다 계약과 설정값으로 일반화한다.
- 새로운 실제 모델이 기존 코드의 잠재 결함을 발견하는 역할을 했다.

### 주의할 점

- 회귀시험 수가 많다는 사실 자체는 연구 기여가 아니다.
- E40은 정규 MLIR pass가 아니라 post-processing 구현이다.
- WGAN과 실입력 결과 상당수는 아직 x86-64에 머물러 있다.
- OnAIR O2의 자원 해제는 검증되지 않았고, 기록된 nanobind 메시지를 근거로 누수라고 단정할 수도 없다.
- O3의 “런타임 미생성”은 별도 런타임 생성 플래그보다 코드 순서와 추론 0건에 의존한다.
- README와 실제 버전 상태가 어긋나 있다.

---

## 12. 남은 작업 우선순위

### P0 — 논문 핵심 주장에 직접 필요한 작업

#### 1. 공개 실입력의 AArch64 cFS 종단 실행

- ResNet CIFAR-10 200장
- SmartCam OPS-SAT 이미지
- DeepAE 실제 log-mel 입력
- 가능하면 WGAN 실제 영상

각 모델에 대해 다음을 하나의 연결표로 남긴다.

`원본 모델·입력 → AArch64 VMFB·계약 → cFS admission → 출력 → HAL peak`

DeepAE는 AArch64에서도 기존 기준을 만족하는지 여부와 관계없이 결과를 그대로 기록해야 한다.

#### 2. DeepAE 실제 입력 수치 발산 분석

우선 확인할 축은 다음과 같다.

- TFLite→ONNX 변환 전후 출력
- ONNX Runtime을 포함한 중간 기준점
- 문제 입력에서 오차가 최초로 커지는 연산 또는 layer
- IREE compiler option과 부동소수점 축약 영향
- x86-64와 AArch64에서의 발산 재현 여부

연구 질문은 어느 런타임이 더 정확한지를 평가하는 것이 아니다. 목적은 모델 변환의 의미 검증 결과를 정직하게 확정하는 것이다.

#### 3. 상한 논증 문서화

- 지원 resource op별 계산 규칙
- buffer alias·reuse·lifetime 처리
- 외부 입력·출력 slab의 정의
- packed constant와 정렬 패딩
- map/copy 분기
- 지원 불가 조건과 `UNKNOWN_BOUND`
- 코드 변수와 논문 수식의 대응표

#### 4. 선행연구 원문 대조

우선순위는 연구와 가장 가까운 다음 자료다.

1. Quilt
2. TVM USMP
3. ExecuTorch memory planning
4. TensorFlow Lite Micro arena planning
5. TinyIREE
6. TASO
7. VISORS memory-budget 사례
8. OnAIR 원 논문

각 원문에서 분석 입력, 회계 범위, 상한 성격, 사용 목적, admission 여부, 비행 소프트웨어 연결 여부를 직접 확인해야 한다.

### P1 — 논문 설득력을 높이는 작업

- WGAN AArch64 cFS 실행
- AArch64 OnAIR 계약 경로 실행
- 모델 교체 후 새 계약으로 다시 판정하는 시나리오
- O3에 `runtime_created` 같은 직접 관측 필드 추가
- 공개 결과 재생성 명령을 하나의 manifest로 통합
- README의 최신 버전과 연구 상태 갱신

### 현재 추가 필요성이 낮은 작업

- 새로운 모델을 무작정 추가
- x86-64 회귀 케이스 확대
- 정확도·AUC·PSNR 연구로 범위 확장
- 전력·열·WCET 실험
- 공급망 보안·전자서명·PKI
- 방사선 오류와 비행 인증
- 전체 OBC RAM 보장

---

## 13. 논문에 사용할 수 있는 주장과 아직 사용할 수 없는 주장

### 현재 사용할 수 있는 주장

1. 지원 조건에서 IREE post-layout 산출물로부터 앱별 부분 메모리 계약을 생성했다.
2. AArch64 cFS에서 세 공개 모델의 계약 기반 승인·거부를 확인했다.
3. 승인된 실행의 동일 회계 영역 HAL peak를 계약과 대조했다.
4. NASA 공식 OnAIR loader에 코어 수정 없이 계약 판정을 연결했다.
5. 순수 OnAIR 경로와 비교해 제안 경로에 실행 전 admission 단계가 추가됨을 보였다.
6. 모델의 상수·호출 메모리 비중에 따라 조건부 계약의 효용이 크게 달라짐을 관측했다.
7. 실제 입력이 합성 입력에서 보이지 않던 의미 차이와 레이아웃 결함을 드러냈다.

### 아직 사용할 수 없는 주장

1. 모든 공개 모델과 실제 입력에서 의미 동치가 성립한다.
2. WGAN이 AArch64 cFS에서 계약대로 실행됐다.
3. 계약값이 전체 프로세스 또는 OBC RAM의 상한이다.
4. 앱 예산이 실제 물리 메모리로 예약된다.
5. MLIR 경로가 artifact-only 방식보다 더 정확하거나 더 작은 상한을 제공한다.
6. 이 연구가 최초이거나 기존 연구가 문제를 해결하지 못했다.
7. QEMU 결과가 실물 OBC의 성능·실시간성·전력 특성을 대표한다.

---

## 14. 최종 평가

현재 연구는 단순한 개념 검증 단계를 지났다. 공개 모델, AArch64 cFS, 공식 OnAIR loader, compiler-derived 계약, 실행 전 판정, HAL 관측을 하나의 저장소에서 연결했고, 실제 입력과 대형 출력 모델이 기존 검증의 약점까지 드러냈다.

가장 중요한 미완성 지점은 코드량이나 모델 수가 아니다. **실제 입력의 AArch64 종단 증거, DeepAE FAIL의 정직한 해석, 상한 알고리즘의 근거, 선행연구 원문 기반 신규성**이다. 이 네 항목이 완료되면 논문의 핵심 증거 구조가 닫힌다.

현 상태에 대한 판정은 다음과 같다.

| 항목 | 판정 |
|---|---|
| 구현 완성도 | 높음 |
| 재현·감사 구조 | 높음 |
| AArch64 cFS 기본 증거 | 확보 |
| 공식 OnAIR 연계 | 확보 |
| 공개 실입력 증거 | 확보, AArch64 종단은 미완성 |
| 모델 다양성 | 충분함 |
| 의미 동치 | 모델별 혼합 결과, DeepAE FAIL |
| 조건부 상한의 방법론 설명 | 상당히 진전됐으나 논증 정리 필요 |
| 신규성 검증 | 검색 단계, 원문 검증 미완성 |
| 논문 투고 준비도 | 핵심 P0 완료 전까지 보류 |

> **본인 분석·판단:** 새로운 기능과 모델을 더 쌓기보다, 현재 네 모델과 실제 데이터의 증거를 AArch64 cFS까지 닫고 신규성 원문 검증을 완료하는 것이 연구 품질을 가장 크게 높인다.
