# 메모리 계약 승인·거절 메커니즘의 핵심 검증 지침

> 대상: \`wookjaeya/onAIR-MLIR\`  
> 기준 커밋: [\`2f730852\`](https://github.com/wookjaeya/onAIR-MLIR/commit/2f73085277f31149dd69b1808b69365eeff8c11f)  
> 목적: 메모리 계약의 승인·거절을 편의적인 비교 기능이 아니라, 정의된 조건과 회계 범위에서 근거 있는 실행 전 판단으로 확립한다.  
> 범위: 상한의 건전성, 실행 전제 충족, 예산과 회계 범위의 일치.  
> 표기: 저장소에서 확인한 내용은 **현재 상태**, 추가로 검증해야 할 내용은 **필요 작업**, 해석·권고는 **분석 판단**으로 표시한다.

---

## 1. 먼저 확정해야 할 연구 명제

이 연구가 검증해야 할 명제는 다음과 같다.

\[
\forall e \in A,\quad M_S(e) \le U_S
\]

그리고 동일한 회계 범위 \(S\)에 대해

\[
U_S \le B_S
\]

이면 다음이 성립한다.

\[
M_S(e) \le U_S \le B_S
\]

| 기호 | 의미 |
|---|---|
| \(e\) | 한 번의 지원되는 모델 실행 |
| \(A\) | 상한이 유효하기 위해 실행환경이 만족해야 하는 전제 집합 |
| \(S\) | 계약·예산·관측치가 공통으로 사용하는 메모리 회계 범위 |
| \(M_S(e)\) | 실행 \(e\)가 회계 범위 \(S\)에서 실제 사용한 최대 메모리 |
| \(U_S\) | 컴파일 산출물에서 계산한 회계 범위 \(S\)의 정적 상한 |
| \(B_S\) | 배포자가 회계 범위 \(S\)에 부여한 예산 |

승인 비교 \(U_S \le B_S\)는 단순하다. 연구적으로 검증할 부분은 다음 세 가지다.

1. **상한의 건전성:** 지원되는 모든 실행에서 \(M_S(e)\le U_S\)인가?
2. **실행 전제 충족:** 실제 OnAIR/cFS 실행이 \(A\)를 만족하는가?
3. **회계 일치:** \(U_S\), \(B_S\), \(M_S(e)\)가 같은 메모리 영역을 가리키는가?

세 항목 중 하나라도 성립하지 않으면 승인 결과의 의미가 약해진다.

---

## 2. 승인과 거절의 정확한 의미

### 2.1 승인

\[
A \land U_S\le B_S
\]

가 확인되면 다음과 같이 해석한다.

> 정의된 실행 전제 \(A\)와 회계 범위 \(S\)에서, 분석 대상 메모리 사용량이 예산 \(B_S\)를 초과하지 않는다는 근거가 있으므로 실행을 허용한다.

승인은 다음을 의미하지 않는다.

- 전체 프로세스 RSS가 예산 이내라는 보장
- 전체 OBC의 가용 RAM이 충분하다는 보장
- 태스크 스택·cFS·OSAL·IREE 런타임 전체를 포함한 보장
- 물리 메모리가 예산만큼 예약됐다는 보장

### 2.2 거절

\[
U_S>B_S
\]

에서 다음 명제는 일반적으로 성립하지 않는다.

\[
U_S>B_S \nRightarrow M_S(e)>B_S
\]

따라서 거절은 다음과 같이 해석한다.

> 현재 분석 결과와 실행 전제에서는 해당 예산 안에서 실행된다고 보장할 수 없으므로 허용하지 않는다.

“실제로 실행하면 반드시 메모리가 부족하다” 또는 “실행 자체가 불가능하다”로 해석하지 않는다.

### 2.3 상한 불명

동적 크기, 미지원 resource operation 또는 불완전한 계약 때문에 \(U_S\)를 계산할 수 없으면 현재 정책은 \`REFUSED_UNKNOWN_BOUND\`를 반환한다. 이는 건전성 우선의 정책 선택이다. 학술적 개념에서 자동으로 도출되는 유일한 정책은 아니지만, 지원 범위를 벗어난 값을 추측해 승인하지 않는다는 점에서 타당하다.

현재 결정 함수: [\`harness/admission_policy.py\`](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/harness/admission_policy.py)

---

## 3. 학술적·기술적 근거와 직접 설계 요소

| 요소 | 선행 근거 | 이 연구가 직접 설계한 것 |
|---|---|---|
| 가정과 보장의 계약 | Assume–Guarantee 및 contract-based design | 메모리 회계 필드와 구체적인 전제 |
| 실행 전 자원 상한 | 정적·정량적 자원 분석 | IREE post-layout IR의 추출·합산 규칙 |
| 버퍼 수명과 재사용을 반영한 계획 | TFLM, ExecuTorch, TVM 등의 memory planning | IREE stream 산출물을 독립 계약으로 외부화 |
| 요구량과 가용량의 실행 전 비교 | admission control·resource reservation 분야 | OnAIR/cFS의 구체적인 판정 위치와 상태명 |
| JSON 계약 | 일반적인 직렬화 수단 | JSON 스키마, 필드명, \`ADMIT\`·\`NOT_ADMITTED\` 상태 |
| 조건부 map 승인 | 전제를 만족할 때 더 강한 보장을 적용하는 조건부 추론 | IREE의 map/copy 동작과 64바이트 정렬을 이용한 정책 |

### 주요 레퍼런스

1. **계약 기반 설계**  
   Benveniste et al., *A Generic Model of Contracts for Embedded Systems*, INRIA RR-6214, 2007, §2–§4.  
   https://arxiv.org/abs/0706.1456

2. **계약 이론의 체계화**  
   Benveniste et al., *Contracts for System Design*, Foundations and Trends in Electronic Design Automation, 2018.  
   DOI: https://doi.org/10.1561/1000000053

3. **정적 자원 상한과 건전성**  
   Lichtman and Hoffmann, *Arrays and References in Resource Aware ML*, FSCD 2017, 특히 soundness theorem과 cost semantics. 여기서 ML은 머신러닝이 아니라 프로그래밍 언어 계열을 뜻한다.  
   DOI: https://doi.org/10.4230/LIPIcs.FSCD.2017.26

4. **임베디드 AI 메모리 계획**  
   David et al., *TensorFlow Lite Micro: Embedded Machine Learning on TinyML Systems*, MLSys 2021, §4.1–§4.6.  
   https://proceedings.mlsys.org/paper_files/paper/2021/file/6c44dc73014d66ba49b28d483a8f8b0d-Paper.pdf

5. **TFLM 공식 메모리 구조**  
   head·temporary·tail arena와 offline allocation plan 설명.  
   https://github.com/tensorflow/tflite-micro/blob/main/tensorflow/lite/micro/docs/memory_management.md

6. **ExecuTorch 공식 memory planning**  
   텐서 lifetime, planned memory, 입력·출력 포함 여부와 외부 버퍼의 구분.  
   https://docs.pytorch.org/executorch/stable/compiler-memory-planning.html

7. **TVM Unified Static Memory Planning**  
   buffer information, workspace/constant pool, compile-time offset 계획.  
   https://github.com/apache/tvm-rfcs/blob/main/rfcs/0009_Unified_Static_Memory_Planning.md

위 레퍼런스는 계약·상한·memory planning의 개념적 근거다. **이 연구의 계산식과 승인 결과를 대신 증명하지는 않는다.** 현재 구현의 타당성은 아래 검증으로 별도로 확보해야 한다.

---

# Part I. 상한의 건전성 검증

## 4. 검증 대상 상한의 정의

현재 저장소의 메모리 성분은 다음처럼 정리할 수 있다.

\[
P = I + O_{\text{slab}} + T_{\text{slab}}
\]

\[
U = P + C_{\text{packed}}
\]

| 성분 | 현재 의미 |
|---|---|
| \(I\) | \`stream.tensor.import\`로 확인한 외부 입력 resource 크기 |
| \(O_{\text{slab}}\) | \`stream.resource.alloca\`의 external 출력 slab 크기 |
| \(T_{\text{slab}}\) | post-layout transient slab 크기 |
| \(C_{\text{packed}}\) | 패딩을 포함한 module-resident packed constant 크기 |
| \(P\) | 호출당 분석 대상 메모리 |
| \(U\) | 상수 copy 가능성까지 포함한 무조건 상한 |

현재 구현: [\`harness/static_mem_bound.py\`](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/harness/static_mem_bound.py)  
계약의 분석 영역: [E40](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.43_E40.md)

### 주의

- 출력 텐서 크기의 단순 합과 출력 slab의 할당 크기는 다를 수 있다.
- 상수의 dense tensor 합과 packed constant 크기는 정렬 패딩 때문에 다를 수 있다.
- post-layout slab는 이미 lifetime·reuse를 반영한 컴파일 결과다.
- map 경로에서는 상수를 HAL에 별도로 복사하지 않을 수 있지만 모델 이미지의 상수 바이트가 전체 CPU RAM에서 사라지는 것은 아니다.
- \(U\)는 현재 계약이 정의한 부분 회계 범위의 상한이며 전체 프로세스 상한이 아니다.

## 5. 검증 질문

### SND-1. 분석 대상 할당을 빠짐없이 식별하는가?

확인할 것:

- entry function의 모든 \`stream.resource.*\`, \`stream.tensor.*\` operation
- 지원 operation whitelist와 실제 관측 operation 집합
- 새 operation이 추가됐을 때 \`unresolved\`로 이동하는지
- 여러 줄 pretty printing, 여러 함수, initializer와 entry 분리
- 동적 크기 또는 해석 불가 symbol이 상한 0이나 누락으로 처리되지 않는지

**완료 기준**

- 지원 operation마다 “새 할당 / 기존 resource의 view / 해제 / import / export” 분류표가 있다.
- 알 수 없는 resource-producing operation을 주입하면 \`UNKNOWN_BOUND\`가 발생한다.
- 동적 크기 fixture가 상한값을 생성하지 않는다.
- 각 실패가 자동 검사와 원시 결과에 남는다.

### SND-2. 할당별 크기 계산이 정확한가?

확인할 것:

- 입력 byte 수 = element 수 × dtype byte 수
- external output은 선언 출력의 합이 아니라 실제 slab 크기로 계상
- transient slab의 실제 post-layout 크기
- packed constant의 패딩·정렬
- subview가 원본 범위를 벗어나면 거절
- 여러 slab가 있을 경우 총 peak 계산 방식

**필요 작업**

각 모델마다 다음 형태의 추적표를 생성한다.

| 모델 | IR operation 또는 객체 | 분류 | 크기 산출 근거 | 계약 성분 | 독립 추출값 | 일치 |
|---|---|---|---:|---|---:|---|
| 예: ResNet | 특정 external alloca | 출력 slab | 상수 index operand | O | walker 값 | PASS/FAIL |

**완료 기준**

- 계약의 \(I,O,T,C\)가 추적표의 합과 일치한다.
- 정규식 추출기와 독립 walker가 같은 원천을 공유해서 생긴 가짜 일치가 아님을 확인한다.
- 기존 회귀 테스트 개수만 제시하지 않고 대표 모델의 실제 할당 추적을 보존한다.

### SND-3. 수명·재사용을 상한 계산에 올바르게 반영하는가?

확인할 것:

- 동일 slab 안에서 겹치지 않는 텐서 lifetime
- 여러 slab가 동시에 존재하는 구간
- 입력·출력·transient·constant가 동시에 살아 있는 시점
- 출력이 호출 이후까지 살아 있는 경우
- 초기화 시 상수 할당과 추론 시 할당의 중첩

**완료 기준**

- “왜 합을 쓰는가” 또는 “왜 max를 쓰는가”를 각 성분에 대해 설명할 수 있다.
- 해당 설명이 IR의 lifetime 또는 실제 API 호출 순서와 연결된다.
- 병렬 호출·출력 보유 등 전제를 벗어나는 경우 상한의 적용 범위가 명시된다.

### SND-4. 실행 관측이 상한을 반증하지 않는가?

각 모델·타깃에 대해 같은 회계 범위의 관측값 \(H\)를 수집하고 다음을 검사한다.

\[
H \le U
\]

조건부 map 승인에서는 다음을 검사한다.

\[
H \le P
\]

**중요:** 여러 입력에서 \(H\le U\)가 관측됐다는 사실은 상한의 보조 증거이며 보편적인 수학적 증명은 아니다. 구조 분석과 실행 관측을 함께 제시한다.

**필요 셀**

| 모델 | 타깃 | 입력 | 분기 | 비교 |
|---|---|---|---|---|
| ResNet | AArch64 cFS | 실제 CIFAR-10 | 실제 관측 arm | H≤승인 예산 |
| SmartCam | AArch64 cFS | 실제 OPS-SAT 이미지 | map/copy 기록 | H≤승인 예산 |
| DeepAE | AArch64 cFS | 실제 log-mel | 실제 관측 arm | H≤승인 예산 |
| WGAN | AArch64 cFS | 실제 noised 영상 | 실제 관측 arm | H≤승인 예산 |

현재 AArch64 합성 입력 근거: [E36b summary](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e36b_aarch64_models/summary.json)  
현재 실입력 근거: [E45 summary](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e45_real_inputs/summary.json), [E46](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.46_E46.md)

---

# Part II. 실행 전제 충족 검증

## 6. 전제별 검증표

| 전제 | 현재 상태 | 필요한 확인 | 위반 시 처리 |
|---|---|---|---|
| 고정 형상 | 계약 생성 과정에서 derived 값으로 확인 | 동적 fixture에서 상한 미생성 확인 | \`REFUSED_UNKNOWN_BOUND\` |
| 지원 resource operation | whitelist와 독립 walker 존재 | 실제 네 모델 operation inventory 보존 | 미지원 시 상한 미생성 |
| 최대 in-flight 호출 1개 | cFS C 앱은 순차 구조, E41 직접 API에서 동시 호출 영향 관측 | 배포 경로에 child task·병렬 invoke가 없는지 검사 | 현재 보장 범위 밖 |
| 다음 호출 전 출력 수명 종료 | cFS는 release 경로 존재; OnAIR은 실제 해제 미검증 | OnAIR의 live bytes·누적 할당/해제 관측 | 조건 미확인으로 표시 |
| 계약에 선언된 HAL driver | C 헤더와 OnAIR 검사 경로 존재 | 잘못된 driver에서 실행 전 거절 확인 | 거절 |
| conditional map 전제 | 정렬·실제 arm 확인 코드 존재 | 승인 전제와 실제 arm을 동일 실행에 기록 | 전제 실패 시 추론 전 거절 |
| 한 모델·한 호출의 계약 | 현재 계약 범위 | 동시 모델/다중 앱으로 확대 해석하지 않음 | 별도 연구 문제 |

현재 전제 정의: [E40 §3](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.43_E40.md)  
전제 프로브: [E41](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.44_E41.md)

## 7. 가장 중요한 추가 전제 실험

### PRE-1. AArch64 cFS 순차성 확인

**목적:** 실제 cFS 경로가 \`max_in_flight_calls=1\`을 만족하는지 확인한다.

**방법**

- IREE invoke 진입과 종료에 단조 증가 call ID를 기록한다.
- 현재 active call 수와 최대 active call 수를 기록한다.
- 테스트 동안 \`max_active_calls == 1\`인지 확인한다.
- cFS child task, OS task, pthread 경로가 없는지 코드 검사 결과를 함께 남긴다.

**판정**

- PASS: 모든 기록에서 최대 active call 수가 1이고 별도 병렬 invoke 경로가 없다.
- FAIL: 두 호출의 진입·종료 구간이 겹친다.
- UNKNOWN: 로그가 호출 중첩 여부를 판별할 수 없다.

### PRE-2. OnAIR 출력 수명 확인

**목적:** \`released_before_next_call\` 전제가 공식 loader 경로에서 실제로 성립하는지 확인한다.

**방법**

- 모델 로딩 후, invoke 직후, 출력 복사·소비 후, 다음 invoke 직전의 live HAL bytes를 기록한다.
- 누적 peak만 사용하지 말고 현재 live bytes 또는 allocated−freed 값을 기록한다.
- 동일 입력 집합을 사전 고정한 횟수만큼 순차 실행한다.
- Python 참조 삭제와 실제 HAL release를 구분한다.

**판정**

- PASS: 다음 호출 전 이전 호출의 출력 buffer가 live set에서 제거되고 반복 사이 증가하지 않는다.
- FAIL: 이전 출력 buffer가 다음 호출까지 유지되어 계약이 계상하지 않은 중첩이 생긴다.
- UNKNOWN: runtime API가 live bytes를 제공하지 않거나 식별할 수 없다.

**주의:** 제한된 반복에서 증가가 없다는 사실을 모든 미래 실행에 대한 무누수 증명으로 확대하지 않는다.

### PRE-3. conditional map 전제 확인

**목적:** \(P\le B<U\)에서 승인할 때 실제 실행이 작은 상한 \(P\)를 만족하는 arm인지 확인한다.

**방법**

1. opt-in 여부, VMFB blob 주소 정렬, 예산 B를 실행 기록에 남긴다.
2. runtime 생성 전 확인 가능한 정렬 조건을 검사한다.
3. module append 직후 HAL peak와 실제 arm을 기록한다.
4. copy arm이면 추론을 시작하지 않는다.
5. 승인된 예산과 추론 peak를 비교한다.

**판정**

- PASS: map arm이고 \(H\le P\), 추론 정상 실행.
- FAIL: copy arm인데 추론을 실행했거나 \(H>P\).
- SAFE REFUSAL: 전제 불충족을 탐지하고 추론 전에 종료.
- UNKNOWN: arm 또는 peak가 기록되지 않음.

현재 근거: [E38 summary](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e38_optin_record/summary.json)

---

# Part III. 예산과 회계 범위 일치 검증

## 8. 회계 범위를 한 문장으로 고정한다

현재 계약의 권장 정의는 다음과 같다.

> **회계 범위 \(S\): 한 모델의 단일 지원 추론 호출에 대해 IREE stream post-layout에서 식별되는 외부 입력 resource, 외부 출력 slab, transient slab 및 조건에 따라 HAL에 복사되는 module-resident packed constant.**

현재 범위에서 제외되는 것으로 저장소가 명시한 항목:

- IREE VM·HAL device·module table 등 런타임 고정비
- cFS core·OSAL 및 다른 cFS 앱의 메모리
- cFS AI_LEARNER 태스크 스택
- wrapper의 CPU-side 입력·출력 배열과 정적 BSS
- 전체 프로세스 RSS와 시스템 가용 RAM
- 다른 모델·앱과의 동시 실행 메모리

계약 범위의 현재 근거: [E40](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.43_E40.md)

## 9. 세 숫자의 범위를 대조한다

| 값 | 생성 주체 | 단위 | 포함 영역 | 제외 영역 | 같은 시점의 값인가? |
|---|---|---|---|---|---|
| \(U_S\) | 계약 생성기 | byte | 명시 필요 | 명시 필요 | compile-time |
| \(B_S\) | 배포 설정/cFS 설정 | byte | 반드시 \(S\)로 정의 | 전체 RAM과 구분 | admission-time |
| \(H_S\) | HAL allocator 관측 | byte | allocator가 실제 세는 영역 | allocator 밖 메모리 | runtime |

**필요 작업:** 모델·실행 셀마다 위 표를 채우고 세 값의 범위가 다르면 직접 비교하지 않는다.

### ACC-1. 예산 출처와 의미 확인

현재 예산은 다음 경로에서 공급된다.

| 실행 경로 | 예산 출처 | 현재 성격 |
|---|---|---|
| OnAIR | deployment JSON의 \`budget_bytes\` | 선언된 앱 예산 |
| cFS | compile-time macro 또는 초기화 override | 선언된 앱 예산 |
| native 도구 | 명령행 인자 | 실험 입력 |

근거: [E44 summary](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e44_budget_provenance/summary.json)

현재 코드는 이 예산만큼의 물리 RAM을 예약하는 구조로 확인되지 않았다. 따라서 admission은 **선언된 부분 예산에 대한 정책 판정**이다.

### ACC-2. 예산값의 두 목적을 분리한다

| 예산값 | 목적 | 해석 |
|---|---|---|
| \(B=U\) | 승인 경계의 포함 여부 확인 | 정수 비교 구현 검증 |
| \(B=U-1\) | 승인 경계 바로 아래 거절 확인 | 실제 OOM 증명 아님 |
| \(B<P\) | 분석 대상 호출 요구량보다 부족한 구간 | 거절 예상 |
| \(P\le B<U\) | map 조건부 정책의 추가 허용 구간 | opt-in·실제 arm 필요 |
| 실제 시스템 할당 예산 | 배포 가능성 판단 | 예산의 산출·권한·범위 근거 필요 |

현재 \(U\)와 \(U-1\) 실험은 정책 경계 검사로 타당하다. 이를 현실적인 위성 메모리 예산이라고 부르려면 별도의 근거가 필요하다.

### ACC-3. wrapper와 스택을 별도 원장으로 남긴다

WGAN에서 출력 배열을 자동 변수에서 static으로 옮긴 것은 task stack 초과 가능성을 줄였지만 전체 RAM을 줄인 것은 아니다. 다음 원장을 계약과 함께 기록한다.

| 메모리 bucket | 값 | 산출 방법 | admission 포함 여부 |
|---|---:|---|---|
| HAL 계약 범위 | U 또는 P | MLIR/IREE 분석 | 포함 |
| cFS task stack | bytes | ES 설정+kernel frame | 별도 gate |
| wrapper BSS | bytes | ELF section/심볼 | 미포함 |
| VMFB blob | bytes | artifact 크기 | 미포함 또는 map 정책과 구분 |
| 런타임 고정비 | bytes/미측정 | 별도 관측 | 미포함 |
| cFS·OSAL | bytes/미측정 | 환경 정보 | 미포함 |

이 표의 목적은 전체 OBC 메모리 보장을 새로 만드는 것이 아니라 서로 다른 bucket을 혼동하지 않는 것이다.

---

## 10. 승인 알고리즘의 검증 매트릭스

| ID | 상한 상태 | 예산 | opt-in | 실제 arm | 기대 verdict | 실행 여부 |
|---|---|---:|---:|---|---|---|
| ADM-1 | known | \(B\ge U\) | 무관 | map/copy | ADMIT | 실행 |
| ADM-2 | known | \(B<P\) | 0 | 무관 | NOT_ADMITTED | 미실행 |
| ADM-3 | known | \(P\le B<U\) | 0 | 무관 | NOT_ADMITTED | 미실행 |
| ADM-4 | known | \(P\le B<U\) | 1 | map | ADMIT_CONDITIONAL_MAP | 실행 |
| ADM-5 | known | \(P\le B<U\) | 1 | copy/전제 실패 | 전제 실패 거절 | 추론 미실행 |
| ADM-6 | unknown | 임의 | 임의 | 미정 | REFUSED_UNKNOWN_BOUND | 미실행 |
| ADM-7 | malformed | 임의 | 임의 | 미정 | 입력 오류·거절 | 미실행 |
| ADM-8 | \(U\ne P+C\) | 임의 | 임의 | 미정 | 계약 불일치 오류 | 미실행 |

현재 Python 정책과 cFS C gate가 같은 의미를 구현하는지 각 셀에서 대조한다. 결과 문자열 일치만 보지 말고 **사용한 U·P·C·B와 실행 시작 여부**를 함께 확인한다.

---

## 11. 실험 기록의 최소 스키마

모든 핵심 실행은 다음 값을 한 레코드 또는 상호 해시로 연결된 레코드에 남긴다.

\`\`\`json
{
  "model_id": "...",
  "source_model_sha256": "...",
  "target": "aarch64",
  "vmfb_sha256": "...",
  "contract_sha256": "...",
  "input_manifest_sha256": "...",
  "accounting_scope_id": "iree_program_buffers_v1",
  "premises": {
    "static_shapes": true,
    "supported_resource_ops": true,
    "max_active_calls_observed": 1,
    "output_released_before_next_call": true,
    "driver_declared": "local-sync",
    "driver_used": "local-sync",
    "constant_arm": "map"
  },
  "contract": {
    "per_call_bytes": 0,
    "constant_bytes": 0,
    "unconditional_bound_bytes": 0
  },
  "admission": {
    "budget_bytes": 0,
    "budget_source": "...",
    "policy": "unconditional",
    "verdict": "ADMIT"
  },
  "observation": {
    "hal_peak_bytes": 0,
    "peak_within_admitted_budget": true,
    "runtime_created": true,
    "inferences_started": 1
  },
  "semantic_comparison": {
    "criterion_id": "...",
    "verdict": "PASS_OR_FAIL",
    "elements_failed": 0
  }
}
\`\`\`

필드가 측정되지 않았으면 0이나 false로 대체하지 않고 \`null\`과 \`unavailable_reason\`을 기록한다.

---

## 12. 수행 우선순위

### P0-1. 상한 추적표 작성과 미지원 상태 시험

- 네 모델의 \(I,O,T,C\)를 IR operation 단위로 추적
- 추출기 두 구현의 독립성 확인
- unknown operation, 동적 크기, 범위 밖 subview 음성 대조
- 계산식과 계약 필드의 일치 검사

**완료 산출물:** 모델별 allocation ledger, 음성 대조 결과, 상한 계산 근거.

### P0-2. 실제 입력을 이용한 AArch64 cFS 종단 실행

- ResNet CIFAR-10
- SmartCam OPS-SAT 이미지
- DeepAE 실제 log-mel
- WGAN 실제 noised 영상

**완료 산출물:** 입력 해시 → AArch64 VMFB·계약 → admission → HAL peak → 전체 출력 비교의 연결 기록.

### P0-3. OnAIR 출력 수명과 런타임 시작 관측

- SmartCam으로 live HAL bytes 및 반복 간 누적 확인
- 거절 셀에서 runtime 생성 함수 도달 여부 직접 기록
- 필요하면 WGAN으로 큰 출력 수명 경로 추가 확인

**완료 산출물:** 호출 단계별 live bytes와 runtime-created 직접 신호.

### P0-4. 회계 범위 대조표

- 계약 \(U\), 설정 예산 \(B\), HAL 관측 \(H\)의 범위 명시
- task stack, BSS, VMFB blob, runtime 고정비 분리
- 모델별 map/copy 실제 분기 기록

**완료 산출물:** 모든 핵심 셀의 accounting-scope matrix.

### P1. 기존 기술과의 원문·공식 코드 비교

- IREE/TinyIREE
- TFLM
- TVM USMP
- ExecuTorch
- OnAIR

비교축은 분석 입력, 회계 범위, 상한 성격, 메모리 계획 사용 목적, 실행 전 판정, 실제 예약 여부로 고정한다. 기존 기능으로 같은 작업이 가능하면 직접 구현한 요소의 범위를 축소해 기록한다.

---

## 13. 전체 완료 판정표

| 검증 축 | PASS 조건 | FAIL 조건 | UNKNOWN 조건 |
|---|---|---|---|
| 상한 건전성 | 지원 operation·크기·수명 규칙이 완전하고 관측이 상한을 반증하지 않음 | 지원 영역 실행에서 \(H>U\) 또는 누락 할당 발견 | 분석 대상·수명·관측 범위가 불명 |
| 실행 전제 | 실제 배포 경로가 계약 전제를 충족 | 동시 호출·출력 중첩·driver·arm 위반 | 필요한 런타임 신호 미수집 |
| 회계 일치 | U·B·H가 동일 scope ID와 포함 항목을 가짐 | 다른 영역 값을 직접 비교 | 예산 또는 allocator 범위 불명 |
| admission 구현 | 표의 모든 정책 셀이 예상 verdict·실행 여부와 일치 | 잘못된 승인 또는 거절 후 추론 실행 | 직접 실행 시작 신호 없음 |
| 실제 모델 적용 | 공개 실입력과 AArch64 cFS 결과가 계약과 연결 | 상한 위반 또는 입력/산출물 연결 오류 | 일부 모델·입력 미실행 |

최종 승인 메커니즘의 타당성은 다음 조건에서 확보된다.

\[
\text{Sound Bound}
\land
\text{Premises Satisfied}
\land
\text{Accounting Congruence}
\land
\text{Correct Decision Implementation}
\]

단순히 ADMIT/NOT_ADMITTED 로그가 존재하거나 회귀시험 수가 많다는 사실만으로는 완료로 판정하지 않는다.

---

## 14. 연구 진행자가 피해야 할 해석

| 부정확한 해석 | 정확한 해석 |
|---|---|
| “U−1에서 거절됐으므로 실제로 1바이트가 부족하다” | 비교 경계 바로 아래에서 정책이 거절함을 확인했다 |
| “승인됐으므로 OBC RAM이 충분하다” | 정의된 부분 회계 범위에서 예산 충족 근거가 있다 |
| “HAL peak가 U보다 작았으므로 U가 증명됐다” | 실행 관측이 해당 표본에서 상한을 반증하지 않았다 |
| “JSON이 계약이므로 보장이 있다” | 계약의 분석·전제·회계 의미가 검증될 때 보장이 성립한다 |
| “OnAIR가 거절 기능이 없으므로 메모리 관리에 실패한다” | 본 연구가 정의한 admission 단계가 순수 경로에는 없다 |
| “artifact-only와 같으므로 MLIR은 쓸모없다” | 현재 표본에서 수치 우위는 없었으며 정보 출처·검증 경로의 차이를 따져야 한다 |
| “MLIR을 썼으므로 상한은 정확하다” | MLIR은 분석 지점이며 상한의 건전성은 별도 논증·검증 대상이다 |

---

## 15. 최종 판단

**분석 판단:** 메모리 계약과 승인·거절 구조는 계약 기반 설계, 정적 자원 분석, AI memory planning, admission control에 근거하므로 임의적인 발상은 아니다. 그러나 현재 연구의 JSON 스키마, 상한 계산 규칙, 예산 공급 방식, map 조건부 정책은 직접 설계한 요소다.

연구의 난점과 기여 가능성은 비교 연산 자체가 아니라 다음 연결에 있다.

1. 컴파일 산출물에서 정의된 메모리 영역의 상한을 도출한다.
2. 상한이 유효한 실행 전제를 계약에 명시하고 실제 배포가 이를 지키는지 확인한다.
3. 같은 회계 범위의 예산과 관측치에 연결한다.
4. 확인된 조건에서만 실행을 승인한다.

따라서 현재 연구 진행의 중심은 **상한 건전성 → 실행 전제 → 회계 일치 → admission 동작**의 순서로 두는 것이 타당하다.

