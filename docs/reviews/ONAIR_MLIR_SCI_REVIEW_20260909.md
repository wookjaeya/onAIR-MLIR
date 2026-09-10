# onAIR-MLIR 최신 재점검 및 SCI급 실험설계 심사

## 1. 검토 범위

- 저장소: <https://github.com/wookjaeya/onAIR-MLIR>
- 검토 HEAD: `c012bda6cfd6480854b1b98469951d71f7c6a607`
- 비교 기준: 이전 검토 시점 `44c27ac` 이후의 E26·E27 진행분
- 검토 대상:
  - 코드와 자동시험
  - `EVIDENCE_v0.25`~`v0.29`
  - E26/E27 사전 계획
  - 보존된 계약·VMFB·HAL/cFS 로그
  - 레퍼런스 기반 벤치마크 반영 상태
- 제외: 공급망 공격, 서명·키 관리, 악의적 계약 위조 등 보안 연구

로컬 재검증에서는 의존성이 축소된 환경에서 `contract_negative_tests.py`가 **181/181 PASS, 13 SKIP**이었다. SKIP은 IREE compiler/runtime 부재에 따른 것이므로, 이는 저장소의 축소환경 동작 확인이지 full toolchain 재현은 아니다. 저장소가 기록한 최신 full CI 결과는 **275/275 PASS + 1 SKIP**이다.

---

## 2. 총괄 판정

> **공학적으로는 강한 연구 프로토타입이지만, 현재 상태 그대로는 SCI급 논문의 핵심 주장과 실험설계가 완결되지 않았다. Major revision이 필요하다.**

가장 큰 이유는 코드 결함이 아니다. 오히려 최신 E27이 다음 사실을 정직하게 드러냈기 때문이다.

> 정상 조건에서는 VMFB만 분석한 기준선도 제안 경로와 8/8 동일한 계약값을 냈다. 따라서 현재 결과만으로는 “MLIR을 사용해야 하는 고유한 이유”가 입증되지 않는다.

현재 연구의 강점과 약점은 다음처럼 갈린다.

| 평가 축 | 판정 | 이유 |
|---|---|---|
| 구현 완성도 | 강함 | cFS admission, x86-64/AArch64, artifact binding, fail-closed, 회귀시험 구축 |
| 내부 타당성 | 중상 | 사전 기준, 원시 로그, 정정 이력, HAL 경계 분리 |
| 외적 타당성 | 부족 | 실제 공개 모델은 x86-64 native/pip까지만 실행; 비행 유래 모델 미완 |
| MLIR 고유 기여 | 현재 약함 | 정상 조건에서 artifact-only와 동일; 정규 MLIR pass가 아님 |
| cFS 실증 | 합성 모델에는 강함 | 실제 MLPerf/OPS-SAT 모델의 cFS 셀 부재 |
| 재현성 | 중상이나 정리 필요 | 핵심 artifact는 보존됐지만 외부 모델 변환환경·부트스트랩 핀이 불완전 |
| SCI 투고 준비도 | 미완 | 연구질문·baseline·실제 모델 의미보존·통합 행렬을 재설계해야 함 |

즉, 지금 필요한 것은 결함 시험을 더 추가하는 일이 아니라 다음 세 가지다.

1. **MLIR 고유 기여의 재정의**
2. **실제 비행 유래 모델의 end-to-end cFS/AArch64 실행**
3. **공정한 baseline과 실질적 admission utility 평가**

---

## 3. 이전 검토 이후 실제로 좋아진 점

### 3.1 E26: 부분 메모리 계약의 관측 근거 확보

E26-core는 49개 정의 셀 중 37개 실행 셀에서 다음을 보고한다.

- 관측 범위에서 `HAL peak ≤ bounded_bytes`, 위반 0건
- `B−1` DENY, `B`와 `B+1` ADMIT
- 동일 VMFB라도 런타임 배포 방식에 따라 상수 매핑/할당 분기가 바뀜
- 합성 모델 tightness 범위 `1.00×~45.50×`
- x86-64와 AArch64에서 세 모델의 `both_sound=true`

