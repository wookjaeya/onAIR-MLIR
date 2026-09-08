# EVIDENCE v0.13 — E18: 정규 MLIR pass — 구조적(비정규식) 할당 추출기 (1단계)

## 0. 등급과 범위

**증거 등급: 결정론적**(파싱 성공/실패, 추출된 수치, 회귀 비교). 이 실험은 IR 텍스트 처리와 API
호출만 다룬다.

**범위**: 이 실험은 CLAUDE.md 우선순위 3번("정규 MLIR/IREE pass")의 **1단계**다 — 자원 할당 크기
추출을 정규식 대신 IREE의 실제 MLIR Python API(`iree.compiler.ir`)로 재구현하고, 보관된 14개
아티팩트에서 기존 정규식 파서(`static_mem_bound.py`)와 값이 일치함을 확인했다. `make_contract.py`
파이프라인의 나머지 부분(one-invocation 검증, ABI/triple 대조, 스키마 검증 등)은 이번 범위 밖이며
계속 정규식/도구 조합을 사용한다. **재컴파일 없음** — 보관된 v0.9의 `layout_ir` 파일만 사용해
one-invocation 규칙(작업 규율 7)을 그대로 지켰다.

## 1. 배경

`docs/EVIDENCE_v0.10_E15.md` §5와 `docs/EVIDENCE_v0.9_E14_stage1.md` §11.9가 남긴 한계: E15가
`static_mem_bound.py`를 fail-closed로 만들었지만 여전히 정규식 기반이다 — "미인식 op를 화이트리스트로
잡는다"는 안전장치 자체가 **정규식이 텍스트에서 op 이름을 올바르게 뽑아낼 수 있다는 전제**에 기대고
있었다. 두 외부 검토와 제안서(§4)가 요구한 다음 단계는 텍스트가 아니라 컴파일러 내부의 실제
Operation·Type·SSA 표현을 직접 순회하는 것이다.

## 2. 기술적 장벽과 해법

`--mlir-print-ir-after=iree-stream-layout-slices`가 만드는 layout IR은 **함수별로 조각나
출력된다**(패스가 건드리지 않은 op는 재출력되지 않음 — `--mlir-disable-threading`을 추가해도
조각남 자체는 그대로임을 재확인, 이건 프린트 *순서*의 결정성 문제였을 뿐 프린트 *단위*의 문제가
아니었다). entry 함수 청크는 다른 청크(`util.initializer`)가 정의하는 전역(`util.global.load
@__hoisted_tensor_...`)을 참조하는데, 그 **선언 자체**는 어느 청크에도 없다 — `ir.Module.parse()`가
"undefined global"로 거부한다.

해법: `util.global.load`/`store` 줄(자원 할당 op가 아니라 딱 이 두 종류만)에서 이름과 타입을 모아
`util.global private [mutable] @name : type` 선언을 합성해 앞에 붙인 뒤, entry 함수 청크와
`util.initializer` 청크를 하나의 `module { ... }`로 합쳐 파싱한다. **이 전처리 한 단계만 텍스트
처리이고, 그 이후의 모든 크기 추출은 실제 API**다:

- 자원 op 열거: `Operation.walk()`로 얻은 진짜 `op.name`(예: `stream.resource.alloca`) — 텍스트
  패턴이 아니라 컴파일러가 부여한 식별자.
- 크기 추출: 인쇄된 `{%c8}` 같은 텍스트가 아니라, `op.operands[0]`(index 타입 SSA 값)을
  `Value.owner`로 정의 지점까지 따라가 `arith.constant`의 `value` 속성을 직접 읽는다(define-use
  체인). 상수가 아닌 값(예: block argument, `arith.muli`의 결과)에 도달하면 그 사실 자체(정의한
  연산 이름)를 `unresolved`에 기록한다 — 값을 못 구했다는 사실을 조용히 버리지 않는다.
- 미인식 op: entry 함수 안에서 `stream.resource.*`/`stream.tensor.*`로 시작하지만 화이트리스트
  (`KNOWN_ENTRY_OPS`, 실제 op 이름 5개)에 없는 op를 만나면 `unresolved`에 등록 — 화이트리스트는
  여전히 사람이 정의하지만, 그 판정 대상은 이제 **파싱된 IR이 실제로 가진 op 이름**이지 정규식
  매치 여부가 아니다.

## 3. 검증 — 14개 보관 아티팩트 전부 일치

`harness/mlir_alloc_walk.py --cross-check`로 7모델×2타깃의 `layout_ir` 파일 각각에 대해, 구조적
추출기의 결과와 기존 정규식 파서(`static_mem_bound.parse_alloc_ir`)의 결과를 대조했다.

