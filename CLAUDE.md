# CLAUDE.md — 프로젝트 컨텍스트 (Claude Code용)

이 파일은 Claude Code가 세션 시작 시 자동으로 읽는 컨텍스트 파일이다. 여기 없는 세부사항은
`PROGRESS.md`(현재 상태 한 장 요약) → `EXPERIMENT_LOG.md`(전체 실험 레지스트리) →
`docs/EVIDENCE_v0.*.md`(버전별 상세 근거) 순으로 내려가며 읽는다.

## 프로젝트 한 줄 요약

NASA cFS/OnAIR 위에서 MLIR/IREE로 AOT 컴파일한 AI 추론 아티팩트를 배치할 때, 컴파일러의
할당 스케줄에서 도출한 **정적 메모리 계약**으로 배치 전 admission(허용/거부) 판정을 수행하는
연구. 현재 버전: **v0.53**(git tag는 v0.9 이후 미부착 — 커밋 이력·CHANGELOG로 확인).

**중심 주장(v0.41 정본, `docs/EVIDENCE_v0.41_E37.md` §2)** — 지어내지 말 것:

> 이 연구는 IREE로 AOT 컴파일한 AI 모델의 **앱별 부분 메모리 계약**(*partial per-app model-execution
> memory contract* — 호출별 버퍼 + 모듈 상주 상수)을 컴파일 산출물에서 추출하고, 그것을 cFS 앱에
> **부여한 예산**과 비교해 **런타임 자원을 획득하기 전에** 허용 여부를 결정하는 방법을 구현·평가했다. 세 개의 공개 실물 모델(OPS-SAT SmartCam 비행 모델,
> MLPerf Tiny ResNet, MLPerf Tiny Deep AutoEncoder)에 대해 AArch64 QEMU 게스트의 cFS에서 예산
> 경계가 `B`→ADMIT / `B−1`→NOT_ADMITTED로 동작했고, 허용된 실행에서는 같은 계약 영역의 HAL 관측
> 피크가 **승인 근거 예산 이하**였고(비율은 셀마다 0.6%~100.0%로 다르다 — *이하*는 tightness의
> 주장이 아니다), 전체 출력이 원본 TFLite 실행기의 출력과 사전 고정한 기준
> (원소별 `abs ≤ 1e-4` **또는** `rel ≤ 1e-5`)을 **그 셀들이 쓴 입력에서** 만족했다
> (**범위 한정 — D74/E45**: 그 입력은 SmartCam이 실이미지 3 + 합성 32 + 경계 2, 나머지 둘은
> 합성 32 + 경계 2였다. 실데이터로 바꾸면 ResNet은 200/200 실이미지에서 여전히 만족하고
> SmartCam도 19/19 실썸네일에서 만족하지만, **Deep AutoEncoder는 실 log-mel 입력에서 만족하지
> 않는다** — 34창 21,760원소 중 94개 실패. 도구 결함이 아님을 네 축으로 확인했고
> 기준은 고치지 않았다. `docs/EVIDENCE_v0.45_E45.md` §2.3). SmartCam에서는 전제조건을 **측정으로**
> 확인하는 조건부 정책이 같은 계약에서 **1.94배 작은 예산**(9,382,092 B)으로 완주했고, 같은 예산의
> opt-in 없는 대조군은 거부됐다. 정보 수준 비교에서 **현재 비교한 모델·도구·정책 조건에서는 MLIR
> 기반 경로와 아티팩트 전용 경로의 수치·판정 차이가 관측되지 않았다** — 같은 계약 범위·같은 조건부
> 지식에서 아티팩트만 보는 기준선이 **세 수치와 커널 스택을 4/4로 동일하게** 산출했고, 그 수치를 같은 정책
> 코드에 넣은 24셀의 판정도 전부 같았다(**따름정리** — D72, `docs/EVIDENCE_v0.38_E35.md` §8: 불일치 셀은
> 수집기 구조상 만들어질 수 없으므로 24/24를 독립 측정으로 읽지 않는다)(구현하지 않은 정규 pass의 효과를
> 부정하는 근거로는 쓰지 않는다). 따라서 이 연구가 주장하는 것은 수치적 우위가 아니라 **MLIR 기반 계약 추출·연계 방법**이다.

**7개 구분**(예산 / 계약 범위 / 무조건 정책 / 조건부 정책 / 실행 타깃 / OnAIR / MLIR 기여)의 확정된
의미는 `docs/EVIDENCE_v0.41_E37.md` §2 표에 있다. **예산은 앱에 배정한 값이지 가용 RAM 탐지가 아니고,
OnAIR는 호환성 보조 실증이며, MLIR 기여는 "MLIR이라야 얻는다"가 아니다.**

아래는 **E14 시점(v0.9)의 중심 문장**이며 이력으로 남긴다 — 합성 3모델 기준이라 실물 모델·조건부
정책·OnAIR·E35 기준선 비교가 전부 그 뒤에 나왔다(`docs/EVIDENCE_v0.9_E14_stage1.md` §11.8):

> 정적 메모리 계약(per-call 버퍼 + 모듈 상주 상수)은 MLP·Conv2D·multi-branch 세 가지 할당
> 구조에서 x86-64와 AArch64(Cortex-A53, QEMU 시스템 에뮬레이션) 모두 동일한 값으로 산출됐고,
> 시험한 실행 구성에서 각 타깃의 HAL 관측 피크 이하였다(tightness는 구성에 따라 다름 — conv2d
> native 1,352 ≤ 3,528 vs cFS 3,528 = 3,528). 같은 계약을 AArch64 게스트 안의 cFS
> `AI_LEARNER` 앱 초기화 admission에 연결해, 선택된 7개 시나리오(정상 허용·모델 교체 거부·
> 모델 파일 부재·반복 추론 무결성·동적 형상(UNKNOWN_BOUND) 거부·앱 재시작 1회)를 실행
> 검증했다(원래 계획한 전체 시나리오의 완주는 아니며, 정상 종료 시의 자원 회수는 미검증).
> AArch64 코드생성이 도입하는 고정 태스크 스택 잔차는 모델의 지역 버퍼 유무에 따라 16 B(MLP·
> multi-branch)에서 191 B(Conv2D, 동적 재정렬 패딩 포함)까지 달랐으며, HAL 계약이 아닌 태스크
> 스택 예산으로 별도 회계해 시작 스크립트에 반영하고 런타임이 그 설정값의 충분성을 스스로
> 확인해 보고하도록 구현했다(초기화를 거부하는 gate는 아님). 동일 경계의 대안 비교는 여전히
> 후속 대상이다.

**절대 하지 말 것**: H1(AOT가 더 빠르다)이나 H2(계약 기반 lowering 선택이 유리하다)를 다시
주가설로 세우지 말 것 — 둘 다 실험으로 기각/격하됐다(`EXPERIMENT_LOG.md`의 가설 판정 이력 참조).

**v0.9에서 완료된 것**: E14 Stage 1(qemu-system-aarch64 전체 시스템 + cFS-in-guest)을 Claude
Code에서 완료했다 — MLP 외 Conv2D·multi-branch·동적형상 모델 추가, cFS 게스트 안에서 A1·A3·
A4·A6·A7·A8 시나리오 7/7 PASS(단, 계획 대비 대폭 축소 — 아래 v0.9.1 참조), 계약 도구 자체의
검증 결함(D9·D10, `docs/EVIDENCE_v0.9_E14_stage1.md` §0.4) 발견·수정. 상세는
`docs/EVIDENCE_v0.9_E14_stage1.md` 참조.

**v0.9.1에서 정정된 것 (외부 검토 2건 반영, `docs/EVIDENCE_v0.9_E14_stage1.md` §11)**: A5b가
"native에서 확인됨"이라는 서술은 **실행 근거가 없어 철회**(native·cFS 어디에도 A5b 미실행,
`runtime_load_failed`는 7/7 `null`). 7/7 PASS는 계획(31개 시나리오) 대비 대폭 축소된 7개 결과이며
전부 timeout(`EXIT=124`)으로 종료돼 **정상 종료 시의 자원 회수는 미검증**. 스택 회계
(`kernel_stack_accounted`)는 admission gate가 아니라 텔레메트리이며 구조상 항상 참에 가까운
항등식(빌드가 써넣은 값을 앱이 그대로 되읽어 비교). conv2d의 HAL peak는 native 1,352 vs cFS
3,528로 tightness가 구성마다 다름 — "HAL peak = contract" 일반화 금지. cross-target 비교
(`comparison/*.json`)는 계약 수치 비교일 뿐 실행 대조가 아님(`native`/`both_sound` 전부 null).
계약 도구 체인이 **fail-open**임도 확인(D11–D15) — 파서가 미인식 할당을 조용히 무시하고,
헤더 생성기는 음수 `bounded_bytes`를 `BOUND_KNOWN=1`로 통과시켜 C 게이트가 무조건 ADMIT함.
14개 계약 자체의 값은 vmfb 실물과 재대조해 14/14 일치 확인(도구 결함이 기존 값을 반증하지는 않음).

**v0.10에서 완료된 것 (E15, `docs/EVIDENCE_v0.10_E15.md`)**: v0.9.1이 정정으로 남긴 D12·D13·D14를
실제로 fail-closed로 수정 — 파서의 줄바꿈 누락·미인식 op 무시, 헤더 생성기의 음수/미지원
`bound_method`·스택 미상 수용·다중입력/비f32 수용, one-invocation의 layout IR 미결합(D14, dispatch
심볼을 dump-dir과 대조)을 각각 직접 재현 후 거부로 전환. 신규 `harness/contract_negative_tests.py`
음성 20건+단위 5건+회귀 26건 = **51/51 PASS**. 보관된 v0.9 14개 계약·헤더를 이 도구로 재생성해
**diff 0**(회귀 없음) 확인. **범위 밖(명시)**: C 게이트 자체(스택 거부 분기, blob 크기 선검사, 입출력
런타임 gate)는 x86-64/cFS 환경 재구축이 필요해 미착수 — v0.11에서 이어감.

**v0.11에서 완료된 것 (E16, `docs/EVIDENCE_v0.11_E16.md`)**: 이 세션에서 x86-64 환경(cFS
native_std, IREE C 런타임)을 재구축해 D15·R8을 실제 cFS 기동으로 검증·수정 — `ai_learner.c`의
스택 확인을 `Init()` 최선두(자원 획득 전)로 옮기고 `accounted=false`에서 실제 거부하는 분기 신설
(이전엔 텔레메트리뿐), blob `malloc` 전 파일 크기를 계약과 선검사(다르면 해시 계산 없이 즉시 거부),
두 실행기에 인터페이스(단일 f32 in/out) defense-in-depth 추가. 실제 `core-cpu1`으로 정상/스택거부/
크기불일치/NOT_ADMITTED 4개 시나리오를 기동해 EVS 이벤트·JSON 필드로 확인. 부수 발견: `scripts/50_wire_cfs_ai_learner.sh`
가 `WIRING.md`의 stack=base+kernel 규칙을 어기고 262144로 하드코딩하던 버그(신규 gate가 즉시 드러냄,
수정함). **범위 밖(명시)**: AArch64 게스트 재구축·재현(A2 전 모델·A5b·재시작 2회+DELETE·정상 종료
cleanup)은 여전히 미착수.

**v0.12에서 완료된 것 (E17, `docs/EVIDENCE_v0.12_E17.md`)**: AArch64 크로스 툴체인·IREE 런타임·
qemu-system-aarch64 게스트를 이 세션에서 재구축(정상 부팅). **A5b를 native x86-64·cFS x86-64·cFS
AArch64 게스트 세 레벨 전부에서 최초로 실제 실행**(D11 실제 해소) — `.vmfb`(ZIP)의 `module.fb`
FlatBuffer 자신의 root-uoffset을 구조적으로 손상시켜(임의 bit flip 아님) binding MATCH 조건을
만든 뒤, 전 레벨에서 admission ADMIT→binding MATCH→`runtime_load_failed`(IREE 검증기가 안전 거부)
→cleanup 1회→cFS OPERATIONAL 유지, 크래시 0을 확인. mlp16k·multibranch A2 경계값(native 6/6+cFS
mlp16k 3/3) 확인. A7을 재시작 2회+DELETE로 확장해 x86-64·AArch64 양쪽에서 완주(이중 해제 없음,
ES 명령 기반 정상 종료 경로로 v0.9 §11.2의 "정상 종료 자원회수 미검증"도 해소). E16의 신규 게이트를
AArch64에서도 교차 확인.

**v0.13에서 완료된 것 (E18, `docs/EVIDENCE_v0.13_E18.md`)**: 우선순위 3번(그 항목명이 가리키는
진짜 pass는 여전히 미착수 — 여기서 만든 것은 MLIR API 기반 구조적 post-processing verifier다)의 1단계 —
`harness/mlir_alloc_walk.py`가 `static_mem_bound.py::parse_alloc_ir`의 크기 추출을 정규식이 아니라
실제 `iree.compiler.ir` API로 재구현. `--mlir-print-ir-after`의 함수별 조각남 문제(v0.12 조사가
찾음)를 `util.global.load`/`store` 선언 합성 전처리로 해결하고, 그 이후는 전부
자체 구현한 재귀 순회 헬퍼(`_walk()`, region/block/operation을 직접 순회 — `mlir.ir.Operation`이
제공하는 네이티브 `walk()` 메서드가 아니다)·`Value.owner` define-use 체인·`arith.constant` 속성
직접 읽기로 크기를 얻는다(정정: 외부 검토 F4, v0.18/E23, `docs/EVIDENCE_v0.13_E18.md` §7 참조).
보관된 v0.9의 14개 `layout_ir`(재컴파일 없음)에서 기존 정규식 파서와 값이 전부 일치, 화이트리스트를
실제로 좁혀서 미인식 op fail-closed도 재확인. `harness/contract_negative_tests.py` 51/51 → **66/66**.
**범위 밖(명시)**: `make_contract.py` 파이프라인 통합, `stream.resource.pack` 실사용 시험, 다른
IREE 버전 재확인.

**v0.14에서 완료된 것 (E19, `docs/EVIDENCE_v0.14_E19.md`)**: 우선순위 3번의 2단계 — v0.13이
범위 밖으로 남긴 "`make_contract.py` 파이프라인 통합"을, **교체가 아니라 필수 상호 검증**으로
완료. 정규식 파서와 구조적 추출기(`mlir_alloc_walk.py`)가 같은 layout IR을 각각 읽어 다섯 항목
(inputs/outputs/transient_slabs 원소별·constants 합계·entry_found·unresolved 존재)을 대조하고,
불일치하거나 구조적 추출기가 파싱 실패하면 계약 자체를 거부(`--allow-structural-mismatch`로만
우회, D13과 같은 hard-fail 경로). `iree.compiler.ir` 미설치 환경에서는 하드 실패가 아니라
스킵(기록만, E15 기준선으로 저하) — 실제로 확인함. 14개 보관 계약을 **서브프로세스로
`make_contract.py`를 실제 재실행**해 재생성(diff 0 + 신규 필드 14/14 available/agrees=True 확인,
E18은 구조적 추출기를 직접 호출했을 뿐 프로덕션 경로를 거치지 않았음), 하드 실패 배선 자체는
in-process monkeypatch로 불일치·파싱예외 두 조건 모두 실제 `SystemExit` 확인.
`contract_negative_tests.py` 66/66 → **85/85**. **여전히 남은 것**: `stream.resource.pack`
실사용 시험, 다른 IREE 버전으로의 실제 재확인(하드 실패 강제 지점은 마련됐으나 발동 조건을
시뮬레이션으로만 확인).

**v0.15에서 완료된 것 (E20, `docs/EVIDENCE_v0.15_E20.md`)**: v0.14/E19의 구조적 크로스체크를
이 세션 내 적대적 다중 리뷰(4개 독립 관점 병렬 + finding당 3인 반박 검증)로 검토, 13건 중 11건
확인·2건 반박. 확인된 것 중 2건은 **실제 재현된 High severity 과잉 거부 결함**(D16, D17) —
크로스체크가 계약이 실제로 서명하는 값(`p`, `const_b`)이 아니라 낡은 가정에 기댄 참조값(`whole`,
`dense_sum`)과 비교되고 있어, print 순서나 상수 패킹 패딩에 따라 완전히 정상인 모델이 거부될 수
있었다(보관된 14개 모델은 우연히 이 조건에 안 걸려 v0.14의 "14/14 일치" 판정 자체는 여전히 참).
둘 다 보관 layout IR의 surgical 텍스트 편집만으로(재컴파일 없음) 재현하고 수정, 재현 시나리오를
고정 회귀 시험으로 등록한 뒤 수정 전 코드로 되돌려 시험이 실제로 실패함을 확인(revert-and-
confirm-fail). 3곳에 중복 구현됐던 diff 로직을 `mlir_alloc_walk.diff_against_regex` 공유
헬퍼로 통합. 시험 갭 4건 추가. `contract_negative_tests.py` 85/85 → **96/96**. 14개 보관 계약은
diff 0 유지. `docs/EVIDENCE_v0.14_E19.md`에 §8 정오표(철회 아님, 정정) 추가.

**v0.16에서 완료된 것 (E21, `docs/EVIDENCE_v0.16_E21.md`)**: 외부에서 새 검토 문서
(`docs/reviews/REVIEW_v0_15_LATEST.md`, 기준 커밋 `6e9ac10`, F1–F11)가 도착 — 이번엔 11건 전부를
독립 에이전트 11개로 병렬 검증(리뷰 주장을 곧이곧대로 반영하지 않고 실제 코드 실행으로 먼저
재현하는 이 프로젝트의 기존 방법론 그대로 적용). 9건 confirmed, 1건 partially_confirmed(F3 —
"MANDATORY라 부르면서 은폐"라는 프레이밍은 과장으로 판정, 이 예외는 이미 5곳에 문서화되고
E19가 시험까지 해둔 의도적 설계였음), 1건 not-a-defect(F11 — CLAUDE.md 우선순위 5가 이미
문서화한 "다중 앱 전역 예산 미착수"의 재확인). 코드 수준 fail-open 결함 6건(F1, F2, F3, F5, F6,
F7)을 실제 재현 후 수정(D18–D23): F1(빈 `--dump-dir`로 one-invocation 신호 전부 None → 통과),
F2(ABI 반사 부재가 불일치와 달리 미거부), F3(구조적 크로스체크가 패키지 미설치시 opportunistic로
저하 — 기본값을 하드 실패로 변경), F5(`stream.resource.pack` 비상수 슬라이스가 unresolved 누락,
IREE 상류 실제 문법으로 재현, 현재는 정규식 크로스체크가 이미 이중 방어 중임을 확인), F6(스택
분석이 스스로 불신뢰로 분류해도 KNOWN=1), F7(C 게이트가 "single-f32"라 주장하나 dtype 미검사 —
`CONTRACT_DTYPES_ALL_F32` 매크로 신설). 전 6건 수정 전 코드로 되돌려 신규 시험이 실제로 실패함을
확인(revert-and-confirm-fail). `contract_negative_tests.py` 96/96 → **107/107**. **여전히 남은
것**: F4(정규 MLIR pass 표현 정정), F8(E16/E17 원자료·A5b 재현 코드화), F9(fresh-clone
재현성 — F3의 기본값 변경과 직접 상충하는 트레이드오프 있음), F10(OnAIR↔native/cFS 바인딩 갭) —
E22/E23로 이연.

**v0.17에서 완료된 것 (E22, `docs/EVIDENCE_v0.17_E22.md`)**: F9(fresh clone 재현성)를
실제 `git clone` 재현으로 확인 후 해결 — v0.16이 남긴 트레이드오프(E21의 F3이 F9를 악화시킬
수 있음)를 실제로 다뤘다. 두 근본 원인을 찾았다: (1) `contract_negative_tests.py`가
`iree.compiler.ir` 부재 시 uncaught `RuntimeError`로 **전체 크래시**(요약 0줄, D24 신규) —
`Result`에 `skip` 상태를 신설해 3개 지점을 명확한 SKIP으로 정리. (2) E21의 F3(구조적 검증기
미설치 기본 하드실패)이 이 시험 하네스 자신의 서브프로세스 호출과 상충 —
`structural_available()`/`with_structural_override()`로 무관한 이유의 실패를 제거. 추가로
`results/e14_aarch64_qemu/*/dump/`(242개 파일, 6.5MB — 회귀·음성 시험이 실제로 요구하는데
`.gitignore`로 빠져 있었음)를 커밋, `requirements.txt`(버전 고정)와
`.github/workflows/contract-negative-tests.yml`(fresh checkout CI, with/without
iree.compiler.ir 두 경로) 신설. 이 세션 내 실제 `git clone`으로 재현: iree-base-compiler
설치 시 **107/107**, 미설치 시 크래시 없이 **77/77 + 3 SKIP**. README의 "환경 구축 불필요"가
이제 정확한 주장이 됨. **여전히 남은 것**: F4, F8, F10 — E23로 이연.

**v0.18에서 완료된 것 (E23, `docs/EVIDENCE_v0.18_E23.md`)**: 외부 검토(v0.15)의 잔여 4건과,
**E22가 만든 CI가 실제 실행에서 잡아낸 신규 크래시 1건**을 처리했다. F8(D26): A5b가
`EVIDENCE_v0.12` §2.1이 서술한 구조 손상이 아니라 A5a와 **동일한** 임의 bit flip을 쓰고 있었고
두 방식을 구분하는 필드조차 없었다(E17 결과 자체는 수작업 구조 손상으로 얻은 것이라 반증되지
않지만, 저장소 코드만으로는 재현 불가였다) — `harness/corrupt_vmfb.py`를 신설해 두 방식을 실제
코드로 만들고(ZIP64/STORED 컨테이너를 풀지 않고 `module.fb` 첫 4바이트만 덮고 양쪽 CRC32를
갱신하는 외과적 패치), `corrupt_method`를 필수화(누락·미인식은 `ValueError`). 보관 vmfb 8/8에서
컨테이너 CRC 유효·타 엔트리 불변·크기 동일·**결정적**(호스트가 만든 corruptsha 계약의 해시가
게스트 산출물과 같아야 하므로 필수 성질)을 확인하고, `iree.runtime`으로 실제 로드해 E17이 cFS
에서 본 것과 **같은 오류 문자열**(`FlatBuffer length prefix out of bounds, prefix 4294967295`)로
거부됨을 확인 — A5b의 네 번째 레벨. F10(D27): OnAIR `CompiledLearner`가 계약이 지목한 vmfb를
sha256·크기 검사 없이 로드하고 있었다(C 경로는 크기 선검사→sha256→자원 획득 전 거부를 이미
하고 있어 A3·A5a에서 비대칭) — `plugins/compiled_learner/artifact_binding.py` 신설(stdlib 전용),
`verify_artifact_hash=True` 기본, 계약에 해당 필드가 없으면 검사 생략이 아니라 거부. F4는 표현
정정(§3), F11은 not-a-defect 판정 유지 + admission JSON에 `"scope":"per_app_local_budget"` 명시.
**D25(방법론적으로 가장 중요)**: `iree-dump-module` 바이너리 부재 시 uncaught
`FileNotFoundError`로 전체 크래시 — D24와 같은 부류의 두 번째 지점인데, **E22가 D24를 확인할 때
쓴 `sys.meta_path` import 차단은 Python 모듈만 숨기고 콘솔 스크립트는 PATH에 남기므로 이 조건을
원리적으로 재현할 수 없었다.** 사람이 아니라 **CI가** 잡았다. 두 함수가 `OSError`를 잡고,
`artifact_rodata_segments`는 `([],[])`가 아니라 `(None,None)`을 반환해 "관측 못 함"과 "관측했고
없음"을 구분한다(상수 독립 확인 불가는 `null` + 기본 거부). `contract_negative_tests.py`
107/107 → **125/125**(CI `with-deps` 포함), 모듈만 부재 95/95+3 SKIP, **진짜 의존성 없는
체크아웃은 CI `without-deps` 실측 48/48+6 SKIP(크래시 없음)**(정정: 그 레그는 실제로는
`jsonschema`를 설치하므로 "진짜 의존성 없는"이 아니라 "without IREE"다 — 외부 검토 N6,
E24에서 확인·수정, `docs/EVIDENCE_v0.18_E23.md` §9.2) — 로컬 시뮬레이션(50/50+5)과
다른 이유마저 같은 계열(이 컨테이너엔 `iree.runtime`이 있어 A5b 런타임 거부 시험이 실제로
돈다)이라, 두 수치를 조건과 함께 병기한다.
`EVIDENCE_v0.13_E18.md` §7·`EVIDENCE_v0.17_E22.md` §6에 정오표 추가.


**v0.19에서 완료된 것 (E24, `docs/EVIDENCE_v0.19_E24.md`)**: 세 번째 외부 검토
(`docs/reviews/REVIEW_v0_18_FOLLOWUP.md`, 기준 커밋 `52bff0d`, N1–N6+§5)가 도착 — E21–E23을
"실제 품질 향상"으로 인정하면서도 **검증 불가 또는 모순 상태에서 여전히 배치 가능한 헤더가
나오는 경로**를 지적했다. 21개 에이전트로 독립 재현 검증(7건 재현 + finding당 반박 2인):
**7건 전부 confirmed, 반박 0건.** 그러나 심각도는 리뷰와 달랐고(N1 P0→P1, N3 P0→P1, N4 P1→P2),
무엇보다 **리뷰가 제안한 수정 3건은 실측 결과 과잉 거부를 유발**했다 — N1의 문자 그대로의
수정(`consts_confirmed is not True` 거부)은 `dynamic` 계약 2개(A8 음성 시나리오의 입력)를,
N3의 strict 변종(복수형 interface 부재 시 거부)은 이 저장소 스키마가 선언하는 정본 형태를
거부한다. 양방향 결함 정의(fail-open과 과잉 거부 모두 결함)가 이번에도 결정적이었다.
수정 5건: D28(N1·N2 — 비어 있지 않은 dump-dir에서 신호가 `None`이면 그대로 통과, 다른 모델의
vmfb를 짝지어도 계약이 나와 **D10 구멍이 None 경로로 재개방**; 상수량 관측이 IR과 모순돼도
거부 안 함 — E23/D25가 더 약한 "관측 불가"는 거부하는데 더 강한 "관측했더니 모순"은 통과시키던
비대칭), D29(N4 — 스택 신뢰 신호의 **부재**가 "신뢰함"과 구분되지 않음), D30(N3 — 빈 dtype
집합이 `{"f32"}`와 구분되지 않아 f16 계약이 `ALL_F32=1`, 공허참), D31(N5 — **E23이 함께
출하한 과잉 거부**: D27 게이트가 저장소 기본 fixture를 거부. 생성기를 먼저 고쳐야 한다 —
`sweep.py`가 그 디렉터리를 매 스텝 재작성하므로 데이터만 고치면 휘발성), D32(N6 — `jsonschema`
부재 시 시험이 **15건의 거짓 FAIL**; CI가 그 조건을 한 번도 시험하지 않았고 부트스트랩 경로는
그것을 설치하지 않아 도달 가능했음). `contract_negative_tests.py` 125/125 → **142/142+1 SKIP**(CI 실측),
보관 14개 계약 diff 0·헤더 바이트 동일. CI에 `stdlib-only` 레그 신설(세 조건 실측:
142/142+1 · 58/58+9 · 58/58+9, 전부 CI 실측). `EVIDENCE_v0.14_E19.md` §9·`EVIDENCE_v0.18_E23.md`
§9 정오표 추가, README·CLAUDE.md의 "정규 MLIR pass" 표현 직접 정정(진짜 pass는 미착수 목표).
**여전히 남은 것**: weights.npz 계약 결속(우선순위 8), 게스트 cFS 재실행(환경 부재),
`subset_sum_match` tri-state 리팩터링(EVIDENCE_v0.19 §7).



**v0.20에서 완료된 것 (E24b, `docs/EVIDENCE_v0.20_E24b.md`)**: 네 번째 외부 검토
(`docs/reviews/REVIEW_v0_19_E24_RESEARCH_REFRAME.md`, 기준 커밋 `f51f66e`)가 도착 — E21–E24를
"구현 완성도와 재현성이 높은 프로토타입"으로 인정하면서 **연구의 남은 핵심 과제는 방어 조건을
더 늘리는 것이 아니라 계약 경계의 실질적 가치·OnAIR↔cFS 의미 동치·MLIR 기여를 증명하는 것**
이라고 재정리했다. §5.2의 반례 5건(R1–R5)을 10개 에이전트(재현 5 + 각 수정안의 과잉 거부 위험 5)로
검증해 **5건 전부 재현**했고, 심각도 재분류가 두 번, 방향이 서로 반대였다: **R1은 리뷰의 "매우 낮음:
수동 변조 필요"와 달리 정상 `make_contract.py` 경로로 도달하는 claim blocker**(`--elf-analysis`
입력의 음수 스택이 truthiness로 "신뢰" 버킷에 오르고, cFS 스택 게이트의 `stack_needed`가
음수(262144 + (-300000) = -37856)가 되어 **스택 0에서도, 그리고 `GetAppInfo` 실패 시의
`es_stack = -1`에서도 참인 항등식**이 된다 — 실제 C 식 컴파일로 확인. 비교는 signed `long`
끼리이며, `StackSize`의 unsigned 여부는 `(long)` 캐스트로 무관하다(정정 E24c/F5)), 반대로 **R4는 리뷰의 문자 그대로의
처방이 정직한 31세그먼트 모델을 통째로 거부**해 미채택하고 열거기를 진짜 tri-state로 고쳤다(스톡
플래그 `--iree-stream-resource-max-allocation-size=1024` 하나로 31세그먼트가 나오며, 옛 코드는
일치하는 총합에 **"NOT matched"라는 거짓 진술을 계약에 기록**했다). D35–D40 수정:
D35(R1), D36(`bounded_bytes`가 자기 구성요소 합과 미대조 — `>=`가 아니라 `==`, `>=`는 부풀린
자기모순 값만 통과시켜 유형 (B)), D37(`validity`↔`interface` shape 미대조, **존재하는 것끼리만**
비교), D38(R4), D39(**적용된 override가 계약에 기록되지 않고** 헤더 생성기가 provenance를 전혀
읽지 않아 우회 계약과 검증 계약이 같은 배치 가능 헤더를 만듦 — `waive()`가 거부 지점이 아니라
**플래그 접근**을 감싸고, 드리프트 1곳 주입 시 **행위 시험 5건은 전부 PASS이고 소스 수준 가드만
FAIL**함을 실측), D40(`CLAUDE.md`가 문서화한 스모크 경로 2개가 rc=1로 깨져 있었고 그중 1건은
**E24의 N3 게이트가 만든 유형 (B) 회귀** — "과잉 거부 위험을 측정했다"는 주장이 어떤 입력
집합에서 측정했는지에 전적으로 의존함을 세 번째로 확인). `contract_negative_tests.py`
143/143 → **170/170**(이 컨테이너 실측). **CI 실측**(커밋 `5debfd5`): `full` 169/169+1 SKIP ·
`without-iree` 85/85+9 SKIP · `stdlib-only` 85/85+9 SKIP — 컨테이너와 `full`의 차이 1건은
PyYAML 유무이며, D34의 교훈에 따라 추정하지 않고 두 값을 조건과 함께 병기한다.
보관 14개 헤더는 `CONTRACT_PROVENANCE_VERIFIED` 한 줄만 추가.
**우선순위 재편**: 이 버전에서 "지금 바로 이어서 할 일"의 축을 fail-closed 방어에서 **연구 질문
(R-1 OnAIR↔cFS 의미 동치 / R-2 계약 경계의 유용성·외적 타당성 / R-3 MLIR 고유 기여)**으로 바꿨다.


**v0.21에서 완료된 것 (E24c, `docs/EVIDENCE_v0.21_E24c.md`)**: 다섯 번째 외부 검토
(`docs/reviews/REVIEW_v0_20_E24b.md`, 기준 커밋 `c680424`, F1–F5)가 도착 — E24b를 인정하면서
세 항목의 경계 조건을 지적하고, **§7·§8에서 "F1–F3는 별도 대형 실험으로 키우지 말고 짧은
hardening으로 닫은 뒤 E25 → E26 → E27로 전환하라"**고 명시했다. 그 지침대로 짧게 닫았다.
15개 에이전트(재현 5 + 각 권고의 과잉 거부 위험 10)로 검증해 **5건 전부 재현**, 4건 수정.
**F1은 수정하지 않았다** — 리뷰 권고(provenance 필수화)를 적용하면 삭제 경로(VERIFIED=0)가
손으로 쓴 `{"single_invocation": true}` 한 블록으로 통과하는 **위조 경로(VERIFIED=1)**로 바뀌어
악화됨을 실측했고, 삭제 경로 헤더는 이미 문서화된 `--allow-override-contract` 헤더와 **바이트
동일**이라 새 fail-open도 아니다(코드가 아니라 threat model 결정 문제 — 아래 우선순위 0번).
수정: D41(F2 — D36의 합 항등식이 `is_int`를 건너뛰기 조건으로 써서 `null`이 검사를 무력화하고
비음수 검사 부재로 `-1`이 항등식을 공허하게 만족. **리뷰 서술은 두 변종 중 하나만 설명**),
D42(F3 — 예산 초과 `None`이 기본 거부 안 됨. **리뷰 처방은 정직한 >256 MiB 모델을 거부**해
미채택하고 결정 절차를 예산 검사보다 앞에 둠, 무작위 3,000건 brute force 교차검증 0 불일치;
`constants_confirmation_state` 5-상태 신설), D43(F4 — D38을 정당화한 사례의 실물 산출물 미보존.
`harness/gen_model_manyconst.py` + `results/e24c_manyconst31/`(한 번의 컴파일 호출, 440 KB)로
보존하고 **실물 입력으로 현재 True / 옛 절단 False를 실증**), D44(F5 — **이 저장소 문서의
"unsigned 비교" 원인 서술이 틀렸다**: 양쪽 signed `long`이고 `info.StackSize`는 명시적 `(long)`
캐스트다. 인과가 반대로 틀렸고 — 실제 unsigned였다면 오히려 거부됐다 — 그 서술에 "컴파일로
확인" 표시가 붙어 있었다. 판정과 코드 수정은 유지, `es_stack = -1`에서도 참임이 추가 확인.
7곳 정정). **방법론 교훈 하나 더**: F4 재현 에이전트가 "재현 안 됨"으로 보고했으나 상수 수가
적은 기존 모델을 쓴 결과였고, 직접 확인하니 재현됐다 — **에이전트 결론을 액면 그대로 받았으면
맞는 문서를 틀리게 정정할 뻔했다.** 170/170 → **191/191**(이 컨테이너 실측). **CI 실측**(커밋 `50f16d0`): `full` 190/190+1 SKIP ·
`without-iree` 103/103+11 SKIP · `stdlib-only` 103/103+11 SKIP — 차이 1건은 PyYAML 유무이며,
SKIP이 9→11로 는 것은 신규 시험 2건이 `iree-dump-module`을 요구하는 정직한 SKIP이다.


