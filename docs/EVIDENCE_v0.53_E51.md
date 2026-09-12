# EVIDENCE v0.53 — E51: 중심 주장의 성립 조건 세 가지

- 실험 ID: **E51** · 날짜: 2026-09-12 · 기준 커밋(계획): `4e5a906`
- 사전 고정 기준: `docs/plans/E51_claim_preconditions.md` (**측정 이전 커밋**)
- 근거 문서: `docs/reviews/DECISIONS_v0_52_REVIEW.md` §5.1~§5.3, §9 단계 1~3
- 증거 등급: **결정론적** (소스 실행 추적 · IR 주입 재현 · 보관 원자료 판독). 지연값 없음.
- 산출물: `results/e51_claim_preconditions/{stage1_preconditions,stage2_sequential_calls,stage3_accounting_map}.json`
- 회귀: 이 컨테이너 **776/776 → 796/796** (FAIL 0 · SKIP 0), 보관 14개 계약 diff 0

## §0 이 실험이 답한 것

검토서는 §검토 한계에서 **v0.52 저장소를 다시 실행·검증하지 않았다고 스스로 적었다.** 따라서
*"E50이 이 조건을 충족했다면 추가 구현 없이 근거만 연결하면 된다"*(§5.1)가 실제로 성립하는지는
E50의 산문이 아니라 **우리 실행**이 답해야 한다. 세 단계 전부 **PASS**이고, **새 게이트는 0개**다
(계획 §1이 측정 전에 그렇게 못박았다 — E50이 바로 그 조건을 hard fail로 만들었다가 유형 (B)를 냈다).

## §1 단계 1 — 전제 검사가 계약 생성 경로에 실제로 연결됐는가

`harness/e51_precondition_trace.py`. **Q1~Q4 전부 PASS.**

### Q1 — 검사가 호출되는가 (읽은 것이 아니라 **실행**한 것)

production 진입점 `make_contract.build_contract()` 를 `sys.settrace` 아래에서 in-process 실행하고,
각 검사가 사는 줄이 실행됐는지 기록했다. 줄 번호는 실행 시점에 **anchor 문자열로 찾는다** — 못 찾으면
`false`가 아니라 `anchor_not_found`다(D51: *"볼 수 없었다"*와 *"보았더니 없더라"*는 다르다).

| 검사 | 위치 | 호출됨 |
|---|---|:--:|
| 지원 연산 — 정규식 파서의 화이트리스트 (D13) | `static_mem_bound.py:179` | ✔ |
| 지원 연산 — 구조적 walker의 같은 검사 (E19 두 구현) | `mlir_alloc_walk.py:176` | ✔ |
| 비동기 연산 — post-layout entry 의 `stream.async.*` (D86) | `mlir_alloc_walk.py:172` | ✔ |
| 미분류 할당 — `unresolved` → `all_static=False` → `bound_method=NONE` | `make_contract.py:469` | ✔ |
| 미분류 할당 — 두 추출기의 `unresolved(presence)` 대조 | `mlir_alloc_walk.py:322` | ✔ |

**5/5 실행됨.** 회귀 시험은 저장된 줄 번호를 믿지 않고 **라이브 소스에서 anchor를 다시 찾는다** —
검사를 옮기거나 지우면 실패한다.

### Q2 — 전제를 깨면 배치 가능한 산출물이 나오지 않는가

보관 layout IR(`x86_64/mlp16k`)을 외과적으로 편집(**재컴파일 없음** — 작업 규율 7)해 전제를 하나씩
깨고 production 서브프로세스를 실제로 돌렸다.

**양성 대조를 먼저 통과시켰다**: 편집하지 않은 같은 IR을 같은 명령으로 돌리면 rc=0 ·
`bound_method=static_from_stream_layout` · 계약 발행. 이것 없이는 `rc=1`이 아무 근거도 아니다
(E38의 witness가 양성 대조를 먼저 요구하는 것과 같은 규율).

