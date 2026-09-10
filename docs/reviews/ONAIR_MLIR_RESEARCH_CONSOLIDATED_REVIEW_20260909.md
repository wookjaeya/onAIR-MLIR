# onAIR-MLIR 연구 현황 및 실제 온보드 AI 모델 중심 실험 구성 종합 검토

**검토 기준일:** 2026-09-09  
**대상 저장소:** <https://github.com/wookjaeya/onAIR-MLIR>  
**확인한 최신 개발 브랜치:** `claude/review-and-proceed-4y1sag`  
**확인 커밋:** `0dba06becfc8a99f05ba0d8d6a53fc9c68c36ead`

---

## 1. 한 문장 결론

이 연구는 **실제 AI 모델을 AArch64용 IREE VMFB로 컴파일하면서 MLIR에서 부분 실행 메모리 계약을 추출하고, cFS 앱이 실행 전에 그 계약으로 모델 배치를 허용하거나 거부할 수 있는지 검증하는 연구**로 정리해야 한다.

현재 저장소는 계약 생성기, cFS admission, HAL 계측, 조건부 상수 매핑까지 상당히 구현됐지만, 논문의 핵심 증거가 되려면 다음 세 가지가 남아 있다.

1. **실제 비행 유래 AI 모델의 AArch64+cFS 완주**
2. **원본 TFLite와 IREE/AArch64 결과의 의미 동치 검증**
3. **MLIR 분석이 LLVM IR/ELF-only 분석보다 제공하는 고유 정보 또는 실용적 이점의 입증**

합성 모델은 제거하지 않는다. 다만 합성 모델은 경계조건과 회귀시험에 한정하고, 본문의 주요 결과는 공개·재현 가능한 실제 모델에서 제시해야 한다.

---

## 2. 연구가 해결하려는 정확한 문제

위성에 새로운 AI 모델을 올릴 때 모델 파일 크기만으로는 실행 중 필요한 버퍼와 상수 처리 메모리를 알 수 없다. 반대로 실행 후 RSS만 측정하면 이미 모델을 실행한 특정 배포환경의 결과에 불과하며, 다른 ISA·런타임 설정·상수 적재 방식에서도 같은 결과가 유지된다고 보장하기 어렵다.

본 연구가 제안하는 구조는 다음과 같다.

```text
공개 AI 모델(TFLite)
  → TOSA/MLIR import
  → IREE lowering
  → 메모리 관련 IR 구조 분석
  → 타깃별 VMFB + 계약 JSON 생성
  → cFS 앱 초기화 시 admission
  → 실행 중 IREE HAL 계측으로 계약 확인
```

핵심 질문은 단순히 “모델이 실행되는가”가 아니다.

> **동일한 모델과 컴파일 설정에서 생성된 MLIR/IREE 정보로 타깃별 실행 메모리 상한을 구성하고, cFS가 그 상한으로 실행 전 배치 결정을 내리며, 실제 AArch64 실행에서도 상한 위반 없이 모델의 의미가 보존되는가?**

### 계약이 보장하는 범위

현재 계약의 정확한 범위는 **IREE HAL 계층의 앱별 부분 메모리**다.

- 호출 중 transient/input/output buffer
- VMFB의 module-resident constants
- 타깃별 커널 스택 분석값은 별도 항목

다음은 계약 밖이며 별도 관측값으로만 보고해야 한다.

- cFS 전체 프로세스 및 다른 앱의 메모리
- IREE instance/device/session 객체
- VMFB 원본 blob을 보유하는 호스트 heap
- 파일 시스템 캐시와 OS 메모리
- 여러 앱의 동시 실행 효과

따라서 논문에서는 “온보드 컴퓨터 전체 메모리를 보장한다”가 아니라 **“선택한 앱의 IREE HAL 실행 메모리에 대한 부분 계약”**이라고 써야 한다.

---

## 3. 최신 저장소에서 확보된 연구 성과

### 3.1 계약 파이프라인과 cFS 연결

