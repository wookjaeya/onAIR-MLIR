# EVIDENCE v0.69 — v20 원고 메타리뷰의 사실 확인에서 나온 결함 세 건 (D105 · D106 · D107)

**경위**: 20차 원고 메타리뷰(Minor Revision)의 요구 — *"분석기가 호출된 함수·중첩 region·반복/분기를 순회하는지,
지원하지 않아 거부하는지 적어라"*(§4) 외 — 에 답하기 전에, 원고 문장이 기대는 사실을 병렬 조사 워크플로우로 저장소에서
직접 확인했다(조사 5 + 완결성 비평 1). 그 조사가 저장소 결함 셋을 찾았다. **셋 다 보고된 수치·판정을 바꾸지 않는다.**

**증거 등급**: 결정론적(생산 경로의 반환 코드·파일 존재·계약 필드). 게스트 실행 없음.

## 1. D105 — 엔트리의 호출·제어 흐름에 규칙이 없었다 (잠재적 fail-open → 거부로)

**발견**: 구조적 walker는 엔트리의 모든 중첩 region을 순회하지만 **호출된 함수는 따라가지 않고**, 할당 op을 **나타난 횟수만큼**
센다(반복 횟수를 곱하지 않고 분기는 합한다). `scf.*`·`cf.*`·`func.call`·`util.call`에 대한 규칙이 어느 추출기에도 없었다.
조사 프로브가 **생산** `make_contract.py`(커밋 `32f5102`)를 보관 ResNet AArch64 layout IR의 **수작업 편집본**에 돌렸다
(`results/d105_control_flow_boundary/before_32f5102.json`):

| 편집 | 수정 전 |
|---|---|
| 같은 청크에 둔 callee(4,096 B 할당)를 `util.call`/`func.call` | rc 0, **618,856 발행** — callee의 할당이 **빠졌다** |
| `scf.for` 0..3 안의 4,096 B `alloca`(dealloca 없음) | rc 0, **622,952 발행** — **한 번만** 셌다 |
| `scf.while` 본문 할당 | rc 0, 622,952 발행 |
| `scf.if`/`cf.cond_br` 두 분기 할당 | rc 0, 631,144 발행(두 분기 합 — 보수적) |
| 루프 변수로 크기를 정한 할당 | 계약 발행, `bound_method NONE`(상한 없음) |
| 자원을 나르는 `scf.if`·`util.call`, 별도 청크 callee | rc 1(미분류 또는 파싱 실패) |

**평가 모델은 해당하지 않는다**: 보관 layout IR **30개**(26 + E59 드리프트 4) 어느 엔트리에도 호출·루프·분기 op이 없다.
네 평가 모델 엔트리의 region을 가진 op은 `stream.cmd.execute`(각 1)와 `stream.cmd.concurrent`(8/0/17/11)뿐이고, `scf.if`는
상수 초기화기(try_map)에만 있다. **보고된 어떤 수치도 바뀌지 않는다.**

**수정**: 지원 범위를 넓히지 않고 **경계를 거부로** 만들었다. walker가 엔트리 안의 `scf.*`·`cf.*`·`affine.*`·`func.call`·
`func.call_indirect`·`util.call`을 전용 키 `unsupported_control_ops`로 보고하고, `make_contract.py`가 **오버라이드 없이** 거부한다.
분기도 거부한다 — 합이 보수적이긴 하지만 *"어떤 구조를 어떻게 세는가"*를 규칙 셋이 아니라 하나로 둔다.

**수정 후**(`results/d105_control_flow_boundary/after.json`, `harness/d105_control_flow_probe.py`가 같은 편집본을 결정적으로 재생성):
편집하지 않은 대조군은 **618,856 그대로 발행**, 호출·루프·분기 변형 **12/12 계약 미발행**. 보관 30개 전부에서 새 거부 **0건**
(과잉 거부 0), 보관 14개 계약 diff 0.

**revert-and-confirm-fail**: walker의 거부 분기만 끄면 `d105/5`(생산 경로 라이브 재실행 ↔ `after.json`)가 실제로 FAIL, 원복하면 통과.

**주장하지 않음**: 호출·루프를 **지원**한다는 것 · 이 컴파일러가 그런 엔트리를 내보낸다는 것(관측된 적 없다 — 편집본은 수작업
텍스트다) · 편집본을 실제로 실행했을 때의 피크.

