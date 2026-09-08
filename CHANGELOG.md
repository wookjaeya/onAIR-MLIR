# CHANGELOG

형식: [버전] 날짜 — 변경. 가설 판정 변경은 반드시 "판정:" 접두어, 이전 주장 철회는 "정정:" 접두어로 기록.

## [v0.18] 2026-09-08
- E23: 외부 검토(v0.15) 잔여 4건 처리(`docs/EVIDENCE_v0.18_E23.md`) — F4(표현 정정),
  F8(A5a·A5b 손상 방식 코드화), F10(OnAIR 바인딩 갭), F11(범위 명시).
- **판정(D26)**: A5b 시나리오가 EVIDENCE_v0.12 §2.1의 구조 손상이 아니라 A5a와 동일한 임의
  bit flip을 쓰고 있었음 — 두 방식을 구분하는 필드조차 없어 저장소 코드로는 E17의 A5b를
  재현할 수 없었다. `harness/corrupt_vmfb.py` 신설(ZIP64/STORED 외과적 패치 + CRC 갱신),
  `corrupt_method` 필수화(누락·미인식은 거부). 보관 vmfb 8/8에서 컨테이너 유효·타 엔트리
  불변·크기 동일·결정적 확인, `iree.runtime`으로 실제 로드해 E17과 같은 오류 문자열로
  거부됨을 확인(A5b의 네 번째 레벨).
- **판정(D27)**: OnAIR `CompiledLearner`가 계약이 지목한 vmfb를 sha256·크기 검사 없이
  로드하고 있었음(C 경로는 두 검사를 자원 획득 전에 수행). `artifact_binding.py` 신설,
  `verify_artifact_hash=True` 기본, 계약에 해당 필드가 없으면 검사 생략이 아니라 거부.
- **정정(D25)**: `iree-dump-module` 부재 시 uncaught `FileNotFoundError`로 전체 크래시.
  **E22가 만든 CI의 without-deps 레그가 첫 실행에서 실제로 잡았다** — E22의
  `sys.meta_path` import 차단은 모듈만 숨기고 콘솔 스크립트를 남기므로 원리적으로 재현
  불가능했던 조건. `OSError` 포착 + `(None,None)` 반환으로 "관측 못 함"과 "관측했고 없음"을
  구분, 상수 독립 확인 불가는 `null` + 기본 거부, 하네스는 `iree_tools_available()`로 SKIP.
