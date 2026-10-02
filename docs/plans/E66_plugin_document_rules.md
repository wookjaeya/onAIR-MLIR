# E66 계획 — OnAIR 플러그인의 명세 문서 수용 규칙과 예산 검사를 헤더 생성기·비행 앱과 맞춘다

**사전 고정 문서다. 구현·셀 실행 이전에 커밋한다.** 근거는 23차 원고 메타리뷰
(`META_REVIEW_V27.md`, 2026-09-28, 연구 책임자 지시 "메타리뷰대로 전부 수행해")의 필수 M1과 경미 1·8·12,
그리고 필수 M3이 요구하는 셀 목록의 원자료 유도다. 모든 셀은 **AArch64 게스트**에서 돌고, 개발 호스트에서는
지상 측 분석(명세 생성·판정 함수 단위 시험·보관 로그 판독)만 한다.

## 0. 착수 전 조사 (실험 아님)

- **문서 수용 규칙의 비대칭 (D111 후보)**: 헤더 생성기(`harness/gen_contract_header.py`)는 기본값에서
  (a) provenance 블록이 있고 상한을 진술한 문서 가운데 override 기록·`verified`가 아닌 grade·`single_invocation`이
  참이 아닌 문서, (b) `producer_check.state`가 `match`가 아닌 문서, (c) provenance 블록이 있고 상한을 진술했는데
  `producer_check`가 없는 문서를 거부한다. OnAIR 플러그인은 JSON을 직접 읽고 `admission_policy.decide`만 적용한다.
  재발행 ResNet 문서를 변형해 재현: `producer_check` 제거 → 생성기 rc 1 / 플러그인 정책 `ADMIT`,
  override 기입 → 생성기 rc 1 / 플러그인 `ADMIT`, 불일치 문서 → 생성기 rc 1 / 플러그인 `REFUSED_UNKNOWN_BOUND`.
  **실제 분석기 발행 경로로도 도달한다**: 보관 AArch64 ResNet 표현에 E64의 A6 편집(staging 수명 할당)을 넣고
  `--allow-structural-mismatch`로 발행하면 `bounded 618856`·`overrides_applied ['--allow-structural-mismatch']`·
  grade `overridden`·`producer_check match`인 문서가 나온다(플래그 없이는 rc 1).
- **평가 셀이 읽은 문서**: E57·E62·E65의 OnAIR 배치 설정(`configs/deployments/onair_deployments_e{57,62,65}_aarch64.json`)은
  전부 재발행 이전의 보관 문서를 가리킨다 — 네 문서 모두 `producer_check`가 없고, WGAN을 뺀 셋은 `analysis_domain`도 없다.
  재발행 문서(`results/e65_producer_check/reissued/*`)는 플러그인이 읽는 필드(인터페이스·수치·아티팩트 해시·driver)에서
  보관 문서와 같다(ResNet 필드 단위 diff).
- **예산 검사의 비대칭 (D112 후보)**: 비행 앱은 양의 정수로 해석되지 않는 예산(0 포함)을 `BUDGET_INVALID`로 거부한다
  (`ai_learner.c`의 `v <= 0` 분기). 플러그인은 `int(budget_bytes)`로 바꿔 `decide`에 넘기므로 `decide` 자신의
  형식 검사를 우회한다: `true` → 1 → `NOT_ADMITTED`, `"618856"` → `ADMIT`, `618856.9` → 618,856 절삭 → `ADMIT`,
  `0` → `NOT_ADMITTED`. 저장소의 모든 배치 설정은 정수이거나 키가 없다(네 설정 파일의 배포 38개 전수 조사) — 형식 검사를 넣어도
  기존 설정의 판정은 바뀌지 않는다.
- **provenance 블록이 없는 문서**: 생성기는 (a)·(c)를 provenance 블록이 있는 문서에만 적용한다(E24b의 과잉 거부 회피,
  `contracts/*.json`과 E33 레거시 fixture). 비교도 provenance도 없는 문서는 `BOUND_KNOWN 1`·`PROVENANCE_VERIFIED 0`
  헤더로 변환되고 비행 앱은 `PROVENANCE_VERIFIED`를 읽지 않는다. 분석기가 발행하는 문서는 항상 provenance 블록을 가진다.
  **이 범위는 바꾸지 않는다** — 플러그인도 같은 범위로 맞춘다(원고 문장을 좁히는 것은 원고 쪽 조치).