특히 `stream.resource.try_map` 성공 여부에 따라 상수가 HAL 할당량에 들어가거나 빠진다는 기전을 layout IR과 실행 결과로 연결한 것은 의미가 있다.

### 3.2 외부 모델에서 같은 현상 재현

| 모델 | 출처 | bounded | 배포별 peak | tightness |
|---|---|---:|---:|---:|
| MLPerf Tiny ResNet | CIFAR-10 reference TFLite | 618,856 B | 309,416 / 618,856 B | 2.00× / 1.00× |
| MLPerf Tiny Deep Autoencoder | ToyADMOS reference TFLite | 1,069,632 B | 6,208 / 1,069,632 B | 172.30× / 1.00× |
| MLPerf Tiny VWW | MobileNetV1 계열 | 1,298,952 B | 1,298,952 B(native) | 1.00× |

합성 모델에서만 보이던 현상이 공개 모델에도 나타났다는 점은 진전이다. 또한 ResNet을 도입하면서 내부 호출 스택 해석 결함(D47), 출력 객체 보존에 따른 HAL peak 오염(D50)을 발견한 것도 실제 워크로드 도입의 가치를 보여준다.

### 3.3 E27: 불리한 결과를 숨기지 않음

E27은 정상 조건 8개 모델/타깃 셀에서 VMFB-only 분석과 제안 경로가 동일한 값을 냈음을 보고한다. 이는 기존의 “MLIR이어야만 수치를 얻는다”는 전제를 반증한다.

이 결과를 숨기지 않은 것은 연구 신뢰도에는 긍정적이다. 다만 이를 곧바로 “MLIR의 장점은 두 번째 정보원”이라는 새 결론으로 전환하는 것은 아직 증거가 부족하다.

### 3.4 증거 관리

- 결과보다 먼저 판정 기준을 커밋함
- 잘못된 수집·서술을 D45~D51로 공개 정정함
- 계약, VMFB, layout IR, ELF, raw log를 연결함
- 동적 형상과 미지원 연산을 UNKNOWN/거부로 처리함
- QEMU 지연값을 논문 근거로 쓰지 않음

이 부분은 일반적인 학위 연구 프로토타입보다 훨씬 잘 관리되고 있다.

---

## 4. SCI급 기준에서 논문 성립을 막는 핵심 문제

## 4.1 P0 — E27은 아직 MLIR 고유 기여를 입증하지 못했다

현재 E27의 핵심 결과는 다음이다.

- 정상 조건: VMFB-only `(b)` = 제안 MLIR 경로 `(c)`, 8/8
- 버전 드리프트 1건: `(b)`가 152배 과소 추정, `(c)`는 정상값과 note 출력

그러나 이 비교로 MLIR 우월성을 주장하기 어렵다.

### 문제 1: 기준선이 의도적으로 약하게 고정돼 있다

`e27_baseline_vmfb_only.py`는 `iree-dump-module`의 반환코드·stderr·메타데이터 완전성을 충분히 검사하지 않고, 문서도 “fail-closed guard를 넣지 말라”고 명시한다. 이 기준선이 버전 불일치에서 조용히 틀리는 것은 **정보 수준의 본질적 한계**라기보다 **오류 검사를 생략한 구현 선택**일 수 있다.

SCI 심사자는 다음 반론을 제기할 가능성이 높다.

> VMFB-only 분석기도 dump 실패와 빈 allocation list를 구분하도록 만들면 같은 조건에서 명시적으로 거부할 수 있다. 그러면 관측된 차이는 MLIR 유무가 아니라 구현 품질 차이다.

따라서 현재의 `silent_wrong: b=1, c=0`은 MLIR의 고유 이득을 입증하는 공정한 비교가 아니다.

### 문제 2: 원래 요구한 LLVM IR/ELF-only baseline이 아니다

현재 `(b)`는 VMFB 메타데이터와 VM bytecode disassembly를 읽는다. 이는 LLVM IR/ELF-only 분석과 다르다. 따라서 이전에 설정한 질문인 “MLIR이 LLVM IR 또는 ELF보다 어떤 정보를 보존하는가”는 아직 직접 검증되지 않았다.