- **정정**: `docs/EVIDENCE_v0.17_E22.md` §6 정오표 추가(§1의 "패키지가 아예 없는 환경을
  시뮬레이션" 서술은 "모듈만 없는 환경"으로 정정, §4 판정은 D25 수정 이후에 참).
- **정정**: `docs/EVIDENCE_v0.13_E18.md` §7 정오표 추가 — `Operation.walk()` 서술은 실제
  구현(자체 재귀 `_walk()`)과 다름, "정규 MLIR pass" 명칭은 "MLIR API 기반 구조적
  post-processing verifier"로 정정(수치·판정 불변).
- `contract_negative_tests.py` 107/107 → **125/125**. 도구·모듈 모두 부재한 환경에서도
  크래시 없이 50/50 + 5 SKIP. 14개 보관 계약 diff 0 유지.

## [v0.17] 2026-09-08
- E22: 외부 검토 F9 재현성 실제 확보(`docs/EVIDENCE_v0.17_E22.md`) — "96/96, 환경 구축
  불필요"가 fresh clone에서 재현되지 않던 문제를 실제 `git clone`으로 재현 후 해결.
- **정정(D24)**: `contract_negative_tests.py`가 `iree.compiler.ir` 부재 환경에서 uncaught
  `RuntimeError`로 전체 크래시(요약 0줄)하던 버그 발견·수정. `Result`에 `skip` 상태 신설,
  3개 지점을 명확한 SKIP으로 정리.
- E21의 F3(구조적 검증기 미설치 기본 하드실패)이 이 시험 하네스 자신의 서브프로세스 호출과
  상충하던 것을 `structural_available()`/`with_structural_override()`로 해소(각 시험이
  실제로 검사하려는 조건만으로 판정되도록).
- `results/e14_aarch64_qemu/*/dump/`(242개 파일, 6.5MB)를 `.gitignore` 제외에서 빼고 커밋 —
  회귀·음성 시험이 실제로 요구하는데 저장소에 없었음.
- `requirements.txt`(버전 고정), `.github/workflows/contract-negative-tests.yml`(fresh
  checkout CI, with/without iree.compiler.ir 두 경로) 신설.
- 이 세션 내 실제 `git clone`으로 재현 확인: iree-base-compiler 설치 시 **107/107**, 미설치
  시 크래시 없이 **77/77 + 3 SKIP**. README의 "환경 구축 불필요" 문구가 이제 정확한 주장이 됨.

## [v0.16] 2026-09-08
- E21: 외부 검토(v0.15 최신본, `docs/reviews/REVIEW_v0_15_LATEST.md`) fail-open 결함 6건 수정
  (`docs/EVIDENCE_v0.16_E21.md`) — 11개 finding(F1–F11)을 독립 에이전트 11개로 병렬 검증(9건
  confirmed, 1건 partially_confirmed=F3, 1건 not-a-defect=F11), 코드 fail-open 결함 6건(F1,
  F2, F3, F5, F6, F7)을 실제 재현 후 수정.
- **정정**: F2(ABI 반사 부재 미거부)·F3(구조적 검증기 미설치시 opportunistic)·F5(stream.resource.pack
  비상수 unresolved 누락)는 검증 과정에서 원 리뷰의 severity(주로 P0)가 과대평가였음이 확인됨.
  특히 F3은 "MANDATORY라 부르면서 은폐"라는 리뷰의 프레이밍이 과장으로 판정됨(이 정확한 예외가
  이미 5곳에 문서화·E19에서 시험됨) — 다만 표현과 동작의 정책적 불일치는 타당해 기본값은 변경.
- 수정: F1(빈 `--dump-dir`로 one-invocation 신호 전부 None → 통과)은 기본 하드 실패
  (`--allow-unverified-invocation`), F2(ABI 반사 부재)는 기본 하드 실패
  (`--allow-missing-abi-declaration`), F3(구조적 검증기 미설치)은 기본 하드 실패
  (`--allow-missing-structural-checker`), F5(`stream.resource.pack` 비상수 슬라이스)는
  형제 분기와 대칭인 unresolved 처리로 수정(IREE 상류 실제 문법으로 재현), F6(스택 분석이
  스스로 불신뢰로 분류해도 KNOWN=1)은 세 신호 중 하나라도 불신뢰면 강제 미확인 처리, F7(C 게이트가
  "single-f32"라 주장하나 dtype 미검사)은 `CONTRACT_DTYPES_ALL_F32` 매크로 신설 + C 양쪽 게이트
  반영.
- 전 6건 수정 전 코드로 되돌려 신규 시험이 실제로 실패함을 확인(revert-and-confirm-fail).
  `contract_negative_tests.py` 96/96 → **107/107**. 보관 14개 헤더는 신규 매크로 반영해 재생성
  (계약 수치 자체는 diff 0 유지). F4/F8/F9/F10/F11은 후속 실험(E22/E23)으로 이연.

## [v0.15] 2026-09-08
- E20: E19 구조적 크로스체크 적대적 코드 리뷰(`docs/EVIDENCE_v0.15_E20.md`) — 이 세션 내에서
  E19의 diff를 4개 독립 관점(정확성/시험 커버리지/단순화/강건성) 병렬 리뷰 + finding당 3인 반박
  검증으로 검토. 13건 중 11건 확인, 2건 반박.
- **정정: 과잉 거부(over-rejection) 결함 2건 발견·수정(D16, D17)** — 둘 다 실제 재현됨(추측 아님):
  (A) 크로스체크가 계약이 실제로 서명하는 `p`가 아니라 정규식 파서의 "파일 마지막 print=최다
  lowering" 낡은 가정에 의존하는 `whole`과 비교돼, 인쇄 순서가 바뀌면 정상 모델도 거부될 수
  있었음(conv2d 두 print 청크 순서만 교환해 재현). (B) constants(sum) 비교가 계약이 실제 채택하는
  `const_b`(패킹 크기)가 아니라 `dense_sum`과 비교돼, 정렬 패딩이 있는 모델은 영구적으로 오탐
  거부됐을 것(mlp16k 패킹 크기만 64B 편집해 재현). 둘 다 보관 layout IR의 surgical 텍스트 편집만
  으로(재컴파일 없음) 재현.
- 수정: 비교 기준을 `p`/`const_b`로 교체, 3곳에 중복 구현됐던 diff 로직을
  `mlir_alloc_walk.diff_against_regex` 공유 헬퍼로 통합(드리프트 위험 제거). 재현 시나리오를
  고정 회귀 시험으로 등록하고, 수정 전 코드로 되돌려 시험이 실제로 실패함을 확인
  (revert-and-confirm-fail). 시험 갭 4건(dispatches-only 양성, allow-override 예외분기,
  constants 진짜불일치, graceful-degradation 정식화) 추가. `contract_negative_tests.py`
  85/85 → **96/96**. 보관 14개 계약은 diff 0 유지.
- `docs/EVIDENCE_v0.14_E19.md`에 §8 정오표 추가(철회 아님 — 14/14 일치 자체는 여전히 참, padding=0
  코퍼스라 이 두 결함이 그 검증에서 드러나지 않았을 뿐임을 명시).

## [v0.14] 2026-09-08
- E19: 정규 MLIR pass 2단계(`docs/EVIDENCE_v0.14_E19.md`) — E18의 구조적 추출기
  (`harness/mlir_alloc_walk.py`)를 `harness/make_contract.py`에 **필수 크로스체크**로 결선.
  대체가 아니라 상호 검증: 정규식 파서와 구조적 추출기가 같은 layout IR을 각각 읽고, 다섯 항목
  (inputs/outputs/transient_slabs 원소별, constants 합계, entry_found, unresolved 존재)이
  불일치하거나 구조적 추출기가 파싱에 실패하면 계약을 **거부**(`--allow-structural-mismatch`로만
  우회, D13과 같은 hard_fail_errors/raise 경로). `iree.compiler.ir`가 설치되지 않은 환경에서는
  하드 실패가 아니라 스킵(기록만, E15 이전 기준선으로 안전하게 저하) — 확인됨(§4).
- 검증: 14개 보관 계약을 **실제 프로덕션 경로**(서브프로세스로 `make_contract.py` 재실행)로
  재생성해 수치 diff 0 + 신규 필드 `provenance.structural_walker` 14/14
  `available=True, agrees_with_regex_parser=True` 확인(E18은 구조적 추출기를 직접 호출했을 뿐
  `make_contract.py`를 거치지 않았음 — 이번이 처음으로 프로덕션 경로 자체를 검증). 하드 실패
  배선은 in-process monkeypatch로 불일치·파싱예외 두 조건 모두 실제 `SystemExit` 확인.
  `harness/contract_negative_tests.py` 66/66 → **85/85**.
- CLAUDE.md 우선순위 3번의 미해결 평가지표("컴파일러 버전 변경 시 명시적 실패")에 실제 강제
  지점을 마련(다른 IREE 버전으로의 실제 재확인은 여전히 범위 밖).

## [v0.13] 2026-09-08
- E18: 정규 MLIR pass 1단계(`docs/EVIDENCE_v0.13_E18.md`) — `harness/mlir_alloc_walk.py` 신설.
  `static_mem_bound.py::parse_alloc_ir`가 하던 일(entry 함수의 입출력·transient·module 상주 상수
  크기 추출)을 정규식이 아니라 IREE의 실제 MLIR Python API(`iree.compiler.ir`)로 재구현.
- 기술적 장벽 해소: `--mlir-print-ir-after`가 함수별로 조각내 출력하는 문제(entry 함수 청크가
  다른 청크의 `util.initializer`가 정의하는 전역을 참조해 단독으로는 파싱 불가) — `util.global.load`
  /`store` 줄에서만 이름·타입을 모아 선언을 합성하는 좁은 전처리로 해결. 이 한 단계만 텍스트
  처리이고, 그 이후 모든 크기 추출은 `Operation.walk()`의 진짜 `op.name`과 `Value.owner`를 통한
  define-use 체인 추적(→ `arith.constant`)으로 이뤄진다 — 인쇄된 텍스트의 `{%c8}`을 읽지 않는다.
- 검증: 보관된 v0.9의 14개 `layout_ir`(재컴파일 없음, one-invocation 규칙 유지) 전부에서 구조적
  추출기와 기존 정규식 파서의 값이 일치(inputs/outputs/transient 원소별, constants 합계,
  entry_found, unresolved 존재 여부). 미인식 op 음성 시험은 텍스트를 손으로 바꾸는 대신 **실제
  화이트리스트를 좁혀서**(D13의 진짜 시나리오에 더 가까움) 재확인. `harness/contract_negative_tests.py`
  가 51/51 → **66/66**으로 확장.
- 범위 밖(명시): `make_contract.py` 파이프라인으로의 통합, `stream.resource.pack` 실사용 시험(현재
  모델 어느 것도 안 씀), 다른 IREE 컴파일러 버전에서의 재확인.

## [v0.12] 2026-09-08
- E17: AArch64 게스트 재현(`docs/EVIDENCE_v0.12_E17.md`) — 이 세션에서 AArch64 크로스 툴체인·IREE
  런타임 크로스 빌드·qemu-system-aarch64 게스트를 처음부터 재구축(정상 부팅, 크래시 재발 없음).
- **A5b 최초 실행**(D11 실제 해소): `.vmfb`(ZIP 컨테이너)의 `module.fb` FlatBuffer 자신의
  root-table uoffset(첫 4바이트)을 구조적으로 손상시키고(임의 bit flip이 아님), 손상된 파일의
  sha256/bytes로 계약을 갱신해 binding이 MATCH되도록 구성 — native x86-64·cFS x86-64·**cFS
  AArch64 게스트** 세 레벨 전부에서 admission ADMIT → binding MATCH →
  `runtime_load_failed`(IREE FlatBuffer 검증기가 안전하게 거부) → `cleanup_calls:1` → cFS
  OPERATIONAL 유지를 확인. 크래시 지표 0. 이 연구가 v0.9에서 "실행 근거 없이 확인했다고 서술"한
  것으로 정정했던 항목을 실제 실행 증거로 채운다.
- mlp16k·multibranch의 A2 경계값(B−1/B/B+1)을 native(양쪽 모델)와 cFS(mlp16k)에서 확인(6+3건 전부
  정확) — conv2d는 v0.9에서 이미 확인됨. 세 정적 모델 모두 native 레벨 완료.
- A7을 재시작 2회+DELETE로 확장(v0.9는 재시작 1회에 그침): x86-64 native_std와 AArch64 게스트
  양쪽에서 `cfs_cmd.py`로 ES 명령 전송 → `init_count` 3, `cleanup_calls` 3, 이중 해제 없음, DELETE
  후에도 cFS core 생존 확인. ES 명령 기반 정상 종료 경로를 사용했으므로 v0.9 §11.2가 남긴 "정상
  종료 시 자원 회수 미검증" 문제도 함께 해소(SIGINT 강제 종료가 아닌 경로에서 cleanup이 매번 정확히
  1회 호출됨을 확인).
