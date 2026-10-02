# EVIDENCE v0.73 — E66: OnAIR 플러그인의 명세 문서 수용 규칙과 예산 검사를 cFS 경로와 맞추다

- **근거 요청**: 23차 원고 메타리뷰(`META_REVIEW_V27.md`, 2026-09-28) — 필수 M1(플러그인의 문서 수용 비대칭), 경미 1(예산 검사),
  경미 8·12와 필수 M3(원고 문장의 원자료). 연구 책임자 지시 *"메타리뷰대로 전부 수행해"*.
- **사전 고정 기준**: `docs/plans/E66_plugin_document_rules.md`(커밋 `ae115f3`, **구현·셀 이전**).
- **대상**: 모든 셀은 AArch64 QEMU 게스트(qemu-system-aarch64, Cortex-A53, 이번 부팅 4 vCPU·2 GiB — `guest/guest_env.txt`).
  개발 호스트에서는 지상 측 작업(명세 문서 배치, 판정 함수의 단위 시험, 헤더 생성기 실행, 보관 로그 판독)만 했다. 모델은 실행하지 않았다.
- **증거 등급**: 결정론적(명세 필드, 헤더 생성기 반환값, 게스트 플러그인 레코드, 보관 게스트 로그). 지연은 재지 않았다.
- **판정: Q1~Q5 PASS, Q6·Q7 기록** (`results/e66_plugin_document_rules/summary.json` — 원자료에서 유도).

## 1. 무엇이 문제였나

### 1.1 D111 — 문서 수용 규칙이 두 실행 경로에서 달랐다 (M1)

cFS 경로는 명세 문서를 빌드 시점에 C 헤더로 바꾸고, 헤더 생성기(`harness/gen_contract_header.py`)는 기본값에서 다음 문서를 거부한다.

| 문서 | 생성기 규칙의 근거 |
|---|---|
| 화이트리스트 밖 `bound_method` | D13/E15 |
| provenance 블록이 있고 상한을 진술하며 override 기록·`verified`가 아닌 grade·`single_invocation`이 참이 아닌 문서 | D39/E24b |
| `producer_check.state`가 `match`가 아닌 문서 | D109/E65 |
| provenance 블록이 있고 상한을 진술했는데 `producer_check`가 없는 문서 | D109/E65 (*"비교의 부재를 일치로 읽지 않는다"*) |

OnAIR 플러그인은 JSON을 **직접** 읽고 `admission_policy.decide`(상한 유무와 크기 비교)만 적용했다. 재발행 ResNet 문서를 변형해 재현했다:
`producer_check` 제거 → 생성기 rc 1 / 플러그인 정책 `ADMIT`, override 기입 → 생성기 rc 1 / `ADMIT`. 불일치 문서는 상한 자체가 없어
플러그인도 `REFUSED_UNKNOWN_BOUND`로 안전했다. **실제 분석기 경로로도 도달한다** — 보관 AArch64 ResNet 표현에 E64의 A6 편집(staging 수명
할당)을 넣고 `--allow-structural-mismatch`로 발행하면 `bounded 618856`·grade `overridden`·`producer_check match` 문서가 나온다(플래그 없이는 rc 1).

게다가 원고의 OnAIR 셀(E57·E62·E65)은 **전부 재발행 이전의 보관 문서**를 읽었다 — 네 문서 모두 `producer_check`가 없고, WGAN을 뺀 셋은
`analysis_domain`도 없다. cFS 쪽은 헤더가 바이트 동일해 차이가 없었지만 플러그인은 JSON을 읽는다. 평가 수치 영향은 없다(보관·재발행 문서는
플러그인이 읽는 필드에서 같다 — ResNet 필드 단위 diff).

### 1.2 D112 — 예산 검사가 비행 앱과 달랐다 (경미 1)

