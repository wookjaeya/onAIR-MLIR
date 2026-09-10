# onAIR MLIR 다음 실험 순서 분석

## 1 결론

다음 작업은 **P1 실제 모델 provenance와 import feasibility**부터 시작하는 것이 맞다. 다만 SmartCam, WGAN, ResNet, DeepAE를 한꺼번에 처리하지 않고 **OPS-SAT SmartCam 한 모델로 P1을 먼저 종료**해야 한다.

권장 순서는 다음과 같다.

```text
P1 SmartCam 반입 가능성 확인
→ P2 SmartCam 의미 동치와 x86-64 구현 검증
→ P4 실제 모델 기반 MLIR 기여 기준선
→ P3 AArch64 Native와 cFS 본 실험
→ ResNet과 DeepAE로 반복 검증
→ WGAN은 대형 출력 사례가 필요할 때 추가
```

P1은 AArch64 게스트 재구축이나 cFS 앱 전체 일반화를 요구하지 않는다. 원본 모델을 재현 가능한 방법으로 MLIR과 VMFB까지 반입할 수 있는지를 판단하는 **저비용 타당성 관문**이다.

---

## 2 현재 상태에 대한 판단

검토 기준 브랜치는 `claude/review-and-proceed-4y1sag`이며 확인한 원격 HEAD는 `42283d7`이다.

현재까지 다음 핵심 작업은 완료됐다.

- E29에서 map과 copy 분기를 결정하는 64바이트 정렬 조건 확인
- E29b에서 조건부 계약의 잘못된 검증 조건 수정
- map 전제조건을 module append 전에 검사하도록 변경
- VMFB-only 기준선을 강화하고 가용성 관점으로 결론 축소
- cFS 입력 초기화 버퍼를 stack이 아닌 static 영역으로 이동
- 보안과 공급망 문제를 연구 범위 밖으로 명시

남은 가장 큰 실험 공백은 다음 두 가지다.

1. 실제 비행 또는 공개 embedded AI 모델의 AArch64 계약 및 실행 증거
2. 실제 모델에서 MLIR 분석이 다른 정보원보다 제공하는 고유한 가치

따라서 실제 모델 반입을 다음 단계로 정한 방향은 타당하다.

---

## 3 현재 문서에서 정정할 부분

### 4.1 SmartCam operator 목록은 이미 확인돼 있다

`ASSUMPTIONS_AND_SCOPE.md`에는 SmartCam operator 목록이 미확인이라고 적혀 있지만, 기존 `E26_boundary_utility.md`에는 다음 목록이 이미 기록돼 있다.

- `ADD`
- `AVERAGE_POOL_2D`
- `CONV_2D`
- `DEPTHWISE_CONV_2D`
- `FULLY_CONNECTED`
- `MUL`
- `SOFTMAX`
- `SUB`
- `SQUEEZE`

따라서 P1의 목표는 operator를 처음 발견하는 것이 아니다. 기존 수기 결과를 다음 형태로 **재현 가능한 증거로 확정**하는 것이다.

- 자동 추출 스크립트
- 원본 모델 SHA-256
- 입출력 signature
- operator inventory JSON
- 실행 명령과 도구 버전

`ai_edge_litert`가 없다는 이유만으로 operator inventory 전체가 미확인인 것은 아니다. 이미 사용한 TFLite schema 기반 추출 경로를 고정하면 된다.

### 4.2 cFS 일반화 전체는 P1의 선행 조건이 아니다

최신 cFS 앱은 입력 초기화 배열을 `static`으로 선언한다. SmartCam은 단일 FP32 입력과 단일 소형 출력이므로 현재 헤더와 호출 인터페이스에 비교적 잘 맞는다.

추가 일반화가 직접 필요한 대상은 주로 다음과 같다.

- WGAN처럼 출력 tensor가 큰 모델
- 다중 입력 또는 다중 출력 모델
- FP32 이외의 경계 dtype을 사용하는 모델
- 모델별 파일 입력과 대형 출력 저장이 필요한 경우

따라서 SmartCam P1 단계에서 §11의 모든 기능을 구현하는 것은 범위가 과하다. 실제 signature와 import 결과가 확정된 후 P3을 막는 항목만 수정해야 한다.

---

## 4 P1의 정확한 수행 범위

P1은 다음 결과까지만 생성하고 종료한다.