### 문제 3: 버전 드리프트 조건이 비대칭이다

3.10 artifact를 3.11 도구로 읽어 실패한 사례는 **도구 호환성 스트레스 시험**으로는 유효하다. 그러나 MLIR 필요성의 본 실험으로 사용하려면 다음이 필요하다.

- 3.10 artifact + 3.10 artifact analyzer
- 3.11 artifact + 3.11 artifact analyzer
- 교차버전 읽기 실패 시 두 분석기 모두의 정책
- 최소 3개 모델 × 복수 버전쌍

현재는 한 모델·한 버전쌍이므로 일반화할 수 없다.

### 판정

E27은 **흥미로운 파일럿 결과**지만 SCI급 핵심 증거로는 부족하다. 현재 제목에서 “MLIR 기반”을 전면에 두려면 반드시 재설계해야 한다.

---

## 4.2 P0 — 실제 공개 모델의 의미 보존이 검증되지 않았다

ResNet과 Deep Autoencoder는 다음 경로로 변환됐다.

`TFLite → tflite2onnx → ONNX opset 변경 → IREE ONNX import → torch/linalg lowering → VMFB`

그러나 저장소에는 다음 비교가 없다.

- 원본 TFLite와 변환 ONNX의 동일 입력 출력 비교
- 원본 TFLite와 최종 IREE의 수치 오차
- argmax/classification 일치
- CIFAR-10 Top-1 또는 ToyADMOS AUC 재확인
- 실제 평가 입력 또는 고정 golden vector

따라서 현재 실험은 **공개 모델의 그래프와 가중치를 가져와 메모리 구조를 실행했다**는 수준이다. “MLPerf Tiny 모델을 의미 보존하여 배치했다”거나 “실제 AI workload에서 end-to-end 검증했다”고 쓰기에는 부족하다.

데이터셋 호스트가 현재 컨테이너에서 차단됐다는 사정은 개발 기록으로는 타당하지만, SCI 논문에서는 범위 밖으로 둘 수 없다. 다른 네트워크에서 공식 데이터셋을 확보하고 checksum과 split을 고정해야 한다.

---

## 4.3 P0 — 실제 모델이 cFS와 AArch64 경로를 통과하지 않았다

현재의 강한 cFS/AArch64 증거는 주로 B0 합성 모델이다. MLPerf Tiny ResNet과 Deep Autoencoder는 x86-64의 pip/runtime와 native C까지만 실행됐다.

따라서 다음 두 문장은 아직 입증되지 않았다.

- “레퍼런스 AI 모델에 대해 cFS가 계약 기반 admission을 수행했다.”
- “레퍼런스 AI 모델이 AArch64 배치 경로에서 같은 계약 성질을 보였다.”

특히 OPS-SAT SmartCam 비행 모델은 아직 반입되지 않았다. 연구가 위성 cFS 배치를 전면에 내세우려면 적어도 **비행 유래 모델 1개가 cFS+AArch64 경로를 완주**해야 한다.

---

## 4.4 P0 — B−1/B/B+1은 유용성보다 비교 연산의 정확성을 검증한다

`B−1`에서 DENY하고 `B`에서 ADMIT하는 결과는 구현의 off-by-one 오류가 없음을 보여준다. 그러나 이것만으로 admission 계약이 실제 배치 판단에 유용하다는 주장은 약하다.

실제 유용성은 다음으로 평가해야 한다.

- 현실적인 앱 메모리 예산 분포에서 몇 개 모델이 배치 가능한가
- source-level 과대 추정 대비 false reject가 얼마나 줄어드는가
- runtime-profile 기반 예산을 다른 배포에 적용할 때 unsafe admit이 발생하는가
- universal worst-case 계약의 보수성 때문에 실제 배치 가능한 모델을 얼마나 거부하는가
- 계약 생성 실패와 수동 override 비율은 얼마인가

현재 관측된 172.3배의 tightness는 오히려 현재 단일 `bounded` 값이 일부 배포에서 실용성이 낮을 수 있음을 보여준다.

