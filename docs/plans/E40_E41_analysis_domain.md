# E40 / E41 계획 — 정적 상한의 분석 영역과 회계 규칙 공식화, 그리고 그 영역의 음성 시험

**상태**: 사전 고정 기준. **측정·구현 이전에 커밋한다.**
**출처**: `docs/reviews/ONAIR_MLIR_ADDITIONAL_RESEARCH_AND_BASELINE_PLAN.md` §5(E40) · §5.3-4(E41),
로드맵 §8의 순서 E39 → **E40 → E41** → E42 → E43 → E44.
**선행**: E39a(`results/e39_prior_art/`) 완료.

---

## 0. 이 계획이 로드맵 처방을 그대로 따르지 **않는** 지점과 그 근거

로드맵 §5.3의 처방 3건을 문자 그대로 적용하면 **이 저장소에 새 결함이 생긴다**는 것을
착수 전 조사에서 실측으로 확인했다. 이 저장소는 지금까지 다섯 번(N1·N3·R4·F1·F3) 같은 이유로
검토 처방을 좁혀 채택했고, 여기서도 같은 규율을 적용한다. **양방향 결함 정의**(fail-open과
과잉 거부 둘 다 결함)가 판단 기준이다.

| 처방 | 문자 그대로 적용하면 | 채택 형태 |
|---|---|---|
| §5.3-1·2 구조적 walker를 **정본 추출기**로, 정규식을 교차검사로 | **값의 출처**가 바뀐다. walker의 `_extract_constants`(`mlir_alloc_walk.py:208-217`)는 `stream.resource.alloc`(=packed)만 합산하므로 `dense_sum`이 사라지고, `make_contract.py:721`의 D17 정렬 패딩 carve-out이 무력화된다(D17은 원장에 **과잉 거부**로 기록된 결함이다). 또 `iree.compiler.ir` 부재 환경에서 `--allow-missing-structural-checker`가 **구현 불가능**해진다 | **권위와 값 출처를 분리한다.** walker는 이미 필수이고 불일치 시 계약이 생성되지 않으므로 *이미* 권위다(`make_contract.py:544-545`의 `diff_against_regex` → `:575`의 hard fail). 문서에서 "정본"이라는 말을 **`diff_against_regex`가 비교하는 다섯 항목에 한정**해 명시하고, 값 출처는 바꾸지 않는다 |
| §5.3-3 계약에 `analysis_domain` 8키 블록 추가 | (a) 8키 중 4키가 **순수 rename**이라 같은 사실이 두 곳에 살게 된다(D65 재발). (b) `make_contract.py:923`의 `"static shapes"`는 **리터럴**이고 `all_static`에서 유도되지 않는다 — `contract.dynamic.*`는 `all_static=False`·`bound_method=NONE`·`unresolved_sizes=['%1','%6','%5']`인데 `bound_assumptions[0]='static shapes'`를 선언한다. 지금은 아무도 읽지 않아 무해하지만 기계 판독 필드로 승격하면 **거부하려고 만든 바로 그 계약에 기계 판독 가능한 거짓 단언**이 실린다(fail-open 신설) | **원천을 먼저 고치고**(유도로 전환), 진짜 없는 것만 추가한다 |
| §5.3-4 조건 5 "계약과 다른 HAL driver면 fail-closed" | driver는 이 현상의 **통제 변수가 아니다** — 같은 vmfb를 `local-sync`/`local-task`로 실행해 HAL 피크가 **바이트 동일**(b2_resnet 309,416). `local-sync`는 동시 호출을 막는 장치가 아니다 | driver는 **선언 불일치 거부**(다른 validity 항목과 같은 취급)로 다루고, 피크가 같았다는 실측을 함께 기록한다. "다른 driver는 위험하다"고 쓰지 않는다 |

---

## 1. 착수 전 조사 — 이 계획이 딛고 있는 실측 (실험 아님, 판정 아님)

전부 이 컨테이너에서 직접 실행해 확인했다.

### 1.1 로드맵 §5.2의 8행 중 실제로 비어 있는 것

| §5.2 행 | 계약에 있는가 | 근거 |
|---|---|---|
| 형상 | **있음(그러나 부정확)** | `interface.all_static`(기계 판독) + `bound_assumptions[0]`(리터럴, dynamic에서 거짓) |
| 호출 수 | 산문만 | `bound_assumptions[1]="single in-flight call (no concurrency)"` |
| 출력 수명 | **없음** | `output_lifetime`·`released_before_next_call` 저장소 전체 0건 |
| 지원 연산 | **없음** | `supported_resource_ops` 0건. 계약에는 `bound_source` 자유 문자열에만 op 이름이 나온다 |
| 미지원 연산 | 관측 가능 | `unresolved_sizes` + `bound_method=NONE`로 사후 관측은 되지만 **정책 선언**은 없음 |
| 상수 정책 | **없음** | 계약 **19개 중 0개**가 `try_map` 분기도 **64바이트 정렬 전제**도 언급하지 않는다 |
| 실행 환경 | 있음 | `target.*` + `validity.*`(compiler/commit/driver/profile) |
| 측정 대응 | 있음 | `resources.scope`가 제외 영역을 명시 |