**v0.22에서 완료된 것 (E25, `docs/EVIDENCE_v0.22_E25.md`)**: 우선순위 R-1(OnAIR↔cFS 의미
동치)을 **완결**했다. 이전까지 OnAIR fixture(`mlp_9x65536x2`, hidden 65536, 외부 `weights.npz`
2.88 MB)와 cFS 배포(`mlp16k`, hidden 16384, baked)는 **서로 다른 모델**이었고 같은 것은
인터페이스뿐이었다 — 검토 C2의 지적이 수치로 확인됐다. `harness/gen_model_canonical.py`가
한 seed에서 baked MLIR과 npz를 함께 생성해 배포 경로 셋이 **같은 vmfb**를 공유하게 하고,
npz는 NumPy reference 계산에만 쓰이게 했다(그래서 "weights가 계약 밖"이라는 문제가 배포
경로에서 사라진다). hidden은 E14와 같은 16384라 **계약 값이 `mlp16k`와 정확히 일치**한다.
**판정 PASS**: 다섯 경로(reference / IREE Python 바인딩 / native C / cFS x86-64 / cFS AArch64
게스트) 중 네 IREE 경로의 출력이 **6쌍 전부 비트 동일**, reference 대비 512/512 원소(경로당
128 = 입력 64 × 출력 2)·argmax 경로당 64/64,
AArch64 반복 실행도 비트 동일(결정적). **AArch64가 다른 vmfb인데도 비트 동일한 것은 계획이
예상하지 않은 결과이며 일반화하지 않는다** — 활성화 없는 matmul 2회 모델·이 컴파일러 버전에서
관측된 것이다. **사전 고정 기준의 가치 실증**: telemetry regime은 abs 단독이면 1/64,
normalized는 rel 단독이면 59/64 — 어느 한 기준만 요구했어도 정직한 결과가 FAIL이었다.
E14 cross-target 지표의 `out0_agreement` 자리를 **canonical 모델에 한해** 실제 출력 대조로
채웠다(`both_sound`는 메모리 관측 종합값이므로 **E25 범위 밖 · E26 대상** — v0.22.1 정정).
환경 실패 2건(게스트 emergency mode → fstab `nofail` + cloud-init 비활성화)은 의미 동치와
**분리해** 기록했다(EVIDENCE §7).

**v0.22.1에서 정정된 것 (일곱 번째 외부 검토 + E25b, `docs/EVIDENCE_v0.22_E25.md` §11·§12)**:
검토(`docs/reviews/REVIEW_v0_22_E25.md`, 기준 커밋 `44c27ac`)가 E25를 "실질적 연구 진전"으로
인정하면서 지적한 **주장 범위 4곳·판정 도구 1곳**을 저장소 대조로 **전부 사실**로 확인하고 정정했다.
(a) "256/256 원소"는 집계 오기 — 경로당 128, 네 경로 **512**(argmax 집계와 섞였다). (b) "두 ISA가
같은 누산 순서를 만들었다"는 **관측을 넘어선 서술이라 철회** — 관측한 것은 출력 바이트 동일뿐이고
누산 순서는 측정한 적이 없다(확인하려면 두 ELF dispatch 대조 필요, E27 후보). (c) **`both_sound`
갭 해소 주장 철회**(D45) — `cross_target_compare.py:201`의 `both_sound`는 각 타깃 실행의
`peak_within_bounded`를 종합한 **메모리** 지표인데 E25는 메모리를 계측하지 않았다(E25 cFS 로그의
stage는 stack/admission/binding/e25_equivalence 넷뿐, `mem` 없음). E25가 채운 것은 같은 지표의
**다른 칸**(`out0_agreement`)이고 그것도 canonical 1개 한정. (d) "OnAIR-IREE"는 **`iree.runtime`
Python 바인딩 직접 호출**이며 OnAIR 플러그인(여전히 `weights.npz` 경로)도, cFS SB 수신·feature
변환도 통과하지 않았다 — 명칭 정정. (e) 계약값 ISA 동일성은 이 구성의 관측이지 일반 증명이 아님.
**E25b**: `harness/e25_compare.py`가 계획 §3.2보다 **강한** 조건(모든 쌍 비트 동일)을 걸고 있어
정직한 cross-ISA 결과를 FAIL로 만드는 **과잉 거부(유형 B)** 경로였다 — 한 원소만 1 ulp 다른
입력(모든 원소가 abs·rel 각각 16/16 만족)으로 **직접 재현**하고, 쌍별 규칙(같은 vmfb=비트 동일,
다른 vmfb=사전 tolerance+argmax, `--vmfb` 미지정은 거부)으로 수정했다. 보관 출력 재판정 결과
**판정·`vs_reference`·`argmax` 전부 불변**(새 파일 `comparison_all.pairrule.json`, 원본 미수정).
회귀 8건 신설.
**다음**: R-2(E26 계약 경계의 유용성) → R-3(E27 MLIR 고유 기여).


**v0.22.2 (E26 준비)**: 외부 검토 §6이 "E26 측정 전 필수"로 지목한 계측 분리를 구현·실행 확인.
cFS 앱이 `{"stage":"e25_mode","active":<bool>}`를 **항상** 기록하고(측정이 동치 모드 꺼짐을
*증명*할 수 있어야 한다), 추론 0회 시점의 `mem_init` 스냅샷과 세션 직후 RSS를 남긴다. native는
`phase_hal.{after_init,after_first_call,steady_baseline}`. 하네스 expect 키
`e25_mode_active`/`mem_init_present` 신설 — **레코드 부재는 `false`가 아니라 실패**(D29의 교훈).
실측(x86-64, canonical): 초기화 직후 peak **720,932**(= constants 720,896 + 입력 버퍼 36 B),
최초 추론 직후 **786,476**(= bounded), 정상 실행도 동일. native·cFS 일치.
기록: `results/e26_boundary_utility/instrumentation_check/`.

**v0.23에서 완료된 것 (E26a, `docs/EVIDENCE_v0.23_E26a.md`)**: 벤치마크 구성 지침
(`docs/reviews/BENCHMARK_PLAN_REFERENCE_BASED.md`)이 요구한 **"합성 모델 대신 출처가 추적되는
실제 워크로드"**를 따르자마자 **첫 실물 모델에서 도구가 막혔다** — 그것이 D47이다.
`elf_stack_frame.py`의 분류 문구는 처음부터 *"resolve targets before classifying"*이라고 적혀
있었지만 **그 해석 단계가 구현된 적이 없어**, 호출 명령이 하나라도 있으면 bucket (3)/(4)로
분류됐고 헤더 생성이 거부됐다. MLPerf Tiny ResNet(CIFAR-10)의 softmax dispatch가 컴파일러 생성
헬퍼를 80회 호출하는데, **그 타깃은 2개뿐이고 둘 다 같은 ELF의 `.text` 안이며 `.plt`도 미정의
심볼도 없고 두 헬퍼는 프레임 0 B의 leaf**다(objdump/readelf로 직접 확인). 실제 추가 스택은
반환 주소 8 B. **이 결함은 합성 모델셋으로는 원리적으로 재현 불가능했다** — E14 14개와 E25
canonical이 전부 `total_call_insns = 0`이다. 수정은 **한 방향으로만** 작동한다(미해석→해석만
가능): 간접 호출·범위 밖 타깃·꼬리 호출·콜리의 동적 alloca·콜리 안 간접 분기·재귀·해석 결과
부재는 전부 거부 유지. 콜리 범위는 CFG를 실제 순회해 발견한다(첫 구현의 "첫 `ret`까지 자르기"는
바로 이 ResNet 헬퍼에서 **거짓 거부**를 냈다). 부수 정정: `kernel_external_call_insns`가 이름과
달리 내부 호출까지 포함한 총 호출 수였다 → 미해석 호출 수로, 옛 분석 파일은 총 수로 폴백.
결과: 그 모델이 **오버라이드 0개**로 계약(`bounded=618856`)과 헤더(`KERNEL_STACK_BYTES=439L`)까지
완주. 시험 12건, revert 시 11건 실패. **221/221**(209→221), 보관 14개 계약 **diff 0**.
실물 근거: `results/e26_boundary_utility/mlperf_tiny_resnet_fixture/`.
**주장하지 않음**: 이 모델의 정확도(CIFAR-10 평가셋 호스트가 이 환경에서 차단 — 직접 확인),
모든 CNN의 통과, HAL 관측 peak와의 관계(E26 대상), 양자화 모델(범위 밖).

**v0.24에서 완료된 것 (E26b, `docs/EVIDENCE_v0.24_E26b.md`)**: 같은 벤치마크 도입 조사에서
**두 번째 과잉 거부**(D48). `iree-dump-module`은 embedded `.rodata`의 내용이 인쇄 가능해 보이면
백틱 사이에 렌더링하므로 **첫 바이트가 NUL인 진짜 상수 블록이 빈 백틱 쌍으로 출력된다.**
`static_mem_bound.py`의 판별식이 "백틱이 있으면 데이터가 아님"이라 2,816 B 상수를 관측에서
버렸고, 그 결과 계약값과 모순 → D28 상수 게이트 거부 → 오버라이드로 뚫으면 `overridden` →
D39 헤더 게이트가 다시 거부. **정직한 f32 모델의 배치 경로가 닫혀 있었다.** 라벨의 존재가 아니라
**길이**(`len(label)==nbytes`)로 판별하도록 수정 — 저장소 전 산출물의 백틱 rodata 줄 137개 중
136개가 이 성질을 만족하고 유일한 예외가 정확히 그 세그먼트다. 모호하면 데이터로 분류한다
(과다 계상은 크로스체크가 거부해 보이고, 과소 계상은 조용히 통과하므로). 시험 8건,
**229/229**(221→229), 보관 14개 계약 diff 0. 실물 vmfb 보존:
`results/e26_boundary_utility/empty_label_rodata_fixture/`.
**부수 교훈**: 이 시험의 첫 작성본은 revert 시 `AttributeError`로 스위트를 죽였다 —
**결함을 재현하려고 되돌리는 순간이 정확히 그 조건이 발생하는 때**다(D24/D32와 같은 부류).

**v0.25에서 완료된 것 (E26, `docs/EVIDENCE_v0.25_E26.md`)**: R-2의 핵심 질문에 답했다.
사전 고정 기준(`docs/plans/E26_boundary_utility.md`, **측정 전에** 커밋)으로 측정한 결과
**Q1 PASS**(21개 실행 셀 전부 `peak ≤ bounded`, 위반 0), **Q3 PASS**(unsafe admit 0,
`B−1`→DENY·`B`/`B+1`→ADMIT), **Q2 정량화**(tightness **1.00×~45.50×**).
**기전이 규명됐다** — IREE는 상수를 `stream.resource.try_map` + `scf.if(%did_map)`로 감싸고
성공 분기는 HAL 할당이 0, 실패 분기는 상수만큼 할당한다(보관 12개 layout IR 전부 같은 구조).
따라서 `bounded = per_call + constants`는 **두 분기의 최댓값**이며 soundness는 **구조적으로**
성립하고 tightness만 분기의 함수다. 네 가지 런타임 배포(pip `iree.runtime` / 소스 빌드 C 런타임
native / 같은 런타임의 cFS 앱 / qemu-user AArch64)에서 **같은 vmfb의 HAL peak가 최대 45.5배**
달라졌다 — 즉 **런타임 계측으로 얻은 상한은 그 배포에만 유효하고 정적 계약은 배포에 독립**이다.
이것이 "부분 계약이 배치 판단에 유용한가"에 대한 답이며, 유용성의 근거는 tightness가 아니라
**배포 독립성**이고 그 대가가 최대 45.5배의 보수성이다. 분기 결정 요인은 네 가지를 실측으로
배제했고(무작위 아님 5/5 결정적 · 런타임 빌드 구성 동일 · 모델 내재적 아님(E14는 같은 vmfb로
다른 값) · embedded/external만으로 설명 안 됨) **최종 요인은 미확정으로 남겼다**.
**E14의 `both_sound: null` 공백을 실제 실행으로 닫았다**(3모델 전부 true — v0.22.1에서 D45로
철회했던 바로 그 항목). 측정 위생: 모든 cFS 셀이 `e25_mode active=false`를 **증언**했고, HAL
통계가 프로세스 전역이라 모델당 별도 프로세스로 측정했다(오염 실측 재현).
회귀 시험 **CI 실측**(커밋 `3afdf80`): `full` **228/228 + 1 SKIP**(PyYAML 미설치) · `without-iree` **126/126 + 13 SKIP** · `stdlib-only` **126/126 + 13 SKIP**. 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무다(D34 — 추정하지 않고 두 수치를 조건과 함께 병기).
**범위**: E26-core(B0 3모델)의 판정이다. B2·B3 실행 측정과 AArch64 게스트 cFS는 E26-ext로 남음.

**v0.26에서 완료된 것 (E26c, `docs/EVIDENCE_v0.26_E26c.md`)**: 벤치마크 지침 도입 조사가
계획서 §6에 남겨 둔 잔여 결함 후보 **C-1**을 직접 재현·수정했다(**D49**, 유형 (B) 과잉 거부).
IREE는 결과가 둘 이상이면 **하나의 external 슬랩(128 B)에 패킹**한 뒤 `stream.resource.subview`
2개(32 B @0, 16 B @64)로 쪼갠다. 그 op이 두 추출기 화이트리스트에 없어 D13의 fail-closed 규칙이
`unresolved`로 밀어 넣었고 **사실상 모든 다중 출력 모델이 계약을 만들 수 없었다** — 정보가 없어서가
아니라 **파서가 이미 건전·보수적으로(128 ≥ 32+16) 계상한 정보를 쓰지 못해서**다. 두 화이트리스트에
추가하되 기존 비할당 항목(`tensor.export`·`dealloca`)과 달리 **검사를 붙였다**: 세 index 피연산자가
전부 상수로 풀리고 `offset + result_size <= source_size`일 때만 통과. **revert-and-confirm-fail을
두 단계로** 했다 — 화이트리스트만 되돌리면 7건 FAIL(과잉 거부 실재), 검사 코드만 빼면 4건 FAIL
(없으면 fail-open, 즉 유형 (B)를 고치며 유형 (A)를 심는 경우). 실물 근거는
`harness/gen_model_multiout.py` + `results/e26c_multiout/`(한 번의 컴파일 호출, D43 규칙)이고,
계약은 오버라이드 0개·`constants_confirmation_state: confirmed`, 실측 HAL 피크 **704 B =
bounded 704 B**(tightness 1.00×). **남는 제약(명시)**: `gen_contract_header.py`는 여전히 단일
f32 in/out만 허용하므로 다중 출력은 *계약은 생성되고 C 배치는 거부*된다 — 두 C 실행기가 실제로
그렇게 가정하므로 과잉 거부가 아니라 정확한 진술이며, 다중 출력의 C/cFS 배치는 열려 있지 않다.
이 컨테이너 **229/229 → 244/244**, 보관 14개 계약 diff 0. 정정: 계획서 §1.4의
`iree-import-tflite` 차단 서술에서 **"TF 2.21에서"를 철회**한다 — TF **2.19.1·2.20.0·2.21.0 셋 다**
같은 심볼을 export하지 않아 다운그레이드로 우회할 수 없고, 막는 축도 IREE 버전 불일치가 아니라
TensorFlow↔TOSA↔IREE다(같은 세션 반박 검증 8건: UPHELD 1, QUALIFIED 7, 반전 0).


**v0.26.1에서 정정된 것 (E26d, `docs/EVIDENCE_v0.25_E26.md` §9)**: 사전 고정 계획서
(`docs/plans/E26_boundary_utility.md` §5-3)가 지정한 **A5b_canonical**이 실행되지도, 미실행으로
기록되지도 않았다. E26의 판정(Q1·Q3 PASS, Q2 정량화)은 바뀌지 않는다 — A5b는 메모리 경계가
아니라 손상 아티팩트 거부 경로의 질문이고 §2 기준에 들어가지 않는다. 그러나 **v0.9.1에서
A5b를 두고 이미 한 번 정정한 유형**(실행하지 않은 시험을 "확인했다"고 서술)이라 조용히 넘기지
않았다. **E26d에서 실제로 실행했다**: `flatbuffer_root_uoffset` 손상(크기 동일 732,760 B) +
계약을 손상 파일의 실제 해시로 재생성 → **해시 게이트가 잡을 수 없는 조건** → 게스트
`core-cpu1`에서 ADMIT → MATCH → `runtime_load_failed`(IREE FlatBuffer 검증기, E17과 같은 오류
문자열) → cleanup 1회 → `CFE_ES_ExitApp`, 이후 cFS는 남은 앱을 계속 로드(크래시·abort 0,
`check_expect` 불일치 0). **손상 아티팩트는 저장하지 않았다** — 손상이 결정적이므로 시험이
in-tree 원본에서 재생성해 게스트가 실제로 적재한 해시와 대조한다. 이 컨테이너 **252/252**.


**v0.27에서 완료된 것 (E26e, `docs/EVIDENCE_v0.27_E26e.md`)**: **E26-ext** — E26-core의 결론이
합성 모델 밖에서 재현되는지 실물 MLPerf Tiny ResNet(CIFAR-10, 16 dispatch)으로 확인했다.
Q1(위반 0)·Q2(반증 0)·Q3(`B−1`→DENY, `B`·`B+1`→ADMIT) **전부 성립**, 계약 `bounded` 618,856 =
`per_call` 309,416 + `constants` 309,440, 오버라이드 0개. **핵심 관측**: 같은 vmfb가 배포에 따라
`try_map`의 **두 분기를 모두** 탔다 — pip `iree.runtime` peak 309,416(`mapped`, tightness 2.00×)
vs 소스 빌드 C 런타임 618,856(`allocated`, 1.00×), 차이가 **정확히 상수량**. E26의 "정적 계약은
배포 독립, 런타임 계측은 그 배포 한정" 결론의 외적 타당성이다. **ext는 판정을 산출하지 않으므로
v0.25의 판정은 그대로다.** 부수 실측 2건: (1) **`iree-compile`은 이 구성에서 바이트 재현적이지
않다**(ResNet 스레딩 3회 = 3개 해시, `--mlir-disable-threading`은 동일) — 그러나 **계약 수치는
전부 동일**하고 `artifact.bytes`/`sha256`만 다르다. 흔들리는 것은 아티팩트 동일성이지 경계
수치가 아니며, **측정에 쓴 vmfb는 보존해야 한다**(작업 규율 7의 두 번째 이유). (2) **D50** —
반환 버퍼를 붙들면 HAL 피크가 부풀어(309,576 = per_call + 4×40) 저장소 분류기가 **거짓
`refutes_hypothesis`**를 냈다. 놓아주면 정확히 per_call이고 `allocated == freed`다.
**HAL 통계는 관측자가 무엇을 붙들고 있는지에 반응한다.** 이 컨테이너 **260/260**.
**남은 ext**: B3 Deep AutoEncoder fixture, 이 모델의 cFS 셀.


**v0.28에서 완료된 것 (E26f, `docs/EVIDENCE_v0.28_E26f.md`)**: **E26-ext 완결** — 계획서가 채택한
마지막 ext 모델(MLPerf Tiny **Deep AutoEncoder**, 상수:per-call **171.3 : 1**)을 실행했다.
Q1·Q2·Q3 전부 성립, `bounded` 1,069,632 = `per_call` 6,208 + `constants` 1,063,424, 오버라이드 0개
— 계획서 §1.1이 조사에서 인용해 둔 값과 **정확히 일치**(독립 재현). 반입은 이 세션에서 직접 수행
(`tflite2onnx` → `graph.name=infer` → `iree-import-onnx --opset-version 17` → `iree-opt` torch→linalg
→ **한 번의 `iree-compile`**, 잔여 torch op 0). **배포 의존성 최대 사례**: 같은 vmfb가 pip
`iree.runtime` **6,208**(`mapped`, tightness **172.30×**) vs 소스 빌드 C 런타임 **1,069,632**
(`allocated`, 1.00×) — E26-core 상한 45.50×를 넓혔다. **B2(1:1)와 B3(171:1)는 할당 구조가 정반대인데
결론이 같다** — tightness는 상수 비중을 따라가고, 분기 가설은 어느 쪽도 반증하지 않으며, 예산 경계
동작은 동일하다. ext는 판정을 산출하지 않으므로 **v0.25의 판정은 그대로다**. 이 컨테이너 **267/267**,
**CI 실측**(커밋 `f7be746`, run 73): `full` **266/266 + 1 SKIP**(PyYAML) · `without-iree` **159/159 + 15 SKIP** ·
`stdlib-only` **159/159 + 15 SKIP** — 차이 1건은 PyYAML 유무다(D34: 추정하지 않고 병기).
**남은 것**: 두 ext 모델의 cFS 셀(미실행), 그리고 **R-3(E27)**.


**v0.29에서 완료된 것 (E27, `docs/EVIDENCE_v0.29_E27.md`)**: **R-3에 답했다.** 사전 고정 기준
(`docs/plans/E27_mlir_contribution.md` §3, 측정 전 커밋)대로 네 정보 수준을 비교했다.
**정상 조건 8/8 셀에서 아티팩트만 보는 (b)가 계약값과 정확히 일치**했다(합성 3 + AArch64 3 +
실물 MLPerf Tiny 2) — 따라서 ***"이 수치는 MLIR이라야 얻는다"는 여전히 쓸 수 없다***.
**차이는 교란에서만 난다**: 컴파일러 버전 드리프트에서 (b)는 `alloca_sizes=[]`·
`alloca_unresolved=[]`로 **문제 없다고 보고하며 152배 과소**(5,172), (c)는 같은 입력에서
786,476을 내고 디스어셈블 실패를 note로 남긴다. 동적 형상은 세 수준 전부 거부 — 모든 교란이
(b)를 무너뜨리진 않는다. (a) 소스 수준은 3.04×~7.29× **과대**라 한 번도 과소 추정하지 않지만
그 위의 게이트는 배치 가능 모델을 거부한다(유형 B). **조용한 과소 추정: a 0 · b 1 · c 0.**
(d)는 배포 간 최대 **172.3×** 폭이라 기준값이 아니다. **결론: MLIR 수준이 주는 것은 더 정확한
수치가 아니라 독립적인 두 번째 정보원이다** (정정 v0.31, `docs/EVIDENCE_v0.29_E27.md` §7:
*"fail-closed는 정보원 수의 문제"*는 **가용성**으로 좁혀야 한다 — 같은 정보원에서 굳힌
fail-closed 변종은 드리프트를 명시적으로 거부하고 정직한 7개를 정확히 맞힌다(과잉 거부 0).
정보원 수가 정하는 것은 fail-closed 가능 여부가 아니라 **fail-closed일 때 무엇이 남는가**다.
또 152배 과소의 지배항은 §3.1이 명명한 버전 경계가 아니라 **vmfb 세그먼트 순서 가정**이었다).
**D51**: 이 수집기의 첫 실행이 파일명 오타로 인한 `FileNotFoundError`를 **`explicit_refusal`
(정직한 거부)로 집계**했다 — "볼 수 없었다"를 "보았더니 없더라"로 바꿔 기록한 것이고, 하필
그 구분을 측정하는 실험 안에서 일어났다. `tool_error` 신설·`collection_clean`으로 수정.
이 컨테이너 **276/276**, **CI 실측**(커밋 `7fb1d4d`, run 76): `full` **275/275+1 SKIP** ·
`without-iree` **168/168+15** · `stdlib-only` **168/168+15**(차이 1건은 PyYAML, D34).
**주장하지 않음**: 정규 MLIR pass(미착수), **(b) 실패는 n=1**,
(d)를 정답으로 삼는 서술.


**v0.30에서 완료된 것 (E28, `docs/EVIDENCE_v0.30_E28.md`)**: 여섯 번째 외부 검토(SCI 심사)를
검증하다 **핵심 논증 안의 fail-open**(D52)을 찾아 재현·수정했다. **D47·D48·D49가 전부 유형 (B)
과잉 거부였던 것과 방향이 반대다.** cFS 스택 게이트가 `base + kernel`만 계산하는데 추론 경로가
**계약이 크기를 정하는 버퍼 셋**(`feat[]` 4 B/입력원소, `out[]` 4 B/출력원소, `outs[]` **16 B**/
출력원소)을 같은 스택에 잡고 있었다. OPS-SAT 입력 형상(150,528 원소) 계약에서 미계상 602,160 B
vs 부여 262,160 B — 게이트 `accounted=true` → admission **ADMIT** → binding **MATCH** → 첫 추론에서
**SIGSEGV(EXIT=139), 추론 0건**. **계약은 옳았고 게이트가 계약이 준 숫자를 쓰지 않았다.**
수정은 세 버퍼를 `static`으로(같은 파일 `:322`의 `zeros[]` 전례) — **검토서 권고(게이트 공식에
I/O 바이트 추가)는 미채택**, 부여 공식이 정확히 base+kernel이라 오늘 도는 모델이 전부 DENY된다.
revert-and-confirm-fail 양방향 실측(되돌리면 EXIT=139·0건, 고치면 10/10·정상 종료), 과잉 거부
확인 `b2_resnet` 5/5. **부수**: 검토서가 P0로 지목한 **B2·B3의 cFS x86-64 셀을 코드 수정 0건으로
완주**(둘 다 peak = bounded, `allocated`) — 막고 있던 것이 없었고 실행하지 않았을 뿐이다.
**AArch64 cFS 셀은 미실행.** 이 컨테이너 **284/284**, 보관 14개 계약 diff 0.
**교훈**: 지금까지가 *"신호의 부재를 신호로 읽지 말라"*였다면 이것은 ***"계약이 준 숫자를 게이트가
실제로 쓰는지 확인하라"***다.



**v0.31에서 완료된 것 (E29, `docs/EVIDENCE_v0.31_E29.md`)**: **E26이 미확정으로 남긴
`stream.resource.try_map` 분기 결정 요인을 규명하고 제어했다** — 착수 순위표의 최우선 세 축 중
"조건부 계약"이다. 결정 요인은 **모듈 이미지 포인터의 64바이트 정렬**이다:
`iree_hal_heap_buffer_wrap()`(`runtime/src/iree/hal/buffer_heap.c`)이
`IREE_HAL_HEAP_BUFFER_ALIGNMENT`(=64, `base/config.h:244`) 미정렬 span의 import를
`OUT_OF_RANGE`로 거부하고 map 분기가 정확히 그 import다. 사전 고정 기준(D1 이분성·D2 결정
요인)으로 **8모델 × 8 정렬 클래스 = 64셀** 측정 → **map 32 · copy 32 · 제3의 값 0**, 위반 0.
두 C 경로가 blob을 `malloc`했고 glibc가 16/32 mod 64를 주었기 때문에 **E26·E26e·E26f의
native·cFS 셀이 전부 copy 분기**였다. `posix_memalign(…,64,…)` 한 줄로 7모델 전부 map으로
넘어갔고 **map 피크 = `per_call` 정확히 / copy 피크 = `bounded` 정확히**(7/7 양방향) —
**E26이 배포 의존성으로 보고한 1.00×~172.30× 폭 전체가 이 한 포인터의 정렬**이었다.
**E26 Q1(soundness)은 그대로**(bounded는 두 분기의 최댓값, copy가 그 값에 정확히 닿음);
바뀐 것은 tightness의 *원인*이다. **조건부 admission은 계약 스키마 변경 0** —
`B_map = CONTRACT_PER_CALL_BYTES`, `B_copy = CONTRACT_BOUNDED_BYTES`가 이미 헤더에 있다.
opt-in 기본 off(기존 배포 판정 무변경), 전제조건을 **구성으로 강제**하고 append 직후
**측정으로 검증**해 copy 분기면 추론 0건에서 거부(**정정 v0.32/D54**: E29가 출하한 그 검증은 크기
비교라 `constants < per_call`이면 뚫렸다 — E29b가 append 전 정렬 검사 + `!= 0` 분기 판정으로 고침).
`bounded ≤ budget`이면 진입조차 않으므로 **유형 (B) 위험 0**. cFS 실측: 예산 6,208 B에서 `NOT_ADMITTED`이던 b3_deepae가 opt-in 시 같은
예산에서 5/5 완주, 피크 정확히 6,208(배치 예산 172배 감소). **D53**: 검증 블록만 빼면 6,208
예산으로 **1,069,632(172배 초과)** 완주인데 `peak_within_bounded`는 `true` — 그 필드는
`bounded`와 비교하지 **승인 근거 예산**과 비교하지 않는다. **교훈**: D52가 *"계약이 준 숫자를
게이트가 실제로 쓰는지 확인하라"*였다면 이것은 ***"어느 숫자로 승인했는지와 어느 숫자로
검증하는지가 같은지 확인하라"***다. 이 컨테이너 **310/310**(E27 §7 정오표 6건 포함), **CI 실측**(커밋 `58757b3`, run 96): `full` **309/309 + 1 SKIP**(PyYAML 미설치) · `without-iree` **202/202 + 15 SKIP** · `stdlib-only` **202/202 + 15 SKIP** — 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무다(D34: 추정하지 않고 조건과 함께 병기). 보관 14개 계약 diff 0, 보관 14개 계약 diff 0.
**미실행(명시)**: AArch64 게스트 cFS 셀.


**v0.32에서 완료된 것 (E29b, `docs/EVIDENCE_v0.32_E29b.md`)**: 일곱 번째 외부 검토
(`docs/reviews/ONAIR_MLIR_RESEARCH_CONSOLIDATED_REVIEW_20260909.md`) §4.1이 **코드를 읽고 예측한**
fail-open(D54)을 실물로 재현·수정했다. E29의 조건부 admission 사후 검증
`hal_peak_after_append > CONTRACT_PER_CALL_BYTES`는 copy 분기가 정확히 `constants`를 할당하므로
**`constants < per_call`인 모든 모델을 통과**시킨다. 보관 계약 21개가 전부 `constants > per_call`
(b2_resnet 24 B 차이)이라 E29의 7모델 양방향 실측이 이 조건을 못 밟았고, **E29 회귀 시험 자신이
그 비교식의 존재를 pin**하고 있었다(결함을 고정하는 시험). `bigact`(합성, per_call 45,444 /
constants 14,016, 단일 호출, 오버라이드 0)로 재현: 조건부 승인(예산 45,444) → 앱이 `arm=copy`라고
기록하고도 통과 → native 3/3·cFS 5/5 완주, 피크 **59,460(예산의 131%)**, `peak_within_bounded=true`.
수정 둘: (1) **append 전** `module_ptr_mod64 != 0`이면 런타임 생성 전에 거부(E29 D2로 분기를 미리
확정 — 검토서 §4.2 선택지 1, copy 분기 할당 자체가 일어나지 않음), (2) append 후
`hal_peak_after_append != 0 → 거부`(map 분기의 append 피크는 정확히 0, E29 32/32). 수정 후 shim 셀은
native·cFS 모두 런타임 생성 전 거부·추론 0·cFS OPERATIONAL 유지, 정렬 셀은 예산 = per_call에서
**정확히 45,444**로 완주(과잉 거부 0). revert-and-confirm-fail: 비교식만 되돌리면 2건 FAIL.
이 컨테이너 **310/310 → 320/320**(v0.32.1: **D55** — E28·E29·E29b의 cFS raw log 9건이 `.gitignore` `*.log` 때문에 저장소에 없었음을 발견, `!results/**/*.log`로 교체·커밋하고 summary.json이 인용한 로그의 존재·추적을 검사하는 가드 신설 → **322/322**; **CI 실측**(커밋 `56f02b2`, run 104, 3레그 success): `full` **321/321 + 1 SKIP**(PyYAML) · `without-iree` **213/213 + 16 SKIP** · `stdlib-only` **213/213 + 16 SKIP** — 컨테이너 322/322와 `full`의 차이 1건은 PyYAML 유무(D34), SKIP 15→16은 E29b의 단일 호출 재생성 시험이 iree 도구 없이는 정직하게 SKIP하기 때문이다.), 보관 14개 계약 diff 0. **교훈**: D53을 E29 자신이 어겼다 —
승인은 분기를 전제했는데 검증은 크기를 비교했다. 그리고 ***"시험이 무엇을 pin하는지 읽어라"***.
**미착수(명시)**: 검토서 §5–§12의 실물 모델 계획(P1–P5: OPS-SAT SmartCam·WGAN 반입, TFLite 의미
동치, AArch64 cFS 완주, LLVM-IR/ELF-only 기준선) — `docs/ASSUMPTIONS_AND_SCOPE.md`에 등록만 했다.

