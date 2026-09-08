# EVIDENCE v0.15 — E20: E19 구조적 크로스체크 적대적 리뷰 + 과잉 거부 결함 2건 수정

## 0. 등급과 범위

**증거 등급: 결정론적**(재현 성공/실패, 계약 값, 회귀 시험 통과/실패). 이 실험은 코드 리뷰와
그 결과로 발견된 결함의 수정·회귀 시험 등록만 다룬다.

**범위**: `docs/EVIDENCE_v0.14_E19.md`(E19)가 도입한 `make_contract.py`의 구조적 크로스체크
로직을, PR로 올리기 전(브랜치가 아직 main에 merge되지 않은 시점) 다차원 적대적 코드 리뷰로
검증하고, 실제로 발견된 결함을 수정했다. E19 자체의 "1단계 완료" 판정(구조적 추출기가 14/14
보관 모델과 일치)은 이 실험으로 철회되지 않는다 — 14개 모델 전부 `packed_sum==dense_sum`
(padding=0)이라 아래 두 결함이 그 검증에서 드러나지 않았을 뿐이다.

## 1. 방법 — 다차원 적대적 리뷰

E19의 diff(`harness/make_contract.py`의 구조적 크로스체크 블록, `harness/contract_negative_tests.py`의
신규 시험)에 대해 4개 독립 관점(정확성, 시험 커버리지, 단순화/중복 제거, 강건성/상태 관리)의
리뷰어를 병렬로 돌리고, 각 관점이 보고한 finding마다 3인 독립 반박(refute) 검증자를 붙여
과반(2/3 이상)이 반박하면 폐기, 아니면 확인(confirmed)으로 채택했다. 리뷰어에게는 이 프로젝트가
정의하는 결함의 두 방향(A: 잘못된 계약을 조용히 ADMIT, B: 정상 입력을 잘못 거부 — "과잉 거부"도
이 프로젝트에서는 진짜 결함)을 명시했고, 추측이 아니라 실제 코드 실행·재현으로 뒷받침할 것을
요구했다.

결과: **13건 중 11건 확인(confirmed), 2건 반박(refuted)**. 확인된 11건 중 2건이 **실제로
재현 가능한 High severity 과잉 거부 결함**이었다(여러 관점이 서로 독립적으로 같은 두 결함에
수렴 — 버그 A는 2개 관점, 버그 B는 3개 관점이 각각 독립적으로 찾아 재현했다는 것 자체가 강한
신호다). 나머지 9건은 시험 커버리지 공백(4건), 중복 로직(1건), 스타일(1건)이었다.

## 2. 버그 A — 잘못된 비교 기준(`whole` 대신 `p`를 써야 함)