비행 앱은 양의 정수로 해석되지 않는 예산(0 포함)을 `BUDGET_INVALID`로 거부한다(`ai_learner.c`, `v <= 0`). 플러그인은 `int(budget_bytes)`로
바꿔 넘겼으므로 `decide` 자신의 형식 검사(bool·비정수 거부)를 우회했다: `true` → 1 → `NOT_ADMITTED`, `"618856"` → `ADMIT`, `618856.9` →
618,856 절삭 → `ADMIT`, `0` → `NOT_ADMITTED`. 전부 거부이거나 보수 쪽이라 안전 문제는 아니지만 E65가 조건부 옵션에서 고친 것과 같은 부류다.

## 2. 무엇을 바꿨나

- `plugins/compiled_learner/artifact_binding.py`(stdlib 전용):
  - `check_document_acceptance(contract, allow_unchecked_producer)` — 생성기의 기본 규칙을 **같은 범위로** 적용하고 `DocumentNotAccepted`
    (`ConfigurationError` 하위)를 낸다. provenance 블록이 없는 문서는 생성기처럼 범위 밖이다(E24b의 과잉 거부 회피; 분석기가 발행하는 문서는
    항상 provenance를 가진다). `BOUND_METHODS`는 생성기의 화이트리스트와 같은 집합이고 동치 시험이 비교한다.
  - `check_budget_option(deployment)` — 부재·`null` → `None`(기존 `NOT_EVALUATED` 경로), bool이 아닌 양의 정수 → 그 값, 나머지 → 구성 오류.
  - `check_unchecked_producer_option(deployment)` — 생성기 `--allow-unchecked-producer`에 대응하는 배포 키. 부재·`false`·`true`만 받는다.
- `compiled_learner_plugin.py`: 가드 안 순서 = 조건부 옵션 → **예산** → 명세 적재 → **문서 수용** → 입력 검사 → driver → 예산 비교 → 아티팩트 적재.
  전부 런타임 생성 전이다. init 레코드에 `document_acceptance`·`allow_unchecked_producer_requested`·`budget_bytes_configured`.
- **과거 배포의 재현성**: 36개 배포(E33·E57·E62·E65)에 `allow_unchecked_producer: true`와 `_e66_pin` 사유를 넣었다 — E62가 E57 설정에
  `output_readback: asarray`를 고정한 방식이다. 수치·판정은 바뀌지 않는다. E66 설정은 C1 한 셀만 이 키를 쓴다.
- 재발행 문서를 아티팩트 옆에 두려고 `results/e66_plugin_document_rules/docs/<model>/`에 **바이트 사본 + 상대 심볼릭 링크**를 두었다
  (`docs/manifest.json`이 사본의 동일성과 링크 대상 해시를 싣는다). 이전 리비전 ResNet과 override 문서도 같은 방식이다.

## 3. 결과

### Q1 (지상) — 동치: 21/21 일치

헤더 생성기의 기본 판정(rc 0 = 수용)과 플러그인 `check_document_acceptance`가 **21개 문서 전부에서 같다**(`ground.json` `Q1_parity`).

| 집합 | 수 | 생성기 | 플러그인 |
|---|---:|---|---|
| 재발행 문서(E65) | 4 | 수용 | 수용 |
| 보관 문서(비교 없음) | 4 | 거부 | 거부 |
| 보관 문서 + 면제(`--allow-unchecked-producer` / `allow_unchecked_producer`) | 4 | 수용 | 수용 |
| 이전 리비전 문서(불일치) | 4 | 거부 | 거부 |
| 분석기가 override로 발행한 문서 | 1 | 거부 | 거부 |
| 손으로 편집한 단위 변형(grade만, `single_invocation` 거짓, 미인식 `bound_method`) | 3 | 거부 | 거부 |
| 손으로 편집한 단위 변형(provenance·비교 둘 다 없음) | 1 | 수용 | 수용 |

revert-and-confirm-fail: 문서 규칙을 "전부 수용"으로 바꾸면 동치 시험이 **12건 불일치**로 실패한다(`e66/2`).

### Q2 (지상) — 예산: 기대대로, 과잉 거부 0

