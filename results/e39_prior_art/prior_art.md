# E39a — 선행연구 비교표 (생성물 · 직접 편집 금지)

생성기: `harness/mk_prior_art_table.py` · 입력: `works.json`, `searches.json` · 사전 고정 축: `docs/plans/E39_novelty_audit.md`

> **증거 등급 경고.** 이 표의 내용 칸은 각 행의 `등급`이 말하는 만큼만 지지된다. 대부분은 `search_summary`(검색 도구가 써 준 요약; 초록도 원문도 직접 읽지 않았다)이고, `fulltext_partial`은 Scholar Gateway가 반환한 **일부 청크 본문**이다(받은 청크 번호와 전체 청크 수를 각 행에 적었다). **세 행은 E39b에서 1차 문헌 전문을 대조했다**(`project_doc_fulltext`·`source_fulltext`) — 다만 그것은 **논문 원문이 아니고**, 각 행의 `A9.axes_checked_against_fulltext`가 그 등급이 지지하는 **축의 범위**다. `fulltext`(논문 원문)는 여전히 **0건**이다.

> **정정(E47·E39b).** E39a는 *"`WebFetch`가 전 외부 호스트에서 `EGRESS_BLOCKED`"*라고 적었는데 그 근거는 **두 호스트 시험**뿐이었다. `raw.githubusercontent.com`은 열려 있고 E39b가 그 경로로 세 문헌을 전문 취득했다. 여전히 막힌 다섯(arxiv·crossref·mlsys·ieee·aaai)은 E39b가 **다시 재서** 전부 `000`임을 기록했다 — *"이 호스트가 막혔다"*와 *"이 자료를 조달할 수 없다"*는 다른 문장이고, 그 사이에 **어느 경로를 재 봤는가**가 있다.

> 이 표는 *"이 검색 범위에서 조합이 확인되지 않았다"*까지만 지지하고, *"선행연구가 해결하지 못했다"*는 **지지하지 않는다**.

## 축

- **A1** — 분석 입력
- **A2** — 메모리 범위(회계 경계)
- **A3** — 정적 상한 산출
- **A4** — 실행 전 판정
- **A5** — 실제 예약
- **A6** — 비행 SW 연계
- **A7** — 타깃 ISA·실행환경
- **A8** — 같은 회계 영역 실행 관측과 대조
- **A9** — 증거 등급

## 비교표