- E16(v0.11)의 신규 게이트(스택 실거부·blob 크기 선검사)를 AArch64 게스트에서도 재확인 — x86-64와
  동일한 패턴(EVS 이벤트·JSON 필드 일치).
- 범위 밖(명시): multibranch cFS 레벨 A2, dynamic 모델의 게스트 재현, 정규 MLIR/IREE pass, 동일
  경계 대안 비교, 다중 앱 동시 admission, 시간 축 계약, RTEMS 단계는 여전히 미착수.

## [v0.11] 2026-09-08
- E16: C 게이트 보강(`docs/EVIDENCE_v0.11_E16.md`) — 환경(cFS native_std, IREE C 런타임 x86-64)을
  이 세션에서 재구축해 실제 `core-cpu1` + `AI_LEARNER`로 검증.
- D15 조치: `ai_learner.c`의 스택 확인을 `AI_LEARNER_Init()` 최선두로 이동하고, `accounted=false`
  에서 초기화를 실제로 거부하는 분기(`EID_STACK_REJECT`)를 신설. 이전엔 확인이 IREE 세션·입력버퍼·
  SB 파이프 생성 뒤에서 텔레메트리로만 기록됐다. 배포된 startup script의 스택 값만 인위적으로 줄여
  실제 cFS 기동에서 거부(admission/binding 단계 도달 안 함, EVS CRITICAL, cleanup_calls:1, cFS core는
  OPERATIONAL 유지)를 확인.