두 추출기의 화이트리스트는 **집합 동일**(6 op)이다 — 별도 결함이 아니다.

### 1.2 §5.1 수식의 이름과 코드의 실제 규칙이 어긋난다

| 기호 | 로드맵의 이름 | 코드의 실제 규칙 | 실물 반례 |
|---|---|---|---|
| `O` | 외부 **출력 버퍼** | entry body의 `stream.resource.alloca` **kind=external 합** = 할당된 슬랩 | multiout: 선언 출력 32+16=**48 B**인데 `static_external_output_bytes`=**128** |
| `C` | 모듈 상주 **상수** | `#util.composite<Nxi8>` **packed** 크기(정렬 패딩 포함) | vww packed 841,728 vs dense 841,664(**pad 64**) · bigact 14,016 vs 13,984(**pad 32**) |
| `T` | post-layout slab의 **보수적 합** | 각 slab은 **정확값**(정렬·재사용이 이미 안에 있음). 합이 보수적이 되려면 slab이 2개 이상이어야 하는데 **계약 19개 전부 slab ≤ 1** → 그 수식어는 현재 **공허** |

`B = P + C`는 커널 태스크 스택(`kernel_task_stack_bytes`)과 `resources.scope`가 명시한 제외
영역을 포함하지 않는다 — 그것이 "**partial** per-app contract"의 *partial*이다.

### 1.3 동시 호출 전제는 load-bearing이다 (측정)

같은 vmfb를 호스트 스레드 N개가 동시에 호출했을 때의 HAL 피크(`local-sync`, 출력 즉시 해제):

| 모델 | per_call | bounded | N=1 | N=2 | N=4 |
|---|---:|---:|---:|---:|---:|
| b2_resnet | 309,416 | 618,856 | 309,416 | 618,832 | **1,237,664 (bounded의 2.00×)** |
| smartcam | 9,382,092 | 18,222,796 | 9,382,092 | **18,764,184 (> bounded)** | **37,528,368** |
| b3_deepae | 6,208 | 1,069,632 | 6,208 | 6,208 | 21,184 |
| multiout | 192 | 704 | 192 | 384 | 448 |

- 겹침이 실제로 일어나면 피크는 **최대 N × per_call**이고, 느린 모델에서 안정적으로 겹친다.
  **반복 측정으로 결정성이 갈렸다**: b2_resnet은 N=2·N=4 각각 3/3회 같은 값,
  smartcam은 N=2에서 3/3회 18,764,184(`peak_within_bounded=false`). 반면 b3_deepae N=4는
  5회가 {18,624 · 6,208 · 6,208 · 12,416 · 6,208}로 **비결정적**이다 — 모델이 너무 빨라
  스레드가 실제로 겹치지 않는 회차가 있다. 따라서 **N배는 상한이지 법칙이 아니다.**
- **실물 비행 모델 SmartCam은 동시 호출 2개만으로 `bounded`를 넘는다.**
- **D50과 분리했다**: 같은 셀을 결과 보유 / 즉시 해제로 각각 측정해 **피크 동일**, `freed`만
  스레드당 40 B 차이 — 증가분은 출력 수명이 아니라 **동시 호출** 때문이다.

### 1.4 그런데 이 저장소가 출하하는 배포 중 어디서도 그 조건에 도달할 수 없다

- `native_learner.c` · `ai_learner.c`: `pthread_*` / `CFE_ES_CreateChildTask` / `OS_TaskCreate` **0건**.
- OnAIR 공식 경로: `sbn_adapter.py`·`redis_adapter.py`의 스레드는 **수신 버퍼만** 채우고,
  플러그인 호출은 `onair/src/reasoning/agent.py:43-64` 메인 루프 한 곳이다.

→ E41은 **도달 불가능한 조건에 게이트를 세우지 않는다.** 대신 (a) 전제를 선언하고,
(b) 배포가 그 전제를 **구조적으로** 지킨다는 것을 시험으로 고정하고,
(c) 전제를 깼을 때의 결과를 **직접 API 프로브**로 측정해 보존한다.

---

## 2. E40이 하는 일