---

## 4.5 P0 — 부분 계약의 경계가 논문 제목보다 좁다

현재 계약의 핵심은 다음이다.

`static_per_call_bytes + module_resident_constant_bytes`

하지만 다음은 별도 버킷이거나 제외된다.

- IREE runtime/session 고정비
- cFS 앱 및 OSAL 메모리
- 태스크 stack
- wrapper의 입력·출력 버퍼
- 파일 로드용 임시 메모리
- 여러 앱 또는 여러 동시 추론의 합성 효과

이는 결함이 아니라 연구 범위다. 다만 논문에서는 반드시 **partial per-app model-execution contract**라고 불러야 한다. “온보드 컴퓨터가 모델을 수용 가능한지 판정한다”처럼 전체 메모리 feasibility로 확대하면 심사에서 바로 지적될 수 있다.

---

## 4.6 P1 — 현재 구현은 정규 MLIR pass가 아니다

현재 구조적 추출기는 `--mlir-print-ir-after` 출력 조각을 재구성한 뒤 Python MLIR API로 순회하고, 별도의 정규식 파서와 대조한다. 이는 좋은 연구 프로토타입이지만 다음 한계가 있다.

- pretty-print dump와 pass 이름에 의존
- 분리된 함수 조각을 정규식으로 합성
- 알려진 `stream.resource.*` 연산 whitelist에 의존
- post-processing sidecar가 compiler pipeline 밖에 존재
- entry function 밖의 자원 효과에 대한 명시적 형식화가 부족

SCI급 compiler 논문으로 만들려면 최소한 **IREE/MLIR pass 또는 pass plugin 형태의 분석기**가 동일 IR 상태에서 구조화된 계약을 직접 방출해야 한다.

---

## 4.7 P1 — 레퍼런스 실험환경 고정이 아직 불완전하다

보존된 E14 환경 manifest는 상당히 좋다. IREE commit, cFS 및 submodule commit, QEMU, compiler, guest image hash가 기록돼 있다. 그러나 재구축 스크립트에는 다음 부동 요소가 남아 있다.

- `scripts/10_build_cfs.sh`: cFS `main`을 clone한 뒤 고정 commit checkout 없음
- `scripts/20_setup_onair.sh`: OnAIR commit 고정 없음
- `scripts/30_setup_iree.sh`: `requirements.txt`가 아니라 버전 없는 pip 설치
- `scripts/70_setup_qemu_system_aarch64.sh`: Ubuntu `noble/current` 사용
- TFLite→ONNX 변환 도구와 ONNX/TFLite 패키지 버전이 `requirements.txt`에 없음
- 변환 명령이 실행 가능한 단일 스크립트로 보존되지 않음

현재 artifact 재사용은 가능하지만, 제3자가 처음부터 같은 모델을 만드는 재현성은 충분하지 않다.

---

## 4.8 P1 — 저장소 외부 공개 상태가 논문 artifact로는 정리되지 않았다

- 원격 기본 브랜치가 `claude/review-and-proceed-4y1sag`
- `main`은 `ca329f7`로 E18 시점에 머물러 있음
- 원격 tag가 없음
- README는 현재 버전을 `v0.22.1`이라고 표시하지만 실제 정본은 `v0.29`
- PROGRESS 상단도 최신 근거를 E26 중간 문서로 가리키는 부분이 남음
- E26 통합 `summary.json`에는 VWW만 ext로 포함되고, 나중의 ResNet/DeepAE는 별도 summary에 분산

이는 실험 결과를 반증하지 않지만, 심사자·재현 평가자가 정본을 찾기 어렵게 한다.

---

## 5. 이전 레퍼런스 벤치마크 구성안에서 정정할 사항

이전 구성안의 B1은 반드시 정정해야 한다.

### 5.1 서로 다른 두 OPS-SAT 모델을 혼동하면 안 된다

