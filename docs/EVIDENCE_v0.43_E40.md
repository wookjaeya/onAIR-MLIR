# EVIDENCE v0.43 — E40: 정적 상한의 분석 영역과 회계 규칙을 계약이 스스로 말하게 한다

**실험 ID**: E40 · **날짜**: 2026-09-11 · **플랫폼 등급**: FUNCTIONAL_ONLY(결정론적 값만 인용)
**촉발**: 아홉 번째 외부 로드맵 `docs/reviews/ONAIR_MLIR_ADDITIONAL_RESEARCH_AND_BASELINE_PLAN.md` §5
**사전 고정 기준**: `docs/plans/E40_E41_analysis_domain.md` (커밋 `9b7d5ba`, **구현 이전**)
**판정**: **Q1~Q4 전부 PASS**

---

## 1. 로드맵이 요구한 것과, 그대로 하면 생기는 일

§5.3은 세 가지를 처방했다: (1) 구조적 walker를 정본 추출기로, (2) 정규식은 교차검사로,
(3) 계약에 `analysis_domain` 8키 블록 추가. 착수 전 조사에서 **세 처방 중 둘이 이 저장소에
새 결함을 심는다**는 것을 실측했고, 계획서 §0에 그 근거와 채택 형태를 측정 이전에 고정했다.

이 실험이 채택한 형태는 **"권위는 그대로 두고, 진짜 없는 것만 유도해서 싣는다"**이다.

---

## 2. 이 실험이 고친 결함 — D70 (잠재 fail-open)

`harness/make_contract.py`는 계약의 전제 목록 첫 항목을 **리터럴**로 써 왔다.

```python
assumptions = ["static shapes", "single in-flight call (no concurrency)", ...]
```

그 결과 `contract.dynamic.{x86_64,aarch64}.json`은 다음을 **동시에** 선언하고 있었다.

| 필드 | 값 |
|---|---|
| `interface.all_static` | `false` |
| `resources.bound_method` | `NONE` |
| `resources.unresolved_sizes` | `['%1', '%6', '%5']` |
| `resources.bound_assumptions[0]` | **`"static shapes"`** |
| `validity.assumptions[0]` | **`"static shapes"`** |

즉 **상한을 말하지 않는다고 선언한 바로 그 계약이, 정적 형상이라고도 선언**하고 있었다.
`bound_assumptions`를 프로그램이 읽는 곳은 저장소에 **한 곳도 없었으므로**(쓰기 1곳, C 주석 1곳)
오늘까지는 무해한 산문 부정확이다. 그러나 로드맵이 요구한 대로 이것을 기계 판독 필드
(`analysis_domain.derived.static_shapes`)로 승격하는 순간, **이 저장소가 거부하려고 만든
바로 그 모델의 계약에 기계 판독 가능한 거짓 단언**이 실린다.

**이것이 D70이며, 처방을 문자 그대로 적용했다면 이 실험이 결함을 심었을 것이다.**
(같은 구조를 D31·E24의 N1/N3, E24b의 R4, E24c의 F1/F3에서 이미 다섯 번 겪었다.)

---

## 3. 무엇을 바꿨나

### 3.1 원천 정정 (유도로 전환)
`assumptions[0]`을 `all_static`에서 유도한다. 정적이면 `"static shapes"`, 아니면
`"NON-static shapes: no bound is stated (see resources.unresolved_sizes)"`.

### 3.2 `analysis_domain` — 평면 8키가 아니라 **두 반쪽**
로드맵의 8키를 그대로 나열하면 4키가 기존 필드의 **순수 rename**이 되어 D65(같은 사실이 두 곳에
살고 한 곳만 정정됨)를 재발시킨다. 그래서 성격으로 나눴다.

- **`derived`** — 이 도구가 컴파일러 산출물에서 **계산한 사실**. 전부 기존 필드를 먹이는
  **같은 변수**에서 나오고, 재타이핑하지 않는다(`supported_resource_ops`는
  `static_mem_bound.SUPPORTED_RESOURCE_OPS`를 **import**한다).
- **`required_premises`** — **배포가 지켜야 할 조건**. 이 도구는 컴파일러 산출물에서 확인할 수
  없다. 이것을 `derived`에 섞어 싣는 것이 곧 이 블록이 없애려는 fail-open이다.
  현재 두 항목: `max_in_flight_calls: 1`, `output_lifetime: "released_before_next_call"`.

`derived.constant_policy`는 §5.2가 "상수 정책: map/copy 분기와 정렬 전제"로 요구한 행이다.
**착수 전 조사에서 계약 19개 중 0개가 `try_map` 분기도 64바이트 정렬 전제도 언급하지 않음을
확인했다** — 계약이 두 개의 상한을 싣고 배포가 그중 하나를 고르게 하면서, **작은 쪽이 유효한
조건을 말하지 않고 있었다.** D53/D54가 게이트 층에서 가르친 교훈의 계약 층 판본이다.

### 3.3 `accounting_rules` — 이름과 코드를 일치시킨다
로드맵 §5.1의 수식 `P = I + O + T`, `B = P + C`는 산술은 맞지만 **이름이 세 곳에서 실제 규칙과
어긋난다**. 계약이 실제 규칙을 스스로 말하게 했다.