- R8 조치: `ai_learner.c`/`native_learner.c` 모두 `malloc` 전에 파일 크기를 `contract.artifact.bytes`와
  비교하도록 수정 — 크기가 다르면 해시 계산·할당 없이 즉시 `CONTRACT_ARTIFACT_MISMATCH`. 크기가 같은
  경우의 기존 해시 비교 경로는 변경 없음(모델 교체 시나리오로 양쪽 다 검증).
- 두 실행기에 인터페이스(단일 f32 입력·출력) defense-in-depth 게이트 추가(신규 종료 코드/이벤트) —
  E15의 `gen_contract_header.py` 검증을 우회한 손편집 헤더에 대한 마지막 방어선.
- 부수 발견·수정: `scripts/50_wire_cfs_ai_learner.sh`가 `WIRING.md`가 명시한 "stack = base + kernel"
  규칙을 따르지 않고 시작 스크립트 스택을 항상 262144로 하드코딩하던 버그. D15의 실제 거부 gate를
  x86-64에 적용하자마자 non-zero kernel stack을 가진 모델(예: mlp16k, kernel=16 B)에서 상시 거부로
  드러났다 — `scripts/51_build_cfs_aarch64.sh`와 동일한 계산으로 수정.
- 범위 밖(명시): AArch64 게스트 재구축·재현(A2 경계값 전 모델·A5b 구조 손상·재시작 2회+DELETE·정상
  종료 cleanup 확인)은 이번에도 하지 않음 — 다음 우선순위로 유지.

## [v0.10] 2026-09-08
- E15: 계약 도구 fail-closed 전환 + 음성 시험(`docs/EVIDENCE_v0.10_E15.md`). v0.9.1이 정정으로 남긴
  D12·D13·D14를 실제로 수정.
- `harness/static_mem_bound.py::parse_alloc_ir`: 정규식이 한 줄(`[^\n]*`)로 한정돼 있어 MLIR이 연산을
  여러 줄로 출력하면 크기를 조용히 누락하던 결함(직접 재현으로 확인)을 경계 있는 non-greedy 패턴으로
  수정. entry 함수 본문의 자원 op를 화이트리스트와 대조해 미인식 op를 `unresolved`로 승격(이전엔 무시).
  독립 실행 경로의 `all_static`에 `entry_found` 누락도 수정(D12).
- `harness/make_contract.py`: one-invocation 검사에 layout IR을 결합(D14) — layout IR이 참조하는
  dispatch 심볼이 `--dump-dir`에 실제 파일로 있는지 확인, 없으면 거부. ABI 불일치·target triple
  불일치·ELF 분석 대상 불일치를 note에서 hard fail로 승격(각각 `--allow-*` 플래그로만 우회 가능).
  스키마 검증을 파일 기록 전으로 이동, `jsonschema` 부재 시 이제 실패(이전엔 조용히 건너뜀).
