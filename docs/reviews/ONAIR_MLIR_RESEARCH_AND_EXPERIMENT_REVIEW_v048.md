# onAIR-MLIR 연구 현황·실험 타당성·추가 연구 검토

- 검토일: 2026-09-11
- 대상 저장소: https://github.com/wookjaeya/onAIR-MLIR
- 기준 커밋: 2f73085277f31149dd69b1808b69365eeff8c11f
- 기본 브랜치: claude/review-and-proceed-4y1sag
- 기록 버전: v0.48
- 검토 방법: 최신 커밋, 분석기·실행기 코드, EVIDENCE 문서, 결과 JSON을 대조했다. 이번 검토에서는 컴파일·게스트 실행·CI를 재실행하지 않았다.
- 표기: **확인 사실**은 저장소 코드·기록에서 확인한 내용이다. 평가·제안은 **본인 분석·판단**이다. 완료 근거를 확인하지 못한 항목은 **미검증**으로 표시한다.

## 1. 종합 판단

**본인 분석·판단:** 핵심 구조는 구현됐고 공개 모델을 이용한 적용 실험도 상당히 진행됐다. 지금 필요한 것은 대규모 재구축보다, 이미 확보한 증거를 목표 실행 경로에서 연결하고 메모리 상한이 성립하는 조건을 확인하는 작업이다.

현재 구조는 **컴파일 결과에서 분석 대상 버퍼의 요구량을 산출하고, 앱에 부여된 메모리 예산과 비교하여 모델 런타임의 시작 여부를 결정**한다. 검사 범위는 앱별 부분 메모리 영역이다. 전체 OBC의 남은 RAM을 계산하거나 물리 메모리를 예약하는 기능으로 해석할 수는 없다. [S2][S3][S5][S6][S15]

| 연구 항목 | 확인된 상태 | 현재 판단 |
|---|---|---|
| 컴파일 결과 기반 요구량 산출 | post-layout MLIR 분석 및 계약 생성 | 구현 확보 |
| AArch64 cFS 적용 | SmartCam·ResNet·DeepAE 실행 및 예산 판정 | 기본 경로 확보 |
| NASA OnAIR 적용 | 공식 loader가 연구 플러그인을 로드하고 실행 | 인터페이스 연계 확보 |
| 공개 실입력 검증 | ResNet·SmartCam·DeepAE·WGAN의 수치 비교 | 확보, DeepAE FAIL 포함 |
| E45·E46 실입력의 AArch64 cFS 실행 | 해당 실입력 집합의 완료 기록 미확인 | 핵심 공백 |
| OnAIR 출력 버퍼 해제 | 실제 해제 검증이 철회된 상태 | 수명 확인 필요 |
| MLIR의 상대적 효과 | artifact-only 기준선과 24/24 판정 일치 | 수치적 우위 미확인 |
| 기존 기법과의 비교 | 검색 중심, 전체 원문 검증 0건·부분 원문 1건 | 기능 차이 확정 미완료 |

근거: [S3][S7]–[S13][S16][S17]. “구현 확보”는 코드·기록 확인이며 이번에 독립 재실행했다는 뜻은 아니다.

최신 커밋은 CHANGELOG.md, CLAUDE.md, EXPERIMENT_LOG.md의 CI 실측 기록을 보완했다. v0.48의 모델 실험 결과를 바꾼 커밋은 아니다. 기록은 컨테이너 710/710과 CI full 705/705 및 3 SKIP을 구분한다. 회귀 검사 개수는 독립적인 모델 실행 실험의 개수로 환산할 수 없다. [S1][S18; 마지막 문장은 본인 분석·판단]

## 2. 연구 아키텍처의 타당성

### 2.1 OnAIR와 cFS는 현재 별도 적용 경로다

| 구간 | 실제 역할 |
|---|---|
| 공개 모델·가중치 및 변환 과정 | 원본 모델을 IREE가 처리할 입력 형태로 변환 |
| IREE 컴파일 | 타깃 VMFB와 post-layout IR 등 생성 |
| 연구 분석기 | 컴파일 결과에서 부분 메모리 계약 산출 |
| OnAIR 연구 플러그인 | 공식 AIPlugin 인터페이스에서 계약을 읽고 예산 판정 후 IREE 실행 |
| cFS 연구 앱 | cFS 초기화 단계에서 계약 기반 예산·스택 검사 후 IREE 실행 |

