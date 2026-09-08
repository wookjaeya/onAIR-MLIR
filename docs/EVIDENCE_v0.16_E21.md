# EVIDENCE v0.16 — E21: 외부 검토(v0.15) fail-open 결함 6건 수정 (F1, F2, F3, F5, F6, F7)

## 0. 등급과 범위

**증거 등급: 결정론적**(재현 성공/실패, 계약·헤더 값, 회귀 시험 통과/실패). 코드 실행 재현과
그 결과로 발견된 결함의 수정·회귀 시험 등록만 다룬다.

**범위**: `docs/reviews/REVIEW_v0_15_LATEST.md`(기준 커밋 `6e9ac10`, E15–E20 코드·근거 문서·
보관 산출물 검토)가 제기한 11개 finding(F1–F11) 중, 이 세션 내 11개 독립 검증 에이전트로
각각 실제 코드 실행·재현을 통해 confirmed(또는 partially_confirmed) 판정된 것 중 **코드 수준
fail-open 결함 6건**(F1, F2, F3, F5, F6, F7)을 수정했다. 나머지(F4 표현 정정, F8 원자료·재현성,
F9 fresh-clone 재현성, F10 OnAIR 바인딩 갭, F11 이미 알려진 한계 재확인)는 각각 별도 실험
(E22, E23)으로 다룬다.

## 1. 검증 방법

11개 finding 각각에 독립 에이전트를 배정해 병렬로 검증했다 — 리뷰의 주장을 그대로 반영하지
않고, 인용된 코드를 직접 읽고 리뷰가 "실제로 실행한 결과"라 제시한 재현을 **동일 조건으로 다시
실행**해 확인하는 방식(이 프로젝트가 앞선 두 차례 외부 검토에서도 써 온 방법). 결과:
**11건 중 confirmed 9건, partially_confirmed 1건(F3), not-a-defect 1건(F11, 이미 알려진 한계의
재확인)**. severity는 리뷰의 원 평가(대부분 P0)와 다르게 일부 하향 조정됐다(F2, F3, F4, F5는
검증 에이전트가 P1로 재평가 — 근거는 각 항목 참조).

## 2. F1 — 빈 `--dump-dir`가 one-invocation 신호를 전부 `None`으로 만들어도 계약이 써짐

`make_contract.py`의 one-invocation 검사(`dump_elf_in_vmfb`, `stem_in_dump`,
`layout_dispatches_in_dump`)는 3값 논리(True=확인됨, False=불일치 확인됨, None=확인 불가)인데,
거부 조건이 `is False`뿐이었다 — `--dump-dir`가 완전히 비어 있으면 세 신호 전부 `None`이 되고,
`invocation_errors`가 비어 있으므로 통과했다. **재현**: `--dump-dir`를 빈 임시 디렉터리로 준
채 저장된 conv2d 아티팩트로 실행 → exit 0, 스키마 검증까지 통과, `single_invocation: false`인데도
그 사실을 설명하는 note가 하나도 없이 계약이 정상 기록됨.

**수정**: `dump_files`가 비어 있으면 `invocation_errors`에 추가해 기본 하드 실패(신규
`--allow-unverified-invocation`으로만 우회). "불일치를 못 찾음"과 "동일 호출임을 확인함"을
구분하지 못하던 것을, 다른 세 신호와 같은 hard-fail 경로로 통일했다.

## 3. F2 — ABI 반사(`iree.abi.declaration`)가 아예 없으면 불일치와 달리 거부되지 않음

`abi is None`(반사 문자열 자체가 없음) 분기는 `notes`에만 기록하고 `hard_fail_errors`에는
아무것도 넣지 않았다 — `abi_matches == False`(있는데 다름) 분기만 `--allow-abi-mismatch` 없이
하드 실패였다. **재현**: 저장된 conv2d layout IR에서 `iree.reflection = {iree.abi.declaration =
...}` 절만 제거하고 실행 → exit 0으로 정상 기록(`single_invocation: true`,
`abi_declaration_matches_source: null`), 컴파일러 자신의 반사 크로스체크가 통째로 생략된 채
소스 시그니처만 신뢰.