- `harness/gen_contract_header.py`: `bound_method` 화이트리스트, `bounded_bytes` 비음수 검사,
  bound-known 계약의 커널 스택 필드 필수화(`--allow-unknown-stack`로만 우회), 입출력 개수·dtype이
  native/cFS C 런타임이 하드코딩한 단일 f32 입출력과 다르면 거부, sha256 hex 검증 강화.
- 신규 `harness/contract_negative_tests.py`: 위 변경들이 실제로 "거부돼야 할 입력을 거부하는지" 확인하는
  음성 시험(20건) + 단위 시험(5건) + 회귀 시험(26건) = **51/51 PASS**.
- 회귀 확인: 보관된 v0.9의 14개 계약(mlp16k·mlp16k_swap·conv2d·conv2d_swap·multibranch·
  multibranch_swap·dynamic × aarch64/x86_64)을 원본 layout IR·dump-dir·ELF 분석에서 fail-closed
  도구로 재생성 — **14/14 계약·14/14 헤더 값 완전 불변**(diff 0). 이번 전환이 기존 유효 입력의
  결과를 바꾸지 않았음을 증명.
- 범위 밖(명시): C 게이트 자체(스택 미달 거부 분기, blob 할당 전 크기 선검사, 입출력 개수 런타임
  gate)는 x86-64/cFS 환경 재구축이 필요해 이번 실험에 포함하지 않음(EVIDENCE_v0.10 §5, EVIDENCE_v0.9
  §11.9 Phase 3). 정규 MLIR/IREE pass, AArch64 게스트 재현(A5b 등)도 마찬가지로 범위 밖.

## [v0.9.1] 2026-09-08
- 외부 검토 2건(`docs/reviews/REVIEW_v0_9_CODE_AND_MD_AMENDMENTS.md`,
  `docs/reviews/OPINION_v0_9_SPACE_CPU_AI_INTEGRATED.md`, 기준 커밋 `33e1ebc`)을 코드·원자료와 직접
  대조해 반영. `docs/EVIDENCE_v0.9_E14_stage1.md` §11(정오표) 신설, 기존 §0–§10은 고쳐쓰지 않음.
- 정정: A5b(계약 해시가 손상 파일을 가리키는 경우, `runtime_load_failed` 경로)를 "native에서
  확인했다"는 §4.1·§9 서술을 **철회**. native·cFS 어느 레벨에서도 A5b는 실행되지 않았다
  (`runtime_load_failed` 7/7 `null`). §3 표에는 A5a 행만 있어 문서 자체가 자기모순이었다(D11).
- 정정: "7/7 PASS"의 범위를 명시. 계획(31개 시나리오) 대비 7개만 실행, expect 조건이 축소됐고
  (`min_completed` 15→3 등, `hal_peak_le_bounded` 독립 대조 삭제), 7개 전부 `EXIT=124`(timeout SIGINT)
  로 종료돼 **정상 종료 시의 자원 회수는 미검증**(정상 시나리오 cleanup 0회).
- 정정: 스택 회계(`kernel_stack_accounted`)가 admission gate가 아니라 텔레메트리임을 명시(D15).
  `accounted=false`에서도 초기화를 거부하는 분기가 없고, 빌드가 startup에 써넣은 `base+kernel`을
  앱이 그대로 되읽어 비교하므로 구조상 항상 참에 가까운 항등식이다. 합격기준 #8의 표현을
  "task stack 설정에 반영·확인"으로 축소.
- 정정: conv2d의 HAL peak가 native(1,352 B)와 cFS(3,528 B=bounded)에서 다름을 명시 — "HAL peak =
  contract" 일반화 금지. cross-target 비교(`comparison/*.json`)는 계약 수치 비교일 뿐 실행 대조가
  아님(`native`/`both_sound` 전부 null)도 명시.
- 정정: one-invocation 검증(D10)이 layout IR을 검사에 결합하지 않음을 확인(D14) — "대표적 산출물
  혼입 탐지"로 표현 축소.
- 결함 원장 추가: D11(A5b 무근거 서술) · D12(`static_mem_bound.py` 단독 경로의 `entry_found` 누락) ·
  D13(계약 도구 체인의 fail-open — 파서 미인식 할당 무시, 헤더 생성기의 음수 bound·미지원 method 통과) ·
  D14(one-invocation의 layout IR 미결합) · D15(스택 회계 항등식 구조).
- 중심 문장 개정판(§11.8)으로 CLAUDE.md 갱신, "지금 바로 이어서 할 일"을 두 외부 검토가 합의한
  우선순위(fail-closed verifier(E15) → 남은 cFS 음성·생명주기 시험 → 정규 MLIR pass → 대안 비교 →
  임무 유사 workload·다중 앱)로 교체.
- 보관된 14개 계약의 `artifact.bytes`/`sha256`을 vmfb 실물과 독립 재계산 — **14/14 일치**(도구 결함이
  기존 계약 값 자체를 반증하지 않음을 확인).