**v0.33에서 완료된 것 (E30, `docs/EVIDENCE_v0.33_E30.md`)**: 여덟 번째 외부 분석서
(`docs/reviews/ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md`)가 §9에서 못박은 **P1 — OPS-SAT SmartCam 반입 타당성만**
수행했다(WGAN·AArch64·cFS 일반화·정확도는 하지 않음). 비행 모델 `model.tflite`(commit `be09ece`, 8,950,028 B,
sha `fd1ecbd0…`)를 **무수정 보존**하고 기계 판독 인벤토리(68 op / 9종 / custom 0 / 동적 형상 0, NHWC
[1,224,224,3] f32 → [1,3] f32)를 만든 뒤, 알려진 차단점(stock tflite2onnx 0.4.1 `Unsupported TFLite OP: 43
SQUEEZE!`)을 **재현**하고, 분석서 §5의 조건 C1–C4(제거 축 크기 1·원소 수·dtype·정적 출력 형상)를 순수 함수로
검사해 **전부 성립할 때만** 변환하는 **변환기 확장**(`harness/tflite2onnx_ext_squeeze.py`, NHWC→NCHW 재색인
[1,2]→[2,3] 감사, 위반은 거부)으로 넘겨 `iree-import-onnx --opset-version 17` → `iree-opt` → **한 번의
`iree-compile`**로 완주했다. 판정 **TRANSFORM_REQUIRED → GO**: 계약 **오버라이드 0**, `bounded`
**18,222,796** = `per_call` **9,382,092** + `constants` **8,840,704**, 디스패치 56, 커널 스택 368/439 B(38 호출
전부 해석), 상수 `confirmed`, 구조적 추출기 일치, **E27 (b′) 아티팩트 전용 기준선이 같은 세 값**, layout IR은
E26의 두 분기 구조 그대로(1.94×), pip 스모크 피크 **= per_call 정확히**(allocated == freed). ONNX `Squeeze`와
분석서가 제안한 정적 `Reshape`는 **linalg MLIR부터 바이트 동일**(판정이 방출 op에 무관). **P2 의무로 기록한
인터페이스 변경**: 엔트리 입력이 NCHW `[1,3,224,224]`라 비행 NHWC 입력을 전치해야 같은 입력이다. 부수 발견 둘:
tflite2onnx가 `initializer`·`value_info`를 `set()`에 담아 **실행마다 ONNX 바이트가 달랐다**(세 번 = 세 해시;
래퍼가 이름순 정렬로 canonical화, 이후 원본→ONNX→linalg sha256이 매번 재현) · pip 바인딩의 호스트 읽기가 HAL
버퍼를 붙든다(D50의 새 얼굴 — 스모크는 결과를 버리는 호출로 피크를 먼저 읽는다). 이 컨테이너 **322/322 →
353/353**(변환기 패키지 `tflite`·`tflite2onnx`·`onnx`를 `requirements.txt`에 고정; 없으면 해당 시험 SKIP). **CI 실측**(커밋 `5267025`, run 110, 3레그 success): `full` **352/352 + 1 SKIP**(PyYAML) · `without-iree` **237/237 + 20 SKIP** · `stdlib-only` **237/237 + 20 SKIP** — 컨테이너 353/353과 `full`의 차이 1건은 PyYAML 유무(D34), SKIP 16→20은 p1-smartcam의 변환기 의존 시험 3건 + 계약 재생성 1건이 해당 패키지·IREE 도구 없이는 정직하게 SKIP하기 때문이다.
**v0.33.1/E30b(D56)**: E30의 적대적 검증(반박 9 + 2인 검증)이 SQUEEZE 확장의 **잠재 fail-open**을 합성
flatbuffer로 재현했다 — C1–C4를 통과하는 TFLite-유효 부분 squeeze([1,1,7,64] dims [1])가 NCHW 재색인 텐서 위에서
방출돼 **데이터가 조용히 전치**(reshape 모드 max_abs_diff 5.46/1.89/2.61, 컴파일러·런타임 무경고). 비행 모델은
남는 축 {N,C}라 무관. 수정 **C5**(남는 축의 순서가 레이아웃 순열 아래에서 보존) + 옵션 부재 크래시·중복 축·항등
사례. 합성 11건 회귀(`harness/gen_tflite_squeeze_cases.py` + `e30b_squeeze_probe.py`; CONVERTED 5건은 IREE 출력을
TFLite 의미와 비트 대조, max_abs_diff 0.0), revert 시 3건 CONVERTED로 전환. **353/353 → 371/371**.
**v0.33.2/E30b 후속(D57)**: 그 **C5 자신이 과잉 거부**였음이 같은 검증에서 재현됐다 — 재정렬되는 남는 축이
전부 extent 1이면 데이터가 안 움직이는데 *"would reorder data"*로 거부했고(81형상 중 7건), **명백한 수정
("extent>1 축만 순서 유지")은 곧 fail-open**이다(선언 `[2,1,1]` vs ONNX 추론 `[1,2,1]`). 논증을 세 번째로
고치는 대신 **시뮬레이션**으로 교체 — 모델 형상의 라벨 배열로 방출될 ONNX를 그대로 계산해 `np.squeeze` 기준과
**형상·값 둘 다** 대조한다. 경계 2사례 신설, 인벤토리가 변환기 순수 함수를 직접 import(형제 도구가 D56과 같은
조건에서 크래시하고 음수 dims를 오보고하던 것도 해소). 비행 모델 산출물 불변, **378/378**. **적대적 검증의
실행 범위**: 반박 9묶음 완주, **2인 검증은 세션 한도로 0건 실행** — 확인 주체는 구현자 자신이다.
**교훈**: *경계 조건을 논증으로 좁히면 논증이 틀린 만큼 틀린다 — 계산할 수 있는 것은 계산하라*. **CI 실측**(커밋 `39a4692`, run 112, 3레그 success): `full` **370/370 + 1 SKIP**(PyYAML) · `without-iree` **240/240 + 21 SKIP** · `stdlib-only` **240/240 + 21 SKIP** — 컨테이너 371/371과 `full`의 차이 1건은 PyYAML 유무(D34), SKIP 20→21은 e30b의 합성 사례 시험이 변환기 패키지 없이는 정직하게 SKIP하기 때문이다. 교훈: *형상·원소
수·dtype 보존 ≠ 데이터 순서 보존*. 인터페이스 좁힘이 둘(레이아웃 + 배치 고정)임도 기록.
**D57까지 반영한 CI 실측**(커밋 `e4e60c3`, run 121, 3레그 success): `full` **377/377 + 1 SKIP**(PyYAML) ·
`without-iree` **241/241 + 22 SKIP** · `stdlib-only` **241/241 + 22 SKIP** — 컨테이너 378/378과 `full`의
차이 1건은 PyYAML 유무(D34). 축소 레그의 총계가 컨테이너보다 적은 것은 변환기 패키지가 없으면
`e30b_squeeze_extension_cases`가 SKIP 2건을 남기고 **조기 반환**하기 때문이다(사례별 SKIP 나열 안 함).
**v0.34에서 완료된 것 (E31, `docs/EVIDENCE_v0.34_E31.md`)**: **P2 — SmartCam 원본 의미 보존, PASS.**
아홉 번째 외부 검토(`docs/reviews/ONAIR_MLIR_ARCHITECTURE_PLAN_20260910.md`)가 §14에서 **"지금 가장 먼저
착수할 구현"**으로 지목한 셋(입력 fixture · 원본 출력 oracle · 전체 출력 comparator)을 만들어 §10 단계 1을
실행했다. 원본 `model.tflite`(무수정, `ai_edge_litert` LiteRT 인터프리터)와 E30의 vmfb가 **같은 전처리
결과**를 받았을 때 37입력 × 3출력 = **111원소 전부**가 사전 고정 기준을 만족, **argmax 37/37**, 최악 abs
**5.364e-07**. 기준은 **측정 전 커밋**(`8f7bcde`)이고 E25에서 **변경 없이 승계**(원소별 `abs<=1e-4` OR
`rel<=1e-5`). 전처리는 원본 `config.ini`의 값(224×224, mean 0, std 255 → `pixel/255`)이며 모델 내부
`MUL(2.0)`·`SUB(1.0)`이 [−1,1]을 완성하므로 **이중 정규화 없음**. resize는 fixture가 한 번 수행해 두 경로에
같은 텐서를 준다(교란 소거). 레이아웃은 **전치**이고 생성기가 왕복을 자기검사한다.
**실측으로 드러난 둘**: (1) **사전 고정한 OR 규칙이 판정을 좌우** — 실제 이미지 최악 `rel_err` **1.573e-05**가
`rel_tol`을 넘고 `abs_err`만이 통과시켰다(rel 단독이면 정직한 결과가 FAIL). (2) **음성 대조**(전치 대신
reshape) → **FAIL 105/111**인데 **argmax만 봤으면 34/37(92%) 통과**였고, 통과한 것은 **상수 경계 입력 2개뿐**
— **경계 입력만으로는 레이아웃 오류를 원리적으로 못 잡는다**(비상수 실데이터 필요). **부수**: fixture 자기검사
첫 구현이 *값*으로 transpose≠reshape를 판정해 전부 0 입력에서 **과잉 거부**(D57 직후 같은 계열) → `arange`
라벨로 형상만 판정. **하지 않음**: 정확도(공개 예제 3장은 평가셋 아님)·비행 파이프라인 동치·AArch64/cFS/OnAIR·
다른 모델·메모리 측정. 회귀 14건(라이브 재실행 포함), **378/378 → 392/392**. **CI 실측**(커밋 `0f25ad4`,
run 122, 3레그 success): `full` **391/391 + 1 SKIP**(PyYAML) · `without-iree` **251/251 + 26 SKIP** ·
`stdlib-only` **251/251 + 26 SKIP** — 컨테이너 392/392와 `full`의 차이 1건은 PyYAML 유무(D34), 축소 레그
에서는 신규 14건이 **10 PASS + 4 SKIP**으로 전부 나타난다(라이브 재실행 4건만 `ai_edge_litert`·
`iree.runtime`·`numpy`를 요구하고, 보관 JSON을 읽는 10건은 의존성 없이 실제로 돈다).
**다음은 검토서 §10 단계 2**(SmartCam AArch64 cFS 실행 — 환경은 이미 존재하므로 재구축하지 않는다) →
단계 3(공식 OnAIR 경로 갱신) → 단계 4(ResNet·DeepAE) → 단계 5(공정한 기준선).

**v0.35에서 완료된 것 (E32, `docs/EVIDENCE_v0.35_E32.md`)**: **단계 2 — SmartCam AArch64 cFS 실행.**
사전 고정 기준(`docs/plans/E32_smartcam_aarch64_cfs.md`, **측정 전 커밋** `3c7295d`)대로 실행했고
**Q1 의미 PASS · Q2 계약/admission PASS · Q4 모드 분리 PASS · Q3 수명주기는 조건부 계층 미달**이다.
계약 세 수치가 x86-64와 **정확히 동일**(bounded 18,222,796 = per_call 9,382,092 + constants 8,840,704,
dispatch 56, 오버라이드 0); 다른 것은 아티팩트와 커널 스택(1,919 B·호출 0 vs 439 B·호출 38)뿐이다.
의미는 **원본 TFLite oracle** 기준·E31에서 무변경 승계한 기준으로 판정: **S-native 37샘플 111원소 전부
통과**(argmax 37/37, 최악 abs 1.252e-06), **S-cfs 5샘플 15원소 전부 통과**(계획서가 측정 전에 고정한 셀
정의 = 실이미지 3 + 경계 2). 예산: `B−1`→NOT_ADMITTED(추론 0)·`B`/`B+1`→ADMIT.
**D58(과잉 거부)**: AArch64 과정렬 프레임의 복귀 철자 `sub sp, x29, #K`를 인식 못 해 정직한 모델의 헤더가
거부됐다 — 도구가 **올바른 상한 1,919 B를 계산해 놓고 자기 수치를 쓰지 못하게 막고 있었고**(D47과 같은 구조),
x86-64의 같은 관용구는 E14부터 처리하고 있었다. 한 방향 완화(K 일치 요구) + 독립 산술 검증
(`all_dispatch_frames_balanced` false→true).
**D59(fail-open)**: 조건부 계층의 **사후** 검사가 승인 근거(`per_call`)가 아니라 `bounded`와 비교해,
승인 예산의 **106.4%**(9,984,204)로 돌고도 `peak_within_bounded: true`를 기록했다. 초과분은 **정확히 입력
텐서 하나**(602,112 B)이고 **대조로 확정**했다 — 재생만 끄면 피크가 정확히 `per_call`이다(그 대조는 부수로
**E29 이분성이 8.9 MB 실물 모델·AArch64에서 재현**됨을 보인다). 두 C 경로가 이제
`admitted_budget_bytes`·`peak_within_admitted_budget`·`admission_mode`를 함께 보고하고 cFS 앱은 초과 시
EVS ERROR를 올린다. **교훈**: D53을 *추론 이후에 도는 검사*에서 다시 어겼다 —
***"승인 근거와 검증 기준이 같은지는 게이트뿐 아니라 사후 검사에서도 확인하라."***
**계획서 자신의 오류**도 기록했다: §3.2의 "런타임 예산" 서술은 틀렸고, 앱 예산이 컴파일 타임 상수라
cFS의 `B−1`은 **빌드 자체가 불가능**하다(fail-open이 아니라 빌드 거부). 이 컨테이너 **404/404 → 411/411**.
**CI 실측**(커밋 `b5d3d0e`, run 126, 3레그 success): `full` **421/421 + 1 SKIP**(PyYAML) · `without-iree` **281/281 + 26 SKIP** · `stdlib-only` **281/281 + 26 SKIP** — 컨테이너 422/422와 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 251→281로 **정확히 +30**이라 E32 신규 30건이 **전부 나타난다**: 합성 objdump 단위 시험과 보관 JSON 판독이라 툴체인 없이 실제로 돈다(신규 SKIP 0).
**다음은 단계 3**(공식 OnAIR 경로 갱신) → 단계 4(ResNet·DeepAE) → 단계 5(공정한 기준선).

**v0.36에서 완료된 것 (E33, `docs/EVIDENCE_v0.36_E33.md`)**: **단계 3 — 공식 OnAIR 경로, Q1~Q4 전부 PASS.**
**E25가 v0.22.1에서 정정한 갭이 닫혔다** — 그때 "OnAIR-IREE"는 `iree.runtime` 직접 호출이었고 공식 로더를
통과한 실행은 없었다. 하네스는 플러그인을 **import하지 않고** `python driver.py <ini>`를 서브프로세스로
돌린다(stub이 아니라는 근거). 네 셀 전부 NASA 로더가 구성했고 **OnAIR 코어 추적 파일 변경 0**을 실행
전후 검사로 확인했다. **P-admit** 5추론·판정 PASS(15원소 0실패, argmax 5/5, 최악 abs 5.364e-07, 기준값은
원본 TFLite oracle, 기준은 E25→E31→E32 무변경 승계) · **P-deny**(bounded−1) 비활성·추론 0·rc 0 ·
**P-mismatch** 파일을 읽기 전 크기 선검사로 거부 · **P-legacy** 기존 MLP 그대로(구식 계약이라 admission은
`NOT_EVALUATED` — 없는 경계를 지어내지 않는다).
**NASA 원본을 읽고서야 알 수 있었던 제약 셋**: 로더가 `(construct_name, headers)` 두 인자만 전달 →
`ONAIR_MLIR_DEPLOYMENT_CONFIG`; headers 비어있지 않음 요구 vs 이미지를 150,528 필드로 펼 수 없음 →
입력 모드 둘; **CSV 파서가 모든 필드를 float화하고 실패 시 0.0으로 대체** → 문자열 ID였다면 다섯 프레임이
전부 0번 샘플을 추론하면서 "5샘플 재생"으로 보였을 것 → 숫자 인덱스.
**실측 발견**: OnAIR이 데이터 소진 후 입력 갱신 없이 `render_reasoning()`을 한 번 더 불러 5프레임에 6결과가
났다 → 입력 신선도를 추적해 추론하지 않고 `stale`로 되돌리고, 변환기도 중복 채점을 거부한다(두 층).
**부수**: 첫 구현이 계획서 §4-3을 스스로 어겨(계약 로딩이 가드 밖) OnAIR 실행 전체를 죽였다 — 실측 후 수정.
**하지 않음**: SBN·cFS 연계(단독 CSV OnAIR 실행을 cFS 연계라 부르지 않는다)·정확도·지연·AArch64 OnAIR·
메모리 실측. 이 컨테이너 **422/422 → 453/453**.
**CI 실측**(커밋 `8186a72`, run 128, 3레그 success): `full` **452/452 + 1 SKIP**(PyYAML) · `without-iree` **312/312 + 26 SKIP** · `stdlib-only` **312/312 + 26 SKIP** — 컨테이너 453/453과 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 281→312로 **정확히 +31**이라 E33 신규 31건이 **전부 나타난다**(신규 SKIP 0): 보관 JSON 판독과 `admission_policy` 순수 단위 시험이라 툴체인 없이 실제로 돈다. **다음은 단계 4**(ResNet·DeepAE) → 단계 5(공정한 기준선).

**v0.37에서 완료된 것 (E34, `docs/EVIDENCE_v0.37_E34.md`)**: **단계 4 — 두 공개 임베디드 모델로 확장,
Q1~Q4 전부 PASS.** 이 단계에서 시험받은 것은 모델이 아니라 **도구**다: **새 모델별 하네스 0개 · 모델별
분기 0줄 · 재컴파일 0회**로 B2 ResNet(340원소 전부 통과, argmax 34/34)과 B3 DeepAE(**21,760원소 전부**
통과)가 E31~E33 도구를 그대로 지났다. `tflite_oracle.py`·`iree_runner.py`는 무변경이었고
`model_fixture.py`·`e31_compare.py`만 규약을 **값으로 받게** 일반화했다.
**argmax 관측이 실질**: 계획서가 예고한 과잉 거부는 **일어나지 않았고**(요구해도 DeepAE 34/34 통과) 그대로
기록했다 — 대신 **DeepAE의 argmax가 모든 입력에서 261 하나로 상수**(ResNet은 {0,4})라 그 일치가 **변별력
0**임이 드러나, 검토서 §9.3의 지시가 **측정된 사실**이 됐다.
**음성 대조**(전치 대신 reshape) FAIL 258/340인데 **argmax만 봤으면 34/34(100%) 통과** — E31의 92%보다
강하고, 못 잡은 것은 정확히 **상수 경계 입력 2개**로 E31의 한계가 그대로 재현됐다.
**원본 보존(D43)**: 두 `.tflite`를 in-tree로 넣고 기록된 해시와 일치 확인. **회귀**: E31 보관 실행 재판정이
판정·totals·worst 전부 동일. **등급**: 두 모델은 **합성 전용**이라 SmartCam보다 약한 의미 검증이고
**정확도는 주장하지 않는다**. 이 컨테이너 **453/453 → 469/469**.
**CI 실측**(커밋 `867c384`, run 134, 3레그 success): `full` **468/468 + 1 SKIP**(PyYAML) · `without-iree` **328/328 + 26 SKIP** · `stdlib-only` **328/328 + 26 SKIP** — 컨테이너 469/469와 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 312→328로 **정확히 +16**이라 E34 신규 16건이 **전부 나타난다**(신규 SKIP 0): 보관 JSON 판독과 comparator 서브프로세스 단위 시험이라 툴체인 없이 실제로 돈다.
**다음은 단계 5**(공정한 기준선과 논문 주장 확정) — §8.3이 지목한 최대 신규성 위험이 걸린 자리다.