### 5.1 원본 고정

- OPS-SAT SmartCam 저장소 commit 고정
- 원본 `model.tflite` 파일 크기와 SHA-256 기록
- 모델을 수정하지 않은 원본 artifact로 보존
- 도구 버전과 실행 환경 기록

### 5.2 모델 구조 기록

- 입력 이름, shape와 dtype
- 출력 이름, shape와 dtype
- operator 종류와 발생 횟수
- 정적 shape 여부
- 예상 cFS 인터페이스 적합 여부

### 5.3 원본 import 시도

현재 환경에서는 직접 TFLite import 대신 검증된 다음 경로를 우선 사용한다.

```text
TFLite
→ tflite2onnx
→ iree-import-onnx
→ iree-opt
→ MLIR
→ 한 번의 iree-compile
→ VMFB와 계약 산출물
```

중간 단계마다 성공 여부와 실패 원인을 저장한다. 지원하지 않는 operator가 발견되면 조용히 제거하거나 수동 편집하지 않는다.

### 5.4 P1 종료 산출물

| 산출물 | 내용 |
|---|---|
| `source_manifest.json` | 원본 저장소, commit, 파일 경로, 크기와 hash |
| `operator_inventory.json` | 입출력 signature와 operator 목록 |
| `import_log.txt` | 단계별 명령, 성공 여부와 정확한 오류 |
| 변환 스크립트 | SQUEEZE 등 필요한 등가 변환을 자동 수행 |
| 변환 전후 manifest | shape, dtype, element count와 artifact hash 비교 |
| `feasibility_summary.json` | 모델별 GO, TRANSFORM_REQUIRED, UNSUPPORTED 판정 |

P1에서는 전체 데이터셋 정확도를 평가하거나 AArch64 cFS를 실행하지 않는다.

---

## 5 SmartCam SQUEEZE 처리 원칙

`SQUEEZE`를 무조건 `RESHAPE`로 바꾸면 안 된다. 다음 조건을 모두 만족할 때만 자동 변환한다.

1. 제거되는 축의 크기가 모두 1이다.
2. 입력과 출력의 전체 원소 수가 같다.
3. 변환 전후 dtype이 같다.
4. 기대 출력 shape가 정적으로 확정된다.
5. 치환 규칙이 코드와 문서로 남는다.
6. 원본과 변환된 artifact의 hash를 별도로 보존한다.
7. P2에서 동일 입력에 대한 TFLite와 IREE 출력이 허용 오차 안에서 일치한다.

권장 구현은 원본 TFLite 파일을 직접 수정하는 방식이 아니다. `tflite2onnx` 변환 단계에서 정적 `RESHAPE`를 생성하거나 변환기를 확장하는 방식이 더 적절하다. 그러면 실제 비행 원본은 변경 없이 보존되고, 변환 과정만 독립적으로 감사하고 재현할 수 있다.

P1에서는 다음 구조 조건을 증명한다.

```text
제거 대상 축의 크기 = 1
입력 원소 수 = 출력 원소 수
입력 dtype = 출력 dtype
출력 shape = 원래 SQUEEZE의 출력 shape
```

수치 출력 동치의 최종 판단은 P2에서 수행한다.

---

## 6 P1 이후 권장 순서

### P2 SmartCam x86-64 구현 검증

- 고정 입력에 대한 TFLite golden output 생성
- IREE x86-64 Native 출력과 비교
- absolute와 relative error 보고
- `bad`, `earth`, `edge` argmax 또는 decision 일치 확인
- MLIR 계약 생성
- Native HAL peak 관찰
- x86-64 cFS는 대표 smoke test 한 건만 수행

x86-64는 논문의 최종 배치 증거가 아니라 변환과 구현 오류를 빠르게 찾는 검증 환경이다.

### P4 실제 모델 기반 MLIR 기여 기준선

P3보다 먼저 수행하는 것이 좋다. 실제 SmartCam artifact가 확보되면 다음 정보 수준을 같은 조건에서 비교한다.

```text
파일 크기
→ VMFB artifact-only
→ runtime profile
→ MLIR universal contract
→ MLIR conditional contract
→ LLVM IR 및 ELF-only
```

비교 항목은 숫자 일치만이 아니다.