| 기호 | §5.1의 이름 | 실제 규칙 | 실물 반례 |
|---|---|---|---|
| `O` | 외부 **출력 버퍼** | `stream.resource.alloca` kind=external의 합 = **할당된 슬랩** | multiout: 선언 출력 32+16=**48 B** vs `static_external_output_bytes`=**128** |
| `C` | 모듈 상주 **상수** | `#util.composite<Nxi8>` **packed** 크기(패딩 포함) | vww 841,728 vs dense 841,664(**pad 64**) · bigact 14,016 vs 13,984(**pad 32**) |
| `T` | slab의 **보수적 합** | 각 slab은 **정확값**. 합이 보수적이려면 slab ≥ 2여야 하는데 **계약 19개 전부 ≤ 1** → 수식어가 **공허** |  |

`B = P + C`가 커널 태스크 스택과 `resources.scope`의 제외 영역을 포함하지 않는다는 것도
명시했다 — 그것이 *partial* per-app contract의 **partial**이다.

### 3.4 드리프트 가드 (거부, 노트 아님)
`analysis_domain_drift(contract)`가 `derived`의 모든 값을 원천 필드와 재대조한다. 하나라도
어긋나면 **계약을 쓰지 않고 `SystemExit`**. 대조 항목: `static_shapes`↔`bound_method`,
`driver`↔`target.driver`↔`validity.driver`, `entry`↔`model.entry`↔`validity.entry`,
`constant_policy` 두 arm↔`static_per_call_bytes`/`bounded_bytes`,
`supported_resource_ops`↔코드 상수, 그리고 **산문 `bound_assumptions[0]`↔기계 판독 플래그**.

### 3.5 회귀 diff는 **SUBTREE**로 제외
`IGNORE_PROVENANCE_SUBTREES`에 `analysis_domain`·`accounting_rules`를 넣었다.
`IGNORE_PROVENANCE_KEYS`는 **마지막 경로 성분**으로 비교하므로 거기에 `driver`·`entry`를
넣었다면 `target.driver`·`model.entry`의 드리프트까지 함께 침묵시켰을 것이다 — 드리프트를
잡으라고 있는 유일한 검사에 fail-open을 심는 일이다. 제외한 자리는 **전용 pin**으로 고정했다
(E24b/D39·E24/N2·E24c/F3 전례).

---

## 4. 보관 계약의 정정

`contract.dynamic.x86_64.json`·`contract.dynamic.aarch64.json`의
`resources.bound_assumptions[0]`·`validity.assumptions[0]` **4개 leaf**를 정정했다.
**수치는 하나도 바뀌지 않았고**, 나머지 12개 계약은 불변이며, 헤더는 전부 바이트 불변이다
(헤더 생성기는 전제 목록을 읽지 않는다). 규율 3에 따라 철회가 아니라 정정으로 기록한다.

정정 후 저장소 전체를 다시 훑어 **`static shapes`를 선언하면서 `bound_method=NONE`인 계약은
0개**임을 시험으로 고정했다.

---

## 5. 판정 (사전 고정 기준 대비)

| 기준 | 결과 |
|---|---|
| **Q1** 보관 14개 재생성 시 dynamic 2개의 `assumptions[0]` 외 **수치 diff 0** | **PASS** — 회귀 14/14 unchanged |
| **Q2** `derived`가 원천과 일치, 가드가 실제로 거부 | **PASS** — 주입 7종 전부 드리프트로 보고 |
| **Q3** `dynamic`에서 `derived.static_shapes == false` | **PASS** — 재생성 실측 `False`(conv2d는 `True`) |
| **Q4** 헤더 14/14 바이트 불변 | **PASS** |

**revert-and-confirm-fail (행위 수준)**: 유도를 리터럴로 되돌리고 `dynamic` 계약을 재생성하면
`make_contract`가 **rc=1로 작성 자체를 거부**한다 —
`resources.bound_assumptions[0]='static shapes' contradicts analysis_domain.derived.static_shapes=False`.
즉 이 가드는 산문과 기계 판독 값이 다시 갈라지는 것을 **구조적으로** 막는다.

**시험**: `harness/contract_negative_tests.py` **570/570 → 598/598**(이 컨테이너 실측,
FAIL 0 · SKIP 0). 신규 28건 = `e40_analysis_domain_cases` 14건 + 회귀 경로의 모델별
`analysis_domain agrees with its sources` 14건(7모델 × 2타깃, **프로덕션 경로에서** 확인).

---

## 6. 하지 않은 것 (명시)

- **구조적 walker를 정본 값 출처로 바꾸지 않았다.** 계획서 §0의 근거대로다 —
  walker의 `_extract_constants`는 packed만 합산하므로 `dense_sum`이 사라지고
  `make_contract.py`의 D17 정렬 패딩 carve-out(원장에 **과잉 거부**로 기록된 결함)이 무력화된다.
  walker는 이미 필수이고 불일치 시 계약이 생성되지 않으므로 *이미* 권위다.
- **정규 MLIR pass는 여전히 미착수다.** E40은 post-processing이며 그 표현을 바꾸지 않는다.
- `analysis_domain`을 전체 OBC RAM 보증으로 확대하는 서술.
- 조건 3·4(동시 호출·출력 수명)의 **게이트화** — E41에서 다루며, 계획서가 측정 전에
  게이트로 만들지 않기로 정한 이유를 거기 기록한다.