근거: [S2][S5][S6][S12].

**확인 사실:** OnAIR 플러그인은 AIPlugin을 상속하고, cFS AI_LEARNER는 별도의 C 앱으로 구현돼 있다. 따라서 현재 구현을 “OnAIR가 cFS AI_LEARNER를 직접 호출하는 하나의 직렬 경로”로 해석하면 부정확하다. [S5][S6]

**본인 분석·판단:** 같은 계약 개념을 서로 다른 기존 프레임워크에 적용하는 구성은 타당하다. 둘을 하나로 합치는 공사는 현 연구의 필수 조건이 아니다. 각 경로의 모델·입력·타깃·측정 완료 범위를 별도로 관리하면 된다.

### 2.2 MLIR 사용은 타당하지만 필연성·우위와 구분해야 한다

**확인 사실:** 분석기는 iree-stream-layout-slices 이후 IR 덤프를 읽어 입력 자원, 외부 출력 할당, 배치가 끝난 임시 slab 등을 계산한다. 지원하지 않는 resource operation이나 해석 불가 크기는 unresolved로 처리한다. 현재 구현은 덤프 후처리 분석기이며 정규 MLIR pass가 아니다. [S2: dump_alloc_ir·parse_alloc_ir][S3]

**본인 분석·판단:** 컴파일러의 버퍼 배치·재사용·정렬 결과를 사용하므로 실제 실행 산출물과 메모리 분석을 연결하기 좋은 위치다. 하지만 이 합리성은 MLIR만으로 가능한 기능이라는 뜻이 아니다. E35는 네 모델/타깃 조합의 주요 수치와 24개 예산·정책 셀 판정이 artifact-only 방식과 같다고 기록한다. [S16]

우선 필요한 연구는 **어떤 컴파일 정보를 어떤 규칙으로 계약에 옮겼고 그 규칙이 왜 상한을 주는지 확인하는 것**이다. 정규 pass 전환은 현재 필수 작업으로 권고하지 않는다. [본인 분석·판단; S1 v0.45.1, S2, S3, S16]

### 2.3 AArch64 QEMU는 현재 목표에 적절하다

**확인 사실:** AArch64 cFS에서 모델별 VMFB를 실행하고 예산 판정·HAL peak·출력 비교를 수집한 기록이 있다. ResNet·DeepAE는 주요 버퍼 계약값이 기존 타깃과 같아도 커널 스택 수치는 다르다. [S7][S8]

**본인 분석·판단:** 타깃 ISA 산출물이 cFS에서 실행되고 버퍼 회계와 예산 판정이 맞는지 확인하는 데 QEMU는 적절하다. 현재 단계에서 고가 보드 구매나 ISA 변경을 우선할 근거는 없다. 실물 CPU의 실행시간·캐시 영향·운용 메모리 압박까지 조사하려는 경우 실물 장비의 필요성을 다시 판단하면 된다.

게스트 RAM 크기는 실행환경의 조건이며, 계약과 비교하는 앱 예산은 별도의 값이다. 두 값을 동일시하지 않아야 한다. [본인 분석·판단; S7, S15]

## 3. 모델·데이터셋 구성과 실제 결과

| 모델 | 실입력 | 최신 실입력 수치 비교 | AArch64 cFS 증거 |
|---|---|---|---|
| MLPerf Tiny ResNet | CIFAR-10 200장, 저장소에 명시된 MLCommons 선택 인덱스 | x86 PASS, 2,000원소 실패 0, argmax 200/200 일치 | 합성 32+경계 2의 출력 비교, ADMIT/DENY, HAL peak |
| OPS-SAT SmartCam | pristine 온보드 썸네일 19장 | x86 PASS, 57원소 실패 0, argmax 19/19 일치 | 기존 입력 및 예산·조건부 map 경로 확보; 19장 전체 재실행은 미확인 |
| MLPerf Tiny DeepAE | 실제 ad01 log-mel 34창 | x86 FAIL, 21,760원소 중 94 실패; 34개 중 1개 샘플 실패 | 합성 32+경계 2의 출력 비교, ADMIT/DENY, HAL peak |
| OPS-SAT WGAN FPN-50 전체 프레임 변종 | 실제 noised 영상 9장+경계 2 | x86 PASS, 1,655,808원소 실패 0 | 해당 모델의 AArch64 cFS 완료 미검증 |