- IREE lowering 과정의 allocation 및 constant 정보를 계약 JSON으로 생성한다.
- 구조적 MLIR API 기반 검증기와 기존 추출 결과를 교차검증한다.
- 계약에서 C 헤더를 생성하고 cFS `AI_LEARNER` 초기화 단계의 admission에 사용한다.
- 정적 상한을 알 수 없는 모델은 `UNKNOWN_BOUND`로 거부한다.
- 모델·계약·실행 아티팩트의 대응과 interface 조건을 검사한다.
- Native IREE 및 cFS 경로에서 HAL allocator 통계를 수집한다.

이 단계는 단순 분석 스크립트가 아니라 **컴파일 결과 → 계약 → 실제 cFS 판정**으로 이어지는 실행 가능한 프로토타입이라는 점에서 의미가 있다.

### 3.2 E25: 실행 경로 간 의미 동치

canonical 모델에 대해 Python IREE, native C, cFS 등 여러 실행 경로의 출력을 비교하는 인프라가 마련됐다. 이는 wrapper나 cFS 결선이 계산 결과를 바꾸지 않는지 확인하는 기반이다.

다만 이 결과는 canonical 모델에 대한 것이며, 원본 TFLite와의 동치를 증명한 것은 아니다. 실제 모델에서는 반드시 다음 비교가 추가되어야 한다.

```text
원본 TFLite 출력
↔ IREE x86-64 출력
↔ IREE AArch64 출력
↔ cFS AArch64 출력
```

### 3.3 E26/E26e/E26f: 계약 경계와 공개 모델

MLPerf Tiny 계열의 공개 모델이 파이프라인에 들어왔다.

| 모델 | 현재 확보된 핵심 결과 | 한계 |
|---|---|---|
| ResNet/CIFAR-10 | 실제 CNN의 계약 생성과 x86-64 HAL 관측 | AArch64+cFS 및 TFLite 의미 동치 미완료 |
| Deep Autoencoder/ToyADMOS | 상수 지배형 모델에서 큰 tightness 차이 관측 | AArch64+cFS 미완료 |
| VWW/MobileNet | depthwise CNN 계열 fixture와 native 관측 | 통합 실험 행렬 미완료 |

실제 공개 모델 도입 과정에서 합성 모델로 발견하지 못했던 호출 해석, 상수 라벨, 다중 출력 처리 등의 과잉 거부 결함이 발견·수정됐다. 이는 실제 모델을 넣는 것이 단순 외형 보강이 아니라 분석기의 coverage와 validity를 실질적으로 시험한다는 근거다.

### 3.4 E27: MLIR 이외의 정보원과 비교

VMFB-only 분석을 강화해 정상 artifact에서 MLIR 계약값을 재구성할 수 있음을 보였다. 이는 “MLIR만이 숫자를 얻을 수 있다”는 강한 주장을 약화시킨다.

따라서 논문의 MLIR 기여는 다음처럼 바뀌어야 한다.

- 단순 숫자 추출의 독점성이 아님
- lowering 중 구조·분기·진단 문맥을 보존한 계약 생성
- 미지원 조건을 명시적으로 거부하는 coverage
- 상수 map/copy와 같은 조건부 경로를 설명하는 구조적 정보
- 타깃별 계약 생성의 자동화와 추적 가능성

아직 **LLVM IR/ELF-only 기준선**이 남아 있다. 동일 모델·동일 컴파일 호출에서 저수준 정보만으로 같은 조건부 계약을 얼마나 복구할 수 있는지 비교해야 MLIR의 필요성을 방어할 수 있다.

### 3.5 E28: admission 게이트의 실제 결함 수정

분석기가 올바른 계약을 생성해도 cFS 게이트가 그 값을 잘못 사용하면 전체 주장이 무너진다. E28은 admission 구현 자체의 fail-open 경로를 재현하고 수정했다. 이 결과는 계약 정확도와 게이트 정확도를 분리 검증해야 한다는 점을 확립했다.

### 3.6 E29: 조건부 상수 계약