- 다음 실험(E15, 계약 도구 fail-closed 전환 + 음성 시험)은 `docs/EVIDENCE_v0.10_E15.md`에서 별도 등록.

## [v0.9] 2026-09-08
- E14 Stage 1(Claude Code 이관분): qemu-system-aarch64 Linux 게스트 + cFS-in-guest + Conv2D/multi-branch/
  동적형상 모델. `docs/EVIDENCE_v0.9_E14_stage1.md`.
- 판정: H3 일반성 범위 재확대 — **모델 종류 불변**(MLP·Conv2D·multi-branch 3종, per-call/상수/bounded
  x86-64=AArch64 완전 동일) + **cFS admission의 타깃 독립성 검증**(AArch64 게스트 cFS `AI_LEARNER` 앱,
  정상/모델교체거부/파일부재/반복무결성/UNKNOWN_BOUND거부/재시작 7/7 시나리오 PASS).
- 정정(D9): v0.7 §4.3(x86-64 "스택 프레임 없음")과 v0.8 §3(AArch64 16B)은 서로 다른 정의를 각 ISA에
  적용한 결과였다. 통일된 정의(callee-save+지역=frame_bytes, +복귀주소=invocation_stack_bytes)로 재분석하면
  x86-64도 같은 16B 프레임 레코드를 가진다(복귀주소 위치만 콜스택 vs 링크레지스터로 다름).
- 정정(D10): 계약 생성기(`harness/make_contract.py`)의 one-invocation 검증이 하드코딩 `true`였다 — 실제로는
  검증을 안 해서 서로 다른 컴파일 호출의 산출물을 섞어도 통과시켰다. 두 독립 신호(임베디드 ELF sha256 매칭
  + dump-dir 파일명의 입력 basename 포함 여부)로 실제 검증 추가, 불일치 재현 케이스로 거부 확인.
- AArch64 태스크 스택 잔차를 모델별로 확정: MLP·multi-branch 16 B(호출 0, 지역변수 없음), Conv2D 191 B
  (동적 스택 재정렬 패딩 63 B 포함 — `elf_stack_frame.py`가 이 관용구를 인식하도록 신규 지원). cFS 시작
  스크립트 스택 크기(`AI_LEARNER_STACK_BASE_BYTES` + `CONTRACT_KERNEL_STACK_BYTES`)에 실제로 반영하고,
  앱이 자신의 실제 태스크 스택 크기를 `CFE_ES_GetAppInfo`로 읽어 회계 충분성을 자체 보고
  (`kernel_stack_accounted`)하도록 구현·검증.
- 신규 도구: `harness/make_contract.py`(one-invocation 산출물에서만 계약 생성), `harness/elf_stack_frame.py`
  (IREE embedded-ELF 정적 분석, x86-64/AArch64 공통 정의), `harness/e14_matrix.py`(모델×타깃 컴파일·추출
  파이프라인), `harness/cross_target_compare.py`, `harness/gen_model_conv2d.py`/`gen_model_multibranch.py`,
  `harness/e14_cfs_scenarios.py`/`e14_make_scenarios.py`, `harness/cfs_cmd.py`(cFE CI_LAB UDP 명령 전송),
  `scripts/51_build_cfs_aarch64.sh`(cFS AArch64 크로스빌드), `scripts/70-73_*.sh`(게스트 준비·부팅·콘솔).
- `native/native_learner.c`·`native/cfs_app/fsw/src/ai_learner.c`를 계약 헤더만으로 모델 독립적으로
  동작하도록 일반화(입출력 형상·엔트리·드라이버·커널 스택을 매크로화), UNKNOWN_BOUND 거부(exit 6)와
  안전한 런타임 로드 실패 경로(exit 7, `runtime_load_failed`) 추가.
- 제안서 §14 합격기준 9개 중 8개 완전 PASS, 1개(경계값 B-1/B/B+1)는 conv2d에서만 cFS 레벨 재검증하고
  나머지 모델은 native 레벨(동일 게이트 코드) 확인으로 갈음 — 부분 PASS로 명시.
- 한계: 다중 AI 앱 동시 admission 미착수, RTEMS 단계 미착수, QEMU 시스템 에뮬레이션이 이 컨테이너
  환경에서 원인 불명 크래시를 2회 겪음(게스트 콘솔 stderr 캡처 개선 후 재발 없음, 하지만 완전한
  안정성을 주장하지 않음).

## [v0.8] 2026-09-08
- 외부 제안(`docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`) 반영, E14 등록.
- Stage 0(이 세션): AArch64/Cortex-A53 교차 컴파일(단일 호출 규칙 준수), 정적 상한 계산,
  LLVM IR/ELF 구조 분석, `qemu-aarch64` user-mode로 Native 실행(참고용, 시간값 비증거).