| 주입 | 어느 추출기가 봤나 | 결과 |
|---|---|---|
| `stream.resource.frobnicate` (화이트리스트 밖) | 정규식 파서 | rc=1 · **계약 미발행** |
| `stream.async.alloca` (post-layout entry) | 구조적 walker | rc=1 · **계약 미발행** |
| 비상수 크기(`arith.addi`)의 `resource.alloca` | **둘 다** | rc=0 · 계약은 나오되 `bound_method=NONE` · **헤더 미생성** |

세 번째가 *"계약 파일이 아예 안 나온다"*가 아닌 것은 **설계대로다** — 상한을 말하지 않는 계약은
`dynamic` 계약과 같은 형태이고, 그것을 막으면 E24가 N1에서 고친 과잉 거부를 되살린다. 판정 기준은
그래서 *"배치 가능한 산출물이 나오지 않는가"*이고 두 형태를 모두 통과로 센다.

**D86이 load-bearing임을 실측했다.** 같은 추출 결과에서 D86 분기의 기여만 제거하고 다시 대조하면:

| | `diff_against_regex` | D86 분기 제거 시 |
|---|---|---|
| `pre_scheduling_async_op` | `['unresolved(presence)']` → 거부 | **`[]` → 계약이 발행된다** |

즉 그 분기를 *"중복이니 지워도 된다"*고 판단하면 스케줄이 끝나지 않은 entry에서 읽은 수치로 계약이
나온다. 회귀 시험이 이 두 값을 함께 고정한다.

### Q3 — 정상 모델은 같은 값으로 통과하는가

`contract_negative_tests.py::regression_check`를 **그대로 호출**한다 — 14/14 diff 0은 이미 거기 있고,
두 번째 구현을 만들면 같은 사실이 서로를 대조하지 않는 두 자리에 산다(E44의 교훈). **14/14 unchanged.**

### Q4 — 감사 도구의 통과와 배포 계약의 통과가 구분되는가 (이 단계의 진짜 신규 항목)

| | 감사 (`e49_alloc_ledger.py`) | 배포 (`make_contract.py`) |
|---|---|---|
| 적용 범위 | **네 실물 모델**(측정: `results/e49_research_audit/ledger/` 4개) | 모델 목록 없음 — **호출마다 그 입력만** |
| 계약 생성이 호출하는가 | **아니오**(소스에 `e49_alloc_ledger` 0건) | 해당 없음 |
| 통과의 뜻 | 그 네 모델에서 ledger 합계 = 계약값 | 이 호출의 layout IR에서 전제 검사 통과 |

저장소 계약 **32개** 중 ledger가 본 것은 **4개**다. 두 통과는 같은 통과가 아니고, 그 사실이 이제
산문이 아니라 기계가 읽는 자리에 있다.

## §2 단계 2 — 순차 호출 근거를 호출부까지

`harness/e51_sequential_calls.py`. **PASS, 그리고 상태는 `ARGUED_FROM_SOURCE` 그대로다.**

검토서 §5.2-4가 요구한 **두 주장의 분리**를 별도 필드로 싣는다.

**(A) 실행기가 스레드를 만들지 않는다** — *센다*. 세 배포 전부 `pthread_create`·
`CFE_ES_CreateChildTask`·`OS_TaskCreate`·`signal(`·`sigaction`·`threading.`·`multiprocessing`·
`concurrent.futures`·`asyncio` **0건**. 이것이 E49가 이미 센 쪽이고, **외부에서 동시에 부르지
않는다는 뜻이 아니다.**

**(B) 외부 호출이 순차적이다** — *읽는다*. 이쪽이 빠져 있던 절반이다.