IREE가 module-resident constants를 처리할 때 다음 두 경로가 존재함을 확인했다.

```text
64-byte aligned module image → try_map 성공 → HAL 상수 복사 0
정렬 조건 미충족          → copy fallback → 상수 블록 전체 HAL 할당
```

8개 모델과 8개 정렬 조건으로 구성된 64개 셀에서 다음 관계가 관측됐다.

- map 경로: `observed peak = per_call`
- copy 경로: `observed peak = per_call + constants`
- 분기 결정요인: module image pointer의 64-byte alignment

특히 DeepAE에서는 동일 VMFB임에도 map/copy 선택에 따라 HAL peak가 `6,208 B`와 `1,069,632 B`로 달라졌다. 이 결과는 단일 최악 상한만 사용하는 계약이 sound할 수는 있어도 실제 admission에서는 매우 보수적일 수 있음을 보여준다.

권장 계약 정의는 다음과 같다.

```text
B_map   = per_call
B_copy  = per_call + module_constants
B_worst = max(B_map, B_copy)
```

---

## 4. E29 이후 반드시 수정해야 할 논리적 문제

실제 모델 실험을 확장하기 전에 다음 두 문제를 먼저 고쳐야 한다.

### 4.1 map 성공 검증 조건

현재 조건부 admission의 사후 검증은 사실상 다음 조건을 사용한다.

```c
hal_peak_after_append > CONTRACT_PER_CALL_BYTES
```

그러나 append 직후 입력 버퍼나 추론이 아직 없으므로, map 성공의 판정은 다음이어야 한다.

```c
hal_peak_after_append == 0
```

즉 조건부 `B_map`으로 승인했다면 다음 경우를 모두 거부해야 한다.

- `hal_peak_after_append != 0`
- 관측된 arm이 `map`이 아님
- constant block과도 일치하지 않는 `other` 상태

현재 비교식은 constants가 per-call보다 작은 모델에서 copy가 발생해도 통과할 수 있으므로 잠재적인 fail-open이다.

### 4.2 초기화 순간의 copy 메모리

map 실패 여부는 module append 이후에 알게 된다. 따라서 조건부 admission을 `B_map`만으로 통과시킨 뒤 copy fallback이 발생하면, 거부하기 전에 이미 `B_copy` 수준의 메모리를 사용했을 수 있다.

다음 중 하나가 필요하다.

1. append 이전에 map 가능성을 확정하는 loader 경로
2. copy fallback을 금지하는 API 또는 적재 방식
3. `B_init`와 `B_steady`를 분리하고 초기화 예산에는 `B_copy`를 요구

권장 정의는 다음과 같다.

```text
B_init   = 모듈 적재·검증 중 발생 가능한 최대 메모리
B_steady = map 또는 copy 정책이 확정된 뒤의 실행 메모리
```

이 문제를 해결하지 않고 SmartCam이나 WGAN처럼 상수가 큰 모델을 추가하면 조건부 계약의 유용성 주장이 오히려 약해질 수 있다.

---

## 5. 실제 AI 모델 중심 벤치마크 구성

### 5.1 선정 원칙

본문의 모델은 다음 조건을 만족해야 한다.

1. 원본 모델 파일 또는 완전한 재학습 절차가 공개돼 있음
2. 모델의 임무·입력·출력과 데이터 출처가 명확함
3. 온보드 실행 사례가 있거나, 공인된 embedded AI benchmark임
4. 원본 출력과 변환 결과를 재현할 수 있음
5. 수동으로 비슷하게 재작성한 모델을 원본 모델처럼 부르지 않음

### 5.2 권장 최종 모델군