- 결과: bounded_bytes가 x86-64와 AArch64에서 **동일**(786,476) — 메모리 계획 패스가
  타깃 코드생성보다 앞서기 때문(구조적 이유 확인). HAL 피크·정상상태 per-call·경계값
  B-1/B/B+1·모델교체거부·동적형상거부 전부 x86-64와 일치. out0 수치까지 일치.
- 발견: AArch64 코드생성이 x86-64에 없던 **16B AAPCS64 스택 프레임**을 커널 함수마다
  도입(호출 0개인데도 발생). (2)태스크 스택 예산으로 분류, Stage 1에서 명시적 반영 필요.
- Stage 1(qemu-system-aarch64 Linux 게스트, cFS-in-guest, Conv2D/multi-branch 모델,
  QEMU RTEMS)은 게스트 이미지·영속 저장·반복 자동화가 필요해 Claude Code로 이관
  (`docs/plans/E14_stage1_qemu_system_cfs.md`).
- 계약 스키마에 `target.cpu`, `target.executable_format` 필드 추가.
- 신규 스크립트: `60_setup_aarch64_cross.sh`, `61_build_iree_runtime_aarch64.sh`,
  `62_compile_and_check_aarch64.sh`.
- 문서: `docs/EVIDENCE_v0.8_E14_aarch64.md`, `docs/plans/E14_stage1_qemu_system_cfs.md`.

## [v0.7] 2026-09-08
- 외부 검토(`REVIEW_v0_6_E13_RESEARCH_DIRECTION.md`) §9 순서대로 반영.
- 계약–아티팩트 결합: `artifact.sha256/bytes` + `validity`; `harness/gen_contract_header.py`로 헤더 생성; gate가 IREE에 넘길 바이트를 해시 비교 (D6).
- E11b: peak↔bounded 비교(D5 수정), 정상 상태 per-call 65,544 B(D7 수정), 단계별 카운터.
- E11c/E12c: 같은 ABI 모델 교체 → 런타임 생성 전 거부 (standalone exit 5 / cFS 기동 거부).
- E12d: 모델 파일 부재 → cleanup, cFS OPERATIONAL. `AI_LEARNER_Cleanup()` 모든 실패 지점·종료에 적용.
- E13: 단일 컴파일 호출 덤프. 커널 LLVM IR alloca 0·외부 호출 0, ELF call 0·스택 프레임 0. host AVX-512 FMA(34) vs generic 스칼라(mulss 9) — E4/E5/E6b 원인 규명.
- 규칙: 계약·덤프·배치 아티팩트는 **한 컴파일 호출**에서 생성 (파일명만 달라도 vmfb 해시가 바뀜).
- 표현 수정(검토 §7): RSS 관측값, Python 제거 단일 귀속 불가, init delta 프로세스 전체, 지연 설명은 후보, 타 앱 무영향 미검증, gate 위치는 IREE 초기화 이전.
- 문서: `docs/EVIDENCE_v0.7_E13.md`.

## [v0.6] 2026-09-08
- IREE 런타임 소스 빌드(컴파일러 동일 커밋 e4a3b04, 최소 구성, PIC).
- E11: Native C 변형. 런타임 생성 전 admission; HAL 피크 786,476 = bounded_bytes(상수가 allocator를 통과하는 구성); RSS 4.3 MB(Python 41.5 MB); median 32.2 µs.
- E12: cFS 앱 `AI_LEARNER`. 초기화 시 계약 vs 앱 예산 admission; ADMIT → ES HK 텔레메트리로 추론(피크=bounded 유지); NOT_ADMITTED → 앱 기동 거부, cFS·타 앱 무영향.
- 판정: H3 메모리 축 → cFS 앱 배치 형태에서도 시험 조건 내 성립. 경계 (b) 런타임 구성 2종에서 견고. "Python 제거" 후속 가설 측정 완료(같은 경로에서 교환 관계 서술 가능).
- 결함 D4(하네스 해제 순서) 등록.
- 문서: `docs/EVIDENCE_v0.6_E11.md`, `native/cfs_app/WIRING.md`.

## [v0.5] 2026-09-08
- 외부 검토(`REPORT_v0_4_REVIEW.md`) 반영.
- 정정(결함 D3): 상한 계산법 "slice 합" → "post-layout transient alloca 크기". E9 정렬 간극·수명 재사용 사례에서 slice 합이 과소(48<128, 84<128)임을 실증. MLP 60/60 재검증.
- E9: 할당 구조 4사례 (A 정렬, B 수명 재사용, C 대형 체인, D fusion) 4/4 sound·tight.
- 상수 독립 검증: `iree-dump-module` rodata 세그먼트 부분합으로 30/30 확인 (IR 값 재사용 아님).
- 판정 의미: ACCEPT/REJECT/UNBOUNDED → ADMIT / NOT_ADMITTED(보증 불가≠불가능) / UNKNOWN_BOUND(분석 미확보≠상한 부재). pessimistic → conservative_denial.
- E10: 경계값 U−1/U/U+1 18/18 정확.
- E7b: 258 판정, misprediction 0, config-invariant.
- 판정: H3 시험 조건 내 성립, 근거 강화. 중심 문장을 "OnAIR IREE 아티팩트의 부분 메모리 계약·판정기 구현·검증"으로 한정. 런타임 컨텍스트 → 미분류 잔차. TFLM 서술 미검증으로 통일.
- 문서: `docs/EVIDENCE_v0.5_E9.md`.