1. **원천 정정**: `make_contract.py`의 `assumptions`에서 `"static shapes"` 리터럴을 제거하고
   `all_static`에서 유도한다. → `contract.dynamic.{x86_64,aarch64}.json` **2개**의
   `bound_assumptions[0]`·`validity.assumptions[0]`이 바뀐다. 나머지 **12/14는 불변**이다.
   이것은 회귀가 아니라 **거짓 선언의 정정**이며 규율 3에 따라 덧붙여 기록한다.
2. **`analysis_domain` 블록 신설** — 단, 8키 평면 나열이 아니라 **유도된 사실**과
   **배포가 지켜야 할 전제**를 분리한다.
   - `derived`: `static_shapes`(←`all_static`), `driver`(←`target.driver`), `entry`(←`model.entry`),
     `supported_resource_ops`(← 코드 상수를 **import**해서 방출, 재타이핑 금지),
     `unknown_operation_policy`, `constant_policy`(map/copy 두 분기와 **64바이트 정렬 전제**).
   - `required_premises`: `max_in_flight_calls: 1`, `output_lifetime: "released_before_next_call"`.
3. **회계 규칙을 계약이 스스로 말하게 한다**: `O`·`C`·`T`의 실제 규칙(§1.2)을
   `accounting_rules`로 방출한다.
4. **드리프트 가드**: `analysis_domain.derived.*`가 원천 필드와 다르면 계약 생성을 거부한다.
5. **회귀 diff**: `IGNORE_PROVENANCE_SUBTREES`에 `analysis_domain`·`accounting_rules`를 넣는다
   (`IGNORE_PROVENANCE_KEYS`는 `k[-1]` 비교라 `driver`·`entry` 같은 bare 이름을 넣으면
   `target.driver`·`model.entry` 드리프트까지 침묵시킨다 — 유형 A 신설). 제외한 자리는
   **전용 pin 시험**으로 값을 고정한다(E24b/D39·E24/N2·E24c/F3 전례 그대로).

### E40 판정 기준 (측정 전 고정)
- **Q1** 보관 14개 계약 재생성 시, 위 2개의 `dynamic` 계약의 `assumptions[0]`을 제외한
  **모든 수치가 diff 0**.
- **Q2** `analysis_domain.derived`의 모든 키가 원천 필드와 일치(드리프트 가드가 실제로 거부함을
  주입으로 확인 — revert-and-confirm-fail).
- **Q3** `dynamic` 계약에서 `analysis_domain.derived.static_shapes == false`.
  (지금 코드로는 `true`라고 **거짓말**한다 — 그것이 이 항목의 존재 이유다.)
- **Q4** 생성된 헤더의 바이트가 14/14 불변이거나, 바뀌면 그 이유가 설명된다.

---

## 3. E41이 하는 일 — 다섯 조건

| 조건 | 현재 상태(실측) | E41의 형태 | 게이트인가 |
|---|---|---|---|
| 1. 동적 크기 | **이미 닫혀 있음** — `bound_method=NONE` → `BOUND_KNOWN=0` → C 게이트 거부 | 계약 층 단언 추가(`derived.static_shapes == interface.all_static`) | 예(기존) |
| 2. 미지원 resource op | 단위 시험 1건(`contract_negative_tests.py:218`) | 계약 층으로 올린다: `unknown_operation_policy` 선언 + 미인식 op 주입 시 `UNKNOWN_BOUND` | 예(기존) |
| 3. 둘 이상 in-flight | **선언만 있고 관측 없음**. 위반 시 SmartCam은 N=2에서 `bounded` 초과(측정) | **배포 경로가 구조적으로 단일 스레드임을 시험으로 고정** + 위반 결과를 직접 API 프로브로 보존 | **아니오**(배포 경로에서 도달 불가) |
| 4. 출력 수명 | `steady_within_per_call`이 사실상 이것을 재고 있으나 **선언이 없다** | `required_premises.output_lifetime` 선언 + 보유/해제 대조를 회귀로 고정 | 아니오(관측) — **무조건 계층에서는 게이트로 만들면 안 된다** |
| 5. 다른 HAL driver | OnAIR 플러그인이 배포 설정의 `driver`를 쓰고(`compiled_learner_plugin.py:99`) **계약의 선언 driver와 대조하지 않는다** | **불일치 거부**(다른 validity 항목과 동일 취급). 피크가 같았다는 실측도 함께 기록 | 예(신설) |