| ID | 모델 | 지위 | 역할 | 우선도 |
|---|---|---|---|---|
| F1 | OPS-SAT SmartCam MobileNetV2 FP32 | 실제 비행 TFLite 모델 | 위성 영상 분류, 실제 모델 교체 시나리오 | **필수** |
| F2 | OPS-SAT WGAN `wgan_fpn50_p.tflite` | 실제 비행·공개 TFLite 모델 | 영상 복원, 상수·activation 구조 다양화 | **필수 또는 강력 권장** |
| E1 | MLPerf Tiny ResNet/CIFAR-10 | 표준 embedded benchmark | residual CNN 일반화 | **필수** |
| E2 | MLPerf Tiny DeepAE/ToyADMOS | 표준 embedded benchmark | 비-CNN·상수 지배형 사례 | **필수** |
| E3 | MLPerf Tiny VWW/MobileNet | 표준 embedded benchmark | depthwise convolution 다양성 | 권장 |
| S0 | 기존 MLP/Conv2D/multibranch/dynamic | 합성·통제 모델 | 경계·반례·회귀시험 | 보조군 |

#### F1: OPS-SAT SmartCam

- 공개 TFLite 모델과 학습 스크립트가 존재한다.
- MobileNetV2 ImageNet feature vector를 사용한 transfer learning 모델이다.
- 입력은 `[1,224,224,3]` FP32, 출력은 `bad/earth/edge` 3개 클래스다.
- OPS-SAT의 ARM32 SEPP에서 TensorFlow Lite C API로 실제 실행됐다.
- 본 연구의 AArch64는 동일 하드웨어 재현이 아니라 ARM 계열 차세대 배치 ISA에 대한 기능 검증으로 표현해야 한다.

#### F2: OPS-SAT onboard image denoiser

- WGAN과 Autoencoder의 실제 `.tflite` 파일이 공개되어 있다.
- `wgan_fpn50_p.tflite`는 약 4.30 MB이며 patch 기반 영상 복원에 사용됐다.
- 원본·FPN-noised·denoised 영상과 우주선 실행 로그가 공개되어 있다.
- 공개 저장소에서 원본 우주선 영상 42개와 원본/노이즈/복원 영상 126개를 구성할 수 있다.

이 모델은 SmartCam보다 출력이 크고 영상 복원 그래프를 포함하므로, 분류 모델에 편중된 실험을 보완한다. 다만 flight log의 일부 파일명에 `fpn/fnp` 표기 불일치가 있으므로 실제 사용 artifact를 checksum으로 확정한 뒤 실험해야 한다.

#### E1~E3: MLPerf Tiny

MLPerf Tiny는 CIFAR-10 ResNet, ToyADMOS DeepAE, VWW MobileNet과 공식 데이터셋·품질 기준을 제공한다. 이 모델들은 우주 비행 모델은 아니지만, 공개성과 embedded workload 대표성이 높아 F1/F2에서 관측한 결과가 특정 OPS-SAT 모델에만 해당하지 않는지 확인하는 일반화 대조군으로 적절하다.

### 5.3 실행 벤치마크에서 제외할 후보

| 후보 | 제외 이유 |
|---|---|
| OPS-SAT OrbitAI Random Forest/온라인 학습 | 현재 IREE tensor inference 계약과 계산 모델이 다름 |
| RaVAEn | 실제 우주 CPU/VPU 실행 사례는 유효하지만 동일 artifact의 공개·재현성이 불충분 |
| PhiSat 계열 비공개 flight model | 임무 근거는 있으나 원본 모델·가중치가 없으면 직접 실행 검증 불가 |
| 임의로 축소·재작성한 유사 CNN | 실제 모델의 graph와 weight를 사용했다는 주장을 할 수 없음 |

이들은 관련 연구와 문제 타당성의 근거로는 사용할 수 있지만 본 실험 모델 수에 포함해서는 안 된다.

---

## 6. 입력 데이터와 의미 동치 검증

### 6.1 모델별 데이터

| 모델 | 권장 평가 입력 | 품질 지표 |
|---|---|---|
| SmartCam | 공개 OPS-SAT 영상 및 denoiser 저장소의 원본 영상 | logits 오차, argmax 일치 |
| OPS-SAT WGAN | 공개된 noised/original 영상 쌍 | 출력 tensor 오차, SSIM, PSNR |
| ResNet | CIFAR-10 공식 test set | Top-1 accuracy, logits/decision 일치 |
| DeepAE | ToyADMOS 공식 평가 split | reconstruction error, AUC |
| VWW | 공식 VWW evaluation set | Top-1/decision 일치 |