근거: [S1 v0.45·v0.46][S7]–[S11]. PASS는 저장소가 정한 출력 수치 비교 기준을 만족했다는 뜻이다. 모델 정확도나 복원 품질의 평가 결과가 아니다.

### 3.1 모델 선정은 적절한가?

**본인 분석·판단:** 네 모델은 충분히 합리적인 구성이다. 서로 다른 메모리 성질을 시험한다는 점이 중요하다.

| 모델 | 연구에서 시험하는 성질 | 선정 타당성 |
|---|---|---|
| SmartCam | 우주 AI 응용 출처, 큰 영상 입력, 변환 레이아웃 | 주 적용 사례로 적합 |
| ResNet | 공개 Embedded 벤치마크, 작은 분류 출력, 재현 가능한 데이터 선택 | 표준 비교 사례로 적합 |
| DeepAE | 상수 지배형 메모리, 비영상 연속값 입력·출력 | 다른 메모리 구성과 수치 변환 한계 검증 |
| WGAN | 작업 버퍼 지배, 큰 영상 출력, 출력 레이아웃 | 기존 세 모델이 드러내지 못한 버퍼 문제 검증 |

근거: [S9][S10]. ResNet·DeepAE가 해당 버전 그대로 위성에서 비행했다는 사실은 이번 검토에서 검증하지 않았다. 공개 Embedded 모델로서의 선정 근거와 비행 모델로서의 근거를 구분한다. SmartCam·WGAN도 공개 원본의 온보드 이력과 본 연구가 생성한 IREE VMFB의 실행 이력이 같지는 않다.

**지금은 모델 추가보다 네 모델의 타깃 검증 경로 완결이 우선이다.** WGAN 반입은 큰 출력 버퍼 문제를 실제로 발견했으므로 단순한 모델 수 늘리기와 다르다. [본인 분석·판단; S10 §5]

### 3.2 실입력은 왜 필요한가?

E45는 ResNet의 실입력이 float32 0–255이며, DeepAE의 log-mel 값이 음수 중심임을 기록한다. 기존 uniform[0,1) 합성 입력은 실제 값 분포를 대표하지 않았다. 실제 입력에서 DeepAE 수치 FAIL이 나타났고, 레이아웃 결함의 argmax 탐지율도 ResNet 180/200, SmartCam 18/19로 높아졌다. [S9]

**본인 분석·판단:** 실입력은 전처리·변환·실행 결과의 유효성을 확인하기 위해 필요하다. 그러나 고정 형상·값 독립적인 할당 계획의 상한은 입력 수를 늘리는 것만으로 증명되지 않는다.

- 실제 입력: 모델의 실제 값 범위에서 출력 보존 확인.
- 합성·경계 입력: 특정 결함·미지원 상태·판정 경계의 보조 검사.
- 할당 구조·수명 분석: 지원 실행 조건에서 상한이 성립하는 이유 확인.

영상 하나의 출력 원소 수가 많다고 독립적인 시험 사례가 그만큼 많은 것도 아니다. WGAN의 약 165만 원소 비교는 실제 영상 9장과 경계 입력 2개라는 다양성 수준과 함께 해석해야 한다. [본인 분석·판단; S11]

## 4. 메모리 측정과 예산 판정의 타당성

### 4.1 상한·예산·관측치를 구분한다

저장소의 계약 성분을 다음 기호로 재표현한다. [S3][S5]

- P: 단일 호출에서 분석하는 입력·출력·임시 버퍼 요구량
- C: 상수의 추가 HAL 복사에 대비해 계상하는 크기
- U=P+C: map/copy 경로를 포괄하는 무조건 상한
- B: 앱에 부여된 동일 회계 범위의 예산
- H: 해당 HAL allocator에서 관측한 peak

기본 정책은 U≤B일 때 허용한다. 조건부 map 정책은 전제와 opt-in이 있을 때 P를 사용한다. map으로 별도 HAL 복사가 없어져도 원본 모델 이미지의 상수 바이트가 CPU RAM에서 사라지는 것은 아니다. [S5][S8; 마지막 문장은 본인 분석·판단]

