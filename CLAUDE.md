# CLAUDE.md — 프로젝트 컨텍스트 (Claude Code용)

이 파일은 Claude Code가 세션 시작 시 자동으로 읽는 컨텍스트 파일이다. 여기 없는 세부사항은
`PROGRESS.md`(현재 상태 한 장 요약) → `EXPERIMENT_LOG.md`(전체 실험 레지스트리) →
`docs/EVIDENCE_v0.*.md`(버전별 상세 근거) 순으로 내려가며 읽는다.

## 프로젝트 한 줄 요약

NASA cFS/OnAIR 위에서 MLIR/IREE로 AOT 컴파일한 AI 추론 아티팩트를 배치할 때, 컴파일러의
할당 스케줄에서 도출한 **정적 메모리 계약**으로 배치 전 admission(허용/거부) 판정을 수행하는
연구. 현재 버전: **v0.34**(git tag는 환경 제약으로 보류 — 커밋 이력·CHANGELOG로 확인).
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
**다음은 단계 3**(공식 OnAIR 경로 갱신) → 단계 4(ResNet·DeepAE) → 단계 5(공정한 기준선).

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
cFS 전체 인증. 손상 아티팩트 시험과 결함 원장 51건은 **부록의 보조 증거**이며 본문 기여가
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
> (ii) R-3 "강화안"인 **정규 MLIR pass**(E27 결과를 보고 판단하기로 했던 것 — E27은
> *정보원 수*가 관건임을 보였으므로, pass로 만드는 것이 그 결론을 바꾸지는 않는다는 점을
> 먼저 따져 볼 것). **새 방어 조건 추가는 여전히 실제로 재현된 결함에 한한다.**

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
- *"이 수치는 MLIR이라야 얻는다"* → **E27이 8/8에서 반증했다**
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
  EVIDENCE_v0.34_E31.md       ★ 최신. P2 — SmartCam 원본 의미 보존 PASS: 원본 TFLite oracle ↔ IREE, 111원소 전부
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