SmartCam 저장소의 소수 mock 영상만으로 분류 정확도를 주장하면 안 된다. 해당 영상은 smoke test에만 사용하고, 실제 공개 OPS-SAT 영상은 출력 동치 검증에 사용한다. 클래스 균형과 ground truth가 충분하지 않다면 SmartCam의 정확도를 새로 주장하지 않고 TFLite와 IREE의 decision 일치만 보고한다.

### 6.2 비교 단계

```text
TFLite 원본
  ↔ import/치환 직후 MLIR 실행
  ↔ IREE x86-64 Native
  ↔ IREE AArch64 Native
  ↔ cFS AArch64
```

SmartCam의 `SQUEEZE` 등 importer가 직접 처리하지 못하는 연산을 `RESHAPE` 등으로 치환한다면 다음 조건이 필요하다.

- 변환 규칙과 적용 위치 공개
- 변환 전후 shape/dtype 동일성 확인
- 동일 입력에서 TFLite golden output과 수치 비교
- argmax 또는 임무 decision 비교
- 변환된 모델을 원본과 구분한 artifact name과 hash 사용

직접 import가 가능하면 TFLite→TOSA/MLIR 경로를 우선하고, 불필요한 ONNX 중간 변환은 피한다. 중간 표현이 늘어날수록 메모리 분석과 의미 차이의 원인을 분리하기 어려워진다.

---

## 7. x86-64 VMFB의 정확한 역할

x86-64 VMFB는 **논문의 주 실험 대상이 아니라 구현 간 검증 기준선**이다.

### 유지해야 하는 이유

- TFLite import와 IREE 컴파일이 정상인지 빠르게 확인
- 모델 변환 오류와 AArch64 코드생성·ABI 문제를 분리
- TFLite↔IREE 수치 동치를 낮은 비용으로 확인
- CI와 회귀시험을 빠르게 수행
- AArch64와 공통인 MLIR 계약값과 타깃 의존적인 ELF/스택 요소를 구분

### 논문에서의 위치

| 항목 | 권장 처리 |
|---|---|
| x86-64 VMFB | Methods에 개발·교차검증 환경으로 명시 |
| x86-64 Native | 전 모델의 변환·출력·계약 sanity check |
| x86-64 cFS | 대표 모델 1개 smoke test 또는 부록 |
| x86-64 성능 | 본문 핵심 결과에서 제외 |
| AArch64 VMFB | 본 실험 artifact |
| AArch64 Native+cFS | 핵심 결과표와 결론의 근거 |

x86-64와 AArch64 VMFB는 동일 모델 소스에서 만들어지지만 서로 다른 ISA용 컴파일 산출물이다. 따라서 x86-64에서 얻은 메모리 결과를 AArch64의 증거로 대신할 수 없다.

---

## 8. 권장 연구질문

### RQ1. 계약의 경험적 soundness와 coverage

> 지원한다고 선언한 실제 정적 모델에서 MLIR 기반 계약은 동일 경계로 측정한 AArch64 HAL peak를 모두 포괄하고, 분석할 수 없는 조건은 명시적으로 거부하는가?

주요 지표:

- `observed_HAL_peak ≤ admitted_bound` 위반 수
- 계약 생성 성공/명시적 거부율
- unsupported op와 dynamic shape 처리
- 수동 override 사용 여부

### RQ2. 조건부 계약의 admission 유용성

> map/copy 전제조건을 포함한 계약이 최악 상한만 사용하는 계약보다 soundness를 유지하면서 실제 모델의 불필요한 거부를 줄이는가?

비교 정책:

- `B_worst`만 사용하는 universal contract
- `B_map/B_copy`를 구분하는 conditional contract
- 특정 배포에서 얻은 runtime profile만 사용하는 정책