부재·`null` → 미평가, 1·618,856 → 그 값, 0·−1·`true`·`false`·`"618856"`·618856.9·`[]` → 구성 오류. 저장소의 배포 51개 전부가 **자기 선언과 같은
판정**을 받는다 — 거부를 선언한 것은 E66의 R4(예산 0) 하나뿐이고, 문서 거부를 선언한 것은 R1–R3뿐이다. 선언하지 않은 거부는 0이다.

### Q3 (게스트) — 재발행 문서 8셀

| 모델 | `B_u−1` | `B_u` 판정 | 호출 | 호출별 피크 | E62 fix 셀과 출력 | cFS 경계 셀 |
|---|---|---|---:|---|---|---|
| ResNet | `NOT_ADMITTED`, 런타임 없음, 추론 0 | `ADMIT` | 50 | 전부 309,416 = $P$ | 호출별 비트 동일 | 일치 |
| DeepAE | 같음 | `ADMIT` | 100 | 전부 6,208 = $P$ | 호출별 비트 동일 | 일치 |
| SmartCam | 같음 | `ADMIT` | 50 | 전부 9,382,092 = $P$ | 호출별 비트 동일 | 일치 |
| WGAN | 같음 | `ADMIT` | 3 | 전부 131,382,784 = $P$ | 호출별 비트 동일 | 일치 |

여덟 셀 모두 `document_acceptance = {verdict: accepted, waived: []}`. cFS 대조는 E48 실입력 경계 셀과 E53 WGAN 셀의 원자료다.

### Q4 (게스트) — 거부 셀과 면제 대조 (ResNet, 예산 `B_u`, R4만 0)

| 셀 | 문서 | 결과 | 사유(플러그인 기록) |
|---|---|---|---|
| R1 | 보관 문서(비교 없음) | 비활성·런타임 없음·판정 없음·추론 0 | `DocumentNotAccepted: … carries no validity.producer_check …` |
| R2 | 이전 리비전 아티팩트와 불일치 문서 | 같음 | `DocumentNotAccepted: validity.producer_check.state='mismatch' (artifact bytecode [16, 0], checked [17, 0])` |
| R3 | override 발행 문서 | 같음 | `DocumentNotAccepted: … overrides_applied=['--allow-structural-mismatch'] …` |
| R4 | 재발행 문서, 예산 0 | 같음 | `ConfigurationError: budget_bytes=0 does not resolve to a positive integer …` |
| C1 | R1의 문서 + `allow_unchecked_producer: true` | `ADMIT`·추론 50·면제 기록 | — |

네 거부 셀 모두 OnAIR rc 0·코어 무수정. R1–R3의 귀속 대조는 Q3의 ResNet `B_u` 셀이다(아티팩트·fixture·예산·설정이 같고 문서만 다르다).
C1은 과거 설정이 면제로 재현됨을 보인다.

### Q5 (지상) — 12번째 AArch64 표현

E65의 두 출력 AArch64 표현(`results/e65_producer_check/multiout_aarch64/multiout.layout_ir.txt`)에서 구조적 walker의 미분류 자원 op **0개**.
E64 코퍼스 11개(미분류 0, 인용)와 합쳐 **12개 전부 0**. E64 도구는 AArch64 표현을 명시적 디렉터리 목록으로 세고 그 목록에 이 디렉터리가 없으므로,
E64를 다시 돌리지 않고 여기서 센다.

### Q6 (기록) — vCPU 수와 map 피크

보관 게스트 로그에서 (모델, cFS가 보고한 CPU 수, 최종 HAL 피크)를 뽑으면, 각 모델의 map 피크 $P$가 **1 vCPU 세션과 2 vCPU 세션**(ResNet·DeepAE·SmartCam:
E54·E55·E56·E58 대 E48 실입력 셀) 또는 **1 vCPU와 4 vCPU 세션**(WGAN: E53·E54·E55·E56 대 E63 단일 빌드 셀)에서 같다. 판정이 아니라 원고 표 4 문장의 원자료다.