| 연구 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | 등급 |
|---|---|---|---|---|---|---|---|---|---|
| **OnAIR: Applications of the NASA On-Board Artificial Intelligence Research Platform** | 해당 없음 (플랫폼) | 불명 | 아니오 | 판정 없음 | 해당 없음 | cFS·OnAIR (본체) | 비행 SW / 위성·드론·로봇 | 아니오 | `fulltext_partial` |
| **TinyIREE: An ML Execution Environment for Embedded Systems from Compilation to Deployment** | 컴파일러 IR (MLIR/IREE) | 불명 | 부분 (임베디드 배포 옵션) | 판정 없음 | 해당 없음 | 일반 임베디드 / bare-metal | MCU·CPU (LLVM ISA/ABI) | 아니오 | `search_summary` |
| **MLIR: Scaling Compiler Infrastructure for Domain Specific Computation** | 컴파일러 IR | 불명 | 아니오 | 판정 없음 | 해당 없음 | 없음 | 전방위 | 아니오 | `search_summary` |
| **TensorFlow Lite Micro: Embedded Machine Learning on TinyML Systems** | 배포 아티팩트 (FlatBuffer 모델) | 비영속 버퍼 재사용 계획 + 영속 메타데이터 + scratch. **주의**: `arena_used_bytes()`는 scratch를 포함하지 않는다(공개 이슈 #890) | 예 (arena 크기) | 판정 없음 (문서는 debugging only로 표기) | enforced (arena를 실제로 잡음) | 없음 (MCU 런타임) | MCU 정적 arena | 아니오 | `project_doc_fulltext+source_fulltext` |
| **Apache TVM RFC 0009: Unified Static Memory Planning (USMP)** | 컴파일러 IR (TIR) | workspace pool + **parameter pool**(`--usmp-parameter-pools`) 분리. I/O 텐서를 workspace에 넣는 U4 사용례 포함. **정정(E39b)**: E39a가 쓴 'constant pool'은 이 RFC 원문에 **0건**이고 개념 대응만 맞다 | 예 | 판정 없음 (코드젠에 씀) | enforced (풀을 잡음) | 없음 | MCU·임베디드 AOT | 아니오 | `project_doc_fulltext` |
| **ExecuTorch Memory Planning** | 컴파일러 IR — 입력은 `ExportedProgram`이고 emission 직전 단계다. **정정(E39b)**: 이 문서는 'EXIR'라는 이름을 쓰지 않는다(0건) | mutable tensor를 고정 크기 arena에 배치. backend delegate가 초기화 후 사전컴파일 데이터를 내릴 수 있어 peak가 달라짐 | 예 | 판정 없음 | 문서가 말하는 것은 *계획하지 않은 I/O는 사용자가 버퍼를 준다*까지다. **정정(E39b)**: 계획된 arena를 누가 잡는지는 이 문서에 없으므로 `enforced`는 이 문헌만으로 확정되지 않는다(E44의 구분: 호출의 존재 ≠ 이 예산의 예약) | 없음 | 모바일·엣지 | 아니오 | `project_doc_fulltext` |
| **TASO: Time and Space Optimization for Memory-Constrained DNN Inference** | 소스 모델 (CNN) | layer별 workspace. 전체 회계 경계는 불명 | 예 (layer별 footprint 상한) | 판정 없음 — **최적화에만 씀**(ILP로 primitive 선택) | 불명 | 없음 | ARM Cortex-A15 CPU | 아니오 | `search_summary` |
| **Quilt / Peak-memory-aware partitioning and scheduling for multi-tenant DNN model inference** | 컴파일러 IR (ONNX-MLIR) | liveness 기반 메모리 풀. 정확한 경계는 불명 | 예 (peak memory 인지) | **OOM 방지에 씀 — 단, 거부가 아니라 분할·스케줄링으로 맞춘다** | memory pool generator가 풀을 만듦 | 없음 | 다중 테넌트 GPU / desktop-scale edge | 불명 | `search_summary` |
| **Futureproof Static Memory Planning** | 배치 계획 | 불명 | 예 (단편화 상한) | 판정 없음 | 불명 | 없음 | 불명 | 아니오 | `search_summary` |
| **Event-Driven Simulation for Rapid Iterative Development of Distributed Space Flight Software (VISORS GNC 사례)** | 해당 없음 (운용 관행) | 동적 메모리 총량 | 아니오 (요구사항으로 부여) | **아니오 — 초과 시 고의 크래시**(런타임 사후 강제) | enforced (시뮬레이션에서 강제) | 비행 SW | 위성 | 아니오 | `search_summary` |
| **core Flight System (cFS) — NASA NTRS 자료** | 해당 없음 | 불명 | 아니오 | 판정 없음 | 불명 | cFS 본체 — **저 TRL 앱(AI 추론 포함)의 sandboxing 지원을 언급** | 비행 SW | 아니오 | `search_summary` |
| **onAIR-MLIR (이 연구)** | 컴파일러 IR (IREE stream layout) + 배포 아티팩트(vmfb·내장 ELF) 교차검사 | **앱별 부분 계약**: per_call(I+O+T) + 모듈 상주 상수. 제외: IREE 런타임 고정비·cFS/OSAL·태스크 스택·wrapper I/O (계약이 scope=program-allocated buffers only; excludes IREE runtime context (VM, HAL device, module tables) and the task stack 로 매 판정마다 명시) | 예 (bound_method=static_from_stream_layout) | **예 — 런타임 자원 획득 전 ADMIT/NOT_ADMITTED** | **declared** — 예산은 앱에 부여한 값이며 물리 RAM을 예약하지 않는다 (예약 호출 0건 / 소스 95파일, `harness/budget_provenance.py`) | **cFS 앱 + NASA 공식 OnAIR 로더** | AArch64 QEMU 게스트 cFS · x86-64 cFS · qemu-user | **예 — 같은 회계 영역의 HAL 관측 피크와 대조** | `repo` |

## 출처와 근거

### OnAIR: Applications of the NASA On-Board Artificial Intelligence Research Platform
- 위치: AAAI 2025 (v39 i28, 28893-28899) · DOI 10.1609/aaai.v39i28.35156
- URL: <https://ojs.aaai.org/index.php/AAAI/article/view/35156>
- URL: <https://dl.acm.org/doi/10.1609/aaai.v39i28.35156>
- 이 연구와의 관계: 이 연구가 올라타는 플랫폼 (경쟁 대상 아님)
- 근거: **부분 원문**(AI Magazine 공동 게재본 4/16 청크): 인지 아키텍처·플러그인 인터페이스·배치 사례를 서술하고, 메모리 상한이나 실행 전 admission은 반환된 청크 어디에도 없다. 이전 판의 근거는 검색 요약이었다(E39a 정정)

### TinyIREE: An ML Execution Environment for Embedded Systems from Compilation to Deployment
- 위치: IEEE Micro 42(5) 2022, 9-16 · DOI 10.1109/MM.2022.3178068
- URL: <https://ieeexplore.ieee.org/document/9782563/>
- URL: <https://arxiv.org/abs/2205.14479>
- 이 연구와의 관계: 이 연구가 쓰는 컴파일·배포 스택의 기반
- 근거: 검색 요약: 제한된 메모리·연산 자원을 수용하는 IREE 배포 옵션 집합. MobileNet SSD 결과 포함. 정적 상한을 배치 전 판정에 쓰는 서술은 검색 요약에 없음

### MLIR: Scaling Compiler Infrastructure for Domain Specific Computation
- 위치: CGO 2021 / arXiv 2002.11054 · DOI 10.48550/arXiv.2002.11054
- URL: <https://arxiv.org/abs/2002.11054>
- 이 연구와의 관계: 분석 지점이 되는 IR 인프라
- 근거: IR 인프라 자체

### TensorFlow Lite Micro: Embedded Machine Learning on TinyML Systems
- 위치: MLSys 2021
- URL: <https://proceedings.mlsys.org/paper_files/paper/2021/file/6c44dc73014d66ba49b28d483a8f8b0d-Paper.pdf>
- URL: <https://github.com/tensorflow/tflite-micro/issues/890>
- 이 연구와의 관계: 정적 arena 산정의 대표 선행 — 이 저장소는 v0.29에서 필수 baseline에서 제외했다(실행환경 불일치)
- 근거: E39b: 문서 9,849 B + 헤더 8,712 B 전문 대조. **정정**: `arena_used_bytes`와 'debugging'은 `memory_management.md`에 **0건**이고 *"For debugging only."*는 `micro_interpreter.h:143`의 주석이다 — CLAUDE.md가 바로 앞 문장에서 인용한 그 헤더와 **같은 주석 블록**인데 귀속이 한 줄 어긋나 있었다. *"모든 유효 입력에 대한 상한임을 증명한다"*는 주장이 두 문헌 어디에도 없다는 것은 원문에서 확인된다(`upper bound` 0건)

### Apache TVM RFC 0009: Unified Static Memory Planning (USMP)
- 위치: Apache TVM RFC / tracking issue #8404
- URL: <https://github.com/apache/tvm-rfcs/blob/main/rfcs/0009_Unified_Static_Memory_Planning.md>
- URL: <https://discuss.tvm.apache.org/t/rfc-unified-static-memory-planning/10099>
- 이 연구와의 관계: **workspace pool과 constant pool을 컴파일 시점에 분리**하는 선행 — 이 저장소의 per_call/constants 분해와 같은 축
- 근거: E39b: RFC 원문 30,902 B 전문 대조 (커밋 고정, sha256 기록). A1·A2 확인, A2 용어 정정

### ExecuTorch Memory Planning
- 위치: PyTorch ExecuTorch 공식 문서 / arXiv 2605.08195
- URL: <https://docs.pytorch.org/executorch/stable/compiler-memory-planning.html>
- URL: <https://github.com/pytorch/executorch/blob/main/exir/memory_planning.py>
- 이 연구와의 관계: 텐서 수명 기반 arena 계획의 현행 대표
- 근거: E39b: 문서 원문 7,815 B 전문 대조. naive/Greedy **두 알고리즘을 제공**하고 naive가 *"serves as an upper bound"*라고 적는다 — **정정**: E39a의 'greedy best-fit **기본**'에서 '기본'은 이 문서에 근거가 없다

### TASO: Time and Space Optimization for Memory-Constrained DNN Inference
- 위치: SBAC-PAD 2020 · DOI 10.1109/SBAC-PAD49847.2020.00036
- URL: <https://arxiv.org/abs/2005.10709>
- 이 연구와의 관계: **layer별 메모리 상한**을 명시적으로 쓰는 선행 (ARM Cortex-A15)
- 근거: 검색 요약: ILP 기반 primitive 선택, layer별 메모리 footprint 상한을 반영한 workspace 할당, 메모리 2.2배 감소

### Quilt / Peak-memory-aware partitioning and scheduling for multi-tenant DNN model inference
- 위치: Journal of Systems Architecture 2026 · DOI 10.1016/j.sysarc.2026.103696
- URL: <https://www.sciencedirect.com/science/article/abs/pii/S1383762126000147>
- 이 연구와의 관계: **가장 가까운 후보** — MLIR 계열 정적 분석 + OOM 방지
- 근거: 검색 요약: liveness analyzer + model partitioner + memory pool generator + runtime interface generator 4개 구성요소. 지연 25.4%/37.7% 감소

### Futureproof Static Memory Planning
- 위치: arXiv 2504.04874
- URL: <https://arxiv.org/html/2504.04874>
- 이 연구와의 관계: 단편화 상한(근사비)을 다루는 최근 연구
- 근거: 검색 요약: 알고리즘 품질을 단편화 상한으로 표현(예: 6-근사)

### Event-Driven Simulation for Rapid Iterative Development of Distributed Space Flight Software (VISORS GNC 사례)
- 위치: arXiv 2505.12502
- URL: <https://arxiv.org/pdf/2505.12502>
- 이 연구와의 관계: **비행 SW의 앱별 메모리 예산 실무** — 이 연구의 예산 개념과 가장 가까운 운용 관행
- 근거: 검색 요약: VISORS GNC는 동적 메모리 최대 50 MB 요구사항, 고충실도 시뮬레이션에서 초과 시 고의 크래시. 비행 코드에서 malloc/free 금지가 일반적

### core Flight System (cFS) — NASA NTRS 자료
- 위치: NASA NTRS
- URL: <https://ntrs.nasa.gov/api/citations/20240004389/downloads/cFSFSW2024v10.pdf>
- URL: <https://github.com/nasa/cFS>
- 이 연구와의 관계: 배치 대상 프레임워크
- 근거: 검색 요약: cFS가 AI Inferencing 같은 저 TRL 앱의 안전한 sandboxing을 지원한다고 언급. 구체적 메모리 예산 admission 기법은 검색 결과에 없음

### onAIR-MLIR (이 연구)
- 위치: 미출판
- URL: <https://github.com/wookjaeya/onAIR-MLIR>
- 이 연구와의 관계: 비교 대상이 아니라 비교의 기준점
- 근거: 계약 results/p1_smartcam_feasibility/build/smartcam.contract.json / bounded 18222796 = per_call 9382092 + constants 8840704

## 집계

- 수록 연구: **11건**(이 연구 포함 12)
- `불명`으로 남긴 칸: **10개** (A2 5 · A5 3 · A7 1 · A8 1) — 그중 회계 경계(A2)는 **5개**이며, 이 축은 원문 근거 없이는 단정하지 않는다
- `fulltext`(전체 원문) 등급 칸: **0개** · `fulltext_partial`(부분 원문) 칸: **1개**
  - 부분 원문은 Scholar Gateway가 반환한 청크 본문이며, 각 행의 `fulltext_source`에 받은 청크 번호와 전체 청크 수를 적었다. **전체 원문 대조가 아니다.**
  - 이 코퍼스는 이 표의 IEEE·ACM·Elsevier·arXiv 항목을 담고 있지 않다(실측): 같은 도구에 이 주제를 물어도 그 논문들의 본문은 나오지 않는다. 따라서 나머지 행의 등급은 그대로다.
- 실행한 검색식: **12건** (`searches.json`)

## 이 표가 지지하는 문장 / 지지하지 않는 문장

**지지한다**: 실행한 12건의 검색 범위에서, A1(컴파일러 IR 분석)·A4(실행 전 판정)·A6(cFS·OnAIR 연계)·A8(같은 회계 영역 실행 관측 대조)를 **함께** 갖춘 연구는 확인되지 않았다. 가장 가까운 것은 Quilt(ONNX-MLIR 정적 분석 + OOM 방지)이며 A4에서 갈린다 — 검색 요약 기준으로 Quilt는 **거부하는 대신 분할·스케줄링으로 맞춘다**. TASO는 상한을 **최적화에만** 쓰고, TVM USMP는 workspace/constant 풀을 컴파일 시점에 분리하지만 판정에 쓰지 않는다. VISORS GNC는 앱별 예산을 두지만 **사후 크래시**로 강제한다.

**지지하지 않는다**: *"최초"*, *"선행연구가 해결하지 못했다"*, 그리고 남의 연구의 **회계 경계(A2)에 대한 단정**. 이 셋은 원문 대조(E39b) 없이는 쓸 수 없다.