주요 지표:

- fixed budget별 admitted model 수
- false reject 및 unsafe admit
- bound/observed peak 비율
- map/copy 분기 재현성

### RQ3. MLIR의 고유 기여

> 동일 모델·컴파일·타깃 조건에서 MLIR 분석이 robust VMFB-only 및 LLVM IR/ELF-only 분석보다 coverage, 조건부 경로 설명, 진단 가능성 또는 자동화 측면에서 무엇을 더 제공하는가?

단순히 MLIR 숫자가 정답과 맞는지만 비교하지 않는다. 다음을 함께 비교해야 한다.

- 추출 성공률
- 거부 사유의 구체성
- map/copy 분기 조건 복구 가능 여부
- 다중 dispatch와 상수 그룹 처리
- 도구 버전 변화에서의 가용성

### RQ4. 실제 모델의 의미 및 cFS 통합 보존

> 실제 공개 모델이 원본 TFLite와 허용오차 내 동일한 결과를 내면서 AArch64 cFS admission과 실행 경로를 완주하는가?

---

## 9. 권장 실험 행렬

전체 Cartesian product보다 연구질문별 최소 행렬을 구성하는 것이 효율적이다.

### 9.1 모델별 최소 실행 범위

| 모델 | x86 Native | x86 cFS | AArch64 Native | AArch64 cFS | TFLite 동치 |
|---|---:|---:|---:|---:|---:|
| SmartCam | 필수 | 선택/smoke | **필수** | **필수** | **필수** |
| OPS-SAT WGAN | 필수 | 선택 | **필수** | **필수 권장** | **필수** |
| ResNet | 완료분 재사용 | 선택 | **필수** | **필수** | **필수** |
| DeepAE | 완료분 재사용 | 선택 | **필수** | **필수** | **필수** |
| VWW | 완료분 재사용 | 생략 가능 | 권장 | 대표군에 따라 선택 | 필수 시 포함 |
| 합성 모델 | 회귀 | 기존 결과 | 회귀 | 기존 결과 | 해당 없음 |

### 9.2 메모리 셀

각 핵심 실제 모델에 대해 다음을 실행한다.

| 축 | 값 |
|---|---|
| 타깃 | AArch64 Cortex-A53 설정 |
| 실행 경로 | Native IREE, cFS+IREE |
| 상수 정책 | aligned map, forced copy/fallback |
| 예산 경계 | `B_map-1`, `B_map`, `B_copy-1`, `B_copy` |
| 실용 예산 | 사전에 고정한 앱별 budget grid |
| 반복 | 독립 프로세스 5회 + 프로세스당 반복 추론 |

`B±1` 실험은 게이트 경계의 정확성을 보여주지만 실용적 유용성을 단독으로 증명하지 못한다. 별도의 고정 예산 grid에서 universal/conditional 정책이 각각 몇 개 모델을 허용하는지 보고해야 한다. 이 budget은 실제 임무 예산이라고 과장하지 않고 **통제된 앱별 배치 시나리오**라고 명시한다.

### 9.3 계측값

- 계약의 `B_init`, `B_map`, `B_copy`, `B_worst`
- append 직후 HAL peak
- 추론 종료 HAL peak
- steady-state allocation 변화
- cFS configured stack과 타깃별 분석 stack
- 출력 tensor와 task-level decision
- RSS는 계약 밖 진단값으로 별도 열에 보고

QEMU 안에서 측정한 latency, jitter, WCET, 전력은 논문의 성능 근거로 사용하지 않는다.

---

## 10. 사전 고정할 합격 기준

### 메모리 계약

1. 지원 대상으로 선언한 모든 셀에서 `observed_HAL_peak ≤ 해당 admission bound`
2. `bound-1`에서는 거부하고 `bound`에서는 허용
3. 조건부 map 승인은 append 직후 `hal_peak_after_append == 0`일 때만 유지
4. copy/other 분기이면 추론 전에 거부하거나 충분한 `B_init/B_copy` 예산으로 전환
5. 미지원 연산·동적 shape·불완전 분석은 수치 추정 없이 `UNSUPPORTED/UNKNOWN_BOUND`