**수정**: `abi is None`도 `--allow-missing-abi-declaration`(신규)으로만 우회 가능한 하드 실패로
승격. (검증 에이전트는 리뷰의 severity를 P1로 재평가 — 재현 자체는 정확했으나 원 리뷰의
"BUILD_SUCCEEDED" 필드명이 실제 계약 스키마에 없는 등 표현상 근사가 있었을 뿐, 핵심 결함
판정에는 영향 없음.)

## 4. F3 — "필수 구조적 크로스체크"가 패키지 미설치 시 조용히 정규식 단독으로 저하

`iree.compiler.ir`가 설치돼 있지 않으면 `structural_available=False`가 되고, 기존 코드는 이를
`notes`에만 기록한 채 정규식 파서 단독으로 계약을 정상 기록했다. **검증 결과**:
기술적 재현(패키지 없으면 계약이 정상 써짐, `structural_walker.available=false`)은 리뷰 그대로
사실이었지만, 이 동작이 "은폐된 결함"이라는 리뷰의 프레이밍은 과장으로 판정됐다 — 이 정확한
예외가 모듈 docstring·인라인 주석·CLI `--help`·`EVIDENCE_v0.14_E19.md` §4 전용 절·
`EXPERIMENT_LOG.md` E19 행 다섯 곳 모두에 이미 명시돼 있었고, E19 세션이 동일한 몽키패치로
직접 검증까지 해뒀다("의도적으로 설계·시험·문서화된 opportunistic 동작"). 다만 "MANDATORY라
부르면서 실제로는 opportunistic"이라는 정책적 불일치 자체는 타당한 지적이다.

**수정**: 이 프로젝트의 fail-closed 원칙과 "mandatory"라는 표현을 일치시키기 위해, 패키지
미설치도 기본 하드 실패로 변경(신규 `--allow-missing-structural-checker`로만 우회). 이는
F9(재현성, E22)와 직접 상충하는 트레이드오프임을 인지하고 있다 — `iree.compiler.ir`가 없는
환경에서는 이제 이 플래그 없이 어떤 계약도 생성할 수 없다. E22에서 이 트레이드오프를 다룬다.

## 5. F5 — `stream.resource.pack`의 비상수 슬라이스 크기가 조용히 사라짐

`harness/mlir_alloc_walk.py`의 `stream.resource.pack` 처리는 형제 분기(`stream.tensor.import`,
`stream.resource.alloca`)와 달리 `_resolve_index_value()`가 실패(비상수)해도 `unresolved`에
넣지 않고 그냥 버렸다 — 코드 자신의 주석("unresolved ones are reported, not skipped")과 실제
동작이 모순. **재현**: IREE 상류(`iree-org/iree` `StreamOps.td`, `resource_ops.mlir`)에서 실제
`stream.resource.pack` 어셈블리 문법을 확인해 진짜 연산(상수 슬라이스 1개 + `arith.addi` 결과인
비상수 슬라이스 1개)을 `ir.Module.parse()`로 실제 파싱, `_extract_from_entry()`를 직접 호출해
`unresolved=[]`(비상수 쪽이 사라짐)를 확인.

**수정**: 형제 분기와 같은 `(bucket if ok else unresolved)` 패턴으로 통일. 새 `--allow-*` 플래그는
불필요(이미 `unresolved`가 비지 않으면 `make_contract.py`의 `all_static`/`bound_method` 판정이
자동으로 `UNKNOWN_BOUND`로 fail-closed 처리하는 기존 경로를 그대로 탐). **완화 요인**(검증
에이전트가 severity를 P1로 재평가한 근거): 현재 배선(E19)에서는 `diff_against_regex()`의
`unresolved(presence)` 비교가 정규식 파서(이미 이 경우를 올바르게 처리)와의 불일치로 이 버그를
실제로 잡아낸다 — 즉 오늘 시점에 이 버그 하나만으로 잘못된 ADMIT이 조용히 나가지는 않는다(이중
방어가 우연이 아니라 실제 작동함을 확인). 다만 `mlir_alloc_walk.py`가 향후 정규식 파서의 진짜
대체가 되거나 `--cross-check` 없이 단독 사용되면 그대로 과소추정된 무음 bound가 된다.