| 구분 | OPS-SAT SmartCam 비행 저장소 | 이후 OPS-SAT/Kelvins 경쟁 사양 |
|---|---|---|
| 모델 | MobileNetV2 전이학습 계열 | EfficientNet-Lite0 계열 |
| 입력 | `[1,224,224,3]` FP32 | `[1,200,200,3]` 계열 사양 |
| 출력 | 3개: `bad/earth/edge` | 8개 클래스 |
| 정밀도 | FP32 TFLite | float16 제출 사양 |
| 연구상 지위 | 공개된 실제 SmartCam 비행 artifact | 비행 캠페인과 연결된 별도 경쟁 reference |

따라서 B1의 1순위는 **공개 비행 artifact인 SmartCam MobileNetV2**로 바꾼다. EfficientNet-Lite0은 별도의 `B1b competition-derived`로 구분해야 한다.

### 5.2 권장 벤치마크 세트

| ID | 모델 | 역할 | 필수 여부 |
|---|---|---|---|
| B0 | canonical/conv2d/multibranch/dynamic | 회귀·경계·fail-closed | 필수, 본문 비중 축소 |
| B1 | OPS-SAT SmartCam MobileNetV2 FP32 | 실제 비행 유래 주 사례 | **필수** |
| B2 | MLPerf Tiny ResNet/CIFAR-10 | 표준 CNN | 필수 |
| B3 | MLPerf Tiny DeepAE/ToyADMOS | 비-CNN, 상수 지배형 | 필수 |
| B4 | MLPerf Tiny VWW/MobileNetV1 | depthwise CNN 다양성 | 권장 |
| 제외 | OrbitAI 온라인 AROW/RF | 현재 IREE tensor inference 범위 밖 | 제외 유지 |

VWW는 이미 VMFB와 native sweep이 존재하므로 버릴 이유가 없다. 다만 B2/B3와 함께 하나의 통합 결과표와 provenance manifest로 합쳐야 한다.

---

## 6. SCI급으로 재설계한 연구질문

### RQ1 — 계약 추출의 soundness와 coverage

> 제안 MLIR pass가 지원한다고 선언한 정적 모델에서, 동일 경계의 런타임 HAL peak를 포괄하며 미지원 조건을 명시적으로 거부하는가?

- 지표: observed violation, extraction success/refusal, unsupported op, manual override
- 주장: 경험적 soundness로 한정
- 모델: B0~B4
- 타깃: x86-64와 AArch64

### RQ2 — 계약은 실제 배치 판단에 얼마나 유용한가

> 제안 계약이 source estimate보다 false reject를 줄이고, runtime-profile-only 정책보다 배포 변경 시 unsafe admit을 줄이는가?

- 지표: false reject, unsafe admit, slack, tightness, admission coverage
- 예산: `B±1`뿐 아니라 실제 모델 크기를 가르는 다수의 고정 예산점
- 비교: source estimate, runtime profile, universal MLIR bound, conditional MLIR bound

### RQ3 — MLIR 정보가 공정한 저수준 기준선보다 무엇을 더 제공하는가

> matched toolchain 조건에서 MLIR 분석이 LLVM IR/ELF 및 robust VMFB 분석보다 coverage, tightness, 진단 가능성 또는 버전 안정성을 개선하는가?

- 정상 조건과 호환성 스트레스를 분리
- 각 artifact는 우선 같은 버전의 도구로 분석
- 교차버전은 별도 robustness 연구질문으로 분리
- 고의로 오류 검사를 제거한 기준선 사용 금지

### RQ4 — cFS/AArch64 통합에서도 모델 의미와 계약 판정이 유지되는가

> 동일 원본 모델·가중치·입력이 standalone, cFS x86-64, cFS AArch64에서 허용오차 내 동일 출력을 내고 동일 admission 정책을 따르는가?

- 실제 레퍼런스 모델 최소 3개 포함
- OPS-SAT B1 필수
- QEMU에서는 기능·계약만 주장

---

## 7. 권장 핵심 기여: 조건부 메모리 계약

E26의 가장 중요한 발견은 단순한 `P≤B`가 아니라 **같은 VMFB의 상수 처리 분기가 배포별로 달라져 tightness가 최대 172.3배 차이 난다**는 점이다.

