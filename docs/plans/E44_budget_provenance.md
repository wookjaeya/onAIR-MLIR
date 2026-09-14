# E44 — 예산 출처(budget provenance) (사전 고정 기준)

> **측정 이전에 커밋한다.** 로드맵 §6.2의 세 필드를 **문자 그대로 추가하지 않는다** — 착수 전
> 조사에서 **둘은 이미 존재**하고 **로드맵의 enum은 구현이 없다**는 것을 실측했다. E40이 처방 3건 중
> 2건을 좁힌 것, E42/E43이 §7을 좁힌 것과 같은 이유다.

---

## §0 로드맵 §6.2가 요구한 것

- `budget_source`: mission configuration / cFS table / experiment override
- `budget_scope`: model HAL allocation
- `reservation_semantics`: declared 또는 enforced

그리고 그 이유를 §6이 정확히 적었다:

> 테이블 값은 그 자체로 물리 RAM을 예약하지 않으므로 **`declared budget`으로 표시해야 한다**.

**그 취지는 옳고 그대로 채택한다.** 바꾸는 것은 *어디에 적는가*이다.

---

## §1 착수 전 실측 — 셋 중 둘은 이미 있고, enum은 구현이 없다

| 필드 | 실측 | 판정 |
|---|---|---|
| `budget_source` | **이미 있다.** `native/cfs_app/fsw/src/ai_learner.c`에 **8회**(`:139` `"macro"`, `:150` `"override"`), 요약 생성기 4개가 싣고, `contract_negative_tests.py`가 **5곳**(`:2514·:2521·:2580·:2700·:2839`)에서 pin한다 | **확장한다** — 값을 바꾸지 않고 **라벨이 없는 경로**에 붙인다 |
| `budget_scope` | **이미 세 곳에 있다.** `make_contract.py:1056`의 `resources.scope`, `accounting_rules.excluded`(E40), admission 레코드의 `"scope":"per_app_local_budget"` | **만들지 않는다** — 네 번째 이름을 붙이는 것이 **D65의 패턴**이다 |
| `reservation_semantics` | 저장소에는 **로드맵 문서에만** 있다. 그러나 **개념은 E39a의 사전 등록 축 A5**로 이미 존재한다 — `docs/plans/E39_novelty_audit.md:79` *"A5 \| 실제 **예약**을 하는가 \| declared / enforced / 해당 없음"* | **계약 필드로 만들지 않는다** — §2 |

### §1.1 로드맵의 `budget_source` enum은 채택하지 않는다

제안값 `{mission configuration, cFS table, experiment override}`를 그대로 쓰면 **근거 없는 주장**이 된다:

- **`cFS table`** — 이 앱은 CFE Table Service를 쓰지 않는다. `CFE_TBL`이 저장소에 15번 나오지만
  **전부 cFS 부팅 로그**(`native/results/*.log`)이고 **소스 사용은 0**이다(직접 확인).
- **`mission configuration`** — 실제로는 빌드가 정의하는 **CMake 매크로**다. 그것을 *"임무 설정"*이라
  부르는 것은 CLAUDE.md의 가드레일이 금지하는 종류의 승격이다.

**있는 그대로의 값을 쓴다**: `macro`(컴파일 타임 매크로) · `override`(초기화 시 런타임 오버라이드,
E36) · `argv`(native 실행기의 명령행 인자) · `deployment_config`(OnAIR 배포 JSON).
로드맵의 어휘로 **바꾸면** 기존 pin 5곳이 깨지고, 깨뜨릴 이유가 없다.

---

## §2 `reservation_semantics`는 계약 필드로 만들지 않는다 — A5를 계약에서 읽게 한다

E39a의 선행연구 비교표는 A2·A3를 **계약에서 읽는다**:

```python
"A2": "... (계약이 scope=%s 로 매 판정마다 명시)" % r.get("scope"),
"A3": "예 (bound_method=%s)" % r.get("bound_method"),
```

그런데 **A5만 손으로 쓴 산문이다**:

```python
"A5": "**declared** (예산은 앱에 부여한 값이며 물리 RAM을 예약하지 않는다)",
```

여기에 계약 필드 `reservation_semantics`를 신설하면 같은 사실이 **두 곳**에 살고, 그중 하나는
**어떤 가드도 대조하지 않는다** — D65가 명명한 바로 그 형태다.

**그래서 반대로 간다**: A5를 **저장소에서 유도**하게 만든다. `declared`의 근거는 *"어떤 경로도
물리 메모리를 예약하지 않는다"*이고, 그것은 **코드에서 확인할 수 있는 사실**이다 —
`mlock`·`mmap(MAP_POPULATE)`·`CFE_ES_PoolCreate`·`CFE_ES_GetPoolBuf` 같은 **예약 호출이 0건**임을
검사하면 된다. 검사가 참이면 `declared`, 예약 호출이 발견되면 **`enforced`가 아니라 `unknown`**으로
낮춘다(호출이 있다는 것과 그것이 이 예산을 예약한다는 것은 다르다 — **E28/D52가 게이트에 대해
배운 것**과 같은 구분이다).