| 모델 | 무조건 상한 U | 호출 성분 P | 상수 성분 C | 해당 기록의 HAL peak |
|---|---:|---:|---:|---|
| ResNet | 618,856 B | 309,416 B | 309,440 B | 309,416 B, AArch64 cFS |
| SmartCam | 18,222,796 B | 9,382,092 B | 8,840,704 B | 9,382,092 B, E38 AArch64 cFS map |
| DeepAE | 1,069,632 B | 6,208 B | 1,063,424 B | 6,208 B, AArch64 cFS |
| WGAN | 135,666,432 B | 131,382,784 B | 4,283,648 B | 131,382,784 B, E46 x86 |

근거: [S7][S8][S10]. 환경이 혼합된 표이므로 AArch64 네 모델의 비교 결과로 해석하면 안 된다.

**본인 분석·판단:** U/H에는 분석의 여유뿐 아니라 map/copy 분기 차이가 섞인다. 분석 정밀도를 평가하려면 실제 분기에 대응하는 상한도 함께 비교해야 한다. 이 비율을 전체 CPU 메모리 절감률로 사용할 수는 없다.

### 4.2 상한보다 1바이트 작은 예산 검사는 무엇을 검증하나?

ResNet·DeepAE의 U와 U−1 예산에서 허용/거부를 확인했고, 거부 경로의 추론 수는 0으로 기록돼 있다. [S7]

**본인 분석·판단:** 이 검사는 정수 비교 경계의 정확성 검증으로 적절하다. 그러나 U−1에서 실제 RAM이 고갈되거나 모델 실행이 물리적으로 불가능하다는 뜻은 아니다. map 관측치 P가 U보다 작을 수 있으므로 이때의 거부는 무조건 정책의 보수성을 반영한다. [S7][S8]

예산 실험은 B<P, P≤B<U, B≥U의 세 구간과 조건부 opt-in을 연결해 해석하는 것이 적절하다. E35·E38이 이미 다룬 셀을 먼저 재사용하고 타깃 실입력 경로의 누락만 보완한다. 촘촘한 숫자 sweep을 대규모로 추가할 필요는 없다. [본인 분석·판단; S8, S16]

### 4.3 부분 회계 범위는 타당한가?

**확인 사실:** E44는 예산 출처를 OnAIR 설정, 명령행 인자, cFS 매크로·초기화 오버라이드로 구분한다. 예약 관련 호출 검사와 구현 검토는 해당 예산을 선언값으로 분류한다. [S14][S15]

**본인 분석·판단:** 부분 예산 검사라는 연구 질문은 유효하다. “해당 버퍼가 상한 이내로 관측됐다”와 “전체 시스템이 그 메모리를 반드시 확보할 수 있다”는 다른 질문이다. 예약 호출 몇 종류의 부재만으로 외부 환경 전체를 증명할 수는 없으므로 E44의 스캔 결과도 현재 연구 코드의 동작 범위에서 해석한다.

WGAN 출력 버퍼를 static으로 옮긴 조치는 스택 부족을 피하는 데 타당하다. 바이트는 .bss로 이동하며 RAM 사용 자체가 사라지지는 않는다. wrapper 정적 버퍼와 태스크 스택은 부분 계약과 분리해 환경 기록에 남기는 것이 적절하다. 전체 RAM 관리자를 새로 만드는 작업은 현재 필수가 아니다. [S5: yv 및 입력·출력 버퍼 주석][S10 §5; 본인 분석·판단]

## 5. OnAIR 비교 실험 평가

| 셀 | 구성 | 기록된 동작 | 실험적 의미 |
|---|---|---|---|
| O0 | 공식 loader + 연구 저장소의 LiteRT 플러그인 | 계약 판정 단계 없음, 추론 5회 | 계약 없는 실행 기준선 |
| O1 | OnAIR + IREE, 예산 미설정 | NOT_EVALUATED, 추론 5회 | IREE 사용과 admission 효과 분리 |
| O2 | OnAIR + IREE + 예산 U | ADMIT, 추론 5회 | 허용 시 정상 실행 |
| O3 | OnAIR + IREE + 예산 U−1 | NOT_ADMITTED, 추론 0 | 정책에 따른 사전 거부 |

근거: [S12 §1–§3][S13]. O0·O1은 E43 측정, O2·O3은 기존 셀 인용이다.

**본인 분석·판단:** 비교 구성은 타당하다. 다만 다음과 같이 해석해야 한다.