| 비교 항목 | 결과 |
|---|---|
| `inputs`/`outputs`/`transient_slabs` (원소별 정확 일치) | **14/14 일치** |
| `constants` (합계 일치 — 정규식은 `dense` 선언별로, 구조적 추출기는 packed `stream.resource.alloc` 단위로 세어 항목 수는 다르지만 총합은 같음) | **14/14 일치** |
| `entry_found` | **14/14 일치** |
| `unresolved` (존재 여부 — 두 도구가 서로 다른 진단 문자열을 내므로 내용이 아니라 "막았는가"만 비교) | **14/14 일치**(dynamic 모델 2개 포함, 둘 다 UNKNOWN_BOUND로 이어지는 unresolved 발생 확인) |
| `dispatches`(참고용, bound_method를 좌우하지 않음) | 12/14 일치, dynamic 2건은 값이 다름(정보성 필드, §5에 기록) |

`harness/contract_negative_tests.py`에 `structural_walker_checks()`로 편입해 **51/51 → 66/66**으로
확장했다(신규 15건: 14개 모델 일치 확인 + 화이트리스트 축소 음성 시험 1건).

### 음성 시험 — fail-closed 재확인 (실제 레지스트리로)

E15의 화이트리스트 음성 시험은 정규식 도구용으로 문자열을 손으로 바꿔 재현했다. 구조적 추출기는
**진짜 op 레지스트리를 좁혀서**(정상적으로 파싱되는 conv2d IR에서 `KNOWN_ENTRY_OPS`에서
`stream.resource.dealloca`만 빼고 재실행) 같은 성질을 재확인했다 — "이 도구의 화이트리스트가
모르는, 그러나 실재하는 op"라는 D13의 실제 시나리오에 더 가깝다. 결과: `unresolved =
["unrecognized_op:stream.resource.dealloca"]`로 정확히 잡힘.

## 4. 이번 실험이 다루지 않는 것 (범위 밖)

- **`make_contract.py`로의 통합**: 이 결과는 독립 검증 도구로만 존재한다. 기존 파이프라인의 기본
  추출 경로를 구조적 추출기로 교체하지 않았다 — one-invocation 검증(layout IR↔dump-dir 결합),
  ABI/triple 대조, 스키마 검증 등 파이프라인의 나머지가 이 추출기와 무관하게 정규식/도구 조합에
  의존하고 있어, 교체하려면 그 부분들도 같은 수준으로 재검증해야 한다.
- **`stream.resource.pack`**: 코드에 처리 로직은 넣었지만(§2), 현재 14개 모델 어느 것도 entry
  함수 안에서 이 op를 쓰지 않아 **실제로 시험되지 않았다** — 다음에 pack을 쓰는 모델이 추가되면
  반드시 재검증할 것.
- **compiler 버전 변경 시 명시적 실패**(§14 평가지표 중 하나): 이번엔 한 IREE 커밋(`e4a3b04`)에서만
  확인했다. 다른 버전에서 `util.global.load`/`store`의 인쇄 문법이 달라지면(예: 속성 순서, 새 키워드)
  선언 합성 정규식이 깨질 수 있다 — 이 경우 `ir.Module.parse()`가 예외를 던지므로 **조용히 틀린
  값을 내지는 않는다**(실패 확인은 함, 명시적 실패는 확보). 그러나 다른 버전으로 실제 재확인은
  안 했다.
- **`entry_arg_shapes`, `artifact_rodata_segments` 등 `static_mem_bound.py`의 나머지 함수**: 이번
  실험은 오직 `parse_alloc_ir`가 하는 일(entry 함수의 입출력·transient·module 상주 상수 크기
  추출)만 대체했다.

## 5. 판정

CLAUDE.md 우선순위 3번의 5개 평가지표 중 셋을 이 범위에서 충족했다: **기존 파서와 정상 모델에서
동일 값**(14/14, §3), **미지원 표현 무시 안 함**(화이트리스트 밖 op는 unresolved로, §3 음성 시험),
**알려진 allocation 누락 없음**(같은 14개 모델에서 정규식 파서가 잡던 모든 크기를 구조적 추출기도
동일하게 잡음). 나머지 둘("compiler 버전 변경 시 명시적 실패", "적대적 변형에서 과소 추정 방지")은
§4에 명시한 대로 이번 실험 범위 밖이다 — 특히 "compiler 버전 변경 시 실패"는 여러 IREE 버전으로
실제 재확인해야 완전히 답할 수 있는 질문이다. `make_contract.py` 통합은 후속 과제로 남는다.

## 6. 재현

```bash
python3 harness/mlir_alloc_walk.py results/e14_aarch64_qemu/aarch64/layout_ir/mlp16k.layout_ir.txt --cross-check
python3 harness/contract_negative_tests.py   # structural: ... 15건 포함, 66/66
```
