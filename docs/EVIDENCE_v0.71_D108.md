# EVIDENCE v0.71 — D108: 초기화 영역의 제어 흐름을 거부로

- 수정: `harness/mlir_alloc_walk.py`(`_initializer_control_ops`, `_is_map_attempt_branch`, `_opname`), `harness/make_contract.py`(거부)
- 프로브: `harness/d108_initializer_control_probe.py` · 원자료: `results/d108_initializer_control/{before_3147684,after}.json`
- 가드: `harness/contract_negative_tests.py::d108_initializer_control_cases` (`d108/1`–`/4`)
- 계기: 원고 v25 메타리뷰 반영을 위한 사실 조사(분석기 축)가 찾았다. **보고된 수치·판정은 바뀌지 않는다.**

## 1. 결함

D105는 **엔트리**의 호출·루프·분기를 거부로 바꿨지만 **모듈 초기화 영역**은 검사하지 않았다. 두 추출기는 상수 할당을
나타난 횟수만큼 센다 — 구조적 walker는 `stream.resource.alloc`을 한 번, 정규식 경로는 packed composite 크기를 한 번 — 그래서
초기화 영역에서 할당을 감싼 루프나 분기가 있어도 **둘이 똑같이 한 번 세고 일치**한다. 평가한 네 초기화 영역은 각각 `did_map`을
조건으로 하는 `scf.if` 하나와 `scf.yield` 둘(두 적재 분기)만 가지므로 **수치에 영향이 없다**(원고 L213의 *"the only branch it
interprets is the map attempt and its copy alternative"*도 사실은 해석이 아니라 composite 크기를 한 번 읽은 결과였다).

## 2. 실측 (보관 ResNet AArch64 layout 표현의 마지막 초기화 print를 편집, 재컴파일 없음, production `make_contract.py`)

| 셀 | 수정 전(HEAD `3147684`) | 수정 후 |
|---|---|---|
| 대조(편집 없음) | 발행 618,856 | 발행 618,856 |
| `scf.for` 안 0 B 상수 할당 | **발행 618,856** | 거부(초기화 영역 제어 흐름) |
| 추가 `scf.if` 안 0 B 상수 할당 | **발행 618,856** | 거부(초기화 영역 제어 흐름) |
| `scf.for` 안 4,096 B 상수 할당 | 거부(추출기 불일치) | 거부(초기화 영역 제어 흐름 + 불일치) |

수정 전에는 **구조 자체**가 통과했다 — 상수 합이 바뀌는 편집만 불일치로 멈췄다. 루프가 기존 할당을 되풀이하는 모양이라면
두 경로의 합이 같으므로 불일치도 나지 않는다(실물 아티팩트의 상수 대조가 걸러낼 수는 있으나 그것은 다른 검사다).

## 3. 수정

초기화 영역(`util.initializer`)을 걸어 `scf.*`·`cf.*`·`affine.*`·호출 op를 모은다. 허용하는 것은 **조건이 `stream.resource.try_map`의
첫 결과(`did_map`)인 `scf.if`와 그 바로 안의 `scf.yield`뿐**이다. 나머지는 `initializer_control_ops`로 보고되고 `make_contract.py`가
**오버라이드 없이 거부**한다(D105와 같은 이유 — 그런 초기화 영역을 이 분석이 세는 방식으로는 발행한 값이 상한이 아니다).

부수: 초기화 영역의 `util.buffer.constant`는 선택적 `name` 속성을 가져 OpView의 `.name`이 가려진다(None). 첫 구현이 이 때문에
보관 표현 30개 전부에서 예외를 냈고, `Operation.name`으로 읽도록 고쳤다(`_opname`).

## 4. 과잉 거부와 revert

- 저장소가 추적하는 layout 표현 **30/30**에서 `initializer_control_ops`가 비어 있다(과잉 거부 0). 보관 14개 계약 diff 0(전체 시험).
- 수정 줄 하나(`initializer_control_ops = []`)를 되돌리면 `d108/3`(라이브 재실행)이 실제로 FAIL한다.

## 5. 주장하지 않는 것

- 컴파일러가 초기화 영역에 루프를 만든다는 관측은 없다 — 편집 표현으로 분석기의 규칙을 시험한 것이다.
- 초기화 영역의 다른 op(`stream.file.read`, `stream.cmd.execute` 등)의 분류는 이 수정의 범위가 아니다.