현재처럼 항상 최악 분기를 합치면 sound하지만 지나치게 보수적이다. 이를 논문의 새 핵심으로 발전시키는 것이 가장 타당하다.

### 제안 계약

```text
B_map   = per_call
B_copy  = per_call + module_constants
B_worst = max(B_map, B_copy)
precondition(map) = loader/runtime이 constant mapping 성공을 보장
```

cFS admission은 다음처럼 동작한다.

- 배포 manifest가 `map` 전제조건을 검증하면 `B_map`
- 전제조건을 증명하지 못하면 `B_worst`
- 런타임이 map 실패 후 copy fallback을 허용한다면 `B_copy` 여유 없이는 시작 거부

이 방향의 장점은 다음과 같다.

1. E26의 172.3배 보수성을 직접 해결한다.
2. MLIR의 `try_map → scf.if → alloc fallback` 구조를 path-sensitive하게 분석하는 이유가 생긴다.
3. 단순 VMFB 숫자 복구가 아니라 **분기 조건과 배포 전제조건을 포함한 계약**으로 기여가 상승한다.
4. admission utility를 false reject 감소로 정량화할 수 있다.

단, `map` 성공을 단순 관측으로 가정하면 안 된다. loader 설정 또는 artifact 배치 방식으로 성공 조건을 강제·검증할 수 있어야 한다.

---

## 8. 공정한 baseline 구성

| Baseline | 구현 요구 | 비교 목적 |
|---|---|---|
| BL0 Source estimate | 텍스트상 tensor occurrence 합이 아니라 정의된 graph-liveness 방법 | lowering 정보 부재 비용 |
| BL1 Robust VMFB-only | 반환코드, bytecode version, 빈 allocation list, ABI 완전성 검사 | self-contained artifact 분석 가능성 |
| BL2 LLVM IR/ELF-only | 동일 compile의 `.ll`/ELF에서 allocation/runtime call 복구 | MLIR 구조 보존의 실제 이득 |
| BL3 Runtime profile | 배포별 HAL peak | profiling의 배포 종속성 |
| P Proposed MLIR pass | 동일 IR 지점에서 구조화 계약 방출 | coverage, tightness, 진단, 조건부 계약 |

### 필수 공정성 규칙

- 같은 모델, 같은 컴파일 호출, 같은 타깃을 비교
- 정상 조건은 matched compiler/analyzer version 사용
- 모든 분석기에 동일 fail-closed 요구 적용
- 사람이 수동으로 알려 준 정답이나 다른 분석기의 값을 baseline에 주입하지 않음
- 각 분석기의 실패는 `unsupported`, `parse_failure`, `incomplete_evidence`로 구분
- version mismatch는 정상 정확도 표가 아니라 별도의 robustness 표에 배치

---

## 9. 권장 실험 행렬

### 9.1 필수 본 실험

| 축 | 값 |
|---|---|
| 모델 | B1 SmartCam, B2 ResNet, B3 DeepAE, B4 VWW |
| 회귀 모델 | B0 4종 |
| 타깃 | x86-64 generic, AArch64 Cortex-A53 |
| 실행 경로 | IREE native C, cFS+IREE |
| 상수 정책 | mapped, copied/fallback, unknown→worst-case |
| 계약 방식 | source, robust VMFB, LLVM/ELF, MLIR universal, MLIR conditional |
| 예산점 | 모델 사이를 구분하는 고정 예산 grid + 각 계약 경계점 |
| 의미 검증 | 원 TFLite, 변환 ONNX, IREE native, cFS x86-64, cFS AArch64 |

전체 Cartesian product를 무조건 돌릴 필요는 없다. 다음 최소 조합이면 된다.

- 모든 모델: x86-64 native에서 모든 계약 방식 비교
- B1~B3: x86-64 cFS에서 admission+output
- B1 및 B2 또는 B4: AArch64 cFS에서 admission+output
- 모든 모델: matched-version VMFB/MLIR 분석
- 대표 3모델: 2~3개 IREE 버전에서 compiler-evolution robustness

### 9.2 입력과 반복

