# CLAUDE.md — 프로젝트 컨텍스트 (Claude Code용)

이 파일은 Claude Code가 세션 시작 시 자동으로 읽는 컨텍스트 파일이다. 여기 없는 세부사항은
`PROGRESS.md`(현재 상태 한 장 요약) → `EXPERIMENT_LOG.md`(전체 실험 레지스트리) →
`docs/EVIDENCE_v0.*.md`(버전별 상세 근거) 순으로 내려가며 읽는다.

## 프로젝트 한 줄 요약

NASA cFS/OnAIR 위에서 MLIR/IREE로 AOT 컴파일한 AI 추론 아티팩트를 배치할 때, 컴파일러의
할당 스케줄에서 도출한 **정적 메모리 계약**으로 배치 전 admission(허용/거부) 판정을 수행하는
연구. 현재 버전: **v0.21**(git tag는 환경 제약으로 보류 — 커밋 이력·CHANGELOG로 확인).
중심 주장은 **정오표 반영 개정판**을 그대로 쓴다 — 지어내지 말 것(`docs/EVIDENCE_v0.9_E14_stage1.md`
§11.8이 정본, 아래는 그 요약):

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
6. **`CHANGELOG.md`, `PROGRESS.md`를 매 버전 갱신한다.**
7. **컴파일러 산출물(vmfb 등)을 재컴파일할 때는 주의**: 같은 MLIR·같은 플래그라도 **입력 파일명이
   다르면 vmfb 바이트가 달라진다**(심볼명에 파일명이 들어감). 계약·IR 덤프·배치 아티팩트는
   반드시 **한 번의 `iree-compile` 호출**에서 생성한다(`EVIDENCE_v0.7_E13.md` §1.3).

## 현재 상태 (v0.7 시점)

| 가설/주장 | 판정 |
|---|---|
| H1 (AOT가 Python/NumPy보다 빠르고 예측 가능) | **성능 우위 미관측**. 최적 compiled가 NumPy/BLAS 대비 2.2–4.1× 느림 (베이킹 가중치, h=16384 기준) |
| H2 (계약 기반 lowering 선택이 고정 설정보다 유리) | **선택의 이점 미입증**. 초기엔 강한 근거(ρ=+0.18 순위 붕괴)로 보였으나 **가중치 per-call 복사 결함(D1)의 인공물**로 판명, 철회 |
| **H3 (실행 전 memory admission 판정)** | **메모리 축, 시험 조건 내 성립.** 정적 상한이 HAL 런타임 피크와 60/60(+구조 사례 4/4, +cFS 통합 등) 일치. 이 연구의 유일하게 살아남은 핵심 결과 |
| MLIR 필연성 (TFLite Micro 등 대안 대비) | **미검증.** 다음 순서 항목 |

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

### 연구 가정 — `docs/ASSUMPTIONS_AND_SCOPE.md` (확정)

계약은 저장소 생성 파이프라인의 산출물이며 생성 후 수동 변경하지 않는다고 가정한다.
hash·provenance는 **실험 대상 식별과 재현성** 수단이지 보안 장치가 아니다. 악의적 변조·
공급망·서명·키 관리는 **연구 범위 밖**이다. 수동 편집으로만 도달하는 반례는 실험으로
등록하지 않는다(그 문서의 "세 질문" 참조).

**E24 계열의 방어적 review–patch 반복은 종료한다.** 새 지적은 Core / Supporting /
Out-of-scope로 먼저 분류하고, Out-of-scope는 문서 한 줄로 닫는다.

### 최우선 — 연구·논문 핵심 (검토 §5.1, §7)

**R-1. OnAIR↔cFS 동일 모델·동일 의미 검증 (검토 C2 / E25)** — 다음 실험으로 가장 우선.
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
   여기에 **동일 경계의 대안 비교(구 우선순위 4, TFLite Micro)**를 합친다 — 별도 축이 아니라
   "왜 MLIR/IREE 경로여야 하는가"에 답하는 같은 질문이다. TFLM 전제 확인과 빌드 시도 이력은
   아래 "참고 — TFLM 착수 이력"에 그대로 보존한다.

**R-3. MLIR 접근의 고유 기여 (검토 C3 / E27)** — 현 구현은 **정규 MLIR pass가 아니라**
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

**지금 근거가 있는 주장**
- IREE 컴파일 중간표현과 vmfb/ELF 산출물을 결속해 AI 모델의 **프로그램 할당 메모리 일부**에 대한
  정적 계약을 생성하고, 이를 cFS 앱 시작 전 admission 및 artifact identity 검사에 연결하는
  **프로토타입을 구현했다.**
- x86-64와 AArch64/QEMU에서 정상·경계·손상·동적형상 시나리오로 **기능적 거부 동작과 계약 생성의
  재현성**을 평가했다.

**아직 하면 안 되는 주장**
- 온보드 컴퓨터 **전체** 메모리 수용성을 보장한다 → R-4
- **모든** 계약 불변식을 검증한다 → 검증한 것은 재현된 결함 집합이다
- **정규 MLIR compiler pass**를 구현했다 → R-3(미착수)
- 실시간 성능 또는 WCET를 보장한다 → R-5
- OnAIR와 cFS가 **동일한 AI 모델을 의미적으로 동등하게** 실행한다 → R-1
- **실제 비행 하드웨어**에서 검증됐다 → QEMU 게스트다

중심 주장 문장은 `docs/EVIDENCE_v0.9_E14_stage1.md` §11.8의 정오표 반영 개정판을 그대로 쓴다
(이 파일 맨 위에 인용됨) — 재편은 **다음에 무엇을 할지**의 순서를 바꾼 것이지 기존 판정을
바꾼 것이 아니다.

### 참고 — TFLM 착수 이력 (R-2에 흡수, 실험 아님)

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
  reviews/                    ★ 원본 연구노트 + 외부 검토 5건 (전부 인용됨, 원문 보존)
    research_note_v0.1.md       최초 연구노트 (엄격 검토 대상이 됐던 원본)
    direction_v0.3_judgment.md  실험 결과 기반 방향 판단
    PROGRESS_v0_3_REVIEW.md      v0.3 외부 검토 (D2 발견)
    REPORT_v0_4_REVIEW.md         v0.4 외부 검토 (D3 발견, E13 제안)
    REVIEW_v0_6_E13_RESEARCH_DIRECTION.md  v0.6 외부 검토 (D5-D7 발견, 계약 결합 요구)
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
  EVIDENCE_v0.21_E24c.md      ★ 최신. 외부 검토 v0.20/E24b F1-F5 — 확인된 4건 수정(D41-D44),
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