- 분석 coverage
- 조건부 map과 copy 표현 가능성
- 미지원 구조의 진단 가능성
- fail-closed 가능성
- 재현성과 자동화 가능성
- 배포 artifact만으로 얻을 수 있는 정보와 컴파일 파이프라인이 필요한 정보의 차이

이 단계는 MLIR 사용의 논문상 필요성을 좌우하므로, 비용이 큰 AArch64 게스트 작업 전에 확인하는 편이 합리적이다.

### P3 AArch64 Native와 cFS 본 실험

- 동일 고정 모델에서 AArch64용 VMFB와 계약 생성
- AArch64 Native 출력 동치 확인
- AArch64 HAL peak와 계약 상한 비교
- map과 copy 조건부 경로 실행
- cFS ADMIT과 DENY 검증
- admission 결과, HAL peak와 모델 출력을 하나의 summary로 결합

QEMU 결과는 AArch64 ISA와 기능 경로의 증거로 사용한다. 실제 우주용 보드의 latency, WCET, jitter, cache 또는 전력 성능 근거로 사용하지 않는다.

---

## 7 모델 확대 순서

SmartCam 한 모델의 전체 경로가 성공한 후 다음 순서로 확대한다.

| 순서 | 모델 | 연구에서의 역할 |
|---:|---|---|
| 1 | OPS-SAT SmartCam MobileNetV2 | 실제 비행 모델 기반의 주 적용 사례 |
| 2 | MLPerf Tiny DeepAE | 상수 지배형 모델과 map 또는 copy 조건부 계약의 강한 사례 |
| 3 | MLPerf Tiny ResNet | residual CNN 구조에서의 반복 검증 |
| 4 | OPS-SAT WGAN | 대형 출력과 영상 복원 구조가 필요할 때 추가 |

WGAN을 SmartCam과 동시에 시작하면 cFS의 대형 출력 저장과 파일 공급 문제가 함께 열려 연구가 통합 프레임워크 개발로 확장될 가능성이 크다. 그러므로 선택적 후속 모델로 두는 것이 안전하다.

---

## 8 이번 단계에서 하지 않을 일

- P1부터 AArch64 게스트를 재구축하지 않는다.
- 네 모델의 cFS 실행기를 동시에 일반화하지 않는다.
- WGAN 대형 출력 때문에 SmartCam 경로까지 지연시키지 않는다.
- 원본 TFLite를 수동 편집하지 않는다.
- 소수 sample 출력으로 정확도 보존을 주장하지 않는다.
- x86-64 결과를 AArch64 메모리 결과로 대체하지 않는다.
- QEMU 결과로 실제 하드웨어 성능을 주장하지 않는다.
- 보안, 공급망, 서명과 키 관리 문제를 다시 연구 범위로 가져오지 않는다.
- HAL peak를 전체 OBC 메모리 사용량으로 확대 해석하지 않는다.

---

## 9 최종 권고

다음 작업 지시는 아래처럼 제한하는 것이 가장 명확하다.

> **P1 SmartCam import feasibility만 수행한다.** 원본 commit과 hash를 고정하고, 입출력 signature와 operator inventory를 기계 판독 형식으로 저장한다. 기존에 확인된 SQUEEZE 차단점을 재현한 뒤, singleton 축과 shape, dtype, 원소 수가 보존되는 자동 RESHAPE 변환을 적용해 MLIR 및 VMFB 생성 가능 여부를 판정한다. 이 단계에서는 AArch64 게스트 재구축, cFS 전체 일반화와 전체 데이터셋 정확도 평가는 수행하지 않는다.

P1이 성공하면 P2에서 출력 의미 동치를 확인하고, 검증된 실제 artifact를 이용해 P4 기준선을 먼저 평가한 후 P3 AArch64와 cFS 실험으로 진행한다.

---

## 참고 문서

- [연구 가정과 유효성 범위](https://github.com/wookjaeya/onAIR-MLIR/blob/claude/review-and-proceed-4y1sag/docs/ASSUMPTIONS_AND_SCOPE.md)
- [E26 boundary utility 계획](https://github.com/wookjaeya/onAIR-MLIR/blob/claude/review-and-proceed-4y1sag/docs/plans/E26_boundary_utility.md)
- [종합 연구 검토](https://github.com/wookjaeya/onAIR-MLIR/blob/claude/review-and-proceed-4y1sag/docs/reviews/ONAIR_MLIR_RESEARCH_CONSOLIDATED_REVIEW_20260909.md)