- 메모리 계약: 정적 shape에서는 입력값보다 allocation plan이 핵심이므로, 서로 다른 공식 입력 10개로 값 독립성을 확인
- 의미 동치: 공식 validation/test split 전체 또는 사전에 정한 층화 subset 사용
- 프로세스 전역 HAL 통계: 각 셀을 독립 프로세스로 최소 5회 재시작해 분기와 peak 결정성 확인
- 컴파일 재현성: 모델×타깃마다 5회 컴파일해 계약값 안정성과 artifact hash 변동을 분리 보고
- latency: QEMU에서 제외. 실제 하드웨어를 사용할 때만 별도 통계 설계

결정론적 카운터에 무의미한 p-value를 붙이지 않는다. 대신 모델·타깃·컴파일러 버전·배포 방식이 독립적인 일반화 단위가 되도록 구성한다.

### 9.3 의미 동치 기준

| 단계 | 판정 |
|---|---|
| TFLite ↔ ONNX | 동일 공식 입력에서 출력 오차 + argmax/decision 일치 |
| ONNX ↔ IREE x86 | 정밀도별 사전 허용오차 |
| IREE x86 ↔ IREE AArch64 | 서로 다른 VMFB이므로 허용오차 + decision 일치 |
| standalone ↔ cFS | 같은 VMFB라면 가능하면 bit identity, 아니면 사유와 허용오차 명시 |
| 품질 guardrail | CIFAR-10 Top-1, ToyADMOS AUC 등 원 벤치마크 기준 재현 |

---

## 10. cFS 앱에서 먼저 고쳐야 할 실험 차단점

현재 `AI_LEARNER`는 큰 영상 입력을 스택의 `float feat[CONTRACT_INPUT_ELEMS]`로 잡는다. OPS-SAT 입력은 약 602 KB이므로 현재 256 KiB대 태스크 스택을 초과한다.

이 문제는 연구 주제 확장이 아니라 실제 모델을 넣기 위한 필수 integration 수정이다.

권장:

1. 입력을 HAL buffer에 직접 기록하거나 계약 기반 heap/static arena로 이동
2. 입출력 버퍼를 계약의 별도 항목으로 명시
3. 단일 f32 입출력 hardcode를 모델 manifest 기반으로 일반화
4. SmartCam의 `SQUEEZE` 변환은 등가 `RESHAPE` 치환 스크립트와 TFLite↔IREE golden test로 검증

이 네 가지를 해결하기 전에는 B1을 “cFS 배치 실험”이라고 부를 수 없다.

---

## 11. 재현성 정비 목록

### 반드시 수정

- cFS와 OnAIR clone 직후 정확한 commit checkout
- `scripts/30_setup_iree.sh`가 `requirements.txt`를 사용하도록 통일
- guest image URL을 날짜 고정 URL 또는 checksum 검증 다운로드로 변경
- `tflite2onnx`, ONNX, TFLite schema 도구 버전 고정
- 외부 모델 변환을 `scripts/build_reference_models.sh` 같은 단일 스크립트로 보존
- 원본 모델·변환 중간물·최종 VMFB hash를 하나의 manifest로 연결
- B1~B4의 고정 평가 입력과 golden output hash 보존
- E26/E27 결과를 단일 machine-readable table로 통합

### 공개 artifact 정리

- 연구 branch를 `main`에 병합
- 논문 실험 스냅샷 tag/release 생성
- README의 현재 버전과 재현 명령 갱신
- `PROGRESS.md` 대신 `PAPER_STATUS.md` 또는 최신 단일 정본 제공
- GitHub Actions에 최소 1개의 end-to-end contract regeneration job 추가

현재 CI는 음성·회귀시험에는 강하지만, 보존 결과를 다시 읽는 시험 비중이 높다. SCI artifact에는 최소 한 모델을 처음부터 변환·컴파일·계약 생성·실행하는 end-to-end CI가 필요하다.

---

## 12. 논문에 넣지 말아야 할 작업