1. O0의 LiteRT 플러그인은 연구 저장소에서 구현했다. NASA 공식 loader를 사용한다는 사실과 플러그인 자체가 NASA 원본이라는 주장은 다르다.
2. O0와 O2는 런타임이 달라진다. 메모리량 차이를 admission 효과로 바로 돌릴 수 없다.
3. O1과 O2/O3은 IREE를 유지하므로 admission 효과를 분리하기에 더 적합하다.
4. 순수 경로에는 본 연구의 계약이 없으므로 계약 위반이나 메모리 관리 실패로 판정할 수 없다.
5. E43은 메모리량을 비교하지 않았다. 현재 결과는 실행 전 판정이라는 기능의 추가를 보여준다.

근거: [S12][S13].

코드에서 _decide_admission()은 _load_artifact()보다 먼저 실행되지만 NumPy 입력 버퍼는 그 앞에서 생성한다. 정확한 실행 경계는 **IREE 런타임·모델 로딩 전 판정**이다. 모든 메모리 할당 이전은 아니다. [S6: __init__·_decide_admission·_load_artifact]

O3의 런타임 미생성은 보관 셀의 독립 신호보다 코드 순서 등을 근거로 해석한 값임이 기록돼 있다. 또한 del out이 실제 HAL 버퍼 해제를 증명하지는 않으며 OnAIR 해제 검증은 철회된 상태다. [S6][S13]

**본인 분석·판단:** OnAIR 출력 수명 확인은 연구의 핵심 조건 검증이다. 다만 모든 모델·예산 조합을 재실행할 필요는 없다. 대표 모델에서 수명과 관측 경로를 확인하고, 큰 출력 등 다른 동작을 시험해야 할 때만 추가한다.

## 6. 필요한 추가 연구와 수행안

아래 수행안과 완료 조건은 모두 **본인 분석·판단**이다. 새 실험 번호는 부여하지 않으며 기존 결과를 우선 재사용한다.

### R1. 공개 실입력의 AArch64 cFS 종단 실행 — 최우선

**근거:** 실입력 결과와 AArch64 cFS 결과가 각각 있으나 최신 실입력 집합의 타깃 완료가 확인되지 않는다. [S7]–[S11]

**수행:**

1. E45 입력 파일·순서·전처리·해시·비교 기준을 유지한다.
2. AArch64 VMFB와 해당 컴파일 결과에서 나온 계약, cFS 앱을 연결한다.
3. 충분한 예산에서 참조 출력과 전체 cFS 출력을 비교한다.
4. 같은 실행에서 초기화·추론 HAL peak와 실제 승인 예산을 기록한다.
5. 예산 부족 셀에서 추론이 시작되지 않는지 확인한다.
6. 기존 조건부 map 증거를 재사용하고 바뀐 입력·실행 경로만 보완한다.

**순서:** ResNet·SmartCam으로 경로를 확인하고 DeepAE를 같은 방식으로 실행한다. 이후 WGAN의 큰 출력 처리를 AArch64 cFS에서 검증한다.

**완료 조건:** 입력 집합, 타깃 산출물, 예산·판정, 관측 peak, 출력 비교 결과가 한 실행 기록에 연결된다. FAIL도 유효한 실험 결과이며 PASS를 만들기 위한 기준 변경은 하지 않는다.

### R2. DeepAE 수치 불일치 원인 분석 — 최우선

**근거:** 실제 log-mel 34창 중 1창, 총 94원소가 기존 기준을 만족하지 않는다. [S9]

**수행:**

1. 실패한 샘플·원소를 그대로 재생한다.
2. 같은 전처리 결과로 원본 TFLite와 변환 ONNX를 비교한다.
3. ONNX 중간 실행이 가능한 연산 구성인지 확인하고, 가능하면 ONNX와 IREE 결과를 비교한다.
4. 오차가 처음 커지는 연산 구간을 국소화한다.
5. 필요할 때만 관련 최적화·부동소수점 옵션을 한 요인씩 바꾼다.
6. AArch64에서 동일 샘플을 실행해 ISA 의존 여부를 구분한다.

**판정 원칙:** abs≤1e-4 OR rel≤1e-5는 저장소가 사전 고정한 수치 기준이다. 모든 모델의 임무 허용오차라는 근거는 이번 검토에서 확인되지 않았다. 기준을 유지하고 다른 기준이 필요하면 별도 근거와 결과를 추가한다.