| 배포 | invoke 호출부 | 구동 |
|---|---|---|
| cFS `ai_learner.c` | `:576` (`AI_LEARNER_Init` 안 e25 재생 for 루프) · `:662` (`AI_LEARNER_Infer`) | `AppMain:717` `while (CFE_ES_RunLoop(&run))` → `:719` `CFE_SB_ReceiveBuffer` → **동기** `AI_LEARNER_Infer(buf)` |
| `native_learner.c` | `:373` · `:417` (둘 다 `main` 아래 for 루프) | 단일 제어 흐름 |
| OnAIR `compiled_learner` | `:426` (`render_reasoning`) | OnAIR 코어 (`sim.py:50` `while self.simData.has_more(): self.agent.reason(next)`, commit `e8af118`) |

**cFS의 두 호출부는 겹칠 수 없다** — 하나는 `Init` 안, 하나는 `Init` 이후의 RunLoop 안이다. 둘은
`g.session`·`g.x`(입력 버퍼 하나)를 공유하므로 이 배타성이 곧 `max_in_flight_calls = 1`이 성립하는
이유이고, `static feat[]/out[]/outs[]/yv[]`(D52·D75)가 공유돼도 되는 근거다.
OnAIR 쪽은 `_input_fresh`가 False면 invoke 하지 않고 `stale`로 되돌린다(E33) — 같은 입력에 호출이
거듭 발생하지 않는다.

**상태는 올리지 않았다.** 호출부를 읽어도 관측이 되지 않는다. `OBSERVED`로 올리려면 invoke 진입·종료의
call id 기록이 필요하고 이 실험은 만들지 않았다(§5.2-5가 소스 근거로 충분하면 신규 계측을 생략해도
된다고 했고, 계획 §2가 **측정 전에** 이 규칙을 고정했다). `observed_value`는 `null`이다.

**OnAIR 코어는 저장소 밖 체크아웃**이라 커밋 해시(`e8af118`)를 함께 적어 무엇을 읽었는지만 식별
가능하게 했다. 체크아웃이 없으면 0이 아니라 사유를 적는다.

## §3 단계 3 — 기존 계약의 회계 매핑

`harness/e51_accounting_map.py`. **17행 전부 U·B 해결 · `H ≤ 승인 예산` 위반 0 · problems 0.**

계획 §3의 제약을 지켰다: **보관 계약 재생성 0** · **값 재계산 0**(전부 원자료에서 읽는다) ·
**정의는 `results/e49_research_audit/audit_matrix.json::accounting_scope`에서 인용**(재입력하지
않는다 — D65) · 연결표와의 겹침을 **먼저 세고** 중복 사본을 만들지 않았다(E44).

핵심 관측 — **승인 예산이 U의 어느 값과 같은지가 이제 행마다 추적된다**:

| `admission_mode` | 셀 수 | `admitted_budget_equals` |
|---|---:|---|
| `unconditional` | 7 | **전부 `bounded_bytes`** |
| `conditional_map` | 1 (`cells.cond_positive`) | **`static_per_call_bytes`** |
| 거부·예산무효 셀 | 9 | `null` (승인하지 않았다) |

예산이 **없는** 두 셀(`malformed_abc`·`zero_budget`)은 원자료가 `budget_invalid_event: true`로
**스스로 사유를 적고 있어서** 해결된 행으로 센다. 사유 없는 부재였다면 결손이다 — 요구 자체를
*"모든 셀에 숫자가 있어야 한다"*로 두면 정직한 fail-closed 셀 두 개가 결손으로 찍히고, 그것이 이
저장소가 반복해 만난 유형 (B)다.

**부수 발견 (D90)**: 같은 세 수치가 요약 생성기마다 **다른 이름**으로 저장돼 있다 —
`mk_e36_summary`는 `bounded`/`per_call`/`constants`, `mk_e36b_summary`·`mk_e48_summary`는
`bounded_bytes`/`static_per_call_bytes`/`module_resident_constant_bytes`. 수치·판정 영향은 0이지만
**판독 영향이 있다**: 한 철자만 아는 판독기는 다른 쪽에서 조용히 `null`을 보고한다. 이 도구의 첫 판이
실제로 E36 다섯 셀에 그렇게 했다. 보관 요약을 고쳐 쓰지 않고 **별칭을 명시 선언**했으며(퍼지 매칭은
그 자체가 결함 — D76), 행마다 읽은 철자를 싣는다.