**v0.38에서 완료된 것 (E35, `docs/EVIDENCE_v0.38_E35.md`)**: **단계 5 — 공정한 기준선. 결론은 MLIR 우위가
아니라 주장 범위의 축소다.** 검토서 §8.3이 "현재 가장 큰 신규성 위험"으로 지목한 자리를 사전 고정 기준
(`docs/plans/E35_fair_baseline.md`, **측정 전 커밋** `3bc617f`)대로 쟀다.
**기준선을 이기게 만들지 않았다**: 같은 정책 코드(`admission_policy.py`) 하나를 두 수준에 적용하고,
**조건부 지식을 artifact-only 기준선에도 주고**, 예산 구간은 모델과 무관한 규칙(`B`·`P`·`P−1`)으로 고정했다
(재컴파일 0회, 모델 실행 0회).
**결과: 4개 모델–타깃 구성(서로 다른 모델은 3개) × 2정책 × 3구간 = 24셀 전부 판정 동일(불일치 0)**, 세 수치 4/4 일치, **차이가 날 것으로 본
커널 스택마저 4/4 일치**(임베디드 ELF가 vmfb 안에 있어 같은 분석기가 dump 없이 돈다 — *"이건 MLIR이라야
얻는다"*가 세 수치에 이어 스택에서도 반증됐다).
**유일한 비대칭은 one-invocation 결속인데 그것을 이점이라고 쓰지 않는다** — 아티팩트가 하나뿐인 수준에서는
어긋날 것이 없어 질문 자체가 성립하지 않으므로, **여러 아티팩트를 쓰는 방식의 비용**이다.
**부수(방법론)**: 수집기 첫 판이 스택을 0/4 불일치로 냈는데 계약의 필드 이름을 잘못 읽은 **도구 결함**이었다.
발견이 아니라 버그였고, 고치자 4/4다 — 차이가 나오면 먼저 자기 도구를 의심해야 하는 이유다.
계획서 §6이 결과별 서술을 **측정 전에** 정해 두었으므로 그대로 채택한다: **"MLIR 기반 계약 추출·연계 방법"**.
이 컨테이너 **469/469 → 477/477**.
**CI 실측**(커밋 `84648ea`, run 136, 3레그 success): `full` **476/476 + 1 SKIP**(PyYAML) · `without-iree` **336/336 + 26 SKIP** · `stdlib-only` **336/336 + 26 SKIP** — 컨테이너 477/477과 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 328→336으로 **정확히 +8**이라 E35 신규 8건이 **전부 나타난다**(신규 SKIP 0): 보관 `summary.json` 판독뿐이라 툴체인 없이 실제로 돈다.
**v0.38.1에서 정정된 것 (열 번째 외부 검토 반영, D60)**: 검토 문서가 저장소 원자료를 직접 읽어 세 곳을 지적했고
**전부 사실로 확인**했다. (a) **D60** — `EVIDENCE_v0.36_E33.md` §8 Q4의 *"매 호출 출력 소비·해제"*에서 **"해제"를
철회**한다. 같은 셀의 `results/e33_onair_official/p_admit/run.json`이 `nanobind: leaked 10 instances`
(HalBufferView·MappedMemory) + `5 keep_alive records`를 남기고 있었는데 **EVIDENCE는 한 줄도 기록하지 않았다**
(저장소 `nanobind|leak|누수` grep 0건). 상태는 **메모리 해제 미검증**이며 양방향으로 못박는다 — 해제됐다고도,
누수라고도 쓸 수 없다(경고 본문이 원인을 IREE 바인딩 참조 계수로 지목하고, 이 경로는 HAL 피크를 재지 않았다).
D55·D45와 같은 계열(원자료는 저장소 안에 있었고 문서가 반대로 적혔다). (b) **"4모델"은 3개 모델의 4개
모델–타깃 구성**이다(SmartCam이 x86-64·AArch64로 두 번 세어진다). (c) **커널 스택 4/4 일치는 정보원 독립성의
증거가 아니다** — 두 수준이 `harness/elf_stack_frame.py` **같은 구현**을 쓰고(`--elf-analysis` vs `--vmfb`),
`make_contract.py:822`가 "분석한 ELF == vmfb 내장 ELF"를 이미 강제한다. E35의 판정은 불변이고, 바뀌는 것은
그 일치를 **오류 독립성의 근거로 쓸 수 없다**는 것이다. 가드 시험 6건 신설(477/477 → 483/483).
**CI 실측**(커밋 `1a66267`, run 142, 3레그 success): `full` **482/482 + 1 SKIP**(PyYAML) · `without-iree` **342/342 + 26 SKIP** · `stdlib-only` **342/342 + 26 SKIP** — 컨테이너 483/483과 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 336→342로 **정확히 +6**이라 정오표 가드 6건이 **전부 나타난다**(신규 SKIP 0): 보관 원자료 판독과 문서 텍스트 검사라 툴체인 없이 실제로 돈다.
**또한 "단계 1~5 완료"는 과장이었다** — E32는 원자료 `stage_2_complete: false`(조건부 계층이 승인 예산의
106.4%로 실행), E34는 §10 단계 4가 지정한 **AArch64 cFS 평가 절차를 실행하지 않았다**(E34 계획서가 측정 전에
범위 밖으로 선언했으므로 은폐는 아니나, 검토서 기준의 완료는 아니다).

**v0.39에서 완료된 것 (E36, `docs/EVIDENCE_v0.39_E36.md`)**: **AArch64 cFS 증거 완성 — E32가 원자료에
`stage_2_complete: false`로 남긴 단계 2를 닫았다.** 사전 고정 기준(`docs/plans/E36_aarch64_cfs_completion.md`,
**측정 전 커밋** `f3ac80c`). **Q1**: §10 단계 2가 요구한 **cFS 예산 미달 거부 셀이 처음으로 실행**됐다 —
E32에서는 예산이 컴파일 타임 매크로라 정적으로 접혀 **빌드 자체가 불가능**했고, 초기화 시점 런타임 오버라이드로
열었다. 예산 18,222,795 → **NOT_ADMITTED · 추론 0회 · `CFE_ES_ExitApp` 이후 같은 cFS가 앱 8개를 계속 로드**
(*"비승인 상태에서도 cFS의 다른 기능이 계속 동작"*을 로그로 충족). **Q1b**: 파싱 실패·`0`은 `BUDGET_INVALID`로
초기화 거부 — 조용히 매크로로 되돌리지 않는다(D29). **Q2**: **조건부 계층이 실물 8.9 MB 모델·AArch64 cFS에서
전제를 지키며 완주** — 승인 예산 **9,382,092**(= `per_call`, `bounded`의 **1.94× 감소**), `module_ptr_mod64:0`·
`hal_peak_after_append:0`·`arm:map`(E29b의 두 전제조건을 **측정으로** 확인), 피크 **정확히 9,382,092**,
`peak_within_admitted_budget:true`. **대조군**(같은 예산·opt-in 없는 빌드)은 NOT_ADMITTED라, 통과의 원인이
느슨한 예산이 아니라 조건부 계층임을 셀로 확인했다. **Q4**: 오버라이드 미설정이 E32 `cfs_B_plus_1`과 결정론적
값 전부 동일(계획서 §4가 *"Q4 실패 시 Q1을 PASS로 적지 않는다"*고 미리 정해 뒀다).
**D61 — 이 변경이 심은 결함 2건을 시험이 아니라 계측이 잡았다**: (a) 일괄 치환이 resolver의 매크로 읽기를
**자기 대입**으로 바꿔 예산 0 → 전부 NOT_ADMITTED. **bounded > 0이라 그 거부는 논리적으로 맞고 정직해 보인다** —
`"budget":0,"budget_source":"macro"`가 드러냈고(계획서 §3.1이 그 필드를 요구했기 때문), 매크로 경로도
`<=0`이면 명시 거부하도록 고쳤다. (b) 빌드 스크립트의 `${VAR:+-D}`가 **공유 CMake 캐시 잔류값**을 물려받아
무조건 트리가 조용히 조건부가 되고 **거부해야 할 셀이 `ADMIT_CONDITIONAL_MAP`**(유형 A) — 기본 0 명시 전달 +
컴파일 도달 검증으로 고치고 **조건부 트리를 먼저 빌드**해 결함 조건을 실제로 만든 뒤 확인했다.
**교훈**: ***"판정에 쓴 설정이 무엇이었는지를 판정 자신이 기록하게 하라."*** 재현 로그도 보존한다
(`results/e36_aarch64_cfs/{prefix_bug,cache_leak_bug}/`). **정정**: 계획서 §3.4의 *"추론 70회 재현"*은
부정확했다 — 모든 셀이 `timeout -s INT`로 끝나므로 횟수는 실행 시간의 함수이고, 비교 대상은 결정론적 값이다.
시험 11건 신설(483/483 → **494/494**), revert 시 2건 FAIL.
**CI 실측**(커밋 `78083d0`, run 146, 3레그 success): `full` **493/493 + 1 SKIP**(PyYAML) · `without-iree` **353/353 + 26 SKIP** · `stdlib-only` **353/353 + 26 SKIP** — 컨테이너 494/494와 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 342→353으로 **정확히 +11**이라 E36 신규 11건이 **전부 나타난다**(신규 SKIP 0): 게스트 raw log에서 만든 `summary.json` 판독과 소스 텍스트 검사라 툴체인 없이 실제로 돈다.
**미실행(명시)**: **Q3 — ResNet·DeepAE의 AArch64 native·cFS는 E36b로 이연**했으므로 **§10 단계 4는 여전히
잔여 셀이 있다.**

**v0.40에서 완료된 것 (E36b, `docs/EVIDENCE_v0.40_E36b.md`)**: **ResNet·DeepAE의 AArch64 확장 —
`stage_4_complete: true`.** §10 단계 4의 작업 항목 중 E34가 계획서에서 범위 밖으로 선언했던 절반이다
(사전 고정 기준은 E36 계획서 **§3.3**, 측정 전 커밋 `f3ac80c`).
**계약**: 모델당 **한 번의 `iree-compile`**, **오버라이드 0** — ResNet `618,856 = 309,416 + 309,440`,
DeepAE `1,069,632 = 6,208 + 1,063,424`로 **x86-64와 정확히 동일**하고 다른 것은 커널 스택뿐이다
(1,232 vs 439 · 16 vs 32). **의미**: 기준을 E25 이래 무변경 승계하고 기준값을 E34 보존 원본
`.tflite`(LiteRT)로 두어, **native(qemu-user)와 cFS 게스트 양쪽에서** ResNet **340원소**(argmax 34/34,
최악 abs 1.937e-06)·DeepAE **21,760원소**(최악 abs 3.815e-05) **실패 0**. **예산**: `B`→ADMIT ·
`B−1`→NOT_ADMITTED(E36의 런타임 오버라이드 재사용, 새 배선 0). **피크가 `bounded`가 아니라 `per_call`**
(309,416 / 6,208)인데, E29b가 앱이 자기 blob을 64바이트 정렬하게 고쳤기 때문이며 E26f가 x86-64
소스빌드 런타임에서 DeepAE를 1,069,632(copy 분기)로 잰 것과 대비된다 — 배포가 분기 전제를 제어한다.
**D62 — 단계 4의 "새 하네스 0개"에 대한 정직한 답**: 새로 만든 하네스는 **0개**지만 기존 둘이 SmartCam의
출력 arity를 **리터럴 3**으로 들고 있었다. `e32_native_aarch64.py`는 **10출력 ResNet을 앞 3개로 조용히
절단**(fail-open), `e32_cfs_outputs.py`는 나눗셈 검사로 **거부**(fail-closed) — 같은 하드코딩의 두 방향.
절단된 출력의 비교 결과가 **340/340 실패 + `worst_abs 0.0`**이라는 자기모순이었고 **계산은 처음부터
맞았다**. 둘 다 `--contract`에서 arity를 읽도록 일반화했다(E34가 `model_fixture.py`·`e31_compare.py`에
한 것과 **같은 방식** — 분기가 아니라 값). **교훈**: *한 모델로 세운 절차를 다른 모델에 적용하는 것이
그 절차의 시험이다 — 통과하지 못하는 것은 모델이 아니라 도구다.*
시험 **14건** 신설, 494/494 → **508/508**.
**CI 실측**(커밋 `b6c778f`, run 150, 3레그 success): `full` **507/507 + 1 SKIP**(PyYAML) · `without-iree` **367/367 + 26 SKIP** · `stdlib-only` **367/367 + 26 SKIP** — 컨테이너 508/508과 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 353→367로 **정확히 +14**라 E36b 신규 14건이 **전부 나타난다**(신규 SKIP 0): 보관 `summary.json` 판독과 소스 텍스트 검사라 툴체인 없이 실제로 돈다. **정정**: 커밋 메시지와 최초 문서가 *"시험 15건"*이라 적었으나 실제 신규 검사는 **14건**이다(494→508 = +14, CI 축소 레그 353→367 = +14로 양쪽이 같은 수를 가리킨다). 수치를 세어 보지 않고 적은 값이었고, 판정에는 영향이 없으나 그대로 고친다.
**하지 않음**: 정확도(합성 전용 — **E34 §5 등급 그대로**, AArch64에서 돌았다고 오르지 않는다)·
이 두 모델의 OnAIR·지연·조건부 계층(무조건 계층만).

**v0.41에서 완료된 것 (E37, `docs/EVIDENCE_v0.41_E37.md`)**: 열한 번째 외부 문서
(`RESEARCH_COMPLETION_ACTIONS.md`, 기준 커밋 `2aa0d68`)가 남은 과제를 *"실험 대상을 늘리는 일이 아니라
확보한 증거를 하나의 재현 가능한 결과로 확정하는 일"*로 지목했다. 주장 8건을 원자료로 대조하고 건별
적대적 반박을 붙여 **문서 정정 요구 0건 · 반박 6건 전부 refuted=false**로 확인했다(이 저장소가 받은
검토 중 처음). **A**: 정본 중심 주장이 여전히 **E14 시점 문장**(합성 3모델)이었다 — v0.41 문장으로
교체하고 7개 구분을 `docs/ASSUMPTIONS_AND_SCOPE.md`에 확정. **B**: `harness/mk_evidence_linkage.py`로
3모델 × 7항목 **21/21 present**(원자료 참조 121건). **C**: `harness/e37_reproduce_check.py`로 최종 코드
재판정 **13/13 동일**, 그리고 게스트 재실행이 실제로 필요한 셀이 **정확히 1개**(SmartCam cFS 등가 모드 —
D61 이후 코드로 밟은 적이 없다)로 좁혀져 **실행했고 E32와 판정·totals·최악 원소가 동일**했다.
**D**: 모델의 실제성 / 가중치 / **입력의 실제성** / 검증한 성질을 네 축으로 분리.
**결함 6건 중 3건이 이 세션의 새 도구 결함**: D63(연결표가 부모 객체 단위 resolve라 하위 키 결손을
present로 통과 — 적대적 검증이 잡음), D64(E36b 요약이 손조립이라 DENY 셀 `inferences` 부재),
D65(D60 정정이 산문에만 남고 원자료·소스엔 철회된 서술이 그대로), D66(원장 누수 수치 오기 6·4 → 5·5),
D67(계약 키 오독), **D68(파싱 실패를 `0`으로 기록 — *"absence is not zero"*라고 쓴 파일 자신이;
적대적 반박이 잡음)**. **교훈**: ***"정정이 산문에만 남았는지, 기계가 읽는 자리와 소스에도 닿았는지
확인하라"*** — 그리고 **증거를 검사하는 도구도 증거다**.
이 컨테이너 **508/508 → 544/544**. **CI 실측**(커밋 `6598cf4`, run 157, 3레그 success): `full` **538/538 + 1 SKIP**(PyYAML) ·
`without-iree` **398/398 + 26 SKIP** · `stdlib-only` **398/398 + 26 SKIP** — **그 커밋 시점의 컨테이너
값은 539/539**이고 `full`과의 차이 1건은 PyYAML 유무다(D34: 추정하지 않고 두 수치를 조건과 함께
병기). 축소 레그가 367→398로 **정확히 +31**이라 당시 신규 31건이 **전부 나타난다**(신규 SKIP 0):
보관 JSON 판독·소스 텍스트 검사·게스트 raw log 판독이라 툴체인 없이 실제로 돈다.
이후 §5b의 peak 가드 5건이 더해져 **컨테이너 544/544**가 됐고, 그 커밋의 CI는 아래에 따로 적는다.

**CI 실측**(커밋 `d1beb44`, run 161, 3레그 success): `full` **543/543 + 1 SKIP**(PyYAML) ·
`without-iree` **403/403 + 26 SKIP** · `stdlib-only` **403/403 + 26 SKIP** — 컨테이너 544/544와 `full`의
차이 1건은 PyYAML 유무다(D34). 축소 레그가 398→403으로 **정확히 +5**라 §5b의 peak 가드 5건이
**전부 나타난다**(신규 SKIP 0).

**v0.42에서 완료된 것 (E38, `docs/EVIDENCE_v0.42_E38.md`)**: 여덟 번째 외부 검토
(`docs/reviews/DECISIONS_v0_41_INTEGRATED_REVIEW.md` §4.1·§10-2)가 *"조건부 계층의 실행 결과가 opt-in이
실제로 적용된 상태에서 얻은 것인지 **판정 결과와 독립적으로** 확인하라"*고 지적했다 — 판정에서 설정을
역추정하고 그 판정을 다시 설정의 근거로 쓰면 순환이다. 검토가 정한 순서(기존 기록 조사 → 있으면 연결 →
없을 때만 두 셀 재실행)를 그대로 따랐다. **D69: 독립 기록은 없었다** — `build.log`에 문자열 `CONDITIONAL`
**0건**, 두 배포 트리의 `build_info.json` `app_knobs`가 **완전 동일**하고 그 키를 갖지 않으며, 보관
`ai_learner.CMakeLists.txt`는 `${AI_LEARNER_ALLOW_CONDITIONAL_MAP}` **미전개 변수**, 게스트 raw log에 해당
stage 없음. **E36 자신이 D61에서 세운 교훈의 목록에서 이 설정만 빠져 있었다.** 판정 수치는 바뀌지 않는
**기록 결함**이다. **소급 증거**: 보관 두 `.so`가 `AI_LEARNER_Init`에서 **정확히 12개 명령** 다르고
추가분이 `per_call − 1`(9,382,091 = 0x8F28CB)을 만들어 예산과 비교하는 그 분기다 — 빌드 시점 대조는
실재했다. 그러나 **어느 바이너리가 어느 셀을 돌렸는지**가 여전히 없어 재실행으로 갔다.
**세 기록 신설**: (1) 앱이 `build_config` stage를 **모든 게이트보다 먼저** 기록(거부 셀도 남긴다),
(2) 빌드 스크립트가 knob과 `compile_commands.json`에서 뽑은 **실제 `-D` 목록**을 기록,
(3) `harness/optin_witness.py`가 **산출물에서** 값을 읽어 요청값과 다르면 **빌드를 죽인다**.
witness는 **양성 대조**(무조건 `bounded` 비교)가 먼저 잡혀야 `false`를 말하고 그 외엔 `undetermined`다
(D25·D29 계열). **재실행은 두 셀만**: `cond_positive`(opt-in 1 → ADMIT_CONDITIONAL_MAP, 피크 **9,382,092**
= 승인 근거 예산, `arm: map`)·`cond_denied_without_optin`(opt-in 0 → NOT_ADMITTED, 추론 0, 이후 cFS가
앱 8개 계속 로드). 두 셀 모두 **89행**에서 설정을 기록하고 판정은 91·92행이며, 게스트에서 계산한 `.so`
sha256이 그 셀의 빌드 기록과 일치한다(**E36에 없던 로그↔바이너리 링크**). E36의 결정론적 값 전부 불변.
**native도 같은 계열**이었다 — 전제 미충족 시 opt-in을 조용히 되돌리므로 `conditional_map_requested`를
분리했고 **requested=true·applied=false·verdict=ADMIT**(이전엔 흔적 0)를 실측 보존했다.
**검토 §10-1 재확인**: 재판정 **13/13 동일**, 연결표 **21/21 present**(재생성 diff 0), 그리고 연결표가
`present`로 적은 **198개 셀 전부**를 생성기와 무관한 감사기로 원자료에서 다시 읽어 **불일치 0** —
그 감사기의 첫 판이 대괄호 locator를 못 읽어 8건을 오탐했고, 연결표가 아니라 **감사기의 결함**이었다.
**같은 결함이 형제 스크립트에도** 있었다 — D61(b)가 `51_build_cfs_aarch64.sh`에서만 고쳐졌고
`50_wire_cfs_ai_learner.sh`가 같은 `${VAR:+-D…}` 모양을 영속 `build-native_std` 트리에 쓰고 있었다(D62 계열).
같은 방식으로 고치고 **세 번 빌드해 실측**했다(`=1` 다음의 미설정 빌드가 산출물에서 **0을 증언**).
이 컨테이너 **544/544 → 570/570**(신규 26건), 보관 14개 계약 diff 0, revert-and-confirm-fail 4건.
**CI 실측**(커밋 `827e08d`, run 165, 3레그 success): `full` **565/565 + 3 SKIP** ·
`without-iree` **425/425 + 28 SKIP** · `stdlib-only` **425/425 + 28 SKIP**.
이 컨테이너(570/570 + 0 SKIP)와 `full`의 차이 **5건**은 전부 설명된다 — PyYAML 미설치 1건(D34),
`aarch64-linux-gnu-objdump` 미설치로 **정직하게 SKIP되는 2건**, 그리고 그 툴체인이 없으면 witness를
실제로 돌리는 분기가 아예 없어 **존재하지 않는 2건**이다(있을 때 4개 항목 · 없을 때 2개 SKIP).
축소 두 레그가 403→425로 **정확히 +22**라, E38 신규 26건 중 objdump를 요구하는 4건을 뺀 22건이
**전부 나타난다** — 보관 JSON 판독·소스 텍스트 검사·게스트 raw log 판독이라 툴체인 없이 실제로 돈다.
**교훈**: D61이 *"판정에 쓴 설정을 판정 자신이 기록하게 하라"*였다면 이것은 ***"기록해야 할 설정 목록에
그 설정이 실제로 들어 있는지, 그리고 그 기록이 판정과 독립인지 확인하라"***다.

**v0.43에서 완료된 것 (E40, `docs/EVIDENCE_v0.43_E40.md`)**: 아홉 번째 외부 로드맵
(`docs/reviews/ONAIR_MLIR_ADDITIONAL_RESEARCH_AND_BASELINE_PLAN.md`) §5가 요구한 **정적 상한의 분석 영역·
회계 규칙 공식화**. 사전 고정 기준은 `docs/plans/E40_E41_analysis_domain.md`(커밋 `9b7d5ba`, 구현 이전).
**처방 3건 중 둘이 새 결함을 심는다**는 것을 착수 전 조사에서 실측해 좁혀 채택했다 — (1) 구조적 walker를
**정본 값 출처**로 바꾸면 `dense_sum`이 사라져 D17 정렬 패딩 carve-out(원장에 **과잉 거부**로 기록된 결함)이
무력화되고 `--allow-missing-structural-checker`가 구현 불가능해진다(walker는 이미 필수이고 불일치 시 계약이
생성되지 않으므로 *이미* 권위다), (2) `analysis_domain` 8키 평면 나열은 4키가 **순수 rename**이라 D65를
재발시킨다. **D70(잠재 fail-open)**: `make_contract.py`의 전제 목록 첫 항목이 **리터럴** `"static shapes"`라,
`all_static=false`·`bound_method=NONE`·`unresolved_sizes=['%1','%6','%5']`인 `contract.dynamic.*`가
`bound_assumptions[0]`·`validity.assumptions[0]`에 그 문자열을 싣고 있었다 — 읽는 코드가 저장소에 한 곳도
없어 오늘까지는 산문 부정확이지만, 처방대로 기계 판독 필드로 승격하면 **거부하려고 만든 바로 그 계약에
기계 판독 가능한 거짓 단언**이 실린다. 리터럴을 `all_static`에서 **유도**로 바꾸고 보관 2개 계약의 4 leaf를
정정했다(수치 불변·헤더 바이트 불변). 신설한 `analysis_domain`은 **`derived`(도구가 계산한 사실)** 와
**`required_premises`(배포가 지켜야 할 조건 — `max_in_flight_calls:1`, `output_lifetime`)** 로 나눠 싣는다.
**`derived.constant_policy`가 map/copy 두 분기와 64바이트 정렬 전제를 처음으로 선언한다** — 착수 전 조사에서
계약 **19개 중 0개**가 그것을 언급하지 않음을 확인했고, 계약이 두 상한을 싣고 배포가 그중 하나를 고르게
하면서 **작은 쪽이 유효한 조건을 말하지 않고 있었다**(D53/D54의 계약 층 판본). `accounting_rules`는 이름과
코드의 어긋남을 적는다 — `O`는 external alloca **슬랩**(multiout 선언 48 B vs 실제 128 B), `C`는 **packed**
composite(vww pad 64·bigact pad 32), `T`의 "보수적 합"은 계약 전부가 slab ≤1이라 **공허**. 가드
`analysis_domain_drift()`는 불일치 시 계약을 **쓰지 않고**, 회귀 diff는 새 블록을 **SUBTREE**로 제외한다
(`IGNORE_PROVENANCE_KEYS`는 마지막 경로 성분 비교라 `driver`·`entry`를 넣었다면 `target.driver`·`model.entry`
드리프트까지 침묵시킨다). **Q1~Q4 전부 PASS**, revert 시 생성기가 **rc=1로 작성 자체를 거부**.
이 컨테이너 **570/570 → 598/598**(FAIL 0 · SKIP 0).
**다음은 E41**(분석 영역 음성 시험) — 계획서 §3이 다섯 조건의 형태를 측정 전에 고정해 뒀다.

**v0.44에서 완료된 것 (E41, `docs/EVIDENCE_v0.44_E41.md`)**: 로드맵 §5.3-4의 **다섯 조건 음성 시험**.
사전 고정 기준은 `docs/plans/E40_E41_analysis_domain.md` §3(측정 이전). **다섯 중 둘은 일부러 게이트로
만들지 않았고 그 이유를 기록한다** — 조건 3(동시 호출)은 이 저장소가 출하하는 **어느 배포도 만들 수 없고**
(두 C 실행기에 `pthread_create`/`CFE_ES_CreateChildTask`/`OS_TaskCreate` 0건, OnAIR은
`agent.py` 메인 루프 한 곳에서만 플러그인을 부른다), 시험하려고 비행 앱에 동시성을 심는 것이 곧 회귀다.
조건 4(출력 보유)는 문자 그대로 강제하면 D50 조건의 b2_resnet 피크 **309,576**이 그 셀 예산 **618,856**의
**50.0%**인데 거부된다(유형 B) — 실제로 무는 조건부 계층에서는 **D59가 이미 보고**한다.
**전제는 장식이 아니다**: `harness/e41_domain_probe.py`가 **셀마다 별도 프로세스**로(HAL 통계가 프로세스
전역이라 첫 판이 그 오염을 재현했다 — deepae N=1이 6,208 대신 1,237,664) N 스레드 동시 호출을 재서,
**N=1 피크가 세 모델 모두 `per_call`과 정확히 일치**하고 **SmartCam은 동시 호출 2개만으로 `bounded`를 넘는다**
(18,764,184 > 18,222,796)는 것을 실측했다. D50과 분리 확인(N=1에서 보유/해제 피크 동일), 빠른 모델은
비결정적이라 **N배는 상한이지 법칙이 아니다**. **신설 게이트는 조건 5뿐**: `gen_contract_header.py`가
`validity.driver` 기본값 `"local-sync"`를 **단언**하던 fail-open을 닫고(`target.driver`도 읽고 둘 다 없으면
거부), OnAIR 플러그인이 배포 설정의 driver를 계약 선언과 대조한다
(`artifact_binding.check_declared_driver`, stdlib 전용 순수 함수). legacy fixture(`validity: null`)가
거부되지 않도록 `analysis_domain.derived` → `validity` → `target` 순으로 읽는다(D31 유형 회피).
공식 OnAIR 경로에서 **admission·binding보다 먼저** 발화한다(`smartcam_wrong_driver`: active=false·추론 0·둘 다 null).
**선언 검사이지 "다른 driver가 위험하다"가 아니다** — N=1 HAL 피크는 `local-sync`/`local-task`에서 바이트 동일이었다.
**D71(재현성)**: E33의 `p_legacy` 셀은 ini 템플릿이 telemetry 파일을 하드코딩해 **저장소 내용만으로
재생성할 수 없었다**(9필드가 필요한데 2필드가 들어가 정당하게 거부됐다). **대조 실행**으로 E41 변경과
무관함을 먼저 확정한 뒤, 배포마다 `telemetry`를 선언하게 하고 **선언이 없으면 추측하지 않고 거부**하도록
고쳤다 — 고친 뒤 E33 값(`active=true`·추론 4회·`NOT_EVALUATED`)과 일치한다.
**R1·R3·R4·R5·R6 PASS**, 보관 14개 헤더 바이트 불변, OnAIR 4셀 전부 E33 값과 동일(과잉 거부 0).
이 컨테이너 **598/598 → 617/617**.

**v0.44.1에서 정정된 것 (D72, `docs/EVIDENCE_v0.38_E35.md` §8)**: 로드맵 검증 워크플로우의 **적대적 반박**이
`harness/e35_baseline_policy_matrix.py`를 끝까지 읽고, E35의 **"24/24 판정 동일"이 독립 측정이 아님**을
지적했다 — 이 세션이 실행으로 재현했다. `:142`의 `continue`가 **세 수치가 다른 모델의 셀을 하나도 만들지
않고**, 통과한 모델에서는 두 수준에 **같은 세 수치**와 계약에서 한 번 읽은 **같은 `bound_method`**를 넣으므로
두 `ap.decide` 호출이 같은 입력이다 → `verdicts_disagreeing: 0`은 **구조적으로 보장된 값**이다. 계획서 §4-2는
측정 전에 *"다른 셀이 하나라도 있으면 그 셀이 이 실험의 핵심이다"*라고 적었는데 구현은 그 셀을 **원리적으로
만들 수 없다**. **판정은 불변이고 근거의 무게가 옮겨간다** — 실제 측정은 `three_figures_agree` **4/4**와
`kernel_stack_agrees` **4/4**이고 24셀 판정 동일은 그 **따름정리**다. **교훈**: E35 자신이 세운
*"차이가 나오면 먼저 자기 도구를 의심하라"*를 ***차이가 나오지 않았을 때도*** 적용해야 했다.

**v0.45에서 완료된 것 (E45, `docs/EVIDENCE_v0.45_E45.md`)**: **세 모델의 합성 입력을 실데이터로 바꿨다.**
사전 고정 기준은 `docs/plans/E45_real_inputs.md`(커밋 `c27b8b2`, 측정 이전). **E26a가 "조달 불가"라고
적은 것은 그때의 참이었고 지금도 참이다** — `cs.toronto.edu` 000, `zenodo.org` 000. 바뀐 것은 **다른
통로가 있다**는 것이고(`git clone`·`raw.githubusercontent.com`), 세 모델의 실입력이 전부 그 뒤에 있었다.
**정본성은 미러끼리의 합치로 세우지 않았다**: 받은 `test_batch`의 md5 `40351d58…`가 **torchvision이
차단된 정본 tarball에서 풀어 기록해 둔 파일 단위 값**과 같다(무관한 제3자를 통한 상류 대조). 부분집합은
MLPerf Tiny **자신의** `perf_samples_idxs.npy`(seed 8108, 클래스당 20)이고 벤치마크의 자기 라벨 파일과
**파일명 200/200 · (파일명,라벨) 200/200** 일치.
**판정**: b2 ResNet **PASS**(실 CIFAR 200장, 2,000원소 실패 0, argmax 200/200) · SmartCam **PASS**
(pristine 썸네일 19장, 57원소 실패 0) · **b3 DeepAE FAIL**(실 log-mel 34창, 21,760원소 중 **94 실패**).
**D74 — 기준을 고치지 않았다**: 계획서 §4가 측정 전에 *"FAIL이 나오면 기준이 아니라 FAIL을 보고한다"*고
정해 뒀고, 착수 전 조사가 b3를 **뒤집힐 수 있는 유일한 셀**로 지목했다. 도구 결함이 아님을 네 축으로
확인했다(두 경로가 **한 파일**을 읽음·전처리 항등·IREE 3회/LiteRT 3회 **비트 동일**·보관 셀 재판정 동일).
실제 원인의 큰 부분은 **값 규모**다 — 합성은 `uniform[0,1)`인데 실제 log-mel은 dB라 `|출력|` 중앙값이
**28.2**이고, OR 규칙의 유효 문턱이 `max(1e-4, 1e-5·|v|)`이라 규모가 커지면 `abs` 다리가 먼저 걸린다.
사후 특성화(판정 아님): 창을 5개로 넓힌 170샘플에서 **10샘플(5.9%) · 1,754/108,800 원소(1.6%)** —
계통적이되 소수이고 중앙값은 `abs_tol`의 38%다.
**Q3가 이 실험의 핵심 관측**: 같은 레이아웃 결함(전치 대신 reshape)에서 **argmax 탐지율이 합성 0/34(0%)
vs 실입력 180/200(90%)·18/19(95%)**. E31이 3/37에서 본 것(그 3이 정확히 실이미지)의 반대편을 채운다 —
E34의 합성 전용 fixture에서는 argmax가 **한 샘플도** 못 잡았다.
**부수(D43 갭 하나가 닫혔다)**: **E31·E34의 음성 대조 fixture가 저장소 내용만으로 재생성되지 않고
있었다**(결함 주입을 손으로 했고 절차가 코드에 없었다 — E23이 A5b에 대해 고친 것과 같은 유형).
`model_fixture.py --layout-defect reshape`을 신설(기본 off, 매니페스트가 최상위·샘플마다 표시)하고
**E31 보관 음성 대조를 재생성해 판정·105/111·argmax 3·worst_abs 0.84248263까지 동일**함을 확인했다.
**반입 규약은 모델마다 다르다**: ResNet은 **in-tree 벤더링**(614,856 B, 라이선스 **미상**으로 명시,
미러를 공식 채널이라 쓰지 않음) · DeepAE는 **바이트 미반입**(EEMBC가 재배포를 문서로 거부 —
`4285411` "Deleted license" → `00bc683` "copyright of their respective creators" → `c38c333` 4,450파일
purge가 **3분 안에** 일어났고 매니페스트가 이 타임라인을 git에서 읽어 싣는다. 해시 매니페스트 248건 +
획득 스크립트만 커밋하고 네트워크 없으면 **사유를 적은 SKIP**) · SmartCam은 **pristine 19장만**
(GIMP 편집 26장을 EXIF로 배제, denoiser의 noised/denoised 파생본 제외, **등급 분리** — tier A 무손실
2048×1944 PNG 3장과 tier B 614×583 JPEG 19장을 *"실이미지 22장"*으로 합치지 않는다).
**G2(정확도)는 세 모델 전부 범위 밖이고 사유가 다르다** — ResNet은 **안 한다**(데이터는 충분하다,
논문 축이 아니라는 범위 결정), DeepAE는 **못 한다**(248파일이 평가셋이 아니라 성능측정 부분집합이고
재배포도 거부됨), SmartCam은 **못 한다**(CSV `label`이 온보드 모델 **자신의 argmax**이고 86/86에서
확인 — 라벨이 순환이며, `confidence_threshold=0.70` 미달분은 궤도에서 삭제돼 종속변수 기준 선택이다).
**새 모델 하네스 0개 · 모델별 분기 0줄 · 재컴파일 0회**(E34가 세운 규약대로 차이는 전부 **값**이다).
이 컨테이너 **623/623 → 650/650**(신규 27건, FAIL 0 · SKIP 0), revert 시 결함 주입 시험이 실제로 실패.
**CI 실측**(커밋 `3bc7efe`, run 180, 3레그 success): `full` **645/645 + 3 SKIP** ·
`without-iree` **488/488 + 29 SKIP** · `stdlib-only` **488/488 + 29 SKIP**.
이 컨테이너(**650/650 + 0 SKIP**)와 `full`의 차이 **5건**은 전부 설명된다 — PyYAML 미설치 1건(D34) ·
`aarch64-linux-gnu-objdump` 미설치로 **정직하게 SKIP되는 2건** · 그 툴체인이 없으면 분기가 아예 없어
**존재하지 않는 2건**(E38이 확립한 설명 그대로). 축소 두 레그가 464→488로 **정확히 +24**이고 SKIP이
28→29로 +1이라, E45 신규 27건 중 **numpy를 요구하는 결함 주입기 재생성 3건이 1개의 정직한 SKIP으로
접히고 나머지 24건이 전부 나타난다**.
**교훈**: ***측정한 것이 무엇인지와 그 측정에서 결론한 것이 무엇인지가 같은지 확인하라*** —
*"이 호스트가 막혔다"*는 관측이고 *"이 데이터를 조달할 수 없다"*는 결론이며, 그 사이에
**"다른 경로를 재 봤는가"**가 빠진 채 여섯 버전을 지났다.


**v0.46에서 완료된 것 (E46, `docs/EVIDENCE_v0.46_E46.md`)**: **네 번째 실물 공개 모델 — OPS-SAT WGAN
denoiser 반입.** 사전 고정 기준은 `docs/plans/E46_wgan_import.md`(커밋 `e37a2fe`, 측정 이전).
두 문서가 미루고 제외했던 모델인데 **이연 사유가 측정으로 거짓**이었고(*"대형 출력 문제를 연다"* —
`_p` 출력 37,632 B는 cFS 앱이 이미 `static`으로 처리하는 602,112 B의 **16분의 1**), **제외 조건**
(*"새 모델이 시험할 구체적인 분석 한계가 먼저 있어야 한다"*)은 **D75가 충족시켰다**.
**검토서가 이름 댄 `_p` 대신 `_f`를 채택**했고 사유 둘 다 측정이다 — 공개 실입력 `testset/noised`가
**224×224**라 `_f` 입력과 정확히 같아 **resize가 비트 단위 항등**이고(E31은 교란을 *소거*했고 여기서는
*발생하지 않는다*), `_f`라야 D75를 밟는다.
**Q1~Q5 전부 PASS**. HAL 피크가 `per_call`과 **정확히 같고**(map 분기) `allocated == freed`다.
**그런데 이 모델에서는 조건부 계층이 3.3%밖에 못 준다** — `bounded/per_call`이 DeepAE **172.30×** ·
SmartCam 1.94× · ResNet 2.00×인데 WGAN은 **1.03×**다. 반증이 아니라 **가치의 정량적 경계**이고,
조건부 계층의 이득은 **상수 비중의 함수**다. 계약 `bounded` **135,666,432** = `per_call` **131,382,784** + `constants`
**4,283,648**, 오버라이드 0, 한 번의 `iree-compile`, `constants confirmed`, 구조적 추출기 일치.
**저장소 사상 최대이고 구조가 정반대다** — 호출:상수 **30.7**로 DeepAE의 **0.006**과 양극단이고,
**같은 계약 형식이 둘 다 담는다**. 의미 동치는 실 noised 9장 + 경계 2 = **1,655,808원소 실패 0**
(argmax 해당 없음). **OR 규칙이 네 번째 연속 판정을 좌우했다** — 최악 `rel` 6.936e-04가 `rel_tol`의
**69배**이고 `abs` 다리만이 통과시켰다(headroom 0.99).
**변환기 확장이 실제 위험을 막았다**: `LEAKY_RELU`·`TANH` 등록에서 E30의 C1~C5는 **복사하지 않았다**
(축을 제거하지 않는 원소별 op라 그 위험이 없다 — 없는 위험에 검사를 붙이는 것은 의례다). 대신
**ONNX `LeakyRelu`의 `alpha` 기본값 0.01**을 막았다 — 이 모델의 실제 alpha는 **0.2**이고, 읽지 않고
넘겼으면 11개 활성화가 음수 쪽에서 **조용히 20배 틀린** 그래프가 컴파일·실행·무경고로 나왔을 것이다
(D25·D28·D29·D30·D68의 여섯 번째 얼굴). 옵션 테이블을 못 읽으면 **거부한다**.
**저장소 최초 — 출력이 레이아웃을 갖는다**: IREE 경로가 `[1,3,224,224]` NCHW를 내는데 원본 TFLite는
NHWC다. 기존 셋은 출력이 클래스 점수(3·10)나 rank-2(640)라 *"출력을 펴서 비교"*가 **우연히** 맞았다.
`iree_runner.py`에 `--output-layout`을 **값으로** 신설(기본 `none`, b2_resnet 출력 비트 불변).
**D62의 세 번째 얼굴**(D62 출력 arity → E45 입력 종류 → 여기 출력 레이아웃).
**D75 — D52의 수정이 한 버퍼를 빠뜨렸다**: `ai_learner.c:557`의 `float yv[CONTRACT_OUTPUT_ELEMS]`가
자동 변수인데 형제 셋(`:635`·`:652`·`:683`)은 D52에서 전부 `static`이 됐고 표시까지 달려 있다.
스택 게이트는 이 버퍼를 **어느 항에도 계상하지 않는다**. **기존 세 모델은 출력이 3·10·640 원소라
원리적으로 못 밟는다.** **양방향 실측**(같은 선언·같은 사용처를 실제 컴파일): 수정 전 정적 프레임
**602,136 B** · 런타임 스택 변위 **602,151 B**로 게이트 허용 262,655 B의 **2.29배 초과**, 수정 후
프레임 **8 B**이고 버퍼는 `.bss`. `static`이 성립하는 근거가 계약이 선언한 `max_in_flight_calls: 1`(E40)
임을 코드 주석에 명시했다. **주장하지 않음**: cFS 재빌드 후 게스트 SIGSEGV 관측(v0.9.1 A5b 교훈 —
관측한 것은 프레임·변위다).
**부수(유형 B)**: `e32_native_aarch64.py`가 합성 샘플 유무와 무관하게 seed를 요구해 **E45가 만든 모든
실입력 fixture를 거부**했고 같은 함수를 **하네스 셋**이 import한다. 조건을 좁히고 sha256 검사는 그대로
뒀다(네 방향 실측: E46 로드 · E31 불변 37샘플 · 합성인데 seed 없으면 여전히 거부).
**교훈**: D52가 *"계약이 준 숫자를 게이트가 실제로 쓰는지 확인하라"*였다면 이것은
***"같은 결함의 모든 사례를 고쳤는지는, 그 결함을 밟을 수 있는 모델을 실제로 넣어 봐야 안다"***다.
`yv`를 찾은 것은 코드 검토가 아니라 **출력이 큰 모델을 반입하려는 시도**였다.
**CI 실측**(커밋 `f4d35e3`, run 188, 3레그 success): `full` **671/671 + 3 SKIP** · `without-iree` **510/510 + 31 SKIP** · `stdlib-only` **510/510 + 31 SKIP**. 이 컨테이너(**676/676 + 0 SKIP**)와 `full`의 차이 5건은 E38이 확립한 설명 그대로다(PyYAML 1 · objdump 미설치 SKIP 2 · 그 툴체인이 없으면 분기가 아예 없어 존재하지 않는 2). 축소 레그가 488→510으로 **정확히 +22**라 E46 신규 22건이 전부 나타나는데, **SKIP이 29→31로 +2 늘었다 — 그 둘이 무엇인지는 로그의 사유 목록이 집계 문자열이라 이 기록만으로 특정되지 않는다. 추정하지 않고 수치와 함께 미상으로 남긴다**(D34).


**v0.47에서 완료된 것 (E42/E43, `docs/EVIDENCE_v0.47_E42_E43.md`)**: **순수 OnAIR 기준선 O0~O3.**
사전 고정 기준은 `docs/plans/E42_E43_pure_onair_baseline.md`(커밋 `766ae2a`, 측정 이전).
로드맵 §7을 **좁혀** 채택했다 — §7.4-3의 *"37개 fixture 재사용"*이 **틀렸고**(`smartcam_replay.csv`는
**5행**, `p_admit` 추론 **5회**), **O2·O3는 E33에 이미 측정돼 있어 인용**했다(재측정해 *"새 셀 4개"*라
적으면 **D72가 고친 중복 증거 부풀리기**). **측정 2셀 · 인용 2셀**이고 요약 생성기가 그 구분을 표에 싣는다.

| | 경로 | 종류 | admission | **런타임 생성** | 추론 |
|---|---|---|---|---|---|
| O0 | OnAIR + LiteRT (순수) | 측정 | `null` — 단계 없음 | ✔ | 5 |
| O1 | OnAIR + IREE, 판정 비활성 | 측정 | `NOT_EVALUATED` | ✔ | 5 |
| O2 | + 계약, 예산 `B` | 인용 | `ADMIT` | ✔ | 5 |
| O3 | + 계약, 예산 `B−1` | 인용 | `NOT_ADMITTED` | **✘** | **0** |

**O3만 런타임을 만들지 않고 추론이 0이다** — 그것이 제안 경로가 더하는 것이고, 나머지 셋이 전부 정상
실행된다는 사실이 그 차이를 차이로 만든다. **로드맵 §7.1의 금지를 채택했다** — *"OnAIR가 계약을
위반했다"*·*"OnAIR가 메모리를 관리하지 못한다"*고 쓰지 않는다. O0의 `admission: null`은
*"이 경로에 그 단계가 없다"*이지 *"통과"*도 *"결함"*도 아니며, 플러그인 init 레코드가
`has_contract: false`·`has_admission_gate: false`·`absences_are_by_construction`을 **기계가 읽는
자리에** 싣는다. **O0 출력은 E31 TFLite oracle과 비트 동일**(5샘플 15원소, 최악 `abs` 0.000e+00) —
원본을 직접 돌리므로 같은 구현이고 0이 아니었다면 전처리·입력 경로 결함이다. **O1은 코드 0줄**.
**인용 셀의 한계를 함께 싣는다**(D65 회피): O2는 `nanobind: leaked 10 instances`를 남기고 **D60이
그 때문에 "해제" 주장을 철회**했다(해제 미검증, 누수라고도 못 쓴다), O3는 **런타임 생성 여부를 적은
필드가 없어** *"런타임 생성 전 거부"*가 문서화된 순서에 근거한다.
**메모리를 아예 재지 않았다** — 로드맵 §7.5가 회계 범위 차이로 비교를 금지했고, 재고 나서
*"비교하지 말라"*고 적는 것은 독자를 견디지 못한다.
**D76(계획서 §2 위반, 사유 기록)**: `onair_integration_check.py:84`가 상대경로를
`("artifact_dir","fixture_dir")` 두 키에 대해서만 다시 뿌리내려 `model_file`을 쓰는 LiteRT 배포에서
경로가 **`results/results/...`로 이중화**됐다. **D62의 세 번째 얼굴**(출력 arity → 입력 종류 →
출력 레이아웃 → 배포 키). 키를 추가만 하지 않고 **뿌리내릴 줄 모르는 키의 `..` 상대경로를 명시적으로
거부**하게 했다. 집합은 명시적으로 유지 — `contract_file`은 `artifact_dir`에 붙이는 맨 파일명이라
*"`_file`로 끝나면 전부"*로 일반화하면 그 `join`이 잘못된 경로를 준다(**과도한 일반화 자체가 결함**).
판정 영향 없음(수정 전에도 플러그인은 거부를 상태로 보고했고 프로세스는 rc 0).
이 컨테이너 **676/676 → 690/690**.
**미실행(명시)**: AArch64·cFS에서의 O0~O3 · 다른 모델의 순수 OnAIR 셀 · OnAIR 조건부 계층
(`allow_conditional_map`은 10곳 전부 false이고, 플러그인에 두 C 실행기가 가진 map-분기 전제 검사가
**없으므로** 플래그만 켜면 D53/D54를 Python 경로에서 재현한다 — **켜지 않았다**).
**CI 실측**(커밋 `c6c0713`, run 192, 3레그 success): `full` **685/685 + 3 SKIP** · `without-iree` **523/523 + 32 SKIP** · `stdlib-only` **523/523 + 32 SKIP**. 이 컨테이너(**690/690 + 0 SKIP**)와 `full`의 차이 5건은 E38의 설명 그대로다. 축소 레그가 510→523으로 **+13**이고 SKIP이 31→32로 **+1**이라, E42/E43 신규 14건이 **13 PASS + 1 SKIP**으로 전부 나타난다.


**v0.48에서 완료된 것 (E44, `docs/EVIDENCE_v0.48_E44.md`)**: **예산 출처(budget provenance)** — 로드맵
§6.2. 사전 고정 기준은 `docs/plans/E44_budget_provenance.md`(커밋 `2aa93cf`, 측정 이전).
요구된 **세 필드 중 실제로 부족한 것은 하나**였고, 그 하나도 계약 필드로 신설하지 않았다.
`budget_source`는 **이미 있었고**(`ai_learner.c` 8회 · 요약 생성기 4개 · 시험 **5곳이 pin**),
`budget_scope`는 **이미 세 곳**(`resources.scope` · `accounting_rules.excluded`(E40) · admission
`per_app_local_budget`)에 있어 **네 번째 이름은 D65의 형태**라 만들지 않았다. 남은 `reservation_semantics`는
개념이 E39a의 사전 등록 축 **A5**로 이미 있었으므로 **반대로 갔다 — A5를 저장소에서 유도**한다.
**Q1**: 네 행이 전부 자기 예산의 출처를 말한다 — OnAIR `deployment_config`/`none`(실행) ·
native `argv`(재빌드 후 실행) · cFS `override`(E38 보관 로그 인용). **`none`은 `null`이 아니다** —
*"선언 자체가 없다"*를 말하는 값이고 `budget_source_note`가 그 문장을 함께 싣는다(부재를 값으로 적되
**어떤 부재인지** 적는다). **Q2·Q3**: `harness/budget_provenance.py`가 예약 능력이 있는 호출 8종
(`mlock`·`mlockall`·`MAP_POPULATE`·`MAP_LOCKED`·`CFE_ES_PoolCreate`·`CFE_ES_GetPoolBuf`·
`CFE_ES_RegisterCDS`·`OS_MemPoolCreate`)을 소스 **85파일**에서 세어 **0건 → `declared`**이고, 표에는
값과 근거가 함께 실린다. **hit가 있으면 `enforced`로 올리지 않고 `unknown`**이다 — 호출이 **있다**는 것과
그 호출이 **이** 예산을 예약한다는 것은 다르고, 그 구분은 **E28/D52가 게이트에 대해 배운 것**과 같다
(게이트가 도는 것 ≠ 게이트가 계약의 수를 쓰는 것). 스캐너가 **소스만** 읽는 이유가 이 실험 중 실제로
나왔다: 감사가 *"`CFE_TBL` 0회"*라 보고했는데 직접 grep하니 **15건**이었고 **전부 cFS 부팅 로그**였다 —
로그를 세는 스캐너였다면 이 앱이 쓰지 않는 테이블 서비스를 보고했을 것이다. **Q4**: 값 개명 **0건**,
시험 pin 5곳 무수정 통과, 비교표 diff **1 insertion / 1 deletion**(이 연구 행의 A5 칸만). **Q5**: 과잉 거부 0 —
`budget_source`는 보고 필드이지 게이트가 아니다. **방법론 — 같은 생성기가 두 번 틀렸다**: 첫 glob이 한 단계 깊어
cFS 행에 *"기록 없음"*을 냈는데 그 줄은 `results/e38_optin_record/cells/cond_positive.log`에 **있었다**
(**D51** — *"볼 수 없었다"*를 *"보았더니 없더라"*로 기록). 넓힌 glob은 이번엔 **정렬 순서상 먼저인**
파일을 집었고 그것이 **D61(b)를 재현하려고 보관하는 결함 로그**였다 — 주장은 참이었지만 한 행 안에서
`detail`과 `cell`이 **서로 다른 말을 했다**(**D65의 기계 판독끼리 판본**). 인용을 의도적으로 바꾸고
(E38 셀 우선, 폴백이면 `cited_from: fallback_scan`으로 적는다) 보관 로그 **21개**라는 수도 함께 싣는다.
native 재빌드가 덮은 추적 `native/contract_gen.h`는 되돌렸다. 신규 가드 4건 전부 revert 시 실패.
이 컨테이너 **690/690 → 710/710**, 계약 스키마 변경 0.
**교훈**: ***요구된 필드가 이미 있는지 먼저 세어 보라 — 없는 줄 알고 더하면, 같은 사실이 서로를
대조하지 않는 두 자리에 살게 된다.***
**하지 않음(명시)**: `budget_scope` 신설 · 계약 스키마 변경 · 로드맵 enum 채택 · cFS 셀 재실행(인용) ·
AArch64에서의 native/OnAIR 예산 출처(x86-64에서만 실행).
**CI 실측**(커밋 `35bc851`, run 194, 3레그 success): `full` **705/705 + 3 SKIP** · `without-iree` **543/543 + 32 SKIP** · `stdlib-only` **543/543 + 32 SKIP**. 이 컨테이너(**710/710 + 0 SKIP**)와 `full`의 차이 5건은 E38의 설명 그대로다. 축소 레그가 523→543으로 **정확히 +20**이고 신규 SKIP 0이라 E44 신규 20건이 **전부 나타난다** — 소스 텍스트 검사·보관 JSON 판독·`verdict()` 순수 단위 시험이라 툴체인 없이 실제로 돈다.

**v0.49에서 완료된 것 (E47, `docs/EVIDENCE_v0.49_E47.md`)**: **외부 검토 2건을 건별로 검증했고,
그 검증이 검토 둘 다 못 찾은 저장소 결함 3건을 찾았다.** 두 검토
(`docs/reviews/RESEARCH_STATUS_REVIEW_v048.md` 기준 `35bc851` ·
`docs/reviews/ONAIR_MLIR_RESEARCH_AND_EXPERIMENT_REVIEW_v048.md` 기준 `2f73085`)는 **독립적으로
같은 네 곳**을 우선순위로 지목했다 — 실입력 AArch64 종단 · DeepAE 수치 발산 · 상한 논증 ·
선행연구 원문. **검증 98건**(CONFIRMED 76 · PARTIAL 17 · REFUTED 4 · UNVERIFIABLE 1), **적대적
재검 93건 중 3건 뒤집힘**(전부 *검증자가 세지 않고 적은 보조 수치*, 판정 방향은 유지 — 양방향
규율이 검증자에게도 걸렸다). **REFUTED 4건은 전부 같은 성격** — 검토가 정정하려는 주장을 저장소가
애초에 하지 않는다(*"어떤 메모리도 할당하기 전에"* 0건 · LiteRT 플러그인 NASA 귀속 0건 ·
O0/O2 메모리 비교는 아예 재지 않음 · hot-swap은 `not_claimed`에 기계 판독으로 존재).
**D77**: E44가 규칙을 *실증*하려고 넣은 fixture 줄(`mlock(p, n);`)이 소스라서 그 규칙을 검사하는
스캐너가 다시 집었다 — 라이브 `unknown` vs 커밋 산출물·비교표 `declared`가 **어긋난 채 아무 가드도
보지 않았다**. E44는 유도값은 출하하고 *그 유도가 재현되는지 보는 가드*는 출하하지 않았다. **줄 단위**
waiver로 고치고(파일 단위 제외는 나중에 들어올 진짜 호출을 숨긴다) 건너뛴 줄을 산출물에 원문 그대로
싣는다. 없던 가드 4건 신설. **D78**: 조건부 계층의 예산 감소는 **HAL 회계 범위의 진술**이다 — map
분기가 없애는 것은 상수의 HAL 디바이스 할당이고, 상수 바이트는 모듈 이미지 안에서 **세션 내내
상주**한다(두 C 실행기가 vmfb 전체를 읽어 zero-copy로 넘긴다). **근거는 처음부터 우리 원자료
안에 있었다** — `cond_positive.log`의 `mem_init`이 `hal_peak 602112`인데 `process_rss_kb 17160`
(= 17,571,840 B)은 승인 예산 9,382,092 B의 **1.873배**이고 그 시점 추론은 **0회**다.
`accounting_rules.excluded_module_image`·`constant_policy.map_arm_scope_note` 신설, 가드는 산문이
아니라 **raw log를 읽는다**. **E36·E38·E29의 판정은 불변**이고 바뀌는 것은 주장의 범위다.
**D79**: 선택 인덱스 교차검사가 *"순열을 잡는 검사"*라 적어 놓고 다중집합 비교였다 — **좁히기 전에
실물을 먼저 재서**(보관 선택이 `y_labels.csv`와 원소별 200/200 일치) 과잉 거부가 아님을 확인하고 고쳤다.
**E39a 집계 오기**도 고쳤다(`불명` 10개는 8축 합계, 실제 A2는 5).
**검토 처방을 문자 그대로 채택한 것은 0건** — 넷 전부 좁히거나 이연했다.
**부수 발견**: E39a의 *"전 외부 호스트 `EGRESS_BLOCKED`"*는 **두 호스트 시험에서 내린 과잉 일반화**다
— `raw.githubusercontent.com`은 열려 있고 TVM USMP RFC 원문에 도달한다(**E45 교훈의 재발**). 원문
대조가 실제로 가능한 것은 셋(TVM USMP·ExecuTorch·TFLM), 다섯은 여전히 불가능. **등급은 올리지
않았다** — E39b로 분리한다(부분 청크·GitHub 문서를 `fulltext`로 승격하는 것이 A9 등급의 fail-open).
이 컨테이너 **710/710 → 721/721**, 보관 14개 계약 diff 0.
**교훈**: ***유도값을 출하할 때는 그 유도를 다시 돌려 보는 가드도 함께 출하하라 — 유도의 입력에는
그 유도를 시험하는 코드도 포함된다.*** 그리고 ***우리가 이미 기록한 수치가 우리 주장의 범위를 좁히고
있는지 다시 읽어라.***
**하지 않음(명시)**: 보관 계약 소급 수정(축소 dump에서 재생성하면 수치는 동일하나 provenance 두
필드가 **퇴화함을 실측**) · E39a 등급 상향 · R1(실입력 AArch64 종단)·R2(DeepAE 원인)·R4(OnAIR 출력
수명) — 다음 작업이다.

**v0.51에서 완료된 것 (E49, `docs/EVIDENCE_v0.51_E49.md`)**: **연구 전반 학술적 타당성 전수 감사** —
연구 책임자 지시와 `docs/reviews/MEMORY_CONTRACT_CORE_VALIDATION_GUIDE.md`(원문 보존)를 근거로
일곱 축을 전수로 훑었다. 사전 고정 기준은 `docs/plans/E49_research_audit.md`(커밋 `4a13593`, **감사 이전**).
**결함 3건**을 찾아 고쳤고 지침이 요구한 세 표를 만들었다.
**축 A(상한 건전성)**: `harness/e49_alloc_ledger.py` 신설 — 네 실물 모델 전부 **ledger = 계약**
(I·O·T·C 4/4, `I+O+T == per_call`), 미분류 op 0. **D84**: `static_mem_bound.py`의 정규식이
`stream.(resource|tensor).*` **두 계열만** 본다 — 다른 계열은 화이트리스트 밖이 아니라 **스캔 대상
자체가 아니어서** 미인식 op을 `unresolved`로 올리는 D13 규칙이 적용되지 않는다. 안전 조건
(post-layout entry에 할당하는 `stream.async.*`가 남지 않음)은 보관 IR 25개에서 **파일 1,020회 vs
마지막 entry print 0회**로 측정되지만 **검사하는 곳이 없었다**. 파서는 건드리지 않고(계약 30개가 pin)
ledger가 독립적으로 훑어 대조하며 async가 있으면 거부한다(양성 대조로 실제 검출 확인, 정직한 모양은
거부 안 됨도 확인). 상수는 두 분기가 같은 바이트를 두 번 보고하므로 **합이 아니라 최댓값**임을 시험이 고정한다.
**축 B(실행 전제)**: 전제 6개의 상태를 기계 판독으로 — OBSERVED 4 · **ARGUED_FROM_SOURCE 1**
(`max_in_flight_calls`: 배포 세 소스의 작업·스레드 생성 호출 **0/0/0**을 셌지만 invoke 진입·종료의
call id 기록이 없다 — **소스에서 세는 것은 논증이지 관측이 아니다**, `observed_value: null`) ·
**NOT_VERIFIED 1**(OnAIR 출력 수명, D60).
**축 C(회계 일치)**: `U`·`B`·`H`의 범위·시점·제외를 표로 고정. **계약 30개 중 1개만 E40의
`analysis_domain`을 싣는다**(유도값) — **배포에 쓰인 세 실물 모델의 계약에는 없다**. 게이트를
약화시키지는 않지만(driver 검사는 fail-closed) *"계약이 두 분기와 정렬 전제를 선언한다"*의 범위가
**E40 이후 생성분**임을 못박는다. 소급 재생성은 E47이 실측으로 거부했다.
**축 D(admission)**: **ADM-1~8 8/8** 일치 — **실제 정책 함수로 평가**하므로 정책이 바뀌면 표가 바뀐다.
**축 F(데이터셋·모델 선정)**: **D82** — `input_reality` 등급이 하드코딩이라 **E45·E48의 실입력 반입을
따라가지 못했다**(ResNet·DeepAE가 *"실데이터 0"*). 세도록 바꿨다.
**축 G(MLIR 주장)**: 금지 문장 **위반 0건** — 전부 그것을 금지하는 자리에서만 인용된다.
**D83**: D34 규율(CI 실측)이 **v0.43·v0.44·v0.44.1·v0.45.1**에서 빠졌고 v0.49도 같았다 — 그것이
D81을 세 커밋 동안 가렸다. 뒤늦게 채웠고(전부 정합), `fb904ff`는 독립 run이 없음을 **run 203개
전수 조회**로 확인해 추정하지 않고 적었다. 가드 조건은 **논증이 아니라 측정으로** 좁혔다.
**감사가 자기 수정 안에서 가드레일 위반 1건을 즉시 잡았다** — 낡은 등급을 고치던 첫 유도가
tier A 3장과 tier B 19장을 합쳐 *"실이미지 22장"*을 냈다. **한쪽을 고치며 다른 쪽을 심지 말 것**이
이 수정 자신에게도 걸렸다.
이 컨테이너 **750/750 → 768/768**(FAIL 0 · SKIP 0).
**CI 실측**(커밋 `1ff9a01`, run 208, 3레그 success): `full` **763/763 + 3 SKIP** · `without-iree` **600/600 + 33 SKIP** · `stdlib-only` **600/600 + 33 SKIP** — 컨테이너 768/768과 `full`의 차이 5건은 E38이 확립한 설명 그대로다(PyYAML 1 · objdump 미설치 SKIP 2 · 그 툴체인이 없으면 분기가 아예 없어 존재하지 않는 2). 축소 두 레그가 582→600으로 **정확히 +18**이고 신규 SKIP 0이라 E49 신규 18건이 **전부 나타난다**. 감사 1차 커밋 `d16ad73`(run 206, 3레그 success)도 함께 적는다 — `full` **745/745 + 3 SKIP** · 축소 두 레그 **582/582 + 33 SKIP**, 컨테이너 750/750(축소 레그 580→582로 +2, D82·D83 신규 2건이 전부 나타난다).
**교훈**: ***규율을 한 번 건너뛰면 그 규율이 잡았을 것도 함께 건너뛴다*** · ***도구가 생산 코드보다
넓게 보면 그 차이가 곧 생산 코드의 범위다*** · ***등급은 쓰는 것이 아니라 세는 것이다***.

**v0.51.1에서 정정된 것 (D85)**: v0.51이 신설한 CI 실측 가드(D83)가 `"CI 실측"`이라는 **문자열의
존재**만 보아서, **그 가드를 출하한 커밋 자신**(`1ff9a01`)이 **CI 수치를 한 줄도 적지 않은 채 통과**했다
— 통과시킨 것은 D83 정정 산문의 *"D34 규율(CI 실측 기록)이 … 빠졌다"*이고, 그 섹션의 유일한 `NNN/NNN`은
컨테이너 회귀 수치였다. **언급은 기록이 아니다**(D65·D77 계열, 이번엔 **규칙을 설명하는 문장이 규칙을
만족**시켰다). 부수로 demand 쪽은 CHANGELOG만, satisfy 쪽은 세 자리를 보는 **비대칭**도 드러나 회귀
수치를 CLAUDE.md에만 적은 버전은 **요구조차 되지 않았다**(v0.46·v0.47). 양쪽을 **측정으로** 좁혔다 —
satisfy는 한 창(420자)에 축소 두 레그 이름 + `NNN/NNN` **3개 이상**(22개 버전 전수 측정의 최솟값 3),
유일한 예외 v0.44.1(커밋 `fb904ff`에 독립 run 자체가 없다)은 정규식이 아니라 **이름 붙인 waiver**이며
그 버전 문서가 실제로 사유를 적을 때만 유효하다; demand는 같은 세 자리를 읽는다(과잉 거부 0을 먼저 쟀다).
**양방향 revert**: 문자열 판정 1건 FAIL · waiver 제거 2건 FAIL. 수치·판정 영향 **0**. **두 번째 절반**: 좁힌 가드가 방금 만든 v0.51.1을 요구했는데 그 커밋의 CI run은 아직 없다 — `git log`로 CI가 **항상 후속 커밋**이 쓰는 것임을 세어 확인하고(전용 커밋 6건) 맨 위 한 항목만 사유를 적어 면제했다(래칫은 닫힌다).
이 컨테이너 **768/768 → 770/770**. **CI 실측**(커밋 `99424ad`, run 210, 3레그 success): `full` **765/765 + 3 SKIP** · `without-iree` **602/602 + 33 SKIP** · `stdlib-only` **602/602 + 33 SKIP** — 컨테이너 **770/770 + 0 SKIP**과 `full`의 차이 **5건**은 E38이 확립한 설명 그대로이고(PyYAML 1 · objdump 미설치 SKIP 2 · 그 툴체인이 없으면 분기가 아예 없어 존재하지 않는 2), 축소 두 레그가 600→602로 **정확히 +2**라 D85 신규 2건이 **전부 나타난다**(신규 SKIP 0 — 문서 텍스트 검사와 순수 함수 단위 시험이라 툴체인 없이 실제로 돈다). **교훈**: ***가드를 출하하는 커밋에 그 가드를 먼저 걸어 보라.***

**v0.52에서 완료된 것 (E50, `docs/EVIDENCE_v0.52_E50.md`)**: 열두 번째 외부 검토
(`docs/reviews/ONAIR_MLIR_RESEARCH_REVIEW_v0_51_1.md`, 기준 커밋 `c407bd0` = 당시 head)를 건별로
**실행 재현**했다. **D86(fail-open, 재현됨)**: `mlir_alloc_walk.py`가 `stream.resource.`·`stream.tensor.`
**두 계열 밖 op을 `continue`로 조용히 건너뛰었다** — D84가 정규식 파서에 기록한 한계와 **같은 한계인데
E49가 이 구현에는 기록하지 않았고**, docstring은 *정확히* 그 두 계열만 다룬다고 적혀 있어 **그 정확함이
구멍**이었다. 보관 entry에 실제로 36 B를 할당하는 `stream.async.clone`을 주입하니 **rc=0 · 계약 발행 ·
`bounded` 786,476 불변 · `unresolved=[]`** — 할당을 빠뜨린 상한이 *"문제 없음"*과 함께 나왔다(E27 (b)
실패 양식). **두 추출기가 맹점을 공유해서 크로스체크가 그것을 "동의"로 보고했다.**
**첫 수정은 유형 (B)였다** — 검토의 세 질문을 문자 그대로 만족시키려 hard fail로 만들었더니 `dynamic`
계약 2개가 거부됐다. 그 entry의 async 6개는 **정직**하고(동적 형상이면 layout이 실제로 안 끝난다) 그 둘은
**A8 음성 시나리오의 입력**이라, 막으면 *도구가 동적 형상을 거부한다는 증거 자체*가 지워진다. **E24가 N1
때문에 만든 과잉 거부 가드와 N1이 걸렸던 같은 두 계약이 세 번째로** 잡았다. 좁힌 뒤 walker는 **보고**하고
거부는 **이미 있는 경로**가 한다(정적은 불일치로 hard fail, 동적은 계약이 나오되 **상한을 말하지 않는다**).
검토 세 질문 **전부 실측 충족**, **양방향 revert 5건/4건 FAIL**. **D87**: E49 §2의 *"entry 안 async 0회"*가
**25개 중 2개에서 거짓**(1,020은 맞다) — 한 패턴만 glob하면 14개만 보이고 그때는 *스캔한 것에 대해서는*
참이다. **E49 ledger는 네 실물 모델만 보므로 그 규칙을 `dynamic`에 적용하면 과잉 거부**임도 못박았다.
**D88**(검토 §4.2): `inference_starts`가 유도값인데 관측값의 이름 → `execution_authorized_by_policy` +
`derived_not_observed`(**ADM 8/8 판정 불변**). **검토 처방을 문자 그대로 채택한 것은 0건**이고 §5 순위
2~5는 **미착수**(다음 실험은 연구 책임자 지시 대기). 이 컨테이너 **770/770 → 776/776**, 보관 14개 diff 0.
**CI 실측**(커밋 `e35f969`, run 214, 3레그 success): `full` **771/771 + 3 SKIP** · `without-iree` **602/602 + 34 SKIP** · `stdlib-only` **602/602 + 34 SKIP**. 이 컨테이너(**776/776 + 0 SKIP**)와 `full`의 차이 **5건**은 E38이 확립한 설명 그대로다 — PyYAML 미설치 1 · `aarch64-linux-gnu-objdump` 미설치로 정직하게 SKIP되는 2 · 그 툴체인이 없으면 witness를 실제로 돌리는 분기가 아예 없어 **존재하지 않는** 2. `full`이 765→**771로 정확히 +6**이라 E50 신규 6건이 전부 나타나고, **축소 두 레그는 602로 변화 없이 SKIP만 33→34(+1)**인데 이것도 정합한다 — D86 시험 6건은 구조적 추출기(`iree.compiler.ir`)를 요구하므로 그 레그에서는 **하나의 정직한 SKIP으로 접힌다**(사례별 SKIP을 나열하지 않는다).
**교훈**: ***docstring이 정확해도 그 정확함이 범위 한정이면 한정 밖은 검사되지 않고, 두 도구가 맹점을
공유하면 크로스체크는 그것을 "동의"로 보고한다*** · ***"전제 위반"의 올바른 귀결이 항상 거부는 아니다.***

**v0.53에서 완료된 것 (E51, `docs/EVIDENCE_v0.53_E51.md`)**: 검토 `docs/reviews/DECISIONS_v0_52_REVIEW.md`
§9가 정한 **단계 1~3**. 사전 고정 기준은 `docs/plans/E51_claim_preconditions.md`(커밋 `4e5a906`, **측정 이전**).
검토서가 §검토 한계에서 *"v0.52 저장소를 다시 실행·검증하지 않았다"*고 **스스로 적었으므로**, *"E50이 충족했다면
근거만 연결하면 된다"*가 성립하는지를 **E50의 산문이 아니라 우리 실행**으로 답했다. **세 단계 전부 PASS이고
새 게이트는 0개다** — 계획 §1이 측정 전에 금지했다(E50이 바로 그 조건을 hard fail로 만들었다가 유형 (B)를 냈다).
**단계 1**: Q1은 읽은 것이 아니라 **실행**이다 — production `make_contract.build_contract()`를 `sys.settrace`
아래 돌려 다섯 전제 검사가 사는 줄이 실행됐는지 기록해 **5/5 실행됨**(줄 번호는 실행 시점에 **anchor로 찾고**,
못 찾으면 `false`가 아니라 `anchor_not_found` — D51). Q2는 **양성 대조를 먼저 통과시킨 뒤**(편집하지 않은 같은
IR이 rc=0으로 계약을 낸다) 보관 layout IR에 전제 위반을 주입해(**재컴파일 없음**) **배치 가능한 산출물 0** —
화이트리스트 밖 op·post-layout async 는 **계약 미발행**, 비상수 크기는 계약이 나오되 `bound_method=NONE`이고
**헤더가 생성되지 않는다**(세 번째가 미발행이 아닌 것은 설계대로다 — 막으면 E24가 N1에서 고친 과잉 거부가
되살아난다). **D86이 load-bearing임을 실측했다**: 그 분기의 기여만 빼면 두 추출기가 **동의해서 계약이 발행된다**.
Q3은 `regression_check`를 **그대로 호출**해 14/14 diff 0(두 번째 구현을 만들지 않는다 — E44). Q4가 이 단계의
진짜 신규 항목으로, **감사 도구**(ledger — 4모델, 계약 생성이 **호출하지 않는다**)와 **배포 계약 경로**(계약
32개, 모델 목록 없음)의 범위를 기계 판독으로 분리했다.
**단계 2**: 검토 §5.2-4가 요구한 두 주장을 **분리 기록**한다 — *"실행기가 스레드를 만들지 않는다"*는 **센다**
(세 배포 0/0/0), *"외부 호출이 순차적이다"*는 **읽는다**(cFS의 두 invoke 호출부는 `Init` 안과 `Init` 이후
RunLoop 안이라 겹칠 수 없고, 둘이 `g.session`·`g.x`를 공유하는 것이 `max_in_flight_calls = 1`이 **필요한**
이유다). **상태는 `ARGUED_FROM_SOURCE` 그대로이고 `observed_value`는 `null`이다** — 호출부를 읽어도 관측이
되지 않는다(계획 §2가 측정 전에 고정).
**단계 3**: U·B·H를 **17행**으로 매핑 — 보관 계약 재생성 0 · 값 재계산 0 · 정의는 E49 `audit_matrix.json::
accounting_scope`에서 **인용**(D65) · 연결표와의 겹침을 **먼저 세고** 사본을 만들지 않았다(E44). 승인 예산이
U의 어느 값인지가 행마다 추적된다 — `unconditional` 7행은 `bounded_bytes`, `conditional_map` 1행은
`static_per_call_bytes`. 예산이 **없는** 두 셀은 원자료가 `budget_invalid_event`로 **스스로 사유를 적어**
해결된 행으로 센다(사유 없는 부재였다면 결손이다).
**D89**: **D77을 따르려고 만든 가드가 D77을 범했다** — 단계 2의 회귀 시험이 보관 JSON만 pin하고 live 재실행
비교에 개수·판정만 넣어, containment 로직을 proximity로 **되돌려도 5/5 전부 통과**했다. live 비교에
enclosing_loop 모양을 넣었다. **D90**: 같은 세 수치가 요약 생성기마다 **다른 이름**이다(`bounded`/`per_call`/
`constants` vs `bounded_bytes`/…) — 수치·판정 영향 0이지만 한 철자만 아는 판독기는 다른 쪽에서 조용히 `null`을
낸다(이 도구의 첫 판이 E36 다섯 셀에 실제로 그랬다). 보관 요약을 고쳐 쓰지 않고 **별칭을 명시 선언**했다(D76).
**판정 전에 잡은 자기 도구 결함 셋**: 주입을 `util.return` **뒤**에 넣어 MLIR을 깨뜨려 세 거부가 **주입과 무관한
이유**로 났던 것 · 절대 경로 root로 14개가 전부 "다르다"고 나온 것 · 최상위 `contract` 키의 scope를 루트로 읽지
못해 E36 다섯 셀이 연결되지 않은 것. 양방향 revert 1·1·2건 FAIL. 이 컨테이너 **776/776 → 796/796**(FAIL 0 ·
SKIP 0), 보관 14개 계약 diff 0.
**CI 실측**(커밋 `5ddec80`, run 220, 3레그 success): `full` **791/791 + 3 SKIP** · `without-iree` **621/621 + 35 SKIP** · `stdlib-only` **621/621 + 35 SKIP**. 이 컨테이너(**796/796 + 0 SKIP**)와 `full`의 차이 **5건**은 E38이 확립한 설명 그대로다 — PyYAML 미설치 1 · `aarch64-linux-gnu-objdump` 미설치로 정직하게 SKIP되는 2 · 그 툴체인이 없으면 witness를 실제로 돌리는 분기가 아예 없어 **존재하지 않는** 2. `full`이 771→**791로 정확히 +20**이라 E51 신규 20건이 전부 나타나고, 축소 두 레그는 602→**621(+19)**이고 SKIP이 34→**35(+1)**이라 합이 정확히 20이다 — 늘어난 SKIP 하나는 단계 1의 live 재실행 가드로, 사유 목록에 `needs iree-compile and iree.compiler.ir`로 나타난다(그 레그에는 두 도구가 없다).
**교훈**: ***거부는 귀속될 때만 근거다*** · ***revert가 실패를 만들지 않으면 고친 것은 코드가 아니라 기록이다.***
**다음**: 검토 §10 순서대로 **단계 4 — DeepAE 수치 불일치 원인 분석(E52)**, §4.4의 세 종료 조건을 따른다.

**v0.50에서 완료된 것 (E48, `docs/EVIDENCE_v0.50_E48.md`)**: **공개 실입력의 AArch64 종단 실행** —
두 외부 검토가 **독립적으로 최우선**으로 지목한 항목이다(`RESEARCH_STATUS_REVIEW_v048.md` §12 P0-1 ·
`ONAIR_MLIR_RESEARCH_AND_EXPERIMENT_REVIEW_v048.md` §6 R1). 사전 고정 기준은
`docs/plans/E48_real_inputs_aarch64_cfs.md`(커밋 `4cd26f5`, **측정 이전**)이고 판정 기준은 E25에서
**변경 없이 승계**했다. E45가 x86-64 pip `iree.runtime`에서만 밟았던 세 모델의 실입력을
**AArch64 native(qemu-user)와 AArch64 cFS 게스트**에서 다시 밟았다 — 갭은 실재했고(`grep -rl
'real_cifar10\|real_ad01' results/`가 `e45_real_inputs/` 바깥을 하나도 내놓지 않았다) 환경은 막혀
있지 않았다(재구축 0). **판정이 세 모델 전부 x86-64와 같다**: ResNet **PASS 0/2,000**(argmax 200/200) ·
SmartCam **PASS 0/57** · DeepAE **FAIL 46/21,760**. **Q5 관측 — DeepAE는 두 ISA가 정확히 같은 한 샘플**
(`normal_id_04_00000043_hist_librosa_w98`)에서 실패하고 **argmax도 같다**(517 == 517); 다른 것은 실패
원소 수(AArch64 46 · x86 94)와 최악 abs(3.6144e-04 vs 6.1893e-04)뿐이다. 계획 §7이 **측정 전에**
정해 둔 문장을 그대로 쓴다 — ***"그 FAIL은 x86 전용 현상이 아니다"*까지이고 원인 귀속은 하지 않는다**
(R2/E49). **기준은 고치지 않았다**(D74 그대로). 계약 세 수치는 합성 셀(E36b·E32)과 **동일**하고
(입력과 무관 — Q2), `B`→ADMIT · `B−1`→NOT_ADMITTED(**추론 0**, 런타임 오버라이드로만 — 계획 §6 P3),
`peak_within_admitted_budget`이 세 셀 전부 true다(Q4).
**D80 — 이 실험이 찾은 양방향 결함**: `runtime_created` 기대 키가
`bool(last_run) or bool(stack)`이었는데 **E16이 스택 확인을 자원 획득 이전으로 옮긴 뒤로 거부 셀도 항상
`stack` 레코드를 남긴다** — 거부가 할당 전에 일어나도록 만든 그 수정이 이 근사를 깨뜨렸다. **유형 (B)**
정직한 `NOT_ADMITTED` 셀이 `False`를 구조적으로 만족할 수 없고(ResNet `B−1` 셀이 실제로 FAIL로 적혔다),
**유형 (A)** `True`를 기대하는 셀은 런타임 없이도 스택 레코드 하나로 통과한다. 이 키를 쓰는 셀이
**E14 이후 한 번도 실행되지 않아** 드러나지 않았다(전수 조사: 보관 3셀, 셋 다 `stack` 없음).
`mem_init`으로 고쳤고 **보관 3셀 판정 불변**, revert 시 3건 FAIL.
**계획 §4의 다섯 가지**: fixture 재생성의 **샘플별 해시 대조**(200/200 · 34/34 · 19/19) ·
**AArch64 cFS 앱 재빌드**(게스트 트리에 **D75 `static yv` 수정이 들어간 적이 없었다**) ·
**러너가 실입력을 나르게**(`stage`/`fetch`/`env` 신설 — E32/E36b는 손으로 했고 그래서 시나리오 파일이
*어떤 입력을 재생했고 어떤 예산으로 판정했는지* 말하지 못했다) · **요약 생성기 일반화**(판독기가 경로를
값으로 받고 E48 생성기가 **import**한다, E36b 요약 diff 0) · **DeepAE 입력 재조달**(248/248 해시 일치).
**두 개의 자기 결함을 판정 전에 잡았다**: (a) `mk_e25_inputs.py`의 첫 판이 manifest가 해시하는 **배열
바이트** 대신 `.npy` **파일**을 해시해 정직한 fixture 셋을 전부 거부했다(유형 B — *틀린 해시 규칙이
fail-closed로 보이는 것은 전부에 대해 실패하기 때문이지 옳기 때문이 아니다*), (b) 스테이징 배선의 첫 판이
`rm`을 실행 체인 안에 둬 **방금 올린 입력 파일을 스스로 지웠고** 그 셀은 e25 모드가 꺼진 채 ADMIT과 올바른
`hal_peak`을 보고했다 — **잡아낸 것은 시험이 아니라 앱이 무조건 남기는 E26 위생 레코드**
(`{"stage":"e25_mode","active":false}`)다. **모드가 꺼졌음을 증명하려고 만든 계측이 잘못 꺼졌음을 증명했다.**
연결표는 새로 만들지 않고 `mk_evidence_linkage.py`에 **항목 8**(입력의 실제성 축)을 더했다(D65 회피) —
3모델 × 8항목 **24/24 present**. 그 과정에서 **셀 수를 리터럴 21로 들고 있던 자리 둘**(생성기 출력 문구·
회귀 시험 이름)을 데이터에서 읽도록 고쳤다.
**D81 — CI가 잡은 셋째 결함**: E47이 넣은 가드가 numpy 부재를 `skip=True` 없이 기록해 **SKIP이 아니라
FAIL**로 집계됐고, CI 축소 두 레그가 두 커밋 동안 빨간 상태였다(553/554 · 577/578). `full` 레그와 이
컨테이너는 numpy가 있어 초록이라 **로컬에서는 원리적으로 보이지 않는다** — **D32의 재발**이고 수치·판정
영향은 0이다. AST로 `Result(..., None, ...)`를 훑는 **구조적 가드**를 신설했다(첫 판은 정규식이라 자기
패턴 리터럴을, AST 판은 자기 양성 대조를 잡아서 D77의 방식대로 **함수 단위 waiver + 원문 노출**로 처리).
이 컨테이너 **721/721 → 748/748**(FAIL 0 · SKIP 0), 보관 14개 계약 diff 0.
**CI 실측**(커밋 `0ab7cca`, run 204, 3레그 success): `full` **743/743 + 3 SKIP** ·
`without-iree` **580/580 + 33 SKIP** · `stdlib-only` **580/580 + 33 SKIP**.
이 컨테이너(**748/748 + 0 SKIP**)와 `full`의 차이 **5건**은 E38이 확립한 설명 그대로다 —
PyYAML 미설치 1 · `aarch64-linux-gnu-objdump` 미설치로 정직하게 SKIP되는 2 · 그 툴체인이 없으면
witness를 실제로 돌리는 분기가 아예 없어 **존재하지 않는** 2. 축소 두 레그가 543→580으로
**정확히 +37**이고 SKIP이 32→33으로 **+1**이라, E48·D80·D81 신규 27건 중 **numpy를 요구하는
1건이 정직한 SKIP**이 되고 나머지 26건 + 이전 커밋의 11건이 나타난다.
**하지 않음(명시)**: WGAN의 AArch64(재실행이 아니라 신규 반입) · OnAIR AArch64(환경 없음) ·
정확도·지연·전력 · 조건부 계층(무조건 계층만; SmartCam 조건부 셀은 E38 인용) · DeepAE FAIL의 원인 귀속.
**교훈**: ***한 실험이 신호가 찍히는 시점을 바꾸면, 그 신호를 옛 의미로 읽던 기대 키도 함께 고쳐야 한다 —
그 키를 쓰는 셀이 그 뒤로 한 번도 실행되지 않았다면 틀렸다는 사실조차 기록되지 않는다.***

**이로써 §10 단계 1~5가 전부 닫혔다**(단계 2는 E36, 단계 4는 E36b). 여덟 번째 검토의 **§10 마무리 4단계**도
닫혔다 — 1(E37 보고 원자료 재확인) · 2(조건부 opt-in 독립 기록 = E38) · 3(결정 문서 4곳 정정, 저장소 밖
문서라 커밋 대상 아님) · 4(범위 완료 확정). 다음 작업은 **연구 책임자 결정 대기** — 논문 초고 착수 /
PR 병합 / 태그 정책 확정 / 검토 §5~§9의 **선택적** OnAIR 메모리 비교 실험 / WGAN 반입 중 선택.
검토가 명시적으로 제외한 것: E38 이후의 모델 확장, WGAN, 새 MLIR pass, 논문 초고(그 문서 범위 밖).

**옛 다음 작업(완료)**: **E36b — ResNet·DeepAE의 AArch64 확장** — 모델당 한 번의 `iree-compile`로 AArch64 vmfb·계약·헤더를
만들고, 계약 수치를 x86-64와 대조하고, native(qemu-user)·cFS에서 전체 출력을 원본 TFLite oracle과 대조하고,
예산 경계 셀을 돌린다. **새 모델별 하네스 0개**가 그 단계의 완료 기준이다. **논문 초고는 그 뒤에 판단한다.**
남은 것은 WGAN 반입이다 — **정규 MLIR pass는 2026-09-11 결정으로 이번 논문 범위에서 빠졌다**
(미착수 상태 자체는 불변이고, *"만들어도 결과가 바뀌지 않음을 실측했다"*고는 여전히 **쓸 수 없다**).

**연구 책임자 지시 (2026-09-11)**: **논문 초고는 별도 지시가 있을 때까지 착수하지 않고, 그때까지
실험을 최대한 진행한다.** 남은 작업 순서는 E42/E43(LiteRTLearner + O0~O3 순수 OnAIR 비교) →
E44(예산 출처) → 실입력으로 AArch64·cFS·OnAIR 경로 재실행 → WGAN 반입이다.

## 작업 규율 (반드시 지킬 것)

이 저장소는 **엄격한 이력 관리**로 운영되어 왔다. Claude Code에서도 동일하게 유지한다.

1. **실험 1건 = git 커밋 1건.** 커밋 메시지에 실험 ID(E14, E15…)와 핵심 수치를 넣는다.
   예: `E14: ...` 형식. 버전 매듭마다 `git tag -a v0.8 -m "..."`.
2. **모든 실험은 `EXPERIMENT_LOG.md`에 등록.** ID·날짜·플랫폼 등급·산출물·결과 요약·판정 문서·커밋 해시.
3. **판정 변경은 철회하지 않고 덧붙인다.** 이전 결론이 틀렸으면 "정정" 항목으로 남기고 사유를 적는다.
   `EXPERIMENT_LOG.md` 하단의 "가설 판정 이력"·"반증된 주장 이력"·"방법론 결함 이력" 표가 그 기록이다.
4. **증거 등급을 항상 명시한다.** 이 컨테이너의 실측 결과, `harness/platform_check.py`가
   `FUNCTIONAL_ONLY`를 반환하면(1 vCPU 등 공유 환경) **절대 지연값은 인용하지 않는다.**
   동일 호스트 연속 측정의 구현 간 비율만, 그것도 platform_check가 보고하는 잡음 비를
   초과할 때만 방향성 신호로 쓴다. **결정론적 값(해시, HAL 통계, 바이너리 크기, IR 구조 분석)은
   이 규칙이 적용되지 않는다** — 그대로 인용 가능.
5. **버전마다 `docs/EVIDENCE_v0.N_<실험명>.md`를 새로 만든다.** 기존 EVIDENCE 파일을 고쳐쓰지
   않는다(단, 발견된 오류의 "정오표" 절 추가는 허용).
6. **`CHANGELOG.md`를 매 버전 갱신한다.** 정본의 순서는 `CLAUDE.md`(범위·가드레일·현재 결론) →
   `EXPERIMENT_LOG.md`(실험 레지스트리·결함 원장) → `CHANGELOG.md`(버전별 변경) →
   `docs/EVIDENCE_v*.md`(주장별 근거)다.
   **`PROGRESS.md`는 v0.3.1 시점 스냅샷으로 동결하고 규율에서 제외한다**(v0.40 확정) — 그 문서 자신이
   *"현재 상태의 정본이 아니다"*라고 선언한 채 35개 버전을 지나왔고, 규율과 실제가 어긋난 항목을
   그대로 두는 것보다 어느 쪽이 정본인지 못박는 편이 낫다. 갱신 지점을 늘리지 않는다.
7. **컴파일러 산출물(vmfb 등)을 재컴파일할 때는 주의**: 같은 MLIR·같은 플래그라도 **입력 파일명이
   다르면 vmfb 바이트가 달라진다**(심볼명에 파일명이 들어감). 계약·IR 덤프·배치 아티팩트는
   반드시 **한 번의 `iree-compile` 호출**에서 생성한다(`EVIDENCE_v0.7_E13.md` §1.3).

## 현재 상태 (v0.7 시점)

| 가설/주장 | 판정 |
|---|---|
| H1 (AOT가 Python/NumPy보다 빠르고 예측 가능) | **성능 우위 미관측**. 최적 compiled가 NumPy/BLAS 대비 2.2–4.1× 느림 (베이킹 가중치, h=16384 기준) |
| H2 (계약 기반 lowering 선택이 고정 설정보다 유리) | **선택의 이점 미입증**. 초기엔 강한 근거(ρ=+0.18 순위 붕괴)로 보였으나 **가중치 per-call 복사 결함(D1)의 인공물**로 판명, 철회 |
| **H3 (실행 전 memory admission 판정)** | **메모리 축, 시험 조건 내 성립.** 정적 상한이 HAL 런타임 피크와 60/60(+구조 사례 4/4, +cFS 통합 등) 일치. 이 연구의 유일하게 살아남은 핵심 결과 |
| MLIR 필연성 (TFLite Micro 등 대안 대비) | **질문이 재정의됐다(v0.29/E27 + TFLite 위치 분석).** TFLM은 이 논문의 대상(AArch64 CPU + cFS)의 필수 baseline이 아니다 — MCU 정적 arena 런타임이라 실행환경이 다르다. MLIR 기여는 **같은 IREE 실행 위에서 정보 수준만 바꾼 baseline 사다리**로 논증한다(파일 크기 / artifact-only / runtime profile / MLIR universal / MLIR conditional) |

가장 중요한 교훈: **이 프로젝트는 두 번의 외부 검토에서 각각 실제 계산 결함을 지적받았다**
(D2: 상수 오귀속, D3: 정렬 패딩으로 인한 slice-sum 과소추정, D5–D7: 계측 경계 오류).
"계산값과 관측값이 일치했다"는 항상 "같은 할당 계획의 두 관측이 서로 모순되지 않는다"는
뜻일 뿐, 계획 자체가 맞다는 증명이 아니다. **새 실험을 설계할 때마다 이 함정을 의심할 것.**

## 지금 바로 이어서 할 일 (Claude Code) — **v0.20에서 재편**

**재편 사유(v0.20/E24b)**: v0.9.1 이후의 우선순위는 두 외부 검토가 합의한 순서
("모델·시나리오 수를 늘리기 전에 '어떤 정보가 없거나 잘못됐을 때 절대 ADMIT하지 않는가'를
먼저 닫는다")였고, 그 축의 항목은 **전부 끝났다**(아래 "완료된 구현 hardening" 참조).
네 번째 외부 검토(`docs/reviews/REVIEW_v0_19_E24_RESEARCH_REFRAME.md`)가 이 상태를
정확히 짚었다:

> onAIR-MLIR v0.19는 구현 완성도와 재현성이 높은 cFS/IREE 부분 메모리 admission
> 프로토타입이다. 남은 핵심 과제는 **주변적인 방어 조건을 계속 늘리는 것이 아니라**,
> 계약 경계의 실질적 가치, OnAIR↔cFS 의미 동치, MLIR 기반 접근의 고유 기여를 증명하는 것이다.

따라서 우선순위 축을 **fail-closed 방어 → 연구 질문**으로 바꾼다. 방어 조건 추가는
새 결함이 재현될 때만 하고(그때도 실험 1건으로 처리), 기본 진행 방향은 아래 R-1~R-3이다.

**옛 번호 → 새 번호**(위 v0.10~v0.19 서술과 `EXPERIMENT_LOG.md`·`CHANGELOG.md`가 쓰는 번호):
1→H-1, 2→H-2, 3→H-3(verifier 부분)·R-3(진짜 pass 부분), 4→R-2에 흡수, 5→R-4, 6→R-5, 7→R-6, 8→R-1.

### 논문 범위 (2026-09-09 확정 — 여섯 번째 외부 검토 + 연구 책임자 지시)

**논문은 "MLIR 기반 AI 실행 메모리 admission"에 집중한다.** 다음 넷은 **핵심 논증에서 제외**한다:
보안(악의적 변조·해시 위조), 공급망·서명·키 관리, QEMU 성능(latency·jitter·WCET·전력),
cFS 전체 인증. **2026-09-11 추가: 정규 MLIR compiler pass도 이번 논문 범위에서 제외한다**
(후속 연구 항목 — 제외는 "만들어도 결과가 안 바뀐다"의 실측이 아니다). 손상 아티팩트 시험과 결함 원장 51건은 **부록의 보조 증거**이며 본문 기여가
아니다. 새 fail-closed 음성 시험을 늘리는 것도 본문 기여가 아니다.
계약의 정확한 이름은 **partial per-app model-execution memory contract**다.
상세는 `docs/ASSUMPTIONS_AND_SCOPE.md` 하단 "논문 범위 결정"과 "TFLite의 위치".
**TFLite는 경쟁 대상이 아니라 원본 기준선**이다(의미 보존 확인용). MLIR 기여는 **같은 IREE 실행** 위에서
정보 수준만 바꾼 baseline 사다리로 논증한다: 파일 크기 → artifact-only → runtime profile →
MLIR universal → MLIR conditional. **TFLM은 필수 baseline이 아니다**(MCU 정적 arena, 실행환경 다름).

### 연구 가정 — `docs/ASSUMPTIONS_AND_SCOPE.md` (확정)

계약은 저장소 생성 파이프라인의 산출물이며 생성 후 수동 변경하지 않는다고 가정한다.
hash·provenance는 **실험 대상 식별과 재현성** 수단이지 보안 장치가 아니다. 악의적 변조·
공급망·서명·키 관리는 **연구 범위 밖**이다. 수동 편집으로만 도달하는 반례는 실험으로
등록하지 않는다(그 문서의 "세 질문" 참조).

**E24 계열의 방어적 review–patch 반복은 종료한다.** 새 지적은 Core / Supporting /
Out-of-scope로 먼저 분류하고, Out-of-scope는 문서 한 줄로 닫는다.

### 최우선 — 연구·논문 핵심 (검토 §5.1, §7)

> **v0.29 현재: R-1·R-2·R-3이 전부 닫혔다.** 네 번째 외부 검토가 재편한 세 축의 답은
> `docs/EVIDENCE_v0.22_E25.md`(R-1) · `docs/EVIDENCE_v0.25_E26.md`+`_v0.27_E26e`+`_v0.28_E26f`(R-2) ·
> `docs/EVIDENCE_v0.29_E27.md`(R-3)에 있고, 각 항목의 §"주장하지 않음"이 범위를 못박고 있다.
> **다음 세션이 새 실험을 고를 때**: 아래 R-4~R-6은 우선순위가 낮고 R-5는 이 컨테이너에서
> 원리적으로 불가능하다. 남은 작은 항목은 (i) E26-ext 두 실물 모델의 cFS 셀(미실행),
> (ii) ~~R-3 "강화안"인 **정규 MLIR pass**~~ — **2026-09-11 연구 책임자 결정으로 이번 논문
> 범위에서 제외 확정**(`docs/ASSUMPTIONS_AND_SCOPE.md` "정규 MLIR pass — 이번 논문에서 하지
> 않는다"). E27이 *"결과를 보고 판단한다"*로 남겨 둔 항목이고 그 판단이 내려졌다. **제외는
> "만들어도 결과가 안 바뀐다"의 실측이 아니다** — 그 실험은 없고 그 문장은 앞으로도 쓸 수 없다.
> **새 방어 조건 추가는 여전히 실제로 재현된 결함에 한한다.**

**R-1. OnAIR↔cFS 동일 모델·동일 의미 검증 (검토 C2 / E25)** — **완결(v0.22/E25, PASS)**.
   아래는 착수 당시의 서술이며 이력으로 남긴다. **잔여(범위 밖으로 명시)**: (i) OnAIR
   `CompiledLearner` 플러그인의 baked-vmfb 전환과 SB 흐름 end-to-end 동치 — 일곱 번째 검토 §4.1이
   "현재 목표를 위해 확대 불필요"로 판단, (ii) `harness/corrupt_vmfb.py`로 AArch64 게스트 A5b raw
   log 재생성(아래 (5)) — 미수행, E26 게스트 세션에서 함께 처리.
   E23이 F10의 즉시 고칠 수 있는 부분(OnAIR 플러그인의 계약-아티팩트 바인딩 게이트 부재, D27)은
   닫았지만 **구조적 단절은 그대로 남아 있다**: OnAIR 플러그인은 `weights.npz`를 별도 인수로 받고
   native/cFS는 baked-weight vmfb를 쓰며, cFS 앱은 플러그인의 이식이 아니라 별도 C 앱이고
   (`CFE_ES_HK_TLM_MID` payload를 feature로 사용), **같은 입력에 대해 OnAIR Python / OnAIR IREE /
   native C / cFS 앱의 출력이 동치라는 end-to-end 시험이 없다.**
   이 시험이 없는 동안 안전한 표현은 *"OnAIR와 cFS에 각각 IREE 실행 경로를 구현했다"*이고,
   *"동일한 OnAIR AI 모델을 cFS에 배치했다"*는 근거를 넘어선다(`docs/EVIDENCE_v0.18_E23.md` §2).
   할 일: (1) OnAIR·cFS의 모델·가중치·vmfb 통일(권장: 양쪽 다 baked-weight, 외부 weights를
   유지해야 한다면 vmfb+weights+preprocessing을 하나의 artifact bundle manifest로 결속 —
   현재 `weights.npz` 2,884,078 B가 계약 밖에 있다), (2) 동일 입력 벡터·전처리,
   (3) Python reference / OnAIR-IREE / native C / cFS x86-64 / cFS AArch64 출력 비교,
   (4) **절대·상대 오차 tolerance와 pass 기준을 사전에 정의**, (5) E23의 결정적 A5b 생성기
   (`harness/corrupt_vmfb.py`)로 AArch64 게스트 raw log 재생성.
   착수 전제: `scripts/20_setup_onair.sh`(OnAIR 설치) + x86-64 IREE C 런타임 재구축.

**R-2. 계약 경계의 유용성과 외적 타당성 (검토 C1+C4 / E26)** — "수치가 맞는가"가 아니라
   **"이 부분 계약이 실제 cFS 배치 판단에 얼마나 유용한가"**에 답한다. 지금까지의 결과는
   전자만 말한다. 할 일: (1) 모델별로 계약 영역 / IREE runtime / wrapper / cFS·OSAL 메모리를
   **분리 측정**, (2) 계약값과 실제 HAL peak의 soundness·tightness를 모델별로 비교
   (conv2d native 1,352 vs cFS 3,528처럼 tightness가 구성마다 다른 사례가 이미 있다 —
   원인 규명이 여기 포함된다), (3) 제외된 runtime·wrapper 비용을 고정 오버헤드 또는 별도
   bucket으로 다룰 수 있는지, (4) 실제 임무형 경량 모델 1~2개 추가, (5) **다른 IREE 버전**에서
   계약 생성 성공·명시적 거부·수치 변화 측정(E19가 하드 실패 강제 지점은 만들었으나 발동은
   시뮬레이션으로만 확인했다), (6) x86-64/AArch64에서 ISA 독립 영역과 종속 영역 구분.
   **정정(v0.29, `docs/reviews/TFLITE_COMPARISON_ROLE_20260909.md`)**: 여기에 "동일 경계의 대안
   비교(구 우선순위 4, TFLite Micro)"를 합친다고 적었던 것을 철회한다. TFLM은 MCU용 정적 arena
   런타임이라 이 논문의 대상(AArch64 CPU + cFS)과 **실행환경이 다르며**, 벤치마크 지침 §9도
   경계 불일치를 이유로 수치 baseline에서 명시 제외했다. "왜 MLIR/IREE 경로여야 하는가"는
   **같은 IREE 실행 위에서 정보 수준만 바꾼 baseline 사다리**로 답한다(R-3/E27이 그 축이다).
   TFLM 착수 이력은 아래에 **이력으로만** 보존하며 재개 대상이 아니다.

**R-3. MLIR 접근의 고유 기여 (검토 C3 / E27)** — **완결(v0.29/E27) + 정정(v0.31)**. 답은
   *"MLIR이라야 이 수치를 얻는다"*가 아니라 **"MLIR 수준은 독립적인 두 번째 정보원을 준다"**이다.
   정상 조건 8/8에서 아티팩트만 보는 분석기가 계약값과 정확히 일치했고, 차이는 컴파일러 버전
   드리프트에서만 났다 — 거기서 **이 저장소가 출하한** 분석기는 읽지 못한 것을 없다고 보고했다
   (152배 과소, 무경고). **v0.31 정정(`docs/EVIDENCE_v0.29_E27.md` §7)**: 그것은 그 *구현*의
   성질이지 정보 수준의 성질이 아니다 — 같은 정보원(vmfb + `iree-dump-module`만)에서 침묵 경로를
   전부 명시적 거부로 바꾼 `harness/e27_baseline_vmfb_only_hardened.py`는 드리프트를
   `C4_DISASM`으로 거부하고 정직한 7개를 정확히 맞힌다(**과잉 거부 0**). 남는 차이는 탐지 능력이
   아니라 **탐지 이후에 남는 것**이다: 정보원이 하나면 거부밖에 낼 것이 없고, 둘이면 값 + note가
   남는다. 152배의 지배항도 §3.1이 명명한 버전 경계가 아니라 **세그먼트 순서 가정**이었다
   (5,172 = 36 + 5,136, 실행 ELF를 상수로 오귀속). 아래는 착수 당시의 서술이며 이력으로 남긴다.
   **전제가 바뀌었다**(v0.25 사전 관측,
   `docs/plans/E27_mlir_contribution.md` §1, 재현 산출물 `results/e27_baselines/`):
   *"이 수치는 MLIR이라야 얻는다"*는 **이 모델 집합에서 반증됐다.** MLIR도 컴파일러 덤프도
   쓰지 않고 `iree-dump-module`만 보는 분석기(`harness/e27_baseline_vmfb_only.py`)가 conv2d·
   mlp16k·multibranch의 `per_call`·`constants`·`bounded`를 **정확히** 재현한다.
   그런데 컴파일러 버전이 한 단계 어긋나면(IREE 3.10 산출물) 그 분석기는 `bounded`를
   **5,172로 152배 과소 추정하면서 `unresolved=[]`, 즉 문제 없음이라고 보고**한다 — 이 저장소가
   D25·D28·D29에서 세 번 고친 바로 그 실패 양식이 조용히 일어난다. 같은 입력에서 이 저장소의
   MLIR 경로는 786,476을 내고 도구 실패를 note로 기록한다.
   **따라서 E27이 물을 것은 "누가 더 정확한가"가 아니라 "어느 정보 수준이 자기가 모른다는 것을
   아는가"다.** 아래 옛 서술은 이력으로 남긴다 — 현 구현은 **정규 MLIR pass가 아니라**
   `--mlir-print-ir-after` 덤프를 다시 읽는 post-processing verifier다(F4·N6/S5로 세 번 지적됨;
   `docs/EVIDENCE_v0.13_E18.md` §7, `docs/EVIDENCE_v0.18_E23.md` §3). 검토가 제시한 선택지:
   - **최소안**: 현 post-processing verifier의 고유 장점(기존 도구 비침습성, 감사 가능성, cFS
     통합 방법)을 runtime-only / C / LLVM-IR 접근과의 **비교 실험**으로 입증
   - **강화안**: PassManager에 등록되어 완전한 in-memory module 위에서 실행되며 계약을 컴파일러
     산출물로 직접 emit하는 **진짜 pass**로 발전(= 이 항목의 원래 이름이 가리키던 것, 여전히 미착수)
   평가지표: 추출 완전성, compiler-version 취약성, 수동 dump 의존성, 계약 생성 실패율, 감사 가능성.
   **중요**: 현 구현을 pass라고 부르는 것이 목표가 아니라, **왜 MLIR 수준의 정보가 C/LLVM IR
   또는 runtime 계측보다 계약 생성에 유리한지**를 보이는 것이 목표다.
   착수 전 조사(v0.12, 실험 아님, 유지): `iree.compiler.ir` 바인딩은 실제 사용 가능하나
   `--mlir-print-ir-after=iree-stream-layout-slices`가 만드는 layout IR은 **함수별로 조각나
   있다**(entry 함수 청크가 다른 청크의 `util.initializer`가 정의하는 전역을 참조하는데 그 전역의
   **선언 자체**는 어느 청크에도 없다 — 선언은 이 패스가 바꾸지 않아 재출력되지 않음).
   `ir.Module.parse()`로 entry 청크만 단독 파싱하면 항상 "undefined global" 검증 오류다
   (`--mlir-disable-threading`을 더해도 청크 수·구조는 동일 — 그건 프린트 *순서*의 결정성
   문제였지 조각남의 원인이 아니었다). E18이 `util.global.load`/`store` 선언 합성 전처리로 우회했다.
   **주의**: 재컴파일해서 얻은 IR로 검증하면 one-invocation 규칙(작업 규율 7)을 위반한다.

### 그 다음 — 범위·환경 제약이 있는 항목

**R-4. 임무 유사 workload + 다중 AI 앱 동시 admission** — 다중 앱은 전역 예산의 예약·해제·경합
   설계가 새로 필요하다(현재는 전역 예약 없음). 외부 검토 F11(E23에서 not-a-defect로 판정)이
   지적한 "온보드 컴퓨터 전체 수용성" 한계와 같은 항목이며, 계약 JSON의 `resources.scope`/
   `bound_assumptions`와 admission JSON의 `"scope":"per_app_local_budget"`이 이 한계를 매 판정마다
   명시하고 있다. F11이 짚은 요소 중 **allocator fragmentation**은 이 저장소 어디에서도 다뤄진 적이
   없다 — 설계 시 나머지 5개(IREE runtime context, OSAL/cFS 메모리, 다른 앱, 동시 실행, task stack)에
   더해 반영할 것. 검토 §5.3은 이 항목 전체를 **명시적 범위 밖(후속 연구)**으로 두는 것도
   타당하다고 본다 — R-1~R-3보다 먼저 손대지 말 것.

**R-5. 시간 축 계약** — `platform_check.py`가 PASS를 반환하는 전용 하드웨어(코어 격리,
   SCHED_FIFO)가 있어야 착수 가능. 이 컨테이너에서는 원리적으로 불가능하다. 검토 §8도 같은
   결론이다: QEMU는 기능 논리(바이너리 생성·cFS 통합·게이트 동작·손상 거부·정리/재시작)에는
   충분하고, latency·jitter·WCET·RSS/allocator/cache 거동을 주장하려면 실물이 필요하다.
   **다만 비싼 우주급 보드가 아니라 저가 AArch64 SBC로 충분하며, 하드웨어보다 R-1·R-2가 먼저다.**

**R-6. RTEMS 단계(제안서 §17)** — 착수 가능하나 우선순위 낮음.

### 완료된 구현 hardening (이력 — 다시 주가설로 세우지 말 것)

- **H-1. fail-closed 계약 verifier** — 완료(v0.10/E15).
- **H-2. C 게이트 보강 + cFS 음성·생명주기 시험** — 완료(v0.11/E16 x86-64 + v0.12/E17 AArch64 게스트).
  A5b(구조 손상, 3레벨 전부 실행), mlp16k·multibranch A2 경계값, 재시작 2회+DELETE(정상 종료
  cleanup 포함), 스택 실거부·blob 크기 선검사의 AArch64 교차 확인. 잔여(우선순위 낮음):
  multibranch cFS 레벨 A2, dynamic 모델 게스트 재현(`docs/EVIDENCE_v0.12_E17.md` §6).
- **H-3. MLIR API 기반 구조적 post-processing verifier** — 1단계 완료(v0.13/E18: `harness/mlir_alloc_walk.py`),
  2단계 완료(v0.14/E19: `make_contract.py`에 **필수 크로스체크**로 결선, 대체 아님),
  적대적 리뷰·과잉 거부 결함 2건 수정(v0.15/E20, D16·D17).
  **이것은 R-3이 말하는 "정규 pass"가 아니다** — 이름을 혼동하지 말 것.
- **H-4. 외부 검토 4회분의 fail-open/과잉거부 결함** — v0.16/E21(F1·F2·F3·F5·F6·F7, D18–D23),
  v0.17/E22(F9 재현성, D24), v0.18/E23(F4·F8·F10·F11 + CI가 잡은 D25, D26·D27),
  v0.19/E24(N1–N6, D28–D34), v0.20/E24b(R1–R5, D35–D40). `contract_negative_tests.py` 170/170.
  **이 축은 여기서 닫는다** — 새 결함이 실제로 재현될 때만 다시 연다.

### 논문 주장 가드레일 (검토 §9 — 그대로 채택)

> **v0.29에서 갱신**: R-1·R-2·R-3이 전부 닫혔으므로 아래 두 목록을 그에 맞게 고쳤다.
> 검토 §9의 골격과 금지 항목은 그대로 두고, 실측으로 근거가 생긴 것만 위로 올렸다.

**지금 근거가 있는 주장**
- IREE 컴파일 중간표현과 vmfb/ELF 산출물을 결속해 AI 모델의 **프로그램 할당 메모리 일부**에 대한
  정적 계약을 생성하고, 이를 cFS 앱 시작 전 admission 및 artifact identity 검사에 연결하는
  **프로토타입을 구현했다.**
- x86-64와 AArch64/QEMU에서 정상·경계·손상·동적형상 시나리오로 **기능적 거부 동작과 계약 생성의
  재현성**을 평가했다.
- **(R-1, v0.22/E25)** 하나의 canonical 모델과 고정된 64개 입력에 대해 다섯 실행 경로의 계산
  결과가 사전 정의한 허용 오차 안에서 일치했고, 네 IREE 경로는 **6쌍 전부 비트 동일**이었다.
  범위는 *계산 결과 동치와 cFS 내부 추론 경로 통합*까지다.
- **(R-2, v0.25/E26 + v0.27·v0.28/E26e·E26f)** 이 부분 계약의 **유용성 근거는 tightness가 아니라
  배포 독립성**이다. 같은 vmfb의 HAL 관측 피크가 배포에 따라 최대 **172.3×** 달라지는 반면
  정적 계약은 변하지 않는다. soundness는 관측 범위에서 위반 0(합성 4모델 + 실물 MLPerf Tiny 2),
  경계 판정은 `bounded−1`→DENY / `bounded`·`+1`→ADMIT.
- **(v0.31/E29)** 그 **배포 의존성의 원인이 규명됐다** — `try_map` 분기는 모듈 이미지 포인터의
  64바이트 정렬이 정한다(64/64셀, 위반 0). 따라서 **보수성은 내재적이지 않다**: 배포가 전제조건을
  제어하면 조건부 값(`per_call`)이 7/7에서 **정확히** 관측 피크와 같다(1.00×). 계약은 두 값을
  이미 싣고 있으므로 스키마 변경 없이 조건부로 읽을 수 있고, 그 전제조건은 **가정이 아니라 측정으로
  검증**된다.
- **(R-3, v0.29/E27 + 정정 v0.31)** MLIR 수준 정보의 기여는 **더 정확한 수치가 아니라
  독립적인 두 번째 정보원**이다. 정상 조건 8/8에서 아티팩트만 보는 분석기가 같은 값을 냈고,
  차이는 컴파일러 버전 드리프트에서만 났다. **정정**: 거기서의 침묵은 *출하한 구현*의 성질이지
  정보 수준의 성질이 아니다(굳힌 변종은 거부한다, 과잉 거부 0). 주장할 수 있는 것은
  **탐지 이후에 남는 것**의 차이다 — 정보원 하나는 거부만, 둘은 값 + note.

- **(단계 5, v0.38/E35)** 정확한 이름은 **"MLIR 기반 계약 추출·연계 방법"**이다(검토서 §8.3의 권고 표현). 같은 VMFB·같은 계약 범위·같은 조건부 지식에서 두 정보 수준의 판정이 **24/24 동일**하므로, 주장할 수 있는 것은 *더 정확한 수치*가 아니라 **독립적인 두 번째 정보원과 계약 형태로의 통합**이다.

**아직 하면 안 되는 주장**
- 온보드 컴퓨터 **전체** 메모리 수용성을 보장한다 → R-4
- **모든** 계약 불변식을 검증한다 → 검증한 것은 재현된 결함 집합이다
- **정규 MLIR compiler pass**를 구현했다 → **여전히 미착수**. E27은 *어느 정보 수준이 필요한가*에
  답했을 뿐 pass를 만들지 않았다
- 실시간 성능 또는 WCET를 보장한다 → R-5
- OnAIR와 cFS가 **동일한 AI 모델을 의미적으로 동등하게** 실행한다 → **E25는 계산 경로 동치까지다.**
  OnAIR 플러그인의 baked-vmfb 전환과 Software Bus 수신·feature 변환을 포함한 전체 데이터 흐름
  동치는 하지 않았다(v0.22.1 정정)
- **실제 비행 하드웨어**에서 검증됐다 → QEMU 게스트다
- *"이 수치는 MLIR이라야 얻는다"* → **E27이 8/8에서 반증했고, E35가 커널 스택까지 확장해 반증했다**(임베디드 ELF가 vmfb 안에 있어 같은 분석기가 dump 없이 돈다, 4/4 일치)
- *"MLIR 수준이 더 나은 admission 판정을 낸다"* → **E35가 반증했다** — 근거의 무게는 **세 수치·커널 스택의 4/4**에 있고, 24셀 판정 동일은 그 **따름정리**다(D72: 수집기가 세 수치 불일치 모델을 건너뛰고 두 수준에 같은 수·같은 `bound_method`를 넣으므로 불일치 셀이 구조적으로 불가능하다. `docs/EVIDENCE_v0.38_E35.md` §8)(4개 모델–타깃 구성 × 2정책 × 3예산구간, 판정 불일치 0)
- *"조건부 map은 MLIR의 기여다"* → **같은 조건부 지식을 artifact-only 기준선에 주면 같은 판정이다**(E35 `band_between` 4/4, 승인 근거 예산까지 동일). 기준선을 무조건 정책에만 묶어 두고 얻은 차이는 실행 정책의 차이지 정보 표현의 차이가 아니다
- *"one-invocation 결속이 MLIR의 이점이다"* → **아니다. 여러 아티팩트를 쓰는 방식이 치러야 하는 비용이다** — 아티팩트가 하나뿐인 수준에서는 어긋날 것이 없어 질문 자체가 성립하지 않는다
- *"24셀에서 판정이 독립적으로 일치했다 / 불일치 셀이 없음을 측정했다"* → **D72로 철회**. `verdicts_disagreeing: 0`은 구조적으로 보장된 값이지 관측값이 아니다
- *"두 정보원의 오류가 독립이다 / 교차 확인이 신뢰성을 높인다"* → **미입증**(v0.38.1). 두 수준이 `elf_stack_frame.py` 같은 구현을 공유하고 같은 컴파일 체인 산출물을 읽는다. 결함 주입·검출 실험 없이는 주장할 수 없다
- *"OnAIR 경로에서 출력 버퍼 해제를 검증했다"* → **D60으로 철회**. 원자료가 종료 시점 미해제 인스턴스를 보고한다. 반대로 *"누수가 있다"*도 쓸 수 없다 — 상태는 **미검증**이다
- *"단계 1~5를 완료했다"* → **v0.40에서 전부 닫혔다**(단계 2 = E36 `stage_2_complete: true`, 단계 4 = E36b `stage_4_complete: true`). 다만 각 단계의 §"하지 않은 것"이 여전히 범위를 못박는다 — 정확도·OnAIR AArch64·SBN 연계·조건부 계층(SmartCam 외)은 미실행이다
- *"정규 pass를 만들어도 결과가 바뀌지 않음을 실측했다"* → pass를 구현해 비교한 실험은 **없다**. 쓸 수 있는 것은 *"현재 두 정보 수준에서 수치·판정 우위가 관측되지 않았다"*까지다. **2026-09-11에 이번 논문 범위에서 제외하기로 결정했지만 그 결정이 이 문장을 허가하지 않는다** — 범위 결정과 실측은 다른 것이다
- *"아티팩트만 보는 수준은 fail-closed일 수 없다"* → **v0.31이 반증했다**: 같은 정보원의 굳힌
  변종이 드리프트를 명시적으로 거부하고 정직한 7개를 정확히 맞힌다(과잉 거부 0). 굳힌 (b′)의
  **가용성 비용**은 이 드리프트 입력 하나(n=1)에서만 관측했다 — 넓은 버전 매트릭스는 미측정
- 계약이 **무조건 tight하다** → 무조건 계약(`bounded`)은 배포에 따라 1.00×~172.3× 보수적이다.
  E29 이후 정확히 말하면: **조건부 값(`per_call`)은 전제조건이 성립할 때 tight하고(7/7 1.00×),
  무조건 값(`bounded`)은 두 분기의 최댓값이라 항상 sound하되 map 분기에서 느슨하다.**
  전제조건을 검증 없이 가정하면 그것이 곧 fail-open이고(D53), 검증이 승인 근거와 다른 양을 재도
  fail-open이다(D54 — 승인은 분기, 검증은 크기 비교)
- **모든** 배포에서 map 분기를 보장한다 → 이 앱이 자기 blob의 정렬을 보장할 뿐이고, 다른 IREE
  버전·드라이버에서 copy 분기의 원인이 정렬뿐이라고는 주장하지 않는다. 그래서 앱이 분기를 측정한다
- 관측한 모델·배포·컴파일러 버전 **밖으로의 일반화** → E26의 분기 결정 요인은 미확정이고,
  E27의 (b) 실패는 n=1이다

- *"세 모델의 출력이 사전 고정 기준을 만족한다"* → **D74/E45로 범위 한정**. 그 판정이 나온 셀의 입력은
  SmartCam이 실이미지 3 + 합성 32 + 경계 2이고 나머지 둘은 합성 32 + 경계 2였다. 실데이터에서
  **Deep AutoEncoder는 만족하지 않는다**(34창 21,760원소 중 94 실패, 170샘플로 넓히면 5.9%의 샘플).
  쓸 수 있는 것은 *"ResNet과 SmartCam은 실입력에서도 만족하고, DeepAE는 실 log-mel 입력에서 소수의
  입력이 기준을 넘는다"*까지다
- *"세 모델을 실데이터로 검증했다"* → **정확도는 세 모델 전부 주장하지 않는다**(E45 §5). 검증한 것은
  **의미 동치**(두 실행 경로가 같은 텐서에서 같은 답을 내는가)이지 모델이 맞는 답을 내는가가 아니다
- *"실제 비행 이미지로 검증했다"*(SmartCam) → 새 19장은 **0.3× 축소 JPEG 썸네일**(tier B)이고 원본
  취득분(tier A, 2048×1944 무손실 PNG)은 여전히 3장이다. 두 등급을 합쳐 *"실이미지 22장"*이라 쓰지 않는다
- *"OPS-SAT 온보드 라벨로 정확도를 쟀다"* → **라벨이 순환이다**. CSV `label`이 그 모델 자신의 argmax고
  `confidence`가 그 max다(86/86 확인). 게다가 임계값 미달 취득분은 궤도에서 삭제됐다
- *"CIFAR-10을 공식 배포 채널에서 받았다 / 라이선스된 데이터다"* → 미러는 **비공식 제3자 재배포**이고
  CIFAR-10 상류는 명시 라이선스를 두지 않는다. 정본성 근거는 **torchvision이 기록한 파일 단위 md5**와의
  일치이지 미러의 권위가 아니다
- *"공식 MLPerf Tiny ic01 평가셋"* → 어느 200개인지 밝히지 않고는 쓸 수 없다. EEMBC EnergyRunner가
  제출 채점에 쓰는 200샘플은 **다른 200개**다
- *"ad01 실입력을 저장소에서 재현할 수 있다"* → **네트워크가 필요하다**. 바이트는 배포자가 재배포를
  문서로 거부해 반입하지 않았고, 저장소에는 해시 매니페스트와 획득 스크립트만 있다(E31의 seed 합성
  입력·E26d의 손상 vmfb와 같은 패턴이되 **그 둘은 오프라인 재생성이라는 차이**가 있다)

- *"WGAN 복원 품질(PSNR·SSIM)을 재현했다"* → **재지 않았다**. 저자가 공개한 `denoised/WGAN/full`은
  **JPEG 재인코딩본**이라 수치 기준값이 될 수 없고, 그것을 oracle로 쓰면 재는 것이 모델 동치가 아니라
  **JPEG 왕복 오차**다. E46은 원본 `.tflite`를 oracle로 쓴 의미 동치까지다
- *"D75가 cFS에서 크래시하는 것을 보았다"* → **보지 않았다**. 관측한 것은 실제 컴파일한 코드의
  **스택 프레임 602,136 B와 런타임 변위 602,151 B**이고, 게스트에서 `EXIT=139`를 재현하지는 않았다
  (D52는 실제로 관측됐다 — 둘을 섞지 말 것)
- *"WGAN을 AArch64·cFS·OnAIR에서 실행했다"* → **x86-64 의미 동치와 계약까지다**

- *"순수 OnAIR가 계약을 위반했다 / 메모리를 관리하지 못한다"* → **로드맵 §7.1이 금지하고 E43이 채택했다.**
  순수 OnAIR에 이 연구의 계약은 **없다**. O0의 `admission: null`은 *"이 경로에 그 단계가 없다"*이지
  *"통과"*도 *"결함"*도 아니다
- *"LiteRT보다 메모리를 덜 쓴다 / 계약값이 더 작다"* → **회계 범위가 다르다**(로드맵 §7.5). E43은
  그래서 O0의 메모리를 **아예 재지 않았다**
- *"O0~O3 네 셀을 측정했다"* → **둘은 측정이고 둘은 인용이다**(O2 = E33 `p_admit`, O3 = `p_deny`).
  요약 표가 그 구분을 싣는다
- *"예산이 물리 RAM을 예약한다 / 예산이 cFS 테이블에서 온다 / 임무 설정이 예산을 정한다"* →
  **전부 근거가 없다**(E44). 예산은 앱에 **부여한 값**이고, 예약 능력이 있는 호출은 소스 85파일에서
  **0건**이며(`harness/budget_provenance.py`), `CFE_TBL` 15건은 전부 **cFS 부팅 로그**다.
  기전의 있는 그대로의 이름은 `macro`·`override`·`argv`·`deployment_config`·`none`이다
- *"예약 호출이 있으면 예산이 강제된다"* → **그 승격은 하지 않는다**(E44). 호출이 **있다**는 것과
  그 호출이 **이** 예산을 예약한다는 것은 다르므로 스캐너는 `enforced`가 아니라 **`unknown`**을 낸다
- *"조건부 계층이 예산을 1.94× / 172× 줄인다"*를 **프로세스 RAM 절감으로 쓰지 말 것** →
  **D78**. 그것은 **HAL 디바이스 할당 회계 범위의 진술**이다. map 분기가 없애는 것은 상수의 HAL
  할당이고, 상수 바이트는 모듈 이미지 안에서 두 분기 모두 **세션 내내 프로세스 RAM에 상주**한다
  (두 C 실행기가 vmfb 전체를 읽어 `iree_allocator_null`로 넘긴다). 우리 원자료가 그것을 보인다 —
  SmartCam 조건부 셀은 `hal_peak 602,112`인데 같은 레코드의 `process_rss_kb 17,160`
  (= 17,571,840 B)이 승인 예산 9,382,092 B의 **1.873배**이고 그 시점 **추론 0회**다
- *"E44의 A5 `declared`는 저장소에서 유도된 값이다"* → **맞지만 그 유도가 재현되는지 보는 가드가
  있을 때만**(D77). E44는 유도값만 출하했고 가드를 빠뜨려, 자기 가드 시험의 fixture가 유도를 뒤집는
  상태로 출하됐다. 지금은 라이브 재실행↔커밋 산출물 일치를 검사한다
- *"계약이 map/copy 두 분기와 64바이트 정렬 전제를 선언한다"* → **범위를 붙이지 않으면 쓸 수 없다**(E49 축 C).
  E40이 신설한 `analysis_domain`은 **그 이후 생성분만** 싣는다 — 보관 계약 **30개 중 1개**(E46 WGAN)이고
  **배포에 쓰인 세 실물 모델의 계약에는 없다**. 게이트를 약화시키지는 않지만(driver 검사는 fail-closed)
  그 문장은 *"E40 이후 생성되는 계약이 선언한다"*까지다
- *"구조적 walker는 미인식 op을 전부 `unresolved`로 올린다"* → **D86이 반증했다.** 그 walker도
  `stream.resource.`·`stream.tensor.` **두 계열만** 분류하고 나머지는 `continue`였다 — D84와 같은 한계다.
  지금은 `stream.async.*`를 보고하지만, 그것은 **E49 ledger가 측정한 계열에 한해** 좁힌 것이고
  `stream.cmd.*`·`stream.timepoint.*`는 여전히 분류 대상이 아니다(할당하지 않는다는 관측에 근거)
- *"보관 IR의 마지막 entry print에 `stream.async.*`가 0회다"* → **D87로 정정**. 25개 중 **2개**
  (`dynamic` x86-64·AArch64)가 **각 6개**를 갖는다. 그것은 결함이 아니라 **정직한 모양**이고,
  그 계약이 말하는 `bound_method=NONE`이 정답이다
- *"E49 ledger가 계약의 전제를 강제한다"* → **아니다**. ledger는 **네 실물 모델만** 보는 감사 도구이고
  `make_contract.py`에 연결돼 있지 않다. 계약 생성 경로의 강제는 **구조적 walker ↔ 정규식 파서의 필수
  크로스체크**가 한다(D86)
- *"ADM 8/8은 추론이 시작·차단됐다는 관측이다"* → **아니다**(D88). `execution_authorized_by_policy`는
  **정책 함수의 판정에서 유도**된 값이다. 관측된 추론 수는 E48·E36의 실행 로그에 있다
- *"계약 도구가 미인식 resource op을 전부 `unresolved`로 올린다"* → **두 계열에 한해서다**(D84).
  `static_mem_bound.py`의 정규식은 `stream.(resource|tensor).*`만 보고 `stream.async.*`·`cmd`·`timepoint`는
  **스캔조차 하지 않는다**. 오늘 안전한 이유는 post-layout entry에 async가 0회이기 때문이고 그것은
  **관측**이다 — E49 ledger가 그 조건을 검사한다
- *"배포가 `max_in_flight_calls = 1`을 지키는 것을 관측했다"* → **아니다**(E49 축 B). 센 것은 **소스의
  작업·스레드 생성 호출 0/0/0**이고 그것은 **논증**이다. invoke 진입·종료의 call id 기록이 없으므로
  `observed_value`는 `null`이다

- *"DeepAE의 FAIL은 x86-64 전용이다 / AArch64가 더 정확하다"* → **E48이 반증·금지했다.** 두 ISA가
  **정확히 같은 한 샘플**에서 실패하고 argmax도 같다(517 == 517). 실패 원소 수가 다르다고(46 vs 94)
  어느 쪽이 옳은지 단정할 수 없다 — **제3의 기준값이 없다**(E45 §2.4). 쓸 수 있는 것은
  *"그 FAIL은 x86 전용 현상이 아니다"*까지이고 원인 귀속은 R2/E49의 질문이다
- *"거부 셀에서 런타임이 만들어지지 않았음을 앱이 직접 기록한다"* → **아니다**(D80). 저장소는 그 사실을
  `mem_init` 레코드의 **부재**로 추론한다. 그 전에는 `stack` 레코드로 추론했고 **E16이 그 레코드를 자원
  획득 이전으로 옮긴 뒤 양방향으로 틀려 있었다**. 직접 신호는 여전히 없다
- *"실입력 셀도 조건부 계층에서 검증했다"* → **E48은 무조건 계층만 썼다**(`admission_mode` 전부
  `unconditional`). SmartCam 조건부 셀은 E38의 것을 **인용**한다

- *"이 자료는 이 환경에서 조달할 수 없다"* → **어느 경로를 재 봤는지 함께 적지 않으면 쓸 수 없다**
  (E45 D74 · E47). E39a의 *"전 외부 호스트 `EGRESS_BLOCKED`"*는 **두 호스트 시험**에서 내린
  일반화였고, `raw.githubusercontent.com`은 열려 있었다

중심 주장 문장은 `docs/EVIDENCE_v0.9_E14_stage1.md` §11.8의 정오표 반영 개정판을 그대로 쓴다
(이 파일 맨 위에 인용됨) — 재편은 **다음에 무엇을 할지**의 순서를 바꾼 것이지 기존 판정을
바꾼 것이 아니다.

### 참고 — TFLM 착수 이력 (**종결됨. 재개 대상 아님**, 실험 아님)

> **이 절은 이력이다.** v0.29에서 TFLM은 이 논문의 필수 baseline에서 빠졌다(위 R-2 정정 참조).
> 아래의 Bazel 의존성 우회 인수인계 경로(`grpc` 오버라이드를 계속하는 것)는 **더 이상 다음
> 작업이 아니다.** 노동집약적 우회를 재개하지 말 것 — 그것은 핵심 논증(MLIR 기반 AI 실행
> 메모리 admission)을 바꾸지 않는다.

**전제 확인(1차 문서 대조, TFLM 빌드/측정 없음)**:
[`micro_interpreter.h`](https://github.com/tensorflow/tflite-micro/blob/main/tensorflow/lite/micro/micro_interpreter.h)의
`arena_used_bytes()` 주석 원문 — *"Returns the actual used arena in bytes. This method gives the
optimal arena size. It's only available after `AllocateTensors` has been called."* 즉
**`Invoke()` 없이 `AllocateTensors()`만으로 유효한 값**이라는 점에서 우리 `bounded_bytes`
(post-layout 슬랩 크기, 추론 미실행)와 **같은 부류**다("TFLM은 런타임 계측만 준다"는 첫 확인은
부정확했다 — 정정). 다만
[`docs/memory_management.md`](https://github.com/tensorflow/tflite-micro/blob/main/tensorflow/lite/micro/docs/memory_management.md)는
이 값을 **"For debugging only"**로만 표기하고, 우리가 `bounded_bytes`에 대해 확보한 종류의
건전성 근거(60/60 실측 일치, 경계값 시험)를 TFLM 문서는 제시하지 않는다 — "모든 유효 입력에 대한
상한임을 증명한다"는 주장은 TFLM 공식 문서 어디에도 없다. **비교의 전제는 참이지만 그 수치의
건전성은 TFLM 쪽에서 직접 확인해야 하는 새로운 질문이다**(우리 `bounded_bytes`도 D2·D3을 거쳐
검증됐음을 상기 — 같은 함정을 TFLM 비교에도 적용할 것).

**빌드 착수 시도(host 빌드 성공 못 함)**: TFLM은 Makefile 빌드를 더 이상 제공하지 않고
**Bazel(bzlmod) 전용**이다(예제도 별도 저장소로 이관). `arena_used_bytes()`를 직접 assert하는
`micro_interpreter_test.cc`를 타깃으로 시도했으나, 이 세션의 GitHub 접근 브로커가
`git clone/fetch`(smart-HTTP)는 허용하면서 Bazel의 `http_archive` tarball 다운로드
(`codeload.github.com`, `bcr.bazel.build`)는 **일괄 403**으로 막았다. 우회는 가능함을 확인했다
(의존성마다 `git clone` + 수동 `BUILD.bazel`/`REPO.bazel` + `--override_repository`로 4단계 진행:
`bats-core`·`flatbuffers`·`kissfft` 통과, `grpc`에서 멈춤 — `testing` 패키지의 pip 요구사항 로딩
때문에 끌려온 대형 의존 트리). **원리적 불가능이 아니라 의존 트리 깊이를 사전에 알 수 없는
노동집약적 우회 작업**이다. 인수인계 경로: `/root/tflite-micro-work/tflite-micro`(클론),
`/root/tflite-micro-work/bin/{bazel-real,bazelisk}`(bazel 8.7.0),
`/root/tflite-micro-work/bazel_overrides.sh`, `/root/tflite-micro-work/{bats-local,flatbuffers-src,kissfft-src}`.
다음 작업은 `grpc` 오버라이드를 같은 패턴으로 계속하는 것.

**환경 참고**: 이 컨테이너는 세션마다 새로 시작되며 `~/onair-mlir-bench`(cFS 빌드, IREE C 런타임,
AArch64 게스트 이미지)가 비어 있을 수 있다. H-1은 `iree-compile`(동일 커밋 필요)과
`results/e14_aarch64_qemu/`의 보관 산출물만으로 재구축 없이 완료했다(`harness/contract_negative_tests.py`
로 재검증 가능). H-2는 x86-64(`scripts/10`+`40`+`50`, v0.11)와 AArch64 게스트
(`scripts/60`+`61`+`70`+`71`+`51`, v0.12) 둘 다 이 세션들에서 재구축해 완료했다 — AArch64 게스트
부팅은 이번엔 ~170초로 정상 완료됐고 크래시가 재발하지 않았지만(§9 한계 유지, 안정성을 일반화하지
않음), 표본은 여전히 작다. 게스트 아티팩트(`~/onair-mlir-bench/ext/cfs-aarch64-exe/`,
`~/onair-mlir-bench/ext/guest/`)는 `results/`에 보관하지 않았다 — 재현하려면 위 스크립트를 다시
실행해야 한다.

## 저장소 지도

```
CLAUDE.md                 ← 지금 이 파일
PROGRESS.md                v0.3.1 시점 한 장 요약 (v0.4 이후는 REPORT_v0.4.md, 이후는 EVIDENCE_v0.7 참조)
REPORT_v0.4.md              v0.4 총괄 + v0.5 정정 부록
EXPERIMENT_LOG.md           ★ 실험 레지스트리 + 가설 판정 이력 + 반증 원장 + 결함 원장 (가장 먼저 읽을 파일)
CHANGELOG.md                 버전별 변경 (판정:/정정: 접두어)
docs/
  ASSUMPTIONS_AND_SCOPE.md    ★ 연구 가정과 유효성 범위(확정) — 보안이 아니라 실험 유효성·재현성
  reviews/                    ★ 원본 연구노트 + 외부 검토 전부 (인용됨, 원문 보존)
    research_note_v0.1.md       최초 연구노트 (엄격 검토 대상이 됐던 원본)
    direction_v0.3_judgment.md  실험 결과 기반 방향 판단
    PROGRESS_v0_3_REVIEW.md      v0.3 외부 검토 (D2 발견)
    REPORT_v0_4_REVIEW.md         v0.4 외부 검토 (D3 발견, E13 제안)
    REVIEW_v0_6_E13_RESEARCH_DIRECTION.md  v0.6 외부 검토 (D5-D7 발견, 계약 결합 요구)
    REVIEW_v0_22_E25.md            v0.22/E25 외부 검토 (주장 범위 4곳·판정 도구 1곳 지적)
    ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md ★ 여덟 번째 외부 분석서 — P1(SmartCam 반입)만 먼저 종료하라는 순서와
                               SQUEEZE 처리 원칙(§5 조건 1–7). v0.33/E30이 그대로 따랐다
    BENCHMARK_PLAN_REFERENCE_BASED.md ★ 레퍼런스 기반 벤치마크 구성 지침 (B0-B4) — 전제 검증
                               결과는 docs/plans/E26_boundary_utility.md §1 참조
  STATUS.md, MVP_RESULT.md   초기 환경 구축, 첫 go/no-go
  EVIDENCE_v0.1.md            E0-E4: OnAIR 통합, 모델 크기 스윕, lowering 설정 효과
  EVIDENCE_v0.2_E5.md         E5: lowering 특성화 (일부 v0.3에서 철회됨 — D1 결함)
  EVIDENCE_v0.3_E6.md         E6/E6b/E6c: 정적 메모리 상한, 가중치 베이킹 정정
  EVIDENCE_v0.4_E7.md         E7/E8: admission checker, 동적 형상 거부
  EVIDENCE_v0.5_E9.md         E9/E10: 할당 구조 4사례 (D3 결함 발견·수정), 경계값
  EVIDENCE_v0.6_E11.md        E11/E12: Native C 변형, cFS 앱 통합 (최초)
  EVIDENCE_v0.7_E13.md        계약-아티팩트 결합, 계측 정정, E13 LLVM/ELF 코드 대응
  EVIDENCE_v0.8_E14_aarch64.md 교차 ISA(x86-64/AArch64) 계약 건전성, Stage 0
  EVIDENCE_v0.9_E14_stage1.md  qemu-system-aarch64 게스트 + cFS-in-guest + 모델셋 확장, Stage 1
                               (§11 정오표: 외부 검토 2건 반영, A5b 미실행·7/7 범위·스택 gate 아님 등)
  EVIDENCE_v0.10_E15.md        계약 도구 fail-closed 전환 + 음성 시험(51/51 PASS), D12-D14 수정
  EVIDENCE_v0.11_E16.md        C 게이트 보강(스택 실거부·blob 크기 선검사), x86-64 native_std 실기동 검증, D15 수정
  EVIDENCE_v0.12_E17.md        AArch64 게스트 재현: A5b 최초 실행(3레벨), A2 경계값, 재시작 2회+DELETE, D11 실제 해소
  EVIDENCE_v0.13_E18.md        구조적(비정규식) 할당 추출기 = MLIR API 기반 post-processing
                               verifier 1단계, iree.compiler.ir API (§7 정오표: 명칭·_walk() 서술 정정)
  EVIDENCE_v0.14_E19.md        같은 verifier의 2단계: 구조적 추출기를 make_contract.py에 필수
                               크로스체크로 결선(대체 아님), 14/14 프로덕션 경로 재검증, 85/85
                               (§8 정오표: E20이 발견한 과잉 거부 결함 2건 정정)
  EVIDENCE_v0.15_E20.md        E19 크로스체크 적대적 리뷰 + 과잉 거부 결함 2건(D16·D17)
                               실제 재현·수정, 회귀 시험 고정, 96/96
  EVIDENCE_v0.16_E21.md        외부 검토(v0.15) fail-open 결함 6건(F1/F2/F3/F5/F6/F7,
                               D18-D23) 실제 재현·수정, revert-confirm-fail, 107/107
  EVIDENCE_v0.17_E22.md        F9 재현성 실제 확보 — 실제 git clone 재현(D24 크래시
                               버그 발견·수정), dump/ 커밋, requirements.txt·CI 신설
                               (§6 정오표: 그 시뮬레이션은 "모듈만 없는 환경"이었음, E23이 정정)
  EVIDENCE_v0.42_E38.md       ★ 최신. E38/D69 — 조건부 opt-in이 어디에도 독립 기록되지 않아 판정이 설정의 유일한
                               근거였다(순환). 세 기록 신설(런타임 `build_config` · 빌드 `-D` 목록 · 바이너리 witness),
                               검토가 정한 대로 그 두 셀만 재실행. 보관 바이너리는 `Init`에서 정확히 12개 명령 차이
  EVIDENCE_v0.41_E37.md       E37 — 주장 고정·증거 연결표·재현 확인·등급 분리 (§10 정오표: MLIR 문장을 관측 범위로
                               좁힘, 조건부 셀 opt-in 근거의 순환을 E38이 해소)
  EVIDENCE_v0.38_E35.md       ★ 단계 5 — 공정한 기준선: 24셀 전부 판정 동일(불일치 0), 세 수치·커널 스택 4/4.
                               결론은 MLIR 우위가 아니라 주장 범위의 축소 (§7 정오표: 4구성=3모델, 스택 일치는 독립성 근거 아님)
  EVIDENCE_v0.37_E34.md       단계 4 — ResNet·DeepAE 확장: 새 하네스 0·모델별 분기 0·재컴파일 0. DeepAE argmax는 상수라 변별력 0
  EVIDENCE_v0.36_E33.md       단계 3 — NASA OnAIR 공식 로더 4셀 PASS, 코어 변경 0
                               (§10 정오표 D60: Q4의 "해제" 철회 → 메모리 해제 미검증, 원자료가 nanobind 누수 경고를 남기고 있었다)
  EVIDENCE_v0.35_E32.md       단계 2 — SmartCam AArch64 cFS: Q1·Q2·Q4 PASS, Q3 조건부 계층 미달(stage_2_complete=false).
                               D58(과잉 거부: 과정렬 프레임 복귀 미인식) · D59(fail-open: 승인 근거 아닌 값과 비교)
  EVIDENCE_v0.34_E31.md       P2 — SmartCam 원본 의미 보존 PASS: 원본 TFLite oracle ↔ IREE, 111원소 전부
                               사전 고정 기준 통과. OR 규칙이 판정을 좌우했고, 음성 대조가 argmax 단독 판정의 위험(92% 오통과)과
                               경계 입력의 원리적 한계(상수는 순열 불변)를 실측으로 보였다
  EVIDENCE_v0.33_E30.md       P1 — OPS-SAT SmartCam 반입 타당성: 원본 무수정, SQUEEZE 차단 재현, C1–C4 검사
                               변환기 확장, 한 번의 iree-compile, 계약 오버라이드 0, TRANSFORM_REQUIRED → GO, P2 의무(NCHW·배치 1)
                               (§8 적대적 검증: E30b/D56 — 부분 squeeze의 조용한 전치 → C5 신설)
  EVIDENCE_v0.32_E29b.md      D54 — E29 조건부 검증이 크기 비교라 constants<per_call에서 fail-open.
                               E29 회귀 시험이 그 비교식을 pin하고 있었다. append 전 정렬 검사 + != 0 분기 판정으로 수정
  EVIDENCE_v0.31_E29.md        조건부 계약 — try_map 분기 결정 요인 = 모듈 이미지의 64바이트
                               정렬(64/64셀 위반 0). 제어 시 map 피크 = per_call 정확히, cFS 예산 172배 감소.
                               D53(승인 근거 예산과 검증 기준이 달라 생기는 fail-open)을 출하 전 차단
  EVIDENCE_v0.30_E28.md        D52 — admission 게이트 자신의 fail-open(게이트가 통과시킨 뒤
                               SIGSEGV). 부수로 B2·B3 cFS 셀 완주
  EVIDENCE_v0.29_E27.md         R-3 답 — 정상 8/8은 (b)=(c), 차이는 교란에서만.
                               MLIR의 기여는 정확도가 아니라 독립적인 두 번째 정보원(D51 포함)
  EVIDENCE_v0.28_E26f.md        E26-ext 완결 — 상수 지배형(171:1) 실물 모델에서
                               Q1·Q2·Q3 성립, 배포 간 tightness 172.30x (최대 실측)
  EVIDENCE_v0.27_E26e.md        E26-ext — 실물 MLPerf Tiny ResNet에서 Q1·Q2·Q3 재현,
                               같은 vmfb가 배포에 따라 두 분기(2.00x vs 1.00x), 컴파일 비재현성, D50
  EVIDENCE_v0.26_E26c.md        E26c/D49 — 다중 출력 과잉 거부 수정(subview 봉쇄 검사),
                               revert-confirm-fail 2단계(7건/4건), 실물 fixture, 244/244
  EVIDENCE_v0.22_E25.md        R-1 완결 — canonical 모델로 다섯 경로 의미 동치,
                               네 IREE 경로 비트 동일(AArch64 포함, 일반화 금지), PASS
  EVIDENCE_v0.21_E24c.md       외부 검토 v0.20/E24b F1-F5 — 확인된 4건 수정(D41-D44),
                               F1은 리뷰 권고가 위조 경로로 악화시킴을 실측해 미채택.
                               F4 실물 근거 보존(results/e24c_manyconst31/). 191/191
  EVIDENCE_v0.20_E24b.md       외부 검토 v0.19-재정리본 R1-R5 — 음수 스택(claim
                               blocker로 상향)·자기모순 bounded·shape 충돌·subset-sum tri-state·
                               override trust(D35-D40). 리뷰 처방 1건은 실측 과잉거부로 미채택. 170/170
                               (§12 정오표: "unsigned 비교" 원인 서술 철회, E24c가 정정)
  EVIDENCE_v0.19_E24.md        외부 검토 v0.18-후속 N1-N6·S5 — fail-closed 불변식 4건
                               (D28-D30), E23이 출하한 과잉거부 회귀(D31), 하네스 거짓경보(D32).
                               리뷰 제안 3건은 실측 과잉거부로 범위 축소. 142/142
  EVIDENCE_v0.18_E23.md        외부 검토 잔여 4건(F4/F8/F10/F11) + CI가 잡은 신규
                               크래시 D25. A5a·A5b 손상 방식 코드화(D26), OnAIR 바인딩
                               게이트(D27), 125/125
  plans/E14_stage1_qemu_system_cfs.md  E14 Stage 1 원 계획 (완료됨, v0.9 참조)
  plans/E25_same_model_equivalence.md  E25 계획·사전 고정 기준 (완료됨, v0.22 참조)
  plans/E25_closeout_E26_E27.md  E25 정정·E25b·E26·E27 계획 (Phase A/B/C-3 완료, 상단 진행표 참조)
  plans/E27_mlir_contribution.md ★ E27 계획 — 사전 관측이 R-3의 전제를 반증했다:
                               아티팩트만 보는 분석기가 3.11에서 계약 수치를 정확히 재현한다.
                               따라서 물어야 할 것은 정확도가 아니라 교란 조건에서의 정직성
  plans/E26_boundary_utility.md  ★ E26 사전 고정 기준 — 벤치마크 포트폴리오(B0/B2/B3 채택,
                               B1 전제 정정, B4 기각), 반입 경로, Q1~Q3 판정, tightness의
                               try_map 분기 가설. 결과보다 먼저 커밋됨
scripts/
  00_env.sh                   의존성 설치 + POSIX mqueue 한계 상향 (컨테이너 필수)
  10_build_cfs.sh              cFS 클론·빌드 (native_std)
  11_run_cfs.sh                 cFS 기동
  20_setup_onair.sh              OnAIR 설치 + 예제 실행
  30_setup_iree.sh                IREE 컴파일러/런타임 (pip, Python 바인딩)
  40_setup_iree_source_runtime.sh  ★ IREE 런타임 소스 빌드 (x86-64, native_learner/cfs_app가 링크할 것)
  50_wire_cfs_ai_learner.sh        AI_LEARNER 앱을 cFS native_std에 배선·빌드 (x86-64)
  51_build_cfs_aarch64.sh          ★ AI_LEARNER 포함 cFS를 AArch64로 크로스빌드 (native_std와 별도 트리)
  60_setup_aarch64_cross.sh          AArch64 크로스 툴체인 + qemu-user (시스템 에뮬레이션 아님)
  61_build_iree_runtime_aarch64.sh   IREE 런타임 AArch64 크로스 빌드
  62_compile_and_check_aarch64.sh    E14 Stage 0 재현 (컴파일→구조분석→qemu-user 확인)
  70_setup_qemu_system_aarch64.sh    ★ AArch64 게스트 이미지·cloud-init·mqueue 준비
  71_boot_guest_aarch64.sh           ★ 게스트 부팅/재부팅 (stderr 캡처, setsid+nohup)
  72_guest_ssh.sh                     게스트 ssh/scp/stop 헬퍼
  73_console.sh                       게스트 양방향 시리얼 콘솔 (emergency-mode 등 ssh 안 될 때)
  99_bootstrap_all.sh              ★ 전체 순서 실행 (x86-64 기준; aarch64는 60-62, 70-73 별도 실행)
harness/                    실험 스크립트
  e49_alloc_ledger.py         ★ E49: 계약의 I·O·T·C 를 **IR op 단위로 추적**해 계약값과 대조한다(지침 §5
                               SND-1/SND-2). 생산 파서를 고치지 않고 **같은 IR 을 독립적으로** 훑는다 — 계약 30개가
                               그 출력에 pin 돼 있기 때문. **D84**: entry 안에 `stream.async.*`(할당하는 pre-scheduling
                               op)가 있으면 거부한다 — 파서의 정규식이 `resource|tensor` 두 계열만 보므로 그것이
                               파서 한정이 안전한 조건이고, 검사하는 곳이 없었다. 상수는 두 분기의 **최댓값**(합 아님)
  e49_audit_matrix.py         ★ E49: 전제 상태 · 회계 범위 · admission 매트릭스(ADM-1~8)를 유도한다.
                               ADM 셀은 **실제 `admission_policy.py` 로 평가**하므로 정책이 바뀌면 표가 바뀐다.
                               측정하지 않은 전제는 `null` + `unavailable_reason` — **0 이나 false 로 대체하지 않는다**
                               (지침 §11; D29·D51·D68). `max_in_flight_calls` 는 `ARGUED_FROM_SOURCE` 다:
                               소스에서 생성 호출을 세는 것은 논증이지 관측이 아니다
  mk_e25_inputs.py            ★ E48: fixture → 게스트 `/cf/e25_inputs.bin` + replay_order. 샘플마다 **manifest의
                               배열-바이트 sha256**과 대조하고 불일치·원소 수 불일치는 거부(계획 §6 P1). 레이아웃은
                               값(`--layout`)이지 모델 분기가 아니다. 첫 판이 `.npy` **파일**을 해시해 정직한 fixture
                               셋을 전부 거부했다 — 유형 (B)이고, 판정에 닿기 전에 잡았다
  mk_e48_summary.py           ★ E48: 실입력 AArch64 셀의 Q1~Q5 판정. 판독기를 `mk_e36b_summary`에서 **import**한다
                               (복사 금지 — 같은 원자료를 읽는 두 구현으로 갈라지지 않게). x86-64 판정은 **인용**이고
                               인용한 파일명을 함께 싣는다(D65)
  budget_provenance.py        ★ E44: 예약 능력이 있는 호출 8종(mlock·mlockall·MAP_POPULATE·MAP_LOCKED·
                               CFE_ES_PoolCreate·CFE_ES_GetPoolBuf·CFE_ES_RegisterCDS·OS_MemPoolCreate)을 **소스만**
                               훑어 E39a 비교표의 A5를 유도한다(로그를 세면 cFS 부팅 로그의 CFE_TBL 15건을 오보고한다 — 실제 사례).
                               0건이면 `declared`, hit가 있으면 **`enforced`가 아니라 `unknown`**(호출의 존재 ≠ 이 예산의 예약, E28/D52)
  optin_witness.py            ★ E38: 빌드 산출물(`ai_learner.so`)에서 조건부 opt-in을 읽는다 — 소스도 빌드 명령도
                               아니라 **최종 바이너리**를 본다. `AI_LEARNER_Init`에서 `CONTRACT_PER_CALL_BYTES`(또는 −1)와의
                               비교가 조건부 분기로 이어지는지 찾는다. **양성 대조 선행**: 같은 매처가 무조건 `bounded`
                               비교를 찾지 못하면 `false`가 아니라 `undetermined`(D25·D29 계열). 게이트가 아니라 관측기
  mk_e38_summary.py           ★ E38: 재실행 두 셀을 게스트 로그에서 유도해 Q1~Q5를 판정. 값은 앱이 스스로 남긴
                               레코드에서만 읽는다(mk_e36_summary의 `stages()`를 그대로 재사용 — D68 포함)
  mk_evidence_linkage.py      ★ E37: 세 실물 모델 × 7항목 증거 연결표 생성기 — 값은 전부 원자료에서 읽고
                               못 읽은 셀은 사유와 함께 남긴다. admission 셀은 **하위 키마다** 확인한다(D63:
                               부모 객체 단위 resolve가 키 결손을 present로 통과시켰다). 거부·BUDGET_INVALID
                               셀의 null 은 같은 레코드의 **양성 신호**가 허가할 때만 값으로 센다
  e37_reproduce_check.py      ★ E37: 최종 고정 코드로 보관 원자료를 **다시 판정**해 보관 판정과 대조(13셀).
                               필드 이름이 `rejudged_at_final_version`이지 `rerun`이 아니다 — 게스트 부팅·
                               cFS 기동·추론은 재현하지 않는다
  mk_e36b_summary.py          ★ E37/D64: E36b 요약을 게스트 로그·계약·비교 JSON에서 유도(이전엔 손조립이라
                               DENY 셀의 `inferences`가 부재했다). D68: 잘려서 파싱 안 되는 레코드도 **관측으로
                               센다** — `run_records` + `run_records_unparseable`
  static_mem_bound.py, admission_check.py, platform_check.py 등  E0-E13 기반 도구
  make_contract.py            ★ SAME iree-compile 호출 산출물에서만 계약 JSON 생성 (one-invocation 검증,
                               fail-closed: layout IR↔dump-dir 결합·ABI/triple/ELF 불일치 hard fail, E15;
                               구조적 추출기 필수 크로스체크 E19 — 불일치/파싱실패 hard fail, 미설치는 skip;
                               비교 기준 p/const_b로 수정 E20, D16·D17; 빈 dump-dir·ABI 반사 부재·
                               구조적 검증기 미설치도 기본 hard fail E21, D18·D19·D20;
                               ELF 분석의 음수 스택 거부·truthiness 승격 제거 E24b D35, subset_sum
                               tri-state E24b D38, waive()로 적용된 override 기록 E24b D39)
  elf_stack_frame.py          ★ IREE embedded-ELF 정적 분석 (x86-64/AArch64 공통 정의, EVIDENCE_v0.9 §5 근거)
  gen_contract_header.py      계약 JSON → C 헤더 (contract_gen.h; fail-closed 검증 E15; 스택 불신뢰
                               분류 거부 E21 D22, CONTRACT_DTYPES_ALL_F32 신설 E21 D23;
                               스택 신뢰 신호 '부재'도 UNKNOWN E24 D29, dtype을 스키마 필수
                               단수형에서도 읽어 공허참 차단 E24 D30; 음수 스택 거부 D35,
                               bounded==per_call+const 강제 D36, validity↔interface shape 대조 D37,
                               override 계약 기본 거부 + CONTRACT_PROVENANCE_VERIFIED E24b D39)
  contract_negative_tests.py  ★ 계약 도구 음성·단위·회귀·구조적 추출기 일치·크로스체크 배선·과잉거부·
                               fail-open·손상방식·OnAIR 바인딩·불변식·워크플로우 YAML·override 기록
                               회귀 시험(E15+E18+E19+E20+E21+E23+E24+E24b). v0.20 CI 실측:
                               full 169/169+1 SKIP · without-iree 85/85+9 · stdlib-only 85/85+9,
                               크래시 없음(E22+E23 D24·D25, E24 N6·D33). 이 컨테이너는 PyYAML이
                               있어 170/170
  p1_tflite_inventory.py      ★ E30/P1: TFLite flatbuffer 기계 판독 인벤토리(tflite 스키마 패키지만; I/O·op 히스토그램·
                               SQUEEZE 인스턴스 C1–C4·정적 형상·cFS 인터페이스 적합). 모델을 변환하지 않는다
  tflite2onnx_ext_squeeze.py  ★ E30/P1: tflite2onnx SQUEEZE 변환기 확장 — C5는 축 위치 논증이 아니라 **시뮬레이션**이다
                               (D57: 논증이 과잉 거부·fail-open 양방향으로 틀렸다). check_squeeze_conditions()(순수 함수)가
                               C1–C4 전부 참일 때만 변환, NHWC→NCHW 축 재색인 후 C1 재검사, 위반은 SqueezeConditionError.
                               두 방출 모드(Squeeze / 정적 Reshape)는 linalg부터 바이트 동일
  p1_tflite_to_onnx.py        ★ E30/P1: 위 확장을 등록해 변환하고 transform_manifest.json(해시·서명·감사)을 쓰는 래퍼.
                               initializer·value_info를 이름순 정렬(tflite2onnx가 set()으로 내보내 실행마다 바이트가 달랐음)
  p1_smoke_pip_runtime.py     ★ E30/P1: pip iree.runtime 스모크 — 결과를 버리는 호출로 HAL 피크를 먼저 읽고(호스트 읽기가
                               버퍼를 붙듦, D50) 그 다음 출력·결정성·읽은 뒤 통계를 기록. 타당성 기록이지 판정 도구가 아니다
  model_fixture.py            ★ E31/P2: 두 경로가 공유하는 입력 fixture — 원본 config의 전처리, NHWC→NCHW **전치**
                               (왕복·순열 실효성 자기검사; 값이 아니라 arange 라벨로 형상만 판정), manifest에 해시·출처
  tflite_oracle.py            ★ E31/P2: 원본 .tflite를 LiteRT로 그대로 실행해 **전체 출력** 기록(기준값)
  iree_runner.py              ★ E31/P2: 같은 fixture로 vmfb 실행, 전체 출력 기록. **HAL 피크는 일부러 보고하지 않는다**
                               (호스트 읽기가 버퍼를 붙드는 D50 조건에서 메모리를 함께 재면 잘못 보고하게 된다)
  e31_compare.py              ★ E31/P2: 계획 §4를 코드로 적용 — 원소별 abs/rel OR + argmax, argmax 단독 판정 금지.
                               FAIL도 rc=0(판정은 결과이지 도구 오류가 아니다), 샘플 집합이 다르면 판정 대신 REFUSED
  gen_tflite_squeeze_cases.py ★ E30b/D56: 합성 TFLite SQUEEZE 사례 11건 생성기(NHWC 입력 → 1x1 AvgPool → SQUEEZE) — C5를
                               정당화한 모델(부분 squeeze의 조용한 전치)의 in-tree 재현(D43). 비행 모델엔 없는 형상
  e30b_squeeze_probe.py       ★ E30b: 사례 1건을 확장에 통과시켜 CONVERTED/REFUSED/CRASH를 보고하고, --iree면 컴파일·실행해
                               TFLite 의미(np.squeeze)와 비트 대조. revert-and-confirm-fail용 프로브이지 게이트가 아니다
  e29_align_probe.c           ★ E29: 같은 파일 바이트를 정렬 클래스별 주소에 적재하고 append 직후 HAL
                               피크만 읽는 계측기 — 그 시점엔 입력 버퍼도 추론도 없어 상수 블록 단독이다.
                               **기준 계측기이므로 fail-closed 가드를 넣지 말 것**(E27 기준선과 같은 이유)
  e29_collect.py              ★ E29: 위 프로브를 8모델 × 8 정렬 클래스로 돌려 D1(이분성)·D2(결정 요인)를
                               판정. 제3의 피크 값이 나오면 두 분기 모델 자체가 반증된다
  e29_no_posix_memalign.c     ★ E29 시험 shim: posix_memalign을 실패시켜 E29 이전 동작(copy 분기)을
                               재현하고, 조건부 계층의 거부 경로(앱이 스스로 정렬하므로 달리 도달 불가)를 연다
  e26_collect.py              ★ E26: 사전 고정 기준을 셀별로 적용하는 수집기 — Q1(peak<=bounded)·
                               Q2(try_map 분기 가설)·Q3(예산 경계) 판정과 core/ext 층 분리
  e27_baseline_source_tensors.py ★ E27 기준선 (a): 소스 `.mlir`만 보는 추정기. 재사용·정렬·할당
                               스케줄을 모르므로 3.04x~7.29x 과대(과소는 구조상 불가).
                               **기준선이므로 fail-closed 가드를 넣지 말 것**(docstring에 명시)
  e27_baseline_vmfb_only.py   ★ E27 기준선 (b): 배포된 vmfb만 보는 추정기. 정상 조건 8/8에서 계약값과
                               정확히 일치하지만, 컴파일러 버전 드리프트에서 `alloca_unresolved=[]`로
                               **읽지 못한 것을 없다고 보고**(152x 과소). 같은 이유로 가드 금지
  e27_baseline_vmfb_only_hardened.py ★ v0.31 정오표: 같은 정보원(vmfb + iree-dump-module)의
                               fail-closed 변종. 정직한 7개 정확 일치·과잉 거부 0, 드리프트는 C4_DISASM 거부 —
                               E27의 침묵이 정보 수준이 아니라 출하 구현의 성질이었음을 보인다. 기준선이지 게이트가 아니다
  e27_collect.py              ★ E27: 네 정보 수준 x 네 조건 수집기. 셀을 value/explicit_refusal/
                               silent_wrong으로 분류하고, **입력 부재를 거부로 세지 않도록**
                               tool_error를 분리한다(D51) — `collection_clean`이 판정의 일부
  gen_model_multiout.py       ★ E26c/D49: 다중 출력 모델 생성기 — IREE가 결과 2개를 한 슬랩에
                               패킹하고 subview로 쪼개는 실물 근거. 비-splat 가중치(상수 실재)와
                               서로 다른 크기의 결과 2개(봉쇄 검사가 우연히 만족되지 않도록)가 의도적
  gen_model_manyconst.py      ★ E24c/F4: 상수 다수 모델 생성기 — D38(24세그먼트 절단 제거)의
                               실물 근거. 16x32 tail로 두 번째 dispatch를 강제(없으면 dump 파일명에
                               mlir basename이 없어 one-invocation 검사가 정당하게 거부)
  corrupt_vmfb.py             ★ E23: A5a(flip)·A5b(flatbuffer_root_uoffset) 손상 방식 실제 구현 —
                               ZIP64/STORED 외과적 패치 + CRC 갱신, corruptsha 계약 생성, 미인식 method 거부(D26)
  mlir_alloc_walk.py          ★ E18: 구조적(비정규식) 할당 추출기 — iree.compiler.ir API, 14/14 정규식 파서와 일치;
                               E19부터 make_contract.py의 필수 크로스체크로 결선됨(대체 아님);
                               E20: diff_against_regex 공유 헬퍼로 통합(3곳 중복 제거);
                               E21: stream.resource.pack 비상수 슬라이스 unresolved 처리 수정(D21)
  e14_matrix.py                모델×타깃 컴파일·계약추출 파이프라인 (compile/extract 단계)
  cross_target_compare.py      타깃 간 계약/ELF 비교표
  gen_model_conv2d.py, gen_model_multibranch.py  Stage 1 모델 생성기 (베이킹 가중치)
  e14_cfs_scenarios.py, e14_make_scenarios.py     게스트 cFS 시나리오 실행기/생성기
                               (E23: 시나리오의 corrupt_method 필수화 — 누락·미인식이면 거부, D26)
  cfs_cmd.py                    cFE CI_LAB UDP 명령 전송 (A7 재시작/삭제 시나리오용)
contracts/                  계약 스키마 + 채워진 예시 (v0.4 memory_boundary 결정, v0.7 artifact binding)
models/                     기본 MLIR 모델
plugins/                    OnAIR AIPlugin 구현체 (compiled_learner=IREE, python_learner=NumPy 베이스라인)
  compiled_learner/artifact_binding.py  ★ E23: 계약-아티팩트 바인딩 게이트(크기→sha256, stdlib 전용) —
                               C 경로와 같은 순서·같은 거부 조건, verify_artifact_hash=True 기본(D27)
native/                     Python 없는 C 경로: native_learner.c, cfs_app/ (cFS 앱 소스) — 둘 다 계약
                             헤더만으로 모델 독립적(v0.9); cfs_app/toolchain-aarch64-linux-gnu.cmake
e13/                        LLVM IR·ELF 덤프 (x86-64 host/generic 설정 비교)
e14/                        교차 ISA 검증 (aarch64/ = Stage 0 산출물)
results/e26_boundary_utility/  ★ E26 계열 전체: 사전 고정 기준(docs/plans/E26_boundary_utility.md),
                             instrumentation_check/, x86_64|aarch64/{native,cfs,pip_runtime}/,
                             mlperf_tiny_{resnet,vww}_fixture/, x86_64/ext_b{2,3}_*/ (실물 워크로드
                             단일 호출 산출물 + 측정), aarch64/a5b_canonical/, comparison/, summary.json
results/e38_optin_record/    ★ E38: `x86_64_cross_check/`(형제 스크립트의 같은 D61(b) 결함을 고치고 3단계 빌드로
                             실측 — `=1` 다음의 미설정 빌드가 산출물에서 0을 증언) · `e36_binaries/`(E36이 실제로 출하한 두 `ai_learner.so` + 각각의
                             build_info·CMakeLists·witness — 소급 판정을 in-tree에서 재현하기 위한 것이고, 두
                             `app_knobs`가 동일하다는 **결함 자체**도 여기서 고정된다) · `cells/`(재실행 두 셀의 raw log) ·
                             `trees/`(재빌드 두 트리의 build_info·witness) · `trees.json`(게스트에서 계산한 `.so` 해시까지) ·
                             `native_requested_vs_applied.json` · `summary.json`
results/evidence_linkage/   ★ E37: linkage.{json,md}(3모델 × 7항목, 원자료 참조 121건) +
                             reproduce_check.json(최종 코드 재판정 13셀). **직접 편집 금지** — 생성기 산출물
results/e37_evidence_consolidation/s_cfs_post_d61/  ★ E37 §5: 게스트 재실행이 실제로 필요했던 유일한 셀
                             (SmartCam cFS 등가 모드, D61 이후 코드). raw log·출력·판정, E32와 판정·totals·
                             최악 원소 동일. `e25_inputs.bin`은 결정적 재생성이라 미보존
results/e31_smartcam_equivalence/  ★ E31/P2: 공유 fixture(manifest + 실이미지 3·경계 2의 .npy; 합성 32는 seed 31에서
                             비트 재생성되므로 미보존, 시험이 sha256으로 대조), 두 경로의 전체 출력, 판정, 음성 대조
results/p1_smartcam_feasibility/   ★ E30/P1: OPS-SAT SmartCam 비행 모델 원본(무수정, 8,950,028 B) + source_manifest·
                             operator_inventory·import/(import_log step 1–8, 변환 매니페스트 2, squeeze ONNX)·build/
                             (mlir.gz·vmfb·layout IR·ELF·계약·헤더·기준선·스모크·축소 dump 123)·variant_reshape/equivalence.json·
                             feasibility_summary.json. 38 MB. 시험이 원본에서 ONNX·linalg sha256과 계약을 매번 재생성해 대조
results/e29b_conditional_verify/   ★ E29b/D54: constants < per_call인 유일한 보관 fixture(bigact, 단일 호출) +
                             native 5셀·cFS 3셀 수정 전/후 raw log + summary.json
results/e29_conditional_contract/  ★ E29: 64셀 정렬 스윕(align_sweep.json), 7모델 before/after
                             (native_sweep.jsonl), cFS 4셀 raw log(cfs/), revert 기록, summary.json
results/e27_baselines/      ★ E27: iree310_mlp16k/(버전 드리프트 실물 근거)와 summary.json
                             (네 정보 수준 x 네 조건의 셀별 판정)
results/e26c_multiout/      ★ E26c/D49: 한 번의 iree-compile 호출 산출물(128 KB) — bounded 704
                             = per_call 192 + constants 512, HAL 실측 피크 704(tightness 1.00x).
                             dump/는 축소본(.o/.bc/.s 없음 → .gitignore 트랩 회피)이며 보관 계약이
                             이 축소본에서 그대로 재생성됨(시험이 매번 확인)
results/e26_boundary_utility/aarch64/a5b_canonical/  ★ E26d: 계획 §5-3의 A5b_canonical 게스트 실행
                             (계약·raw log·판정 JSON). 손상 vmfb는 결정적이라 저장하지 않고 시험이 재생성
results/e24c_manyconst31/   ★ E24c/F4: 한 번의 iree-compile 호출 산출물(440 KB) — 33개 data
                             세그먼트(embedded 1024 B 슬랩 32 + external 1), 상수 총량 33792 B.
                             invocation.json에 argv·컴파일러 버전·sha256·관측 세그먼트 목록.
                             dump/는 축소본(.o 없음 → .gitignore 트랩 회피, 계약 수치는 동일 재생성)
results/e14_aarch64_qemu/   ★ E14 Stage 1 전체 산출물: environment/, models/, {aarch64,x86_64}/(계약·ELF·
                             헤더·objdump·llvm_ir·vmfb), native/(qemu-user 결과), cfs/(게스트 시나리오
                             결과), comparison/(교차 타깃 비교)
results_*.json               각 실험의 원자료 (git 추적됨 — 재실행 없이 분석 재현 가능)
```

## 환경 구축 (최초 1회, 순서대로)

```bash
bash scripts/99_bootstrap_all.sh
```

내부적으로 하는 일 (개별 실행도 가능):
1. `00_env.sh` — apt 패키지, **`/proc/sys/fs/mqueue/msg_max`를 512로 상향** (기본 10에서는
   cFE SB 파이프 생성이 `errno=22`로 실패해 cFS가 기동하지 못한다. 컨테이너 재시작마다 리셋되므로
   매 세션 다시 실행 필요할 수 있음).
2. `10_build_cfs.sh` — nasa/cFS 클론(`--recurse-submodules`), `make native_std.prep && make native_std.install`.
   **함정**: `cfe/cmake/Makefile.sample`을 번들 루트에 덮어쓰지 말 것 — `Target "hs" not found`로 실패한다.
   번들 자체의 `Makefile`/`sample_defs`를 그대로 쓴다.
3. `20_setup_onair.sh` — nasa/OnAIR 클론, pip 의존성, CSV/Kalman 예제로 스모크 테스트.
4. `30_setup_iree.sh` — `pip install iree-base-compiler iree-base-runtime` (컴파일러 + Python 런타임 바인딩).
5. `40_setup_iree_source_runtime.sh` — **IREE C 런타임을 소스에서 빌드**. `iree-compile --version`이
   보고하는 커밋과 **정확히 같은 커밋**을 체크아웃해야 한다(vmfb 포맷·HAL ABI 정합).
   최소 구성(local-sync 드라이버, embedded ELF loader, 스레딩 없음, ukernel 없음) + PIC
   (cFS 앱이 `.so`이므로). 이 저장소 기준 커밋: `e4a3b0405d7d23554da26403658d0e8c3c5ecf25`
   (IREE 3.11.0rc20260316). **버전이 달라지면 이 커밋 해시를 갱신할 것.**
6. `50_wire_cfs_ai_learner.sh` — `native/cfs_app/`을 cFS의 `apps/ai_learner/`로 복사하고
   `targets.cmake`·`generate_startup.cmake`를 패치, 재빌드.

**검증(smoke test)**:
```bash
python3 harness/platform_check.py                          # 이 머신의 증거 등급 확인
cd native && bash build.sh && ./native_learner model_16384_baked.vmfb 1048576 100
cd $HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && ./core-cpu1   # AI_LEARNER 로그 확인
```

## 알려진 환경 함정 모음 (반복하지 말 것)

| 증상 | 원인 | 해결 |
|---|---|---|
| `qemu-system-aarch64`가 로그 없이 죽음 | `-daemonize`는 fork로 부모와 분리돼 stderr가 유실됨 | `71_boot_guest_aarch64.sh`처럼 `setsid nohup … 2> qemu_stderr.log` 사용 |
| 게스트가 emergency mode에서 멈췄는데 원인을 못 봄 | `-serial file:`은 출력 전용이라 입력을 못 보냄 | `-chardev socket,...,server=on,wait=off` + `73_console.sh`(양방향 유닉스 소켓 콘솔) |
| cFS 시나리오 자동화 스크립트가 원격 로그 파일을 못 찾음(scp 실패) | 원격 쉘에서 `cd {remote_root}` 이후에도 상대경로 변수가 `remote_root` 접두어를 다시 붙여 `remote_root/remote_root/...`로 이중화 | `cd` 이후 쓰는 경로는 항상 그 시점의 작업 디렉터리 기준 상대경로인지 확인 |
| cFS 크로스빌드가 "contract sha256 not found in ai_learner.so"로 실패 | UNKNOWN_BOUND 모델은 admission에서 즉시 거부돼 sha256 비교 코드가 도달 불가능 → 컴파일러가 그 문자열까지 제거(-O2) | `CONTRACT_BOUND_KNOWN=0`일 때는 이 검증을 건너뜀(정상 동작의 부작용이지 버그가 아님) |
| 같은 오류가 **정적 형상 모델**에서 남 | 예산을 `bounded−1`로 주면 컴파일러가 admission 실패를 정적으로 판정해 뒤 코드를 죽은 코드로 제거(같은 기전, 다른 방아쇠, E26에서 실측) | 그 조합은 빌드하지 않는다 — DENY 동작은 x86-64 cFS의 `B−1` 셀로 이미 확인됨 |
| 계약 생성 도구가 "one-invocation" 위반(서로 다른 컴파일 산출물 혼합)을 못 잡음 | 검증 로직 없이 `provenance.single_invocation`을 하드코딩 `true`로 기록 | 임베디드 ELF sha256 매칭 + dump-dir 파일명의 입력 basename 포함 여부, 두 독립 신호로 실제 검증(D10) |
| cFS `prep`이 `Target "hs" not found`로 실패 | `cfe/cmake/Makefile.sample`을 번들에 덮어씀 | 번들 자체 Makefile 사용 |
| cFS 기동 시 EVS/ES 초기화 실패 | `/proc/sys/fs/mqueue/msg_max` 기본 10 | `echo 512 > /proc/sys/fs/mqueue/msg_max` |
| cFS 앱 컴파일 에러 (`-Werror=pedantic`, `static_assert` 등) | cFS가 앱에 `-std=c99 -pedantic -Werror` 강제, IREE 헤더는 C11/GNU 확장 필요 | 해당 앱 CMakeLists에 `-std=gnu11 -Wno-pedantic -Wno-error` 추가 |
| `CFE_ES_HK_TLM_MID` undeclared | 헤더 누락 | `#include "cfe_es_msgids.h"` |
| `/cf/model.vmfb` fopen 실패 | `/cf`는 OSAL 가상 경로 | `OS_TranslatePath()`로 실경로 변환 후 fopen |
| IREE 링크 시 `undefined reference to flatcc_verify_error_string` 등 | flatcc/printf 서드파티 라이브러리 누락 | `libflatcc_parsing.a libflatcc_runtime.a libprintf_printf.a`도 링크 |
| IREE 런타임 종료 시 segfault (`iree_vm_bytecode_module_lookup_function`) | 모듈 blob을 세션 해제 **전에** `free()` (D4) | blob은 세션이 zero-copy 참조 — 세션 해제 **후**에 free |
| cmake `check_c_source_compiles` unknown command | 이 IREE 커밋의 ukernel CMakeLists가 include 누락 | `40_setup_iree_source_runtime.sh`가 자동 패치함 |
| CMake `target_link_libraries` plain/keyword 혼용 에러 | cFS의 `add_cfe_app`이 plain 시그니처 사용 | 앱 CMakeLists도 plain 시그니처로 통일 |
| 재컴파일한 vmfb의 해시가 이전과 다름 | **입력 MLIR 파일명이 vmfb 심볼명에 들어감** | 계약·덤프·배치 아티팩트는 한 번의 컴파일 호출에서 생성 |
| 파일명·플래그를 똑같이 맞췄는데도 vmfb 해시가 매번 다름 | `iree-compile`이 스레딩 기본값에서 **바이트 재현적이지 않다**(E26e: 16-dispatch 모델 3회 = 3개 해시, `--mlir-disable-threading` 2회 = 동일). 계약 수치는 동일하고 아티팩트 동일성만 흔들린다 | 측정에 쓴 vmfb를 저장소에 **보존**한다(레시피만으로는 되돌아오지 않음). 재현성이 필요하면 `--mlir-disable-threading` |
| EVIDENCE가 인용한 `results/**/*.log`가 저장소에 없음(시험은 green) | `.gitignore`의 `*.log`를 실험별 allowlist로만 되살려 새 실험 디렉터리의 로그가 조용히 무시됨(D55: E28·E29·E29b 9건) | `!results/**/*.log`(v0.32.1) + `cited_raw_logs_tracked_cases()`가 summary.json 인용 로그의 존재·추적을 검사. 새 실험을 커밋하기 전 `git status --short --ignored results`를 볼 것 |
| 빌드 knob을 `env`로 안 주었는데 이전 빌드의 값이 살아 있음 | `${VAR:+-D...}`는 *"미설정 = 기본값"*이 아니라 *"미설정 = CMakeCache.txt에 남은 지난 값"*이다. `build-native_std`·`build-aarch64_std` 둘 다 호출 간 공유되는 영속 트리다(D61(b), E38에서 형제 스크립트도 같은 모양이었음을 확인) | 기본값을 **항상 명시 전달**하고, `compile_commands.json`에서 실제 도달을 확인하고, 산출물에서 `harness/optin_witness.py`로 되읽어 **빌드를 죽인다** |
| 어떤 설정으로 얻은 판정인지 나중에 알 수 없음 | 그 설정이 텔레메트리·빌드 기록 어디에도 없으면 판정 자체가 유일한 근거가 되어 **순환**이 된다(D69) | 판정에 쓰는 설정은 **판정보다 먼저** 레코드로 남긴다 (`build_config` stage). 거부하는 셀도 남겨야 의미가 있다 |
| HAL `device_bytes_peak`가 계약값보다 조금 큼(분류기가 `refutes_hypothesis`) | 반환된 출력 버퍼를 붙들고 있어 이전 호출분이 해제되지 않음(D50, E26e: per_call + 4×40 B) | 호출마다 결과를 놓아주고 `allocated == freed`인 상태에서 피크를 읽는다 |

## 이 컨테이너(claude.ai)에서 검증됐던 사실과의 관계

이 프로젝트는 원래 claude.ai의 공유 VM(1 vCPU)에서 시작했다. `harness/platform_check.py`가
그 환경을 `FUNCTIONAL_ONLY`로 판정했다 — 즉 **기능 검증은 가능하지만 타이밍 증거는 못 만든다.**
Claude Code 환경(로컬 머신/전용 컨테이너)으로 옮긴 이유가 바로 이것이면, 이관 후 가장 먼저 할 일은:
```bash
python3 harness/platform_check.py
```
이 `PASS`를 반환하는지 확인하는 것이다. **PASS라면** 이 프로젝트가 지금까지 미룬 두 가지
(시간 축 계약, H1/H2의 잔여 가능성 — `EVIDENCE_v0.5_E9.md` §3의 "대형 구간 유리한 신호" 등)를
비로소 시험할 수 있다. 이는 새 우선순위이므로 착수 전 `EXPERIMENT_LOG.md`에 왜 우선순위가
바뀌었는지 한 줄 남길 것.