---

## §3 실제로 하는 일

| # | 작업 | 왜 |
|---|---|---|
| 1 | `native/native_learner.c`가 `budget_source: "argv"`를 기록 | 예산을 `argv[2]`로 받으면서 **아무것도 라벨하지 않는다**(현재 `budget_source` 0회) |
| 2 | OnAIR 플러그인이 `budget_source: "deployment_config"`(또는 예산 부재 시 `none`)를 admission 레코드에 기록 | 같은 이유(현재 0회). 세 배포 경로 중 **cFS만** 출처를 말하고 있었다 |
| 3 | `mk_prior_art_table.py`의 A5를 **유도**로 바꾸고 근거를 싣는다 | §2 |
| 4 | `docs/ASSUMPTIONS_AND_SCOPE.md`에 **예산의 의미**를 한 문장으로 못박는다 | 로드맵 §6의 취지. 그 문서에 `예약`·`declared`가 **0건**임을 확인했다 |

**하지 않는 것**: `budget_scope` 신설 · 계약 스키마 변경 · 기존 `budget_source` 값의 개명 ·
로드맵 enum 채택 · 새 admission 판정 경로.

---

## §4 사전 고정한 판정

| Q | 질문 | PASS 조건 |
|---|---|---|
| **Q1** | 세 배포 경로가 **전부** 예산 출처를 말하는가 | cFS(`macro`/`override`) · native(`argv`) · OnAIR(`deployment_config`/`none`)가 각각 자기 레코드에 싣는다. **실행으로 확인**한다 |
| **Q2** | A5가 저장소에서 유도되는가 | `mk_prior_art_table.py`가 A5를 리터럴로 쓰지 않고, 근거(예약 호출 수)를 표에 싣는다 |
| **Q3** | `declared`의 근거가 참인가 | 예약 호출 검사가 **0건**을 보고한다. 0건이 아니면 `unknown`으로 낮추고 **그대로 적는다** |
| **Q4** | 기존 pin이 깨지지 않는가 | `contract_negative_tests.py`의 5곳이 **수정 없이** 통과하고, 보관 셀 재판정 값 불변 |
| **Q5** | 과잉 거부 0 | §5 |

**Q3이 FAIL이면**(예약 호출이 발견되면): A5를 `enforced`로 올리지 **않는다**. 호출의 존재는
*"이 예산을 예약한다"*를 뜻하지 않는다. `unknown`으로 낮추고 무엇을 찾았는지 적는다.

---

## §5 과잉 거부(유형 B) 사전 점검

| # | 위험 | 방지책 |
|---|---|---|
| P1 | `budget_source`를 **필수**로 만들어 기존 레코드를 거부 | **보고 필드이지 게이트가 아니다.** 없는 레코드는 그대로 읽힌다 |
| P2 | 로드맵 어휘로 개명해 pin 5곳이 깨짐 | **개명하지 않는다**(§1.1). 기존 값 `macro`·`override`는 그대로 |
| P3 | 예약 호출 검사가 **문자열 우연 일치**로 오탐 | 검사 대상을 소스 파일로 한정하고(로그 제외 — `CFE_TBL`이 15건 전부 로그였던 것이 실제 사례다), 찾은 위치를 **파일:줄로 기록**해 사람이 재검증 가능하게 한다 |
| P4 | A5 유도가 표의 다른 칸을 바꿈 | 표 재생성 후 **A5 외 칸 불변** 확인 |

**revert-and-confirm-fail**: A5를 리터럴로 되돌리면 Q2 시험이 실패해야 한다.

---

## §6 결과별 서술 (측정 전에 정한다)

| 관측 | 쓸 문장 |
|---|---|
| Q1~Q5 PASS | *"세 배포 경로가 각각 자기 예산의 출처를 기록하고, 선행연구 비교표의 `declared` 판정이 저장소에서 유도된다."* |
| Q3 FAIL | *"예약 호출이 발견됐다"* — A5를 `unknown`으로 낮추고 무엇을 찾았는지 적는다. **`enforced`로 올리지 않는다** |
| Q4 FAIL | pin이 깨졌다는 뜻이므로 **변경을 되돌린다** — 개명하지 않기로 한 이유가 바로 이것이다 |

**어느 경우에도 쓰지 않는 문장**: *"예산이 cFS 테이블에서 온다"*(구현 없음) ·
*"임무 설정이 예산을 정한다"*(실제로는 CMake 매크로) · *"예산이 메모리를 예약한다"* ·
*"`budget_scope`를 신설했다"*.

---

## §7 산출물

`docs/EVIDENCE_v0.48_E44.md` · `native/native_learner.c` · `plugins/compiled_learner/` ·
`harness/mk_prior_art_table.py` · `harness/budget_provenance.py`(예약 호출 검사, 순수 함수) ·
`docs/ASSUMPTIONS_AND_SCOPE.md` · `results/e44_budget_provenance/` ·
`harness/contract_negative_tests.py` · `EXPERIMENT_LOG.md` · `CHANGELOG.md` · `CLAUDE.md`