## §4 이 실험이 자기 도구에서 잡은 것 (전부 판정 이전)

1. **주입을 `util.return` 뒤에 넣어 MLIR 자체를 깨뜨렸다.** 세 주입이 전부 rc=1로 거부됐지만 사유는
   주입과 무관했다 — walker가 그 청크를 파싱하지 못해 **이전(pre-layout) print로 조용히 후퇴**했고,
   거부 메시지에 찍힌 것은 그 후퇴한 청크의 `stream.async.clone`/`dispatch`였다.
   ***거부는 귀속될 때만 근거다.*** terminator 앞으로 옮기고, 셀마다 **각 추출기가 따로 무엇을 봤는지**
   기록하게 했다.
2. **절대 경로 root를 넘겨 14개가 전부 "다르다"고 나왔다.** 차이는 `provenance.dump_dir` 하나였고
   내 호출이 만든 차이였다. 판정에 닿기 전에 측정으로 확인했다.
3. **E36의 다섯 셀이 계약에 연결되지 않았다.** 최상위 `contract` 키에 점이 없어 scope를 루트가 아니라
   문자열 `"contract"`로 잡았다 — 7 problems · 그 소스에서 0행.
4. **가드가 보관 JSON만 pin하고 유도를 재실행하지 않았다 (D89).** 단계 2의 containment 로직을
   proximity로 되돌렸는데 **5/5 전부 통과**했다 — live 비교가 개수와 판정만 보고 enclosing_loop 모양을
   보지 않았기 때문이다. **D77이 경고한 형태를 그 D77을 따르려고 만든 가드가 그대로 범했다.**
   live 비교에 containment 모양을 넣자 revert 시 1건 FAIL.

## §5 revert-and-confirm-fail (양방향)

| 되돌린 것 | 결과 |
|---|---|
| 단계 2의 containment → proximity | **1건 FAIL** (가드 보강 후. 보강 전에는 0건 — §4-4) |
| 단계 3의 root-scope 계약 해석 | **1건 FAIL** |
| `mlir_alloc_walk.py`의 D86 분기 제거 | **2건 FAIL** |
| 전부 복원 | 796/796 |

## §6 주장하지 않는 것

- *"모든 전제를 강제한다"* → **쓰지 않는다**(계획 §5가 측정 전에 금지). 강제되는 것은 **재현된 결함
  집합**이고, 이 실험이 확인한 것은 다섯 검사가 호출되고 세 주입이 배치 가능한 산출물을 만들지
  못한다는 것까지다.
- *"`max_in_flight_calls = 1`을 관측했다"* → **아니다.** 상태는 `ARGUED_FROM_SOURCE` 그대로이고
  `observed_value`는 `null`이다. 호출부를 읽는 것은 논증의 보강이지 관측이 아니다.
- *"OnAIR 코어가 단일 스레드임을 저장소가 재현한다"* → **아니다.** 외부 체크아웃(`e8af118`)을 읽었고,
  없으면 사유를 적는다.
- *"E40의 `analysis_domain`이 모든 계약에 있다"* → **아니다.** E49 축 C가 못박은 대로 보관 계약
  32개 중 1개다. 단계 3은 그 범위를 바꾸지 않는다.
- *"단계 3이 새 수치를 만들었다"* → **아니다.** 전부 읽은 값이고, 유도된 것은 **읽은 값끼리의 비교**뿐이다.

## §7 다음

검토서 §10의 순서대로 **단계 4 — DeepAE 수치 불일치 원인 분석(E52)**. §4.4의 세 종료 조건을 따른다.