## 2. D106 — E51이 헤더 생성기를 잘못 불러 "헤더 없음"을 관측으로 기록했다

**발견**: `harness/e51_precondition_trace.py`가 `gen_contract_header.py --contract … --out …`으로 불렀는데 생성기는 **위치 인자 두
개**만 받는다. 그래서 **양성 대조군과** 비상수 크기 셀이 똑같이 **사용법 오류(rc 2)**를 냈고, E51은 비상수 크기 셀을
*"계약은 나오되 헤더가 생성되지 않는다"*로 분류했다(`stage1_preconditions.pre_d106.json`: 양성 대조군 `gen_contract_header_rc 2`).
**D51의 계열**이다 — 도구 오류가 관측으로 적혔고, 양성 대조군이 헤더 단계까지 확인하지 않아 그것을 잡지 못했다.

**바른 사실**: 비상수 크기면 헤더가 **생성되고** `CONTRACT_BOUND_KNOWN 0`을 싣는다. 비행 앱은 그 헤더를 Init에서
`UNKNOWN_BOUND`로 **런타임 자원 획득 전에 거부**한다(`ai_learner.c` `GATE_BOUND_KNOWN`) — 게스트에서 관측된 거부다
(E14 A8, `results/e14_aarch64_qemu/cfs/logs/A8_dynamic_unknown.log`: `"verdict":"UNKNOWN_BOUND"`, `mem_init` 없음).

**수정**: 위치 인자로 호출, 헤더의 `CONTRACT_BOUND_KNOWN`을 기록, **양성 대조군이 `BOUND_KNOWN 1` 헤더를 내야** 통과, 비상수 셀은
`contract_states_no_bound_header_bound_known_0_refused_at_init`으로 분류(배치 불가). E51 stage1을 재실행해
`stage1_preconditions.json`을 교체하고 옛 기록은 `stage1_preconditions.pre_d106.json`으로 남겼다. **판정 Q1~Q4 PASS 불변.**

**revert-and-confirm-fail**: 호출을 옛 형태로 되돌리면 양성 대조군이 통과하지 못해 E51 라이브 재유도가 Q2 FAIL, `d106/4`도 FAIL.

**원고 영향 없음**: 원고는 *"헤더가 생성되지 않는다"*를 쓰지 않았다(§III.C는 *"상한 없는 명세"*까지만 쓴다).
**`CLAUDE.md`의 E51 요약은 틀렸다** — 정정을 덧붙인다.

## 3. D107 — E59 드리프트 계약의 `validity.compiler`는 아티팩트의 컴파일러가 아니다 (기록만)

E59의 IREE 3.10 드리프트 아티팩트 4개에 대한 계약이 `validity.compiler: "IREE 3.11.0rc20260316 e4a3b04"`를 싣는다. 이 필드는
**계약 생성 시점 PATH의 `iree-compile`**을 기록하기 때문이다. 같은 계약의 `notes`가 *"bytecode version mismatch … module has
16.0"*을 싣고 있어 모순이 드러나 있고, `verification_grade`는 `verified`다(오버라이드 없음 — 등급은 오버라이드 여부만 뜻한다).
원고는 이 필드에 기대지 않는다. **코드 수정 없음**: 아티팩트는 컴파일러 버전을 싣지 않으므로 필드를 *"생성 환경의 컴파일러"*로
읽어야 한다는 것을 기록해 둔다.

## 4. 함께 고친 가드

`e55/6`(분석 영역 분류 전수)이 파싱에 실패한 파일을 **조용히 건너뛰고** `scanned >= 25`만 요구해, 원고가 인용하는 코퍼스 크기를
고정하지 못했다. 이제 파싱 실패를 보고하고 실패시키며 `scanned == len(files)`를 요구한다(현재 26/26). **원고의 "27개" 표현은
착수 전 측정(E55 §2.1 이름 규칙 시험)의 수치가 분류 결과 문장에 옮겨간 것**이고, 분류 결과는 E55 §2.3이 적은 대로 **26개**다 —
원고 v21에서 고친다.

## 5. 가드

`d105_control_flow_boundary_cases` 5건 · `d106_e51_header_leg_cases` 5건. 이 컨테이너 **949/949 + 2 SKIP → 959/959 + 2 SKIP**.