### 의미 동치

- FP32 출력: 기존 계획과 동일하게 `absolute error ≤ 1e-4` 또는 `relative error ≤ 1e-5`
- 분류 모델: argmax/decision 일치율 별도 보고
- ResNet/VWW: 공식 accuracy 기준 및 TFLite 대비 변화 보고
- DeepAE: 공식 AUC와 reconstruction score 변화 보고
- WGAN: tensor 오차와 SSIM/PSNR 변화 보고

같은 VMFB를 standalone과 cFS에서 실행한 경우에는 bit identity를 우선 검사한다. x86-64와 AArch64는 서로 다른 VMFB이므로 허용오차와 decision 일치를 사용한다.

### 통계 표현

HAL allocation과 계약값은 결정론적 계측이므로 무의미한 p-value를 붙이지 않는다. 대신 다음을 제시한다.

- 전체 실험 셀과 위반 수
- 모델별·타깃별 coverage
- tightness의 범위·중앙값
- 독립 프로세스 반복에서 분기 및 peak의 일관성
- 공식 데이터셋 평가의 정확도/AUC/SSIM 분포

모델 수가 임의 표본이므로 결과를 모든 온보드 AI 모델로 통계적 일반화하지 않는다.

---

## 11. 실제 모델 도입을 위해 필요한 cFS 수정

현재 cFS 앱은 단일 f32 입력·출력과 작은 feature buffer에 강하게 맞춰져 있다. 224×224×3 영상은 f32 기준 약 602 KiB이므로 큰 자동 배열을 cFS task stack에 두면 기존 stack 설정과 충돌할 수 있다.

필수 수정:

1. 입력 tensor를 큰 stack 배열이 아니라 heap/static arena 또는 HAL buffer에 직접 기록
2. 계약에 input/output buffer와 transient 영역의 귀속을 명확히 표현
3. 단일 입력·단일 출력·f32 hardcode를 model manifest 기반으로 일반화
4. WGAN처럼 출력 tensor가 큰 모델을 처리하도록 output 저장 경로 일반화
5. cFS Software Bus 패킷에서 대형 영상을 직접 운반하지 말고, 실험 fixture 또는 파일/공유 버퍼로 전처리 tensor를 공급

이 수정은 영상 처리 시스템 전체를 연구하는 범위 확장이 아니라 실제 모델을 계약 실험에 넣기 위한 최소 integration 작업이다.

---

## 12. 권장 실행 순서

### P0. E29b — 조건부 계약의 논리 수정

- map 검증을 `hal_peak_after_append == 0`으로 변경
- `other` 분기 fail-closed
- 승인에 사용한 bound와 사후검증 bound를 동일하게 연결
- `B_init`과 `B_steady` 정책 확정
- 기존 E29 셀 및 반례 재실행

### P1. 실제 모델 provenance와 import feasibility

- SmartCam, WGAN, ResNet, DeepAE 원본 commit·파일·hash 고정
- 입출력 signature와 TFLite operator 목록 저장
- 직접 TFLite→TOSA/MLIR import 성공 여부 확인
- 미지원 op가 있으면 자동·문서화된 등가 치환과 golden test 적용

### P2. x86-64 구현 검증

- 모든 실제 모델의 TFLite↔IREE 출력 비교
- 계약 생성과 Native HAL 관측
- cFS는 대표 모델 1개 smoke test만 유지

### P3. AArch64 본 실험

- 모델별 AArch64 VMFB와 계약을 동일 compile invocation에서 생성
- AArch64 Native에서 map/copy, 예산 경계, 출력 동치 실행
- SmartCam, WGAN, ResNet 또는 DeepAE를 AArch64 cFS에서 실행
- cFS admission·HAL peak·출력을 하나의 summary로 결합

### P4. MLIR 기여 기준선