`make_contract.py`는 entry 함수의 여러 print 청크 중 lowering_score로 "가장 진행된" 것을 골라
`p`로 쓰고, 계약의 모든 실제 수치(`bounded_bytes` 등)는 `p`에서만 나온다. 반면 E19가 새로
추가한 구조적 크로스체크는 `structural`을 `whole = smb.parse_alloc_ir(ir, entry)`과 비교했는데,
`whole`은 `static_mem_bound.py` 자신의 문서화된 가정("파일에서 마지막으로 나오는 entry print가
가장 lowering된 것") — 즉 `make_contract.py`의 모듈 docstring이 스스로 "스레드 스케줄링에
좌우된다"고 경고하는 바로 그 가정 — 에 의존한다.

**재현**: 보관된 `results/e14_aarch64_qemu/aarch64/layout_ir/conv2d.layout_ir.txt`에서 entry
함수의 두 print 청크(헤더 포함, 내용은 원본 그대로, 파일상 순서만 교환)를 물리적으로 바꾼 뒤
`make_contract.py`를 실제 CLI로 재실행했다: `p`(계약이 실제로 쓰는 값)와 구조적 추출기는 여전히
완전히 일치했는데도(둘 다 정확히 올바른 값), `whole` 기준 비교는 `['outputs', 'transient_slabs']`
불일치로 판정해 `--allow-structural-mismatch` 없이 `SystemExit`로 계약 생성을 거부했다.

**영향**: 가상의 시나리오가 아니다 — 14개 보관 모델의 `provenance.entry_print_states_differ`가
전부 `true`(entry 함수가 서로 다른 lowering 상태로 최소 2번 프린트됨)이고, 지금까지 우연히 전부
`chosen_idx == last_idx`였을 뿐이다. 재컴파일 시 스레드 스케줄링에 따라 이 우연이 깨지면, **완전히
정상인 모델이 즉시 하드 거부됐을 것**이다.

## 3. 버그 B — 잘못된 비교 기준(`dense_sum` 대신 `const_b`를 써야 함)

`harness/mlir_alloc_walk.py`의 `_extract_constants`는 `stream.resource.alloc`(constant kind) op의
오퍼랜드 크기를 모으는데, 실제 layout IR을 직접 읽어 확인한 바 이 op는 `stream.resource.try_map`
실패 시 폴백 경로에서 **패킹된 전체 상수 버퍼**(`#util.composite<Nxi8>`, `make_contract.py`의
`packed_sum`)를 그대로 할당한다 — 즉 구조적 추출기의 constants 합은 항상 `packed_sum`을 잰다.
반면 E19의 비교는 `dense_sum`(패킹 이전 per-tensor 합)과 비교하고 있었다. `make_contract.py`
자신도 이미 이 둘이 다를 수 있음을 알고(정렬 패딩·중복 제거로 `packed_sum != dense_sum`인 경우가
있다는 기존 주석) `const_b = packed_sum if packed_sum > 0 else dense_sum`을 계산해 실제 계약
값으로 쓴다 — 그런데 크로스체크만 이 값을 무시하고 `dense_sum`을 썼다.

**재현**: 보관된 `results/e14_aarch64_qemu/aarch64/layout_ir/mlp16k.layout_ir.txt`에서 패킹 버퍼
크기를 가리키는 **같은 심볼릭 상수의 모든 참조**(`#util.composite<720896xi8`,
`stream.resource.alloc{%c720896}`, `stream.file.read`/`stream.resource.subview`의 같은 참조 등
8곳)만 720960으로 일관되게 바꾸고(64B 정렬 패딩 시뮬레이션), 개별 텐서의 dense 선언(589824,
131072, 합 720896 그대로)은 건드리지 않았다. `make_contract.py`를 실제 CLI로 재실행한 결과: 수정
전 코드는 `['constants(sum)']` 불일치로 거부, 수정 후 코드는 정상 수락하고 계약이 올바르게
`module_resident_constant_bytes=720960`(패딩 포함 실제 값)을 보고함을 확인했다.

**영향**: 버그 A와 마찬가지로 지금까지 보관된 14개 모델이 전부 `padding=0`이라 드러나지 않았을
뿐 — 정렬 패딩이나 중복 제거가 있는 어떤 모델이든 **영구적으로** 하드 거부됐을 것이다(모델을
고쳐도 해결되지 않는, 도구 자체의 결함).

## 4. 수정

`harness/make_contract.py`의 크로스체크가 `p`(entry 값)와 `const_b`(상수 값)를 기준으로 비교하도록
변경. 부수적으로, 같은 diff 로직이 `harness/mlir_alloc_walk.py`의 `--cross-check` CLI와
`harness/contract_negative_tests.py`의 `structural_walker_checks()`에도 **독립적으로 중복
구현**돼 있었고(리뷰가 실제로 두 곳 모두에서 같은 버그 B를 재현해 확인), 이 드리프트 위험을
없애기 위해 `mlir_alloc_walk.diff_against_regex(structural, regex_based, constants_reference=None)`
공유 함수로 통합했다 — `make_contract.py`는 `constants_reference=const_b`를 넘기고, 독립
진단 도구(CLI, 시험 스위트)는 기본값(자체 dense 합)을 그대로 쓴다(진단 전용이라 이 한계를 문서화만
하고 남겨둠 — 실제 계약 생성 경로가 아니므로 우선순위 낮음). 스타일 finding(중복된 `notes.append`
+ `hard_fail_errors.append` 조건 블록)도 하나로 병합했다(기존 "agrees" 경로에서는 여전히 `notes`에
아무것도 안 남기는 동작을 정확히 보존 — 안 그러면 14개 보관 계약의 `provenance.notes` 리스트가
바뀌어 회귀 시험을 깬다는 것을 직접 확인하고 고침).

## 5. 회귀 시험

`harness/contract_negative_tests.py::structural_bugfix_regression_cases()`(신규)에 버그 A·B의
재현을 **고정 회귀 시험**으로 등록했다 — §2·§3의 텍스트 조작을 그대로 시험 코드에 넣어, 수정된
`make_contract.py`가 두 경우 모두 정상 수락하고 올바른 값을 보고하는지 확인한다. **수정이 실제로
이 조건을 잡는지**(우연히 통과하는 시험이 아닌지) 검증하기 위해, 수정 전 커밋의
`harness/make_contract.py`로 일시적으로 되돌려 같은 시험을 실제로 재실행했고 — 두 시험 모두
실제로 FAIL함을 확인한 뒤 수정본으로 복원했다.

추가로 시험 커버리지 공백 4건(리뷰 finding #4, #5, #7, #11)을 메웠다:
- **dispatches만 다른 경우는 거부하지 않아야 한다**(정보성 필드) — 양성 케이스 추가.
- **`--allow-structural-mismatch`가 "파싱 예외" 분기에서도 작동하는지** — 이전엔 "불일치" 분기만
  시험됨, 예외 분기 오버라이드 케이스 추가.
- **constants(sum) 불일치가 실제로 잡히는지**(inputs만 시험되고 있었음) — 진짜 불일치(패딩이
  아니라 완전히 다른 값)를 몽키패치로 만들어 거부되는지 확인하는 케이스 추가.
- **`iree.compiler.ir` 미설치 시 우아한 저하** — E19 문서(§4)가 수동 확인만 하고 재현 가능한
  시험이 없었던 것을, `mc.maw` 자체를 `ir=None`인 가짜 객체로 치환해 `build_contract()`가
  여전히 성공하고 `bounded_bytes`가 정규식 경로만으로 정상 계산됨을 단언하는 시험으로 등록.
  (이 함수의 기존 "prerequisite" 조기 반환은 나머지 케이스용으로 남겨뒀다 — 그 케이스들은 진짜
  구조적 추출기가 필요하다.)

`harness/contract_negative_tests.py` 85/85 → **96/96**.

## 6. 반박된 finding 2건 (참고, 조치 없음)

- `IGNORE_PROVENANCE_SUBTREES`로 제외된 `structural_walker` 서브트리의 세부 필드가 회귀 검사에서
  직접 단언되지 않는다는 지적 — 사실관계는 맞지만 제시된 실패 시나리오가 재현되지 않아 반박.
- `mlir_alloc_walk.py`의 (entry, initializer) 청크 페어링이 constants를 스코어링에서 제외해
  print 순서에 은밀히 의존할 수 있다는 지적 — 코드상 취약점 존재는 확인되나(3인 반박자 중 검토
  결과 불충분으로 판정), 실제 재현이나 이 프로젝트의 corpus에서 발동 조건 증명에는 이르지 못해
  반박. 후속 조사 대상으로 남겨둠(이 문서에는 기록만, 별도 결함 등록은 하지 않음 — 재현되면
  다시 다룰 것).

## 7. 이번 실험이 다루지 않는 것 (범위 밖)

- §6의 반박된 finding 2건에 대한 추가 조사(재현 시도).
- `mlir_alloc_walk.py`의 `--cross-check` CLI 자체의 버그 B 한계(진단 전용 도구라 `const_b`에
  접근할 수 없어 여전히 `dense_sum` 기준 — §4에서 의도적으로 남김, 문서화만 함).
- E19가 이미 범위 밖으로 남긴 것들(`stream.resource.pack` 실사용 시험, 다른 IREE 버전 재확인)은
  이 실험도 다루지 않는다.

## 8. 판정

E19가 도입한 fail-closed 강화가 두 곳에서 실제로 **과잉 거부**(정상 입력을 잘못 거부)로 이어질
수 있었음을 코드 리뷰와 실제 재현으로 확인하고 수정했다. 두 결함 모두 지금까지 보관된 14개 모델
corpus의 우연한 특성(padding=0, chosen==last) 때문에 드러나지 않았던 잠재 결함이었다는 점에서,
"14/14 일치"가 로직 자체의 건전성을 보장하지 않는다는 이 프로젝트 자신의 반복된 교훈(§CLAUDE.md
"가장 중요한 교훈")이 이번에도 그대로 적용됐다 — 이번엔 외부 검토가 아니라 이 세션 내 적대적
다중 리뷰가 그 역할을 했다. 수정은 실제 되돌리기 검증(revert-and-confirm-fail)으로 뒷받침됐고,
14개 보관 계약은 diff 0으로 유지된다.

## 9. 재현

```bash
python3 harness/contract_negative_tests.py   # structural-bugfix(A)/(B) 포함, 96/96
```