## 6. F6 — 스택 분석이 "불신뢰"로 자체 분류해도 헤더는 `KNOWN=1`

`harness/gen_contract_header.py`는 스택 값이 정수인지만 확인했다 — `elf_stack_frame.py`
자신의 `classify()`가 `kernel_stack_classification`(예: `bucket_4_unaccounted_dynamic_stack`),
`kernel_dynamic_stack_alloc`, `kernel_external_call_insns`로 "이 숫자는 신뢰할 수 있는 상한이
아니다"라고 명시적으로 말하는 경우조차 무시했다. **재현**: 저장된 conv2d 계약을 복사해 이
세 필드만 "불신뢰" 값으로 바꾸고(정수 스택 값 자체는 그대로) 실행 → exit 0,
`CONTRACT_KERNEL_STACK_BYTES_KNOWN 1`인 헤더가 그대로 생성됨.

**수정**: `kernel_dynamic_stack_alloc`가 참이거나 `kernel_external_call_insns`가 0이 아니거나
`kernel_stack_classification`이 `none`/`bucket_2_task_stack_budget`이 아니면 `stack_known`을
강제로 `False`로 만들어, 기존 `--allow-unknown-stack` 경로로 동일하게 fail-closed 처리(부재와
불신뢰를 같은 게이트로 통일, 새 플래그 불필요). 에러 메시지도 "필드 없음"과 "필드는 있지만
분석이 불신뢰로 표시함"을 구분해 더 정확하게 남기도록 갱신.

## 7. F7 — cFS C 게이트가 "single-f32"라 주장하지만 실제로는 개수만 검사

`native/cfs_app/fsw/src/ai_learner.c`·`native/native_learner.c`의 인터페이스 검사 조건은
`CONTRACT_NUM_INPUTS/OUTPUTS`만 보고, 이벤트 메시지/주석은 "single-f32-in/out"이라 서술했다 —
dtype을 나타내는 매크로 자체가 헤더 생성기에 없어 C 코드가 애초에 검사할 방법이 없었다.
정상 경로(파이썬 생성기가 dtype 불일치를 먼저 거부)에서는 안전하지만, 이는 주석 자신이 명시한
"stale 또는 hand-edited contract_gen.h" 위협 모델을 커버하지 못한다. **재현**: 저장된 mlp16k
계약의 dtype만 "i8"로 바꾸면 헤더 생성기가 정상 거부됨을 확인(정상 경로는 안전) — 그러나
헤더 자체에 dtype 매크로가 없어 "개수는 맞지만 dtype만 stale"한 손수정 헤더를 C가 잡을 수
없음을 코드로 확인.

**수정**: `gen_contract_header.py`가 `CONTRACT_DTYPES_ALL_F32`(0/1) 매크로를 새로 방출.
`ai_learner.c`/`native_learner.c` 양쪽의 필수 매크로 `#error` 가드와 인터페이스 검사 조건에
추가해, 메시지가 주장하는 바를 실제로 검사하게 했다. 보관된 14개 헤더 fixture와 checked-in
예시 헤더(`native/contract_gen.h`, `native/cfs_app/fsw/src/contract_gen.h`, 후자는 이미
최신이었고 전자는 Stage 1 이전 macro set이 누락된 stale 상태였음 — 이번에 실제
`gen_contract_header.py` 재실행으로 함께 갱신)를 재생성.

## 8. 검증 방법론

