# E42/E43 — 순수 OnAIR 기준선 O0~O3 (사전 고정 기준)

> **측정 이전에 커밋한다.** 로드맵 §7의 처방을 **문자 그대로 따르지 않는다** — 착수 전 감사에서
> 두 가지 사실 오류와 한 가지 중복이 확인됐고(§1), E40이 로드맵 처방 3건 중 2건을 좁힌 것과 같은
> 이유다.

**연구 책임자 결정(2026-09-11)**: 논문 초고는 별도 지시까지 착수하지 않고 그때까지 실험을 최대한
진행한다. 정규 MLIR pass는 이번 논문 범위 밖(`dfba1d8`).

---

## §0 이 실험이 답하는 것

로드맵 §7.1이 정확히 적었다:

> 이 비교의 목적은 OnAIR의 결함을 찾는 것이 아니라 **기존 OnAIR 실행 경로에 본 연구가 추가하는
> 기능은 무엇인가**를 분리하는 것이다.

**순수 OnAIR에는 이 연구가 정의한 계약이 없다.** 따라서 *"OnAIR가 계약을 위반했다"*거나
*"OnAIR가 메모리를 관리하지 못한다"*고 **쓰지 않는다**(로드맵 §7.1이 명시적으로 금지).

---

## §1 로드맵 §7을 좁혀 채택한다 — 세 가지를 실측으로 확인했다

| # | 로드맵의 서술 | 실측 | 채택 |
|---|---|---|---|
| 1 | §7.4-3 *"E33의 `file_replay` 입력 경로와 **37개** SmartCam fixture를 재사용한다"* | **틀렸다.** `configs/onair_data/smartcam_replay.csv`는 **5행**(헤더 제외)이고 E33 `p_admit`의 추론은 **5회**다. 37은 E31 fixture의 샘플 수이고 그중 32개는 `.npy`가 in-tree에 없다 | **5샘플을 유지한다** — 그래야 O0~O3가 `p_admit`/`p_deny`와 **직접 비교 가능**하고 재생성도 필요 없다 |
| 2 | §7.3 O2·O3를 새로 측정 | **이미 있다.** O2 ≡ `results/e33_onair_official/p_admit`(active=true·추론 5·rc 0), O3 ≡ `p_deny`(active=false·추론 0·rc 0). 게다가 **더 최신 재실행**이 `results/e41_analysis_domain/onair_cells/`에 5셀(+`smartcam_wrong_driver`) 있다 | **인용한다, 재측정하지 않는다.** 다시 돌려 *"새 셀 4개"*라 적으면 D72가 고친 **중복 증거 부풀리기**다 |
| 3 | O0가 E41의 게이트에 걸릴 위험 | **걸리지 않는다.** `telemetry` 필수화는 E41이 D71을 고치며 **의도한 fail-closed**이고(*"선언이 없으면 추측하지 않고 거부"*), O0도 다른 배포처럼 **선언하면 된다**. `check_declared_driver`는 `compiled_learner`의 것이고 LiteRT 플러그인은 호출하지 않는다 | 과잉 거부 **아님**. 단, §5 P1에서 다시 확인한다 |

### §1.1 그래서 실제로 새로 측정하는 것

| 경로 | 상태 | 이 실험에서 |
|---|---|---|
| **O0** OnAIR + LiteRT | **신규** | **측정한다** — 새 플러그인 `plugins/litert_learner/` |
| **O1** OnAIR + IREE, 계약 비활성 | **코드 0줄** | **측정한다** — 배포 항목 하나(`budget_bytes` 생략 → `NOT_EVALUATED`). 오늘 측정된 유일한 `NOT_EVALUATED` 셀은 **legacy MLP**이므로 SmartCam에서의 이 셀은 새롭다 |
| **O2** OnAIR + IREE + 계약, 예산 `B` | **측정됨** | `p_admit` 인용 |
| **O3** 같은 구성, 예산 `B−1` | **측정됨** | `p_deny` 인용 |

**인용하는 셀의 알려진 한계를 함께 적는다** — `p_admit/run.json`은 `nanobind: leaked 10 instances`를
남기고 있고 D60이 그 때문에 *"출력 버퍼 해제 검증"* 주장을 이미 철회했다. 그 셀을 O2로 인용하면서
그 사실을 빼놓으면 D65(정정이 산문에만 남음)의 재발이다.

---

## §2 O0의 설계 — 무엇을 만들고 무엇을 만들지 않는가

`plugins/litert_learner/`는 `compiled_learner`의 **형제**다. 같은 NASA `AIPlugin` 인터페이스
(`(construct_name, headers)`), 같은 JSONL 레코드 스키마, 같은 `input_mode: file_replay`,
같은 5샘플 telemetry.

**다른 것은 하나뿐**: 원본 `.tflite`를 LiteRT 인터프리터로 실행하고 **계약도 admission도 없다.**

| `compiled_learner`가 하는 것 | `litert_learner` |
|---|---|
| 계약 JSON 로드 → 없으면 거부 | **없다** (이 경로에 계약이 존재하지 않는 것이 요점) |
| `artifact_binding` 크기·sha256 게이트 | **없다** |
| `admission_policy.decide` → ADMIT/NOT_ADMITTED | **없다** — `admission`은 레코드에 `null` |
| `check_declared_driver` | **없다** |
| IREE 런타임 생성 | LiteRT 인터프리터 생성 |