- **게스트 셀 소요(보관 로그)**: E62에서 ResNet 50회 약 32 s, DeepAE 100회 약 22 s, SmartCam 50회 약 6.5분,
  WGAN 3회 약 74분. 거부 셀은 수 초.
- **표현 코퍼스**: E64가 센 AArch64 표현 11개는 `AARCH64_COMPILE_DIRS`의 명시 목록이다. E65가 추가한
  `results/e65_producer_check/multiout_aarch64/multiout.layout_ir.txt`는 그 목록에 없다.
- **vCPU 관측(경미 8)**: 보관 게스트 로그에서 cFS가 보고한 CPU 수와 최종 HAL 피크를 스캔하면, 각 모델의 map 피크 $P$가
  1 vCPU 세션과 2 vCPU(ResNet·DeepAE·SmartCam, 실입력 셀)·4 vCPU(WGAN, 단일 빌드 셀) 세션에서 같다.

## 1. 변경 (구현)

1. `plugins/compiled_learner/artifact_binding.py`(stdlib 전용)에 두 순수 함수를 둔다.
   - `check_budget_option(deployment)`: 키가 없거나 `null`이면 `None`(기존 `NOT_EVALUATED` 경로 유지), bool이 아닌
     정수이고 0보다 크면 그 값, 나머지(0·음수·bool·문자열·실수·기타)는 `ConfigurationError`.
   - `check_document_acceptance(contract, allow_unchecked_producer)`: 헤더 생성기의 기본 규칙을 같은 범위로 적용한다.
     `bound_method`가 있는데 생성기 화이트리스트 밖이면 거부; 상한을 진술하고 provenance 블록이 있으면 override 기록·
     `verified`가 아닌 grade·`single_invocation`이 참이 아님을 거부; `producer_check`가 있고 `match`가 아니면 거부;
     provenance 블록이 있고 상한을 진술했는데 `producer_check`가 없으면 거부(`allow_unchecked_producer`가 참일 때만 수용하고
     그 사실을 기록). 거부는 `ConfigurationError`의 하위 예외로 낸다.
2. 플러그인 순서: 조건부 옵션 → 예산 옵션 → 명세 적재 → **문서 수용** → 입력 검사 → driver → 예산 비교 → 아티팩트 적재.
   모두 런타임 생성 전이다. `allow_unchecked_producer`는 부재·`false`·`true`만 받고(E65/M2와 같은 규칙) 나머지는 구성 오류.
   init 레코드에 `document_acceptance`(판정·사유·면제 여부)를 싣는다.
3. **과거 배치 설정의 재현성**: E57·E62·E65 설정과 `onair_deployments.json`의 배포 가운데 provenance 블록이 있고
   비교가 없는 문서를 가리키는 것에 `allow_unchecked_producer: true`와 `_e66_pin` 사유를 넣는다(E62가 E57 설정에
   `output_readback: asarray`를 고정한 것과 같은 방식). 판정 값·수치는 바뀌지 않는다. E66 설정은 이 키를 쓰지 않는다
   (C1 셀 하나만 예외 — 아래).
4. 재발행 문서를 아티팩트 옆에 두기 위해 `results/e66_plugin_document_rules/docs/<model>/`에 재발행 문서 사본
   (바이트 동일)과 아티팩트에 대한 상대 심볼릭 링크를 둔다. 이전 리비전 ResNet과 override 문서도 같은 방식으로 둔다.

## 2. 질문과 판정 기준 (측정 전 고정)