각 수정은 (1) 실제 코드 실행으로 결함 재현, (2) 최소 수정 적용, (3) 새 회귀 시험 등록,
(4) **수정 전 코드로 되돌려 새 시험이 실제로 실패하는지 확인**(revert-and-confirm-fail, E20과
동일 방법론) 순서로 진행했다. F1/F2/F6/F7은 `git show`로 이 실험 이전 커밋의 파일을 가져와
교체 후 재실행, F5는 `mlir_alloc_walk.py`만 이전 버전으로 교체 후 재실행 — 6건 모두 새로 추가한
시험이 정확히 실패함을 확인한 뒤 수정본으로 복원했다(`git status` clean 확인).

`stream.resource.pack`(F5)의 회귀 시험은 이 프로젝트의 모델 corpus에 해당 op가 전혀 없어
기존 14개 layout IR로는 만들 수 없었다 — 대신 IREE 상류 소스(StreamOps.td 어셈블리 포맷,
resource_ops.mlir의 실사용 예시)를 직접 확인해 손으로 지어낸 것이 아닌 실제 문법의 MLIR을
합성하고, `ir.Module.parse()`가 IREE 자체 검증기로 이를 통과시킴을 확인한 뒤 사용했다.

`contract_negative_tests.py`가 96/96 → **107/107**로 확장됐다(F1: 2건, F2: 2건, F3: 3건 갱신,
F5: 1건, F6: 4건, F7: 1건, 그 외 기존 시험이 요구하는 헤더 macro set 재생성으로 인한 fixture
갱신). 부수 발견: 이 시험 스위트 자신에도 결함이 있었다 — `base_cmd()`가 `--extra-args`(뒤에
오는 모든 토큰을 iree-compile 인자로 그대로 삼키는 특수 인자) 뒤에 `extra_flags`를 붙이고
있어, 이번에 처음 `--allow-*` 플래그를 `extra_flags`로 전달하려 하자 그 플래그가 실제
argparse에 도달하지 못하고 조용히 삼켜졌다(발견 즉시 수정: `extra_flags`를 `--extra-args`
앞으로 이동).

## 9. 이번 실험이 다루지 않는 것 (범위 밖)

- **F4**(정규 MLIR pass 표현 정정), **F8**(E16/E17 원자료·A5b 재현 코드화),
  **F10**(OnAIR↔native/cFS 바인딩 갭), **F11**(이미 알려진 한계 재확인) — E22/E23으로 이연.
- **F9**(fresh-clone 재현성) — E21의 F3 수정이 F9의 문제를 더 악화시킬 수 있음(패키지 없는
  환경에서 이제 계약 생성 자체가 기본 거부됨)을 인지하고 있으며, 이 트레이드오프는 F9를
  전담하는 E22에서 함께 다룬다.
- F5의 `--allow-*` 플래그 부재는 의도적 판단(기존 `unresolved` 기반 fail-closed 경로가 이미
  충분)이며, 재검토 여지는 있으나 이번 범위에서는 결정하지 않았다.

## 10. 판정

외부 검토(v0.15)가 제기한 fail-open 결함 6건을 전부 실제 재현 후 수정하고, 각 수정이 실제로
결함을 잡는지 되돌리기 검증으로 확인했다. 이 중 3건(F2, F3, F5)은 검증 과정에서 원 리뷰의
severity가 과대평가였음이 밝혀졌다(F3은 프레이밍 자체가 과장, F5는 실제 프로덕션 경로에서
이미 이중 방어로 완화됨) — 이는 "외부 검토를 곧이곧대로 반영하지 않고 먼저 재현으로
확인한다"는 이 프로젝트의 방법론이 이번에도 유효했음을 보여준다. `contract_negative_tests.py`
107/107, 보관 14개 계약·헤더는(의도된 신규 macro 제외) diff 0 유지.

## 11. 재현

```bash
python3 harness/contract_negative_tests.py   # F1/F2/F3/F5/F6/F7 관련 신규 시험 포함, 107/107
```