**이것을 "OnAIR의 결함"으로 적지 않는다.** 없는 것은 결함이 아니라 **이 연구가 더하는 것**이다.

**하네스는 고치지 않는다.** `harness/onair_integration_check.py`에 `--plugin-dir`이 이미 있으므로
O0는 그 값만 바꿔 돌린다. 하네스를 고쳐야 한다면 그것 자체가 Q4 실패다.

---

## §3 사전 고정한 판정

| Q | 질문 | PASS 조건 |
|---|---|---|
| **Q1** | O0가 **NASA 공식 로더**로 구성되는가 | 플러그인이 생성 시점에 남기는 마커로 확인(우리 로그 줄이 아니라). `python driver.py <ini>` 서브프로세스, OnAIR 코어 **추적 파일 변경 0** |
| **Q2** | O0가 같은 5샘플을 실제로 추론하는가 | 추론 **5회**, rc 0, 프로세스 정상 생존 |
| **Q3** | O0의 출력이 원본 TFLite oracle과 일치하는가 | **일치해야 한다** — O0는 그 원본을 직접 돌리므로 기준값과 **같은 구현**이다. 불일치는 하네스 결함이다 |
| **Q4** | O1이 **코드 변경 없이** 되는가 | 새 코드 0줄, 배포 항목 하나. `admission: NOT_EVALUATED`, active=true, 추론 5회 |
| **Q5** | 네 경로의 **차이가 무엇인지** 표로 확정되는가 | O0~O3의 §7.5 측정값(공식 로더 구성·코어 무수정·admission 판정·런타임 생성 여부·추론 횟수·프로세스 생존·거부 사유·거부 시점)이 셀마다 채워지고, **인용 셀은 인용으로 표시** |

**Q3이 FAIL이면**: O0가 oracle과 다른 답을 낸다는 뜻이고, 그건 **모델의 문제가 아니라 전처리·
입력 경로의 문제**다. 먼저 자기 도구를 의심한다(E35의 교훈).

---

## §4 비교하지 않는 것 (로드맵 §7.5가 미리 금지한 것)

> LiteRT 프로세스 RSS와 MLIR/IREE 부분 계약값은 **회계 범위가 다르므로 직접 우열 비교에 사용하지
> 않는다.**

그대로 채택한다. **O0의 메모리를 재지 않는다** — 재면 그 수치가 계약값과 비교되는 것을 막을 수 없고,
둘은 같은 것을 세지 않는다. 지연도 재지 않는다(`FUNCTIONAL_ONLY`).

---

## §5 과잉 거부(유형 B) 사전 점검

| # | 위험 | 방지책 |
|---|---|---|
| P1 | 새 배포 항목이 E41의 `telemetry` 게이트에 걸림 | **의도된 fail-closed다.** O0·O1 항목에 `telemetry`를 **선언**한다. 게이트를 완화하지 않는다 |
| P2 | LiteRT 플러그인이 `compiled_learner`의 계약 필수화를 상속 | 형제이지 상속이 아니다. 코드 공유는 **JSONL 레코드 형식**뿐 |
| P3 | 기존 4셀이 새 배포 항목 추가로 깨짐 | E33·E41의 보관 셀을 재판정해 **값 불변** 확인 |
| P4 | `ai_edge_litert` 부재 환경에서 시험이 **거짓 FAIL** | 정직한 SKIP(사유 포함). D24·D32 계열 |
| P5 | O0에 admission이 없다는 것을 *"OnAIR가 못 한다"*로 서술 | §0·§2가 금지. 시험으로 문서 텍스트를 고정한다 |

---

## §6 결과별 서술 (측정 전에 정한다)

| 관측 | 쓸 문장 |
|---|---|
| Q1~Q5 PASS | 로드맵 §7.6의 문장을 그대로 쓴다 — *"순수 OnAIR 경로는 공개 AI 모델의 실행 기능을 제공한다. 제안 경로는 여기에 컴파일 산출물 기반 앱별 예산 판정을 추가하여, 예산이 계약 요구량보다 작은 배포에서 IREE 런타임 생성과 추론을 시작하지 않았다."* |
| Q3 FAIL | 전처리·입력 경로를 먼저 의심하고, 도구 결함이 아니면 **FAIL을 그대로** 적는다 |
| Q4 FAIL(O1에 코드가 필요했다) | *"계약 비활성 경로가 코드 없이 열리지 않았다"* — 도구의 한계로 기록 |

**어느 경우에도 쓰지 않는 문장**: *"OnAIR가 계약을 위반했다"* · *"OnAIR가 메모리를 관리하지 못한다"* ·
*"MLIR 경로가 더 빠르다/작다"* · LiteRT RSS와 계약값의 직접 비교 · **O2·O3를 새 측정으로 계수**.

---

## §7 산출물

- `docs/EVIDENCE_v0.47_E42_E43.md`
- `plugins/litert_learner/` — 형제 플러그인(계약·admission 없음)
- `configs/deployments/onair_deployments.json` — `smartcam_litert`(O0) · `smartcam_no_budget`(O1)
- `results/e43_pure_onair/` — O0·O1 raw 실행 + 네 경로 비교표(인용 셀은 **인용으로 표시**)
- `harness/mk_e43_summary.py` — 표를 **생성**한다(D64: 손조립 금지)
- `harness/contract_negative_tests.py` · `EXPERIMENT_LOG.md` · `CHANGELOG.md` · `CLAUDE.md`