**완료 조건:** 변환 결함, 컴파일/실행의 수치 차이, 아직 국소화하지 못한 차이를 근거로 분류한다. 수치 FAIL과 메모리 상한 위반은 따로 판정한다. 정확도·AUC 연구로 확대할 필요는 없다.

### R3. 상한 계산 규칙과 실행 전제 검증 — 최우선

**근거:** 관측한 H≤상한만으로 모든 지원 실행을 보장할 수 없다. E40·E41은 계산 사실과 요구 전제를 구분하지만 실제 적용의 근거를 계속 연결해야 한다. [S2]–[S4]

**수행:**

- 입력·외부 출력·post-layout 임시 slab·상수 성분을 추출 코드와 대응시킨다.
- alias/subview를 추가 할당으로 세지 않는 처리와 범위 검사를 확인한다.
- 여러 slab 합산의 보수성과 slab 내부 정렬·재사용 처리를 구분한다.
- 모듈 초기화와 호출 중 할당이 분리 계상되는지 확인한다.
- 미지원 크기·연산·제어흐름에서 상한을 확정하지 않는지 확인한다.
- 기존 추출기·독립 walker·회귀 결과를 먼저 재사용하고 드러난 공백에만 최소 재현 예제를 추가한다.

**실행 전제 해석:** E41은 SmartCam 동시 호출 N=2에서 무조건 상한 초과를 기록했다. 이는 순차 호출 전제가 중요하다는 증거다. 현재 순차 cFS 앱에 동시성을 새로 추가하거나 별도 게이트를 의무적으로 만들 이유는 아니다. 현재 호출 구조가 전제를 지키는지 확인하면 된다. [S4 §1]

출력을 보유한 일부 실행이 예산 안에 남았다는 사실도 모든 출력 수명을 허용하는 근거는 아니다. 반대로 전제를 벗어난 모든 실행이 반드시 실제 예산을 초과하는 것도 아니다. 검증할 것은 보장하는 실행 영역과 실제 호출·수명 구조의 일치다. [S4 §2; 본인 분석·판단]

**완료 조건:** 계산 규칙·지원 연산·계약 필드·실행 전제가 연결되고 미지원 상태가 상한 확정으로 이어지지 않는 근거를 확보한다. 정규 MLIR pass 전환은 요구하지 않는다.

### R4. OnAIR의 실제 출력 수명 확인 — 핵심 보완

**근거:** OnAIR 적용은 확보됐지만 실제 해제 검증이 남아 있다. [S6][S12][S13]

**수행:**

1. SmartCam 한 모델에서 로딩 전·후, 호출 후, 출력 소비 후의 살아 있는 HAL 바이트를 관측한다.
2. peak는 누적 최대값이므로 해제 여부는 현재 살아 있는 바이트 또는 할당·해제 누적량의 차이로 함께 확인한다.
3. 같은 집합을 사전 고정한 횟수만큼 순차 실행해 반복 사이 메모리 누적을 확인한다.
4. 거부 셀은 IREE 런타임 생성 호출에 도달했는지 직접 기록한다.
5. 기존 AArch64 OnAIR 환경이 준비돼 있으면 그곳에서 수집한다. 준비되지 않았다면 cFS 타깃 결과와 OnAIR 호스트 결과를 구분하고 추가 구축 비용을 판단한다.

**완료 조건:** 실제 출력 수명이 어떻게 끝나는지와 관측 범위를 확인한다. 참조 제거 또는 종료 경고 하나로 해제·누수를 단정하지 않는다. 제한된 반복 실행만으로 모든 미래 호출에서 누수가 없다고 일반화하지 않는다.

### R5. 예산 구간·map/copy 조건의 유용성 확인 — 기존 결과 재사용 중심

**근거:** E35·E38이 이미 관련 조건을 다뤘다. 빠진 목표 실행 셀만 보완하면 된다. [S8][S16]

| 조건 | 기대 정책 | 확인 목적 |
|---|---|---|
| B<P | 거부 | 부분 요구량 자체가 예산보다 큼 |
| P≤B<U, opt-in 없음 | 무조건 정책에서 거부 | 보수적 기준 유지 |
| P≤B<U, map 전제·opt-in 충족 | 조건부 허용 | 전제가 허용 영역을 넓히는지 |
| B≥U | 기본 허용 | 충분한 부분 예산에서 정상 실행 |
| 작은 예산으로 조건부 승인했으나 map 전제 불충족 | 전제 실패 처리 | copy 할당 전 차단 여부와 실제 거부 시점 |