- 손상 VMFB, 해시 위조, 공급망 공격을 추가 확장
- fail-closed 음성 테스트 수를 계속 늘리는 것
- QEMU latency·WCET·전력 측정
- 실제 모델이 없는 상태에서 합성 모델 shape만 더 늘리는 것
- OnAIR를 통과하지 않은 결과를 OnAIR 통합으로 표현
- cFS open-source bundle을 flight-qualified system으로 표현
- artifact-only baseline을 일부러 약하게 둔 뒤 MLIR 우위를 주장

손상 artifact 시험과 50여 건의 결함 원장은 구현 신뢰성의 보조 증거로 부록에 둘 수 있지만, 본문의 연구 기여로 확대하지 않는다.

---

## 13. 권장 실행 순서

### 1단계 — 논문 기반 정리

1. README/default branch/release 정리
2. 외부 모델 변환환경과 데이터셋 provenance 고정
3. E26/E27 통합 결과 테이블 생성

### 2단계 — 레퍼런스 모델 end-to-end 완결

1. ResNet·DeepAE의 TFLite↔IREE 의미 동치와 품질 기준 확인
2. MLPerf 모델 cFS x86-64 실행
3. cFS 입력버퍼 구조 수정
4. OPS-SAT SmartCam B1 변환·동치·cFS x86-64 실행
5. B1 및 대표 MLPerf CNN의 AArch64 cFS 실행

### 3단계 — MLIR 기여 재구성

1. 정규 MLIR analysis pass 구현
2. `B_map/B_copy/B_worst` 조건부 계약 생성
3. robust VMFB-only와 LLVM IR/ELF-only baseline 구현
4. matched-version 정상 비교
5. compiler-evolution robustness 비교

### 4단계 — 실질적 utility 평가

1. 현실적인 예산 grid 사전 등록
2. 정책별 false reject/unsafe admit 비교
3. conditional contract가 worst-case 계약보다 배치 가능성을 얼마나 개선하는지 측정
4. 모델·ISA·컴파일러 버전별 coverage와 tightness 보고

---

## 14. 최종 연구 방향

현재 결과를 가장 강한 논문으로 만드는 방향은 다음이다.

> **MLIR에서 IREE의 path-dependent allocation plan을 추출해, 런타임 상수 매핑 정책에 따른 조건부 부분 메모리 계약을 생성하고, 이를 NASA cFS의 실행 전 admission에 적용한다.**

이 방향은 현재 확보한 결과를 버리지 않는다.

- E25: 의미 동치 인프라
- E26: 배포에 따른 map/copy 분기와 최대 172.3배 tightness 차이
- E27: 단순 숫자는 artifact-only에서도 얻어진다는 반증

오히려 세 결과가 논리를 만든다.

1. 같은 AI 의미를 여러 실행 경로에서 유지할 수 있다.
2. 단일 worst-case 숫자는 sound하지만 배포에 따라 매우 보수적이다.
3. 단순 숫자 추출만으로는 MLIR 기여가 약하다.
4. 따라서 MLIR의 구조적 분기·전제조건을 이용한 **조건부 계약**이 실제 신규 기여가 된다.

현재 저장소는 이 논문을 시작할 기반으로는 충분히 강하다. 그러나 지금 그대로 제출하면 심사자는 **“왜 MLIR인가”, “실제 모델이 cFS에서 실행됐는가”, “B±1이 왜 실용적 유용성인가”**를 핵심 약점으로 지적할 가능성이 높다.

---

## 15. 참고할 공식·일차 자료

1. NASA cFS: <https://github.com/nasa/cFS>
2. NASA OnAIR: <https://github.com/nasa/OnAIR>
3. IREE: <https://github.com/iree-org/iree>, <https://iree.dev/>
4. MLPerf Tiny: <https://mlcommons.org/working-groups/benchmarks/tiny/>, <https://github.com/mlcommons/tiny>
5. OPS-SAT SmartCam: <https://github.com/georgeslabreche/opssat-smartcam>
6. OPS-SAT competition: <https://kelvins.esa.int/opssat/submission-rules/>
7. OPS-SAT SmartCam paper: <https://doi.org/10.1109/AERO53065.2022.9843402>
8. OPS-SAT competition paper: <https://doi.org/10.1007/s42064-023-0196-y>