### Q7 (기록) — 원고 셀 목록의 재집계

실행 셀 **37**(모두 피크 ≤ 승인 근거 예산, 서로 다른 피크 8개), 거부 셀 **20**(모두 `mem_init`·`run` 0), 정렬 셀 **32** 중 추론 후 피크를 기록한 셀 **22**
(오프셋 0 = $P$ 3셀, 나머지 = $P+C$ 19셀, 전부 $B_u$ 이하). 여기에 미지의 상한 거부 2셀(E65 no-bound, E14 A8)과 적재 단계에서 런타임이 멈춘
1셀(E65 legacy)이 있다.

**판정 전에 잡은 제 도구 결함**: 첫 판독기가 앱의 JSON `mem` 레코드만 읽어 정렬 셀의 최종 피크를 **20**으로 셌다. 추론이 1회뿐인 SmartCam 두 셀은
EVS 진행 메시지(`completed=1/1 … hal_peak=…`)에만 피크가 있다 — E58 요약기는 둘 다 읽는다. "볼 수 없었다"를 "없더라"로 기록한 D51의 모양이고, 같은
규칙으로 고쳐 22가 됐다.

## 4. 가드

`contract_negative_tests.py::e66_plugin_document_rules_cases` — `e66/1`(동치 재실행), `/2`(규칙을 빼면 12건 불일치), `/3`(예산·배포 51개의 선언
판정), `/4`(플러그인 결선 순서, 실행 줄만), `/5`(면제 키는 고정된 과거 배포와 C1만), `/6`(게스트 레코드에서 Q3·Q4 재유도), `/7`(문서 사본·링크),
`/8`(12번째 표현, `iree.compiler.ir` 필요), `/9`(셀 목록 재집계). 이 컨테이너 **996/996 + 2 SKIP → 1005/1005 + 2 SKIP**(FAIL 0; SKIP 2건은 기존의 실입력 라이브 재실행 두 건).

되돌림 실측: 문서 규칙을 "전부 수용"으로 바꾸면 `/1`·`/3`, 플러그인의 결선을 빼면 `/4`, 예산 검사를 `int()`로 되돌리면 `/3`이 FAIL한다(`/2`는
규칙을 뺀 플러그인을 **스스로 흉내 내는** 대조라 되돌림과 무관하게 통과한다). **첫 판은 예산 되돌림에서 FAIL이 아니라 스위트를 죽였다** — `int([])`의
`TypeError`가 가드 밖으로 샜다. E26b(D48)가 적은 모양 그대로다: 결함을 재현하려고 되돌리는 순간이 정확히 그 예외가 나는 조건이다. 규칙·예산 함수의
구성 오류가 아닌 예외를 `crash:<유형>`으로 기록하고 어느 기대와도 맞지 않게 세도록 고쳤다. 규칙 함수가 `KeyError`를 던지게 되돌린 경우에도 스위트가
살아 `/1`·`/3`이 FAIL한다.

첫 판 `/3`은 E66의 거부 셀을 "모든 배포 수용" 검사에 넣어 실패했다 — 거부가 정답인 셀을 과잉 거부로 읽은 **가드 설계 결함**이다. 배포가 기대 판정을
`_e66_expected`로 스스로 선언하게 하고 그것과 대조하도록 고쳤다. 이 선언 키는 게스트 실행 뒤에 설정 파일에 더했다 — 밑줄 키는 플러그인과 하네스가
읽지 않으며, 각 셀이 실제로 읽은 설정은 `guest/cells/<셀>/deployment.json`에 있다.

## 5. 주장하지 않는 것

- 손으로 편집한 문서는 연구 가정 밖이다 — 네 변형은 단위 시험일 뿐이다.
- provenance 블록이 없는 문서는 생성기와 같은 범위 밖이다(둘 다 수용, 기록).
- E57·E62·E65의 OnAIR 셀은 재실행하지 않았다. 그 설정은 기록된 면제로만 재현된다.
- 지연, 정확도, 조건부 정책.