DeepAE의 상수 지배성과 WGAN의 작업 버퍼 지배성은 조건부 정책의 효과가 모델 구성에 따라 달라지는지를 보여주는 대비다. 결과는 HAL 회계 범위에서 해석한다.

**완료 조건:** 이미 확보한 셀과 새 타깃 셀을 연결하고, 승인된 예산과 관측 peak를 같은 범위에서 대조한다. 물리 OOM을 유발하는 시험으로 바꿀 필요는 없다.

### R6. 기존 메모리 계획 기법과의 기능 차이 확인 — 조사 연구

**근거:** E39의 원문 검증은 제한돼 있고 E35의 수치·판정은 기준선과 같다. [S16][S17]

우선 IREE/TinyIREE, TVM USMP, ExecuTorch, TFLM, OnAIR의 원문·공식 코드에서 다음을 확인한다.

- 분석 입력 및 메모리 회계 범위
- 요구량 산출 시점과 사용 목적
- 배포 전 예산 판정 및 실제 메모리 예약
- 실행 전제와 위반 시 동작
- 본 연구에서 추가로 구현한 연결 기능

검색 요약을 확정 사실로 승격하지 않고 확인 구간·URL을 남긴다. 기존 구현으로 이미 같은 기능이 가능하면 그 사실을 수용하고 추가 작업을 줄인다. 이 조사 자체가 대규모 타 런타임 성능 비교를 요구하지는 않는다.

**완료 조건:** MLIR 경로를 포함한 기존·제안 방법의 차이를 확인 근거로 설명한다. MLIR 우위를 만들기 위해 artifact-only 기준선을 약화하지 않는다.

## 7. 실행 순서와 연구 종료 기준

아래 순서는 본인 분석·판단이며 모든 항목이 엄격한 선후 의존관계를 가진다는 뜻은 아니다.

| 순서 | 작업 | 넘어갈 기준 |
|---|---|---|
| 1 | ResNet·SmartCam 실입력 AArch64 cFS | 입력·출력·예산·HAL 기록 연결 |
| 2 | DeepAE 실입력 AArch64와 실패 국소화 | 결과와 원인 분석 상태를 근거로 분류 |
| 3 | OnAIR 대표 모델의 출력 수명·시작 시점 | 계약을 적용할 실행 조건 확인 |
| 4 | WGAN AArch64 cFS | 큰 출력 처리와 작업 버퍼 지배형 타깃 검증 |
| 함께 진행 | R3 계산 규칙 검증·R6 기존 기법 조사 | 상한 근거와 기능 차이 확인 |
| 마무리 | 누락된 예산 구간·조건부 셀만 보완 | 핵심 질문마다 직접 연결된 결과 확보 |

모델 교체 시 재판정은 **모델 변경을 실제 목표에 포함할 경우의 후속 실험**이다. 같은 예산에서 요구량이 다른 기존 두 모델의 교체 후보 판정을 확인할 수 있다. 다만 현재 초기화 시 판정 기능만으로 실행 중 무중단 교체·상태 이전까지 구현됐다고 볼 수는 없다. 기본 연구 완료를 위해 무중단 교체 구조를 새로 만들 필요는 없다. [본인 분석·판단; S5, S6, S15]

## 8. 불필요한 확장을 막는 연구 진행 지침

아래는 현재 목표와 증거를 기준으로 한 본인 분석·판단이다.

1. **추가 제안은 기존 코드·결과와 먼저 대조한다.** 이미 검증된 항목을 이름만 바꿔 다시 만들지 않는다.
2. **새 실험에는 해결할 공백이 있어야 한다.** 모델·필드·검사마다 어떤 질문에 답하는지 명시한다.
3. **현재 지원 범위를 유지한 채 완성한다.** 동적 형상·동시 추론·다중 앱 예산 분배를 기본 목표에 추가하지 않는다.
4. **공식 인터페이스 적용과 성능 우위를 구분한다.** OnAIR loader 사용만으로 메모리 절감이 입증되지는 않는다.
5. **출력 비교와 메모리 상한을 별도로 판정한다.** 수치 FAIL을 메모리 FAIL로 바꾸거나 메모리 PASS로 수치 FAIL을 덮지 않는다.
6. **재실행은 바뀐 코드·타깃·입력·측정 공백에 필요한 범위로 제한한다.**
7. **현재 부분 예산 판정 완결에 기여하지 않는 주변 기능을 완료 조건으로 삼지 않는다.**