- **Q1 (지상, 동치)**: 문서 집합 F에 대해 헤더 생성기의 기본 판정(rc 0 = 수용)과 플러그인 `check_document_acceptance`의
  판정이 **전부 같은가**. F = 재발행 4(수용) · 보관 4(거부) · 이전 리비전 불일치 4(거부) · override 발행 1(거부) ·
  보관 4 + 면제(수용, 생성기는 `--allow-unchecked-producer`) · provenance와 비교를 둘 다 뺀 재발행 ResNet(수용).
  **PASS**: 불일치 0. **반증**: 한 문서라도 다르면 FAIL. revert-and-confirm-fail: 함수를 되돌리면 동치 시험이 실패해야 한다.
- **Q2 (지상, 예산)**: `check_budget_option`이 부재·`null` → None, 1·618856 → 값, 0·-1·`true`·`false`·`"618856"`·
  618856.9·`[]` → 구성 오류. **PASS**: 전부 기대대로. 저장소의 모든 배치 설정이 수용된다(과잉 거부 0).
- **Q3 (게스트, 재발행 문서 8셀)**: 네 모델 × {`B_u−1`, `B_u`}, 재발행 문서, 나머지는 E62 fix 셀과 같은 배포
  (buffer-protocol readback, HAL 통계 기록, 같은 fixture·텔레메트리).
  **PASS**: `B_u−1` 네 셀 `NOT_ADMITTED`·`runtime_created false`·추론 0; `B_u` 네 셀 `ADMIT`·계획 호출 수 전부·
  모든 호출 피크 = $P$·출력이 E62 fix 셀과 호출별 비트 동일; 판정이 cFS 경계 셀(E48 실입력·E53)과 8/8 같음;
  init 레코드의 `document_acceptance`가 `accepted`이고 면제 없음. **반증**: 재발행 문서가 거부되면(과잉 거부) FAIL.
- **Q4 (게스트, 거부 셀)**: 모두 ResNet, 예산 `B_u`(R4만 0).
  R1 보관 문서(비교 없음) · R2 이전 리비전 아티팩트와 그 불일치 문서 · R3 override 발행 문서 · R4 재발행 문서에 예산 0.
  **PASS**: 네 셀 모두 `active false`·`runtime_created false`·`admission null`·추론 0·사유가 해당 규칙을 명시·
  OnAIR rc 0·코어 무수정.
  대조 C1: R1과 같은 문서에 `allow_unchecked_producer: true` → `ADMIT`·추론 ≥ 1·init 레코드에 면제 기록
  (R1의 거부가 문서 규칙에 귀속됨을 보이고, 과거 설정이 면제로 재현됨을 보인다). R1–R3의 귀속 대조는 Q3의 ResNet `B_u` 셀이다
  (문서만 다르다).
- **Q5 (지상, 코퍼스)**: E65의 두 출력 AArch64 표현에서 구조적 walker의 미분류 자원 op가 0개인가.
  E64 코퍼스 11개와 합쳐 12개 전부 0이면 PASS(보관 11개의 E64 결과는 인용).
- **Q6 (지상, 보관 로그 판독)**: 평가 셀의 게스트 로그에서 (모델, cFS 보고 CPU 수, 최종 HAL 피크)를 뽑아, 각 모델의 map 피크
  $P$가 서로 다른 CPU 수의 세션에서 같은지 기록한다. 판정이 아니라 원고 문장의 원자료다.
- **Q7 (지상, 보관 기록 판독)**: 원고 증거 요약의 셀 목록 수를 원자료에서 센다 — 거부 셀(예산 비교·매핑 전제·
  unknown bound), 런타임 적재에서 멈춘 셀, 정렬 셀 가운데 추론 후 최종 피크를 기록한 셀. 판정이 아니라 원고 문장의 원자료다.

## 3. 하지 않는 것

- 원고가 보고한 과거 OnAIR 셀(E57·E62·E65)의 재실행 — Q3이 판정 동치 8셀만 재발행 문서로 다시 돈다.
  보유·해제 장기 셀(DeepAE 450회 등)은 문서의 수치 필드가 같으므로 다시 돌리지 않는다.
- 헤더 생성기의 규칙 변경(provenance 블록이 없는 문서의 범위 포함). 비행 앱 변경.
- `admission_policy.decide` 변경(E35·E49 매트릭스가 쓴다).
- 조건부 정책, 지연, 정확도.