- 동일 actual model artifact를 VMFB-only와 LLVM IR/ELF-only 분석기에 입력
- 숫자뿐 아니라 coverage·조건부 분기·진단 가능성을 비교
- baseline에도 동일한 fail-closed 요구 적용

### P5. 논문용 통합 결과

- 모델 provenance 표
- 타깃별 계약·관측 peak 표
- universal vs conditional admission utility 표
- TFLite↔AArch64/cFS 의미 동치 표
- MLIR/VMFB/LLVM-ELF coverage 표
- 합성 모델은 반례 및 회귀시험 표로 분리

---

## 13. 논문에서 유지할 주장과 제외할 주장

### 주장 가능한 목표

> 공개된 실제 온보드·embedded AI 모델을 대상으로, MLIR/IREE lowering 정보에서 AArch64용 앱별 부분 메모리 계약을 생성하고, 그 계약이 cFS의 실행 전 admission과 런타임 HAL 관측을 연결할 수 있음을 경험적으로 보였다. 또한 상수 map/copy 전제조건을 분리한 조건부 계약이 최악 상한의 soundness를 유지하면서 불필요한 거부를 줄이는지 평가했다.

### 주장하지 않을 것

- 전체 온보드 컴퓨터의 메모리 안전 보장
- 모든 AI 모델과 IREE 버전에 대한 형식적 soundness
- QEMU 기반 latency, WCET, jitter, cache, 전력 성능
- 실제 OPS-SAT ARM32 하드웨어의 재현
- GPU/VPU/NPU 메모리까지 포함한 heterogeneous 배치
- 여러 cFS 앱의 전역 메모리·스케줄링 보장
- 방사선 내성 또는 flight qualification
- 악의적 공격자와 공급망 보안

모델·계약·VMFB의 hash는 보안 연구를 위한 것이 아니라 **동일 artifact를 비교했다는 실험 재현성**을 위해 유지한다.

---

## 14. 최종 평가

현재 연구는 단순 아이디어 단계가 아니다. 계약 생성, cFS admission, AArch64 기능 검증, 실제 MLPerf 모델, HAL 관측, 조건부 상수 경로까지 구현됐다. 특히 실제 모델이 분석기의 여러 과잉 거부 결함을 드러냈고, E29는 같은 VMFB에서도 배포 방식에 따라 메모리 tightness가 크게 달라진다는 의미 있는 결과를 만들었다.

그러나 아직 논문의 가장 강한 문장은 완성되지 않았다.

> **실제 비행 유래 AI 모델의 메모리 계약을 MLIR에서 생성하고, AArch64 cFS에서 실제 peak와 의미 보존까지 검증했다.**

이 문장을 성립시키는 것이 다음 단계의 목표다. 가장 적절한 증거 구조는 다음과 같다.

```text
합성 모델 → 원인 분리·경계·반례·회귀
OPS-SAT 실제 모델 → 비행 현실성
MLPerf Tiny → 공개성·embedded workload 일반화
AArch64 Native/cFS → 목표 ISA의 계약·통합 검증
x86-64 → 구현 간 검증·CI·디버깅
LLVM IR/ELF baseline → MLIR 고유 기여 검증
```

즉, 모델 수를 늘리는 것 자체가 목표가 아니다. **실제 모델의 provenance, 원본 의미, AArch64용 계약, cFS admission, HAL 관측을 끊김 없이 연결하는 것**이 연구의 최종 완성 조건이다.

---

## 참고한 공개 1차 자료

1. onAIR-MLIR: <https://github.com/wookjaeya/onAIR-MLIR>
2. OPS-SAT SmartCam: <https://github.com/georgeslabreche/opssat-smartcam>
3. OPS-SAT onboard image denoiser: <https://github.com/georgeslabreche/opssat-onboard-image-denoiser>
4. MLPerf Tiny: <https://github.com/mlcommons/tiny>
5. IREE TFLite integration: <https://iree.dev/guides/ml-frameworks/tflite/>
6. IREE CPU deployment: <https://iree.dev/guides/deployment-configurations/cpu/>