## 9. 최종 판정

**본인 분석·판단:** 현재 실험 구성은 연구 목표에 대체로 적합하다. 공개 모델의 종류도 충분하며 OnAIR·cFS·AArch64·MLIR/IREE 구성 요소를 전면 교체할 이유는 확인되지 않았다.

우선 과제는 **실입력의 AArch64 cFS 연결, DeepAE 수치 차이의 원인 분석, 상한 계산과 실행 전제의 대응, OnAIR 출력 수명 확인**이다. 기존 기법과의 원문·코드 비교는 추가 기능의 위치를 확정하는 데 필요하다.

완료 여부는 PASS 개수보다, **어떤 모델을 어떤 조건에서 얼마의 부분 예산으로 허용했고 실제 버퍼 사용과 출력이 어떻게 나타났는지**를 끊김 없이 설명할 수 있는지로 판단한다.

## 10. 출처

모든 저장소 링크는 검토 커밋에 고정했다. 외부 모델·기존 연구의 출처는 저장소가 기록한 내용을 확인했으며, 이번 검토에서 외부 원문 전체를 별도로 재검증한 것은 아니다.

- **[S1]** [CHANGELOG.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/CHANGELOG.md)
- **[S2]** [harness/static_mem_bound.py](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/harness/static_mem_bound.py)
- **[S3]** [docs/EVIDENCE_v0.43_E40.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.43_E40.md)
- **[S4]** [docs/EVIDENCE_v0.44_E41.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.44_E41.md)
- **[S5]** [native/cfs_app/fsw/src/ai_learner.c](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/native/cfs_app/fsw/src/ai_learner.c)
- **[S6]** [plugins/compiled_learner/compiled_learner_plugin.py](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/plugins/compiled_learner/compiled_learner_plugin.py)
- **[S7]** [results/e36b_aarch64_models/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e36b_aarch64_models/summary.json)
- **[S8]** [results/e38_optin_record/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e38_optin_record/summary.json)
- **[S9]** [results/e45_real_inputs/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e45_real_inputs/summary.json)
- **[S10]** [docs/EVIDENCE_v0.46_E46.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.46_E46.md)
- **[S11]** [results/e46_wgan/cell/comparison.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e46_wgan/cell/comparison.json)
- **[S12]** [docs/EVIDENCE_v0.47_E42_E43.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.47_E42_E43.md)
- **[S13]** [results/e43_pure_onair/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e43_pure_onair/summary.json)
- **[S14]** [docs/EVIDENCE_v0.48_E44.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.48_E44.md)
- **[S15]** [results/e44_budget_provenance/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e44_budget_provenance/summary.json)
- **[S16]** [results/e35_fair_baseline/summary.json](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e35_fair_baseline/summary.json)
- **[S17]** [results/e39_prior_art/prior_art.md](https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e39_prior_art/prior_art.md)
- **[S18]** [최신 커밋 변경 파일·CI 기록](https://github.com/wookjaeya/onAIR-MLIR/commit/2f73085277f31149dd69b1808b69365eeff8c11f)

[S1]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/CHANGELOG.md
[S2]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/harness/static_mem_bound.py
[S3]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.43_E40.md
[S4]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.44_E41.md
[S5]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/native/cfs_app/fsw/src/ai_learner.c
[S6]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/plugins/compiled_learner/compiled_learner_plugin.py
[S7]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e36b_aarch64_models/summary.json
[S8]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e38_optin_record/summary.json
[S9]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e45_real_inputs/summary.json
[S10]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.46_E46.md
[S11]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e46_wgan/cell/comparison.json
[S12]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.47_E42_E43.md
[S13]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e43_pure_onair/summary.json
[S14]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/docs/EVIDENCE_v0.48_E44.md
[S15]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e44_budget_provenance/summary.json
[S16]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e35_fair_baseline/summary.json
[S17]: https://github.com/wookjaeya/onAIR-MLIR/blob/2f73085277f31149dd69b1808b69365eeff8c11f/results/e39_prior_art/prior_art.md
[S18]: https://github.com/wookjaeya/onAIR-MLIR/commit/2f73085277f31149dd69b1808b69365eeff8c11f