## [v0.4] 2026-09-07
- 결정: 계약 메모리 경계 = 옵션 (b) per-call 정적 버퍼 + 모듈 상주 상수. 스키마에 `memory_boundary`, `bounded_bytes`, `bound_method: NONE` 추가.
- E7: 메모리 전용 admission checker (`harness/admission_check.py`). 240 판정, misprediction 0, 판정 config-invariant, observed==bounded 240/240.
- E8: 동적 배치 차원 모델 → UNBOUNDED 거절 확인 (정적 상한의 적용 경계).
- 판정: H3 → "메모리 축, 시험 조건 내 성립; 시간 축 미검증".
- 판정: H2 → 논문 주장에서 제외 권고 (E7 config-invariance).
- 문서: `docs/EVIDENCE_v0.4_E7.md`, `REPORT_v0.4.md`(총괄).

## [v0.3.1] 2026-09-07
- 외부 검토(`PROGRESS_v0_3_REVIEW.md`) 반영.
- E6c: 베이킹 모델 정적 상한을 IR 파싱으로 재검증, 30/30. 총 60/60 (v0.3의 "50/50"은 오기).
- 정정: 런타임 컨텍스트 ≈971 KB → ≈244 KB (베이킹 상수 720,896 B 분리, 결함 D2).
- 정정: 파서가 initializer 상수 임포트를 입력으로 오귀속 (D2) → 엔트리 함수 스코프 + 상수 별도 집계.
- 판정: H1 "기각" → "현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류".
- 판정: H2 "부분 지지" → "설정별 비용 차이 관측; 계약 기반 선택의 이점 미입증".
- 판정: H3 "메모리 축 전제 충족" → "정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요".
- 판정: E6 "sound & tight" → "동일 할당 계획에 대한 예측·관측 일치 (가정 명시)".
- 판정: "2.2× 대가 교환" → Native-cFS 후속 가설로 강등.
- 계약 예시: 스코프 노트·가정·상수/런타임 분리 귀속·정오표 추가.
- 잔여 작업 우선순위 변경: 상충 워크로드 탐색(A2)을 H2 유지 시에만; 기본 순서는 E6 범위 정리 → Native-cFS → 메모리 전용 admission checker → 일반성/TFLM.

## [v0.3] 2026-09-07
- E6 정적 메모리 상한 추출 (`harness/static_mem_bound.py`, `static_bound_sweep.py`). 30/30 sound, tightness 1.0, lowering 설정 불변.
- 정정: E1–E5의 컴파일 경로가 매 호출 가중치 전체를 임포트(결함 D1). E6b로 재측정.
- 정정: 컴파일 vs B0 격차 6.3–9.5× → 2.2–4.1×.
- 정정: E5 §4 "순위 붕괴 ρ=+0.18" 철회 (ρ=+0.81).
- 정정: E5 §3 "Pareto front 5개" 철회 (상충 미관측).
- 판정: H2 "확립" → "부분 지지".
- 판정: H3 메모리 축 전제 충족 (정적 상한).
- 판정: C1 `peak_memory` → `static_from_stream_schedule`.
- 계약 예시 갱신: 정적 프로그램 65,580 B + 런타임 컨텍스트 ~971 KB(측정) 분리.
- 문서: `docs/EVIDENCE_v0.3_E6.md`.

## [v0.2] 2026-09-07
- E5 lowering 특성화 추가 (`harness/characterize.py`, 10 설정 × h∈{256,4096,16384}).
- 판정: H2 "강화" → "확립". 근거를 tail 지표(noise 안쪽)에서 결정론적 지표(binary 2.25×, RSS 2.75×, Pareto 5, ρ=+0.18)로 교체.
- 판정: 방향판단 §7 "peak memory 우위" 반증 (B0 40 KB vs compiled 최소 1216 KB).
- 계약 공란 채움 (`contracts/contract.filled.example.json`): profile, peak_memory(measured), bound(measured_max).
- 문서: `docs/EVIDENCE_v0.2_E5.md`.
- 이력 관리 도입: git, `EXPERIMENT_LOG.md`, 본 파일.

## [v0.1] 2026-09-07
- E0–E4 수행. 환경 구축, OnAIR 통합, 크기 스윕, 마샬링 floor, 설정 효과.
- 판정: H1 주가설 → 부분 기각. H2 강화. H3 미검증.
- 문서: `docs/STATUS.md`, `docs/MVP_RESULT.md`, `docs/EVIDENCE_v0.1.md`.

## [v0.0] 2026-09-07
- 연구노트 v0.1 (외부 문서) 검토. Critical 3 / Major 10 / Minor 10.