> **조건 5의 과잉 거부 함정(착수 전에 확인함)**: 선언 driver를 `validity.driver`에서만 읽으면 legacy fixture(`plugins/compiled_learner/runtime/contract.json`)가 **`validity: null`**이라 정직한 E33 `p_legacy` 셀이 거부된다 — E23이 D31로 이미 한 번 출하했던 유형이다. `validity.driver` **또는** `target.driver`에서 읽고, 배포 설정 4개가 전부 `driver` 키를 생략해 기본값 `local-sync`를 쓴다는 사실(실측)까지 확인한 뒤에만 넣는다. 계약 19개 전부 `target.driver`를 가지므로 이 형태에서 과잉 거부는 0이다.

> **조건 3의 정확한 범위**: "도달 불가"는 **배포 경로**(`native_learner.c`·`ai_learner.c`·OnAIR
> 공식 루프)에 한정한 진술이다. `iree.runtime` **직접 호출**에서는 도달 가능하고 실제로
> 위반을 측정했다(§1.3). 따라서 "이 성질은 위반될 수 없다"고 쓰지 않는다 — 쓸 수 있는 것은
> **"이 저장소가 출하하는 배포 중 어느 것도 그 조건을 만들지 않는다"**까지다.
> 그리고 **AI_LEARNER에 스레드를 넣어 시험하는 일은 하지 않는다** — 부재를 단언하려고
> 그 위험을 비행 앱에 심는 것이 되기 때문이다.

> **조건 4를 문자 그대로 게이트로 만들면 과잉 거부다(실측)**: D50 조건(반환 버퍼 4개 보유)에서
> b2_resnet의 피크는 **309,576**인데 그 셀의 무조건 예산은 **618,856**이다 — **예산의 50.0%**를
> 쓰는 정직한 실행을 거부하게 된다(D31·D47·D48·D49·D57·D58과 같은 유형 B). 이 조건이 실제로
> 무는 곳은 **조건부 계층뿐**이고(309,576 > `per_call` 309,416), 거기서는 **D59의
> `peak_within_admitted_budget`가 이미 탐지·보고하고 있다.** 따라서 신설 게이트는 없다.

> **조건 5에서 재현된 fail-open 1건**: `gen_contract_header.py:462`는
> `v.get("driver", "local-sync")`이고 `v = c.get("validity") or {}`(:148)라,
> **`validity`가 없는 계약이 조용히 `CONTRACT_DRIVER "local-sync"`를 단언하는 헤더**를 만든다
> — `target.driver`는 아예 보지 않는다. 도달성은 낮다(생성기가 항상 두 자리에 쓰므로 수동 편집만
> 도달, `docs/ASSUMPTIONS_AND_SCOPE.md`가 범위 밖으로 선언). 그러나 수정의 **과잉 거부 위험은 0**이다
> (`contracts/`·`results/` 계약 전부가 두 필드를 갖고 값이 전부 `local-sync`). `validity.driver`
> **또는** `target.driver`에서 읽고 **둘 다 없으면 거부**한다(D29: 부재는 신호가 아니다).

### E41 판정 기준 (측정 전 고정)
- **R1** 조건 1·2는 **이미 닫혀 있음을 시험으로 보인다**(새 게이트 0개). 조건 5만 신설이며,
  거부가 실제로 일어난다(revert 시 시험이 FAIL).
- **R2** 조건 3·4는 **게이트가 아니라 관측**으로 기록되고, 그 사실과 **그렇게 정한 이유**
  (각각 도달 불가 / 실측 과잉 거부)가 문서에 명시된다.
- **R3** **과잉 거부 0**: 저장소의 정직한 계약·배포(계약 19개, cFS/native/OnAIR/pip 셀)가
  새 조건 때문에 하나도 거부되지 않는다. 특히 **b2_resnet의 D50 보유 셀이 여전히 통과**한다.
- **R4** 조건 5의 신설 거부가 E33의 4셀을 깨지 않는다(전부 `local-sync`이므로 일치해야 한다).
- **R5** 헤더 생성기의 driver fail-open이 닫히고(둘 다 없으면 거부), 보관 14개 **헤더 바이트 불변**.
- **R6** 스위트 총계가 늘고 **기존 570건이 하나도 깨지지 않는다**(기준선: 이 컨테이너 570/570 실측).

---

## 4. 하지 않는 것 (명시)

- 정규 MLIR pass. E40은 여전히 post-processing이며 그 표현을 바꾸지 않는다.
- `analysis_domain`을 전체 OBC RAM 보증으로 확대하는 서술.
- 동시 호출을 막는 런타임 게이트(도달 불가능한 조건에 fail-closed를 붙이지 않는다).
- 새 모델 반입, 정확도 주장, 지연 측정.
- E42~E44(순수 OnAIR 기준선·O0~O3·예산 출처)는 별도 실험이다.
