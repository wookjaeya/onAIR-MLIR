# EVIDENCE v0.58 — E55: v0.57 필수 후속 작업 (P0-1 ~ P0-4)

**근거 지시**: `docs/reviews/MANDATORY_FOLLOWUPS_v0.57_RECOMMENDATION.md`(원문 보존, sha256 `e7074a20…`).
**사전 고정 기준**: `docs/plans/E55_mandatory_followups.md` — 커밋 `a63149b`, **측정 이전**.

지시는 선택적 확장이 아니라 네 항목의 완료를 요구했고, 각 항목의 완료 기준을 §2~§5에서 **문장으로 미리
고정**했다. 이 문서는 그 기준에 대한 답이다. **기준은 측정 후에 바뀌지 않았다.**

---

## §1 P0-1 — 참조 예산의 NASA 1차 출처

### 1.1 착수 전 확정 — 지시가 준 세 URL은 E54가 **한 번도 재 본 적이 없는** 경로다

E54의 기계 판독 매니페스트(`results/e54_reference_budget/sources/source_manifest.json::
blocked_primary_sources.probes`)가 기록한 URL은 **넷**이고, 지시 §2가 준 셋과 **하나도 같지 않다**:

| | E54가 프로브한 것 | 지시가 준 것 |
|---|---|---|
| SWEHB | `swehb.nasa.gov/display/SWEHBVC/9.12+-+Resource+Margins` (옛 Confluence `display` 경로) | `swehb.nasa.gov/spaces/SWEHBVD/pages/102695803/9.12%2BResource%2BMargins` (**`spaces` 경로 · VD**) |
| NPR 7150.2D | `nodis3.gsfc.nasa.gov/displayDir.cfm?t=NPR&c=7150&s=2D` (질의형) | `…displayDir.cfm?Internal_ID=N_PR_7150_002D_&page_name=Chapter5` (**Internal_ID 형**) |
| GSFC-STD-1000 | **기록 없음** | `standards.nasa.gov/system/files/tmp/GSFC-STD-1000RevI_Approved_0.pdf` |

**GSFC-STD-1000은 E54의 매니페스트에 프로브 기록이 없다.** E54 계획 §1이 `standards.nasa.gov`라는
*호스트*가 차단됐다고 산문으로 적었을 뿐 이 PDF를 지목한 적이 없다 — 즉 **지시는 새 1차 출처를
실제로 하나 추가한다**. 이것이 이 항목을 재실행할 근거였다(E45/E47의 교훈: *"이 호스트가 막혔다"*는
관측이고 *"이 자료를 조달할 수 없다"*는 결론이며, 그 사이에 *"다른 경로를 재 봤는가"*가 있다).

또한 E54가 실제로 **도달한** 것은 NPR 7150.2**C** 미러다(개정 C이지 D가 아니다).

### 1.2 마진 수치의 정확한 상태 (지시 §2의 "50/50/40/30%")

`budgets.json`이 실제로 **쓴** 마진은 **둘**이다 — `pdr50`(0.50)·`ship30`(0.30).
전사된 네 값(SRR 50 / PDR 50 / CDR 40 / Ship 30)은 매니페스트의 `consequence` 문장에 있고,
지시 §2의 *"50/50/40/30%"*는 그 넷을 가리킨다. **둘은 모순이 아니다** — 넷을 전사했고 둘을 썼다.

### 1.3 취득 결과 — 세 대상에 **66개 경로**를 재 봤고, 하나를 취득했다

원자료: `results/e55_mandatory_followups/p0_1_sources/nasa_probe_log.json`(시도마다 URL·방법·HTTP 코드·
바이트 수·받은 바이트가 실제로 그 문서인지를 싣는다).

| 대상 | 시도 경로 | 취득 | 등급 |
|---|---:|---|---|
| SWEHB **SWE 9.12 Resource Margins** | 27 | ✘ | `transcribed_from_directive_primary_blocked` |
| **GSFC-STD-1000 Rev. I** Table 3.07-1 | 20 | ✘ | `transcribed_from_directive_primary_blocked` |
| **NPR 7150.2D §5.4.5** [SWE-199] | 19 | **✔** | `mirror_adjacent_revision_fetched` + `revision_match: same_revision_D` |

**차단의 기전을 이름 붙였다.** NASA 호스트 전부(`swehb` · `nodis3.gsfc` · `nodis.hq` · `ntrs` ·
`standards` · `www.nasa.gov` · `sma` · `nen` · `appel`)가 `curl 000 (CONNECT tunnel failed, 403)`이고
WebFetch는 `EGRESS_BLOCKED`다. 평문 HTTP로 프록시가 돌려준 **101 B** 본문이
`Host not in allowlist: swehb.nasa.gov.`였다 — 즉 **NASA 쪽 실패가 아니라 이 컨테이너 프록시의
호스트 allowlist 정책 거부**다. **바이트를 받은 것은 취득이 아니다**(그 바이트는 거부문이지 문서가 아니다).
호스트가 거부되므로 같은 호스트의 다른 경로를 더 시도하는 것은 의미가 없고, **그 구분을 확인한 뒤 중단했다**.
`web.archive.org`·`archive.org`·`timetravel.mementoweb.org`도 전부 차단됐다. 살아 있는 통로는
GitHub 계열뿐이었고 — E47·E39b가 확인한 `raw.githubusercontent.com` 개방이 **세 번째로 재현됐다**.

**GSFC-STD-1000은 지시가 추가한 새 출처였고, 이번에 처음 쟀다.** WebSearch가 찾아 준 NASA 미러 하나는
**Rev G**였고 지시가 지목한 것은 Rev I다 — **다른 개정판을 같은 것이라 쓰지 않는다**(E45의 CIFAR 규율과 같은 축).

### 1.3.1 취득한 것: NPR 7150.2D §5.4.5 — **5개 독립 미러가 바이트 단위로 합치한다**

정본성의 근거는 미러의 권위가 아니라 **합치**다. 서로 다른 계보의 미러 5개(PDF 텍스트 추출 2 ·
챕터 단위 분할 1 · 구조화 JSON 1 · 프로젝트 컴플라이언스 표 1)에서 §5.4.5의 정규화 텍스트가
**783자 · sha256 `734cab987d9bd461`**로 완전히 같다. **그중 둘은 이 세션이 직접 받아 해시까지 다시 계산했다**
(에이전트 보고를 액면 그대로 받지 않는다 — E24c/F4의 교훈). 조항 원문:

> 5.4.5 The project manager shall monitor measures to ensure the software will meet or exceed
> performance and functionality requirements, including satisfying constraints. **[SWE-199]**

**등급 이름의 한계를 기록한다**: E54가 정의한 `mirror_adjacent_revision_fetched`의 **정의**는
*"제3자 미러에서 받았고 인용을 그 바이트에서 확인했다"*이고 개정판에 대해 아무 말도 하지 않는다.
그러나 **이름**은 `adjacent_revision`이라 여기서는 오해를 부른다 — 이것은 인접 개정판이 아니라 **개정 D 그
자체**다. 네 번째 등급 이름을 만드는 대신(D65·E44: *같은 사실을 서로 대조하지 않는 두 자리에 두지 말 것*)
`revision_match: "same_revision_D"` 필드로 구분한다.

### 1.3.2 **결정적 발견 — 취득한 원문에 마진 백분율이 없다**

지시 §2는 이 세 출처를 마진 `50/50/40/30%`의 근거로 지목했다. 취득에 성공한 하나를 **직접 세어 확인했다**:

| 검사 | 결과 |
|---|---|
| `margin` 등장 횟수(전문) | **정확히 1회** — §5.4.5의 Note |
| `50 percent` / `50 %` | **0건** |
| `40 percent` / `40 %` | **0건** |
| `30 percent` / `30 %` | 2건 — **둘 다 MOTS 코드 변경 임계값**(문맥 직접 확인), 자원 마진이 아니다 |

그 유일한 `margin`은 이렇게 말한다 — 기술 자원 지표를 갱신해 *"**the margins**와 비교한다"*.
**요구는 하되 값을 말하지 않는다.**

**따라서 마진 백분율의 등급은 `transcribed_from_directive_primary_blocked`로 유지된다.**
취득이 바꾼 것은 **값의 근거가 아니라 관행의 근거**다 — *"배포 전에 자원 지표를 마진과 비교한다"*는
이 연구의 기본 동작 자체는 이제 1차 요구문서의 조항(§5.4.5 [SWE-199])으로 인용할 수 있고,
**그 값이 왜 50/40/30인지는 여전히 인용할 수 없다.** 둘은 다른 주장이다.

### 1.3.3 완료 기준 대조 (지시 §2)

| # | 기준 | 상태 |
|---|---|---|
| 1 | 마진 수치와 계산식이 취득한 NASA 원문에서 확인된다 | **미충족 — 그러나 그 사실 자체가 측정 결과다.** 취득한 원문에 값이 없음을 세어 확인했고, 나머지 둘은 66개 경로 중 47개를 쓰고도 차단됐다. 계획 §6이 측정 전에 정한 문장을 그대로 쓴다 |
| 2 | 기존 예산과 재계산값의 동일성 여부가 기계 판독 결과로 남는다 | **충족** — §1.4(D94). 재현되지 않았고, 원인·영향·수정이 전부 기계 판독 자리에 있다 |
| 3 | 예산을 **공개 근거로 구성한 참조 예산 시나리오**로 명시한다 | **충족** — `budgets.json::budget_nature`(`constructed_reference_scenario` · `is_mission_allocation: false`). 착수 전 세어 보니 이 선언은 **없었고**, 기존 *"실제 임무 예산이 아니다"* 서술은 전부 **Part 2 격자**에 대한 것이었다(E44: 없는 줄 알고 더하기 전에 세어 보라 — 세어 보니 정말 없었다) |


### 1.4 **D94 — 예산이 저장소 내용으로 재현되지 않았다** (이 항목이 찾은 결함)

지시 §2-3이 요구한 *"기존 예산 계산을 읽기 전용으로 재실행해 `budgets.json`과 일치하는지 확인"*을
그대로 수행했더니 **일치하지 않았다.**

```
observations   21 → 46
chosen_kb     368 → 376        (= R_noncontract_AI 의 런타임 컨텍스트 항)
```

**원인**: `harness/e54_budgets.py::iree_fixed_runtime_ctx`가 `results/**/*.log`를 **재귀 glob**해
*"지금 존재하는 모든 AArch64 `mem_init` 레코드"*를 입력으로 삼는다. 그 집합은 **실험이 추가될 때마다
자란다** — E54 **자신의 셀 로그 25건**이 `budgets.json` 커밋(`25df44b`) **이후에** 생겼고, 오늘 재실행하면
그것들이 입력에 들어온다. 디렉터리별 집계로 확인했다:

| 디렉터리 | 커밋 시점 | 오늘 |
|---|---:|---:|
| `e54_reference_budget` | 0 | **25 (신규)** |
| `e36_aarch64_cfs` | 7 | 7 |
| `e36b_aarch64_models` | 4 | 4 |
| `e48_real_inputs_aarch64` | 3 | 3 |
| 나머지 넷 | 7 | 7 |

**E54의 판정은 바뀌지 않는다.** 비순환성의 근거는 커밋 순서였고(`budgets.json`이 셀보다 먼저),
커밋된 값은 셀이 존재하기 전의 관측만 썼다. 무너진 것은 판정이 아니라 **재현성**이다 —
D71(ini 템플릿이 telemetry를 하드코딩해 저장소 내용만으로 재생성 불가)과 같은 계열이고,
D77(*"유도값을 출하할 때는 그 유도를 다시 돌려 보는 가드도 함께 출하하라"*)이 정확히 이것을 경고했다.

#### 영향을 단정하지 않고 **측정했다**

16셀 전부를 두 예산으로 재판정했다:

- **모든 예산이 정확히 −8,192 B**(= 8 kB × 1024) 줄어든다 — 오버헤드가 커지는 쪽, 즉 **ADMIT이 어려워지는
  보수적 방향**이다.
- **판정 뒤집힘 0건 / 16셀.** 가장 빡빡한 셀 `PB_pdr50__wgan`이 2.193× 여유로 그대로 ADMIT.

따라서 이것은 *"틀린 예산을 썼다"*가 아니라 *"커밋된 예산을 오늘 다시 만들 수 없다"*이고,
후자만으로도 결함이다.

#### 수정 — 고정하되 얼리지 않는다

입력 집합을 `results/e54_reference_budget/sources/runtime_ctx_observations.json`에 **pin**했다(21건).
그러나 **얼어붙은 데이터가 아니다**:

1. 생성기는 pin에 적힌 로그를 **매번 다시 읽어** `delta_kb`를 재추출하고, 값이 다르거나 파일이 없으면
   **거부한다**(fail-closed). pin은 증거를 가리키지 증거를 대체하지 않는다.
2. 현재 glob이 찾는 수를 함께 싣는다 — `scan_observations_now: 46` · `sources_present_but_not_pinned: 25`.
   **드리프트가 보인다**(D65: 정정은 기계가 읽는 자리에 닿아야 한다). 조용히 흡수하지 않는다.
3. 재-pin은 `--repin`으로만 한다. **자동 갱신은 없다.**

재생성 결과 `budgets.json`은 **32 insertions / 0 deletions**이고 추가된 줄은 전부 드리프트 보고다 —
**값은 하나도 바뀌지 않았다**(16개 `B_contract` 전부 동일, `chosen_kb` 368, `observations` 21).

#### 가드와 revert 실측

신규 4건(`e55/1`~`e55/4`): 생성기 재실행이 커밋본과 **바이트 동일** · pin된 로그가 전부 존재하고
**git 추적**됨 · **변조된 pin은 거부**(rc≠0) · 드리프트가 기계 판독 자리에 **기록**됨.
**revert-and-confirm-fail**: pin 분기를 되돌려 옛 glob 동작으로 만들면 `e55/1`(재현성)과
`e55/3`(변조 거부)이 **실제로 FAIL**한다(2/4).

---

## §2 P0-2 — 추출기 분류 범위 완결

### 2.1 착수 전 측정 — **문자 그대로의 처방은 27/27 파일을 죽인다**

계획 §2.1이 *"이 집합을 논증으로 정하지 않는다"*고 고정했으므로, 보관 layout IR **27개**의
마지막 entry print에 실제로 나타나는 op을 **텍스트 스캔과 MLIR API 순회 두 방법으로 대조**해 셌다.
**20종 / 2,415 인스턴스**이고 그중 walker가 실제로 분류하던 것은 6종뿐,
**14종 / 1,994 인스턴스(82.6%)** 가 `startswith("stream.resource.")` 검사에서 맨 `continue`로 빠졌다.

*"화이트리스트 밖은 전부 `unresolved`"* 를 문자 그대로 적용하면 어떻게 되는지 **채택 전에 쟀다**:

> **27/27 파일 전멸.** 결정타는 `stream.yield`다 — MLIR API는 **99회** 보는데 IR 텍스트에는 **0회**다
> (커스텀 프린터가 생략하는 암묵 terminator, `grep` 27파일 합계 0으로 확인). 정규식 파서는 그것을
> **원리적으로 볼 수 없으므로** walker만 unresolved를 올리고 → `diff_against_regex`의 presence 비교
> 불일치 → `make_contract.py` hard fail. `arith.constant`(792회)·`util.return`·`stream.timepoint.join`도
> 같은 방향으로 죽인다.

**E50이 출하했다 철회한 유형 (B)를 이 실험이 세 번째로 마주쳤고, 이번에는 밟기 전에 쟀다.**

### 2.2 채택한 정의 — **자원 흐름**

이름 접두어가 아니라, **result 또는 operand가 `!stream.resource<...>`인 op**만 분석 영역으로 본다.
계약이 경계 짓는 것이 바로 그 자원의 바이트이기 때문이고, `arith.constant`·`util.return`·
`hal.element_type`은 *낡을 수 있는 이름 목록*이 아니라 **자원을 만지지 않는다는 사실**로 빠진다.

분류는 지시 §3-1이 요구한 세 갈래다:

| 갈래 | op | 근거 |
|---|---|---|
| **지원**(크기를 유도) | `stream.resource.alloca` · `stream.tensor.import` · `stream.resource.subview` · `stream.tensor.export` · `stream.resource.dealloca` · `stream.cmd.dispatch` | 기존 |
| **비할당 확인**(사유 기록) | `util.global.load` · `stream.cmd.execute` · `stream.timepoint.await` · `stream.cmd.fill` · `stream.cmd.concurrent` | 각 항목이 *왜* 할당하지 않는지를 문자열로 싣는다 — 그래야 두 번째 화이트리스트로 퇴화하지 않는다 |
| **명시적 거절** | 그 밖의 자원 접촉 op | `unclassified_resource_ops` **전용 키**로 보고하고 `make_contract.py`가 거부 |

**전용 키인 것이 핵심이다.** `unresolved`에 접어 넣으면 §2.1의 27/27 전멸이 그대로 재현된다 —
정규식 파서는 op 구조를 볼 수 없으므로 모든 모델에서 presence가 어긋난다. E51이 적은
*"거부는 귀속될 때만 근거다"*가 그대로 적용된다.

### 2.3 결과 — 완료 기준 대조 (지시 §3)

| # | 기준 | 결과 |
|---|---|---|
| 1 | 모든 분석 대상 resource 연산이 세 갈래 중 하나로 분류된다 | **충족** — 보관 26개 IR, 미분류 **0건** |
| 2 | 알 수 없는 연산이 조용히 누락되는 경로가 없다 | **충족** — `_touches_resource`가 참이면 반드시 분류되거나 거절된다 |
| 3 | 네 실물 모델의 기존 상한값이 유지된다 | **충족** — 보관 14개 계약 **diff 0**, 헤더 바이트 불변 |
| 4 | 미지원 연산 음성 사례가 실제로 fail-closed | **충족** — 가드 `e55/7`(in-process로 목록에서 하나를 빼면 `unclassified_resource_ops`로 이동하고 `unresolved`에는 들어가지 않는다) |
| 5 | (규율) revert 시 신규 시험이 실제로 FAIL | **충족 — 2건** |

**비할당 확인 버킷은 476 인스턴스로 채워진다**(`util.global.load` 352 · `stream.cmd.fill` 72 ·
`stream.cmd.execute` 26 · `stream.timepoint.await` 26).

### 2.4 **D95 — 조용한 chunk 폴백** (이 항목이 찾은 결함)

P0-2를 재려고 보관 IR을 전수로 훑다가, 같은 코드 경로에서 **더 무거운 것**이 나왔다.

`mlir_alloc_walk.parse_alloc_ir_structural`은 entry chunk를 **가장 최근(=가장 lowered) 것부터**
시도하는데, 그 chunk가 파싱에 실패하면 **조용히 이전 pre-layout chunk로 물러난다** —
`ctx_errors`는 **모든** 조합이 실패했을 때만 표면화되기 때문이다.

**원인은 IR이 아니라 컴파일러 진단 한 줄이다.** `iree-compile`이 IR 덤프와 같은 스트림에 쓴

```
results/e14_aarch64_qemu/models/dynamic/dyn_batch_mlp.mlir:0:0: remark: Executable benchmarks were requested but none were generated...
```

를 `split_dumps`가 마지막 chunk에 삼키고(마지막 chunk는 EOF까지다), MLIR이 `results`를 op 이름으로
읽어 `custom op 'Executable' is unknown`으로 실패한다.

**실행으로 양방향 재현**(보관 `dynamic` layout IR):

| | `dispatches` | `pre_scheduling_ops` | `unresolved` |
|---|---:|---|---|
| remark 포함(커밋 상태) | **0** | async **6개** | `pre_scheduling_alloc_op:*` 6 + 1 |
| remark 제거 | **2** | **0** | `non_constant_def:arith.muli` **3**(동적 형상 — 정직한 이유) |

**따라서 D87의 기록이 틀렸다.** *"보관 dynamic 두 파일의 마지막 entry print에 async 6개"*는
post-layout IR의 사실이 아니라 **chunk 선택 artifact**였다. E49의 원래 *"0회"*는 **IR에 대해서는
옳았고**, 틀린 것은 그것이 잰 glob(D87이 정정)과 그 뒤 walker가 읽은 chunk(D95)였다.

**오늘 이 결함이 무는 것은 어차피 거부되는 모델뿐이다. 고치는 이유는 반대 방향이다** —
**정직한 정적 모델**의 마지막 chunk가 같은 이유로 깨지면 walker만 async를 unresolved로 올리고,
정규식 파서 쪽은 비어 있으므로 크로스체크가 어긋나 **배치 가능한 모델이 컴파일러 remark 한 줄 때문에
hard fail** 한다(유형 B).

**수정은 한 방향으로만 작동한다** — 진단 줄 제거는 파싱 가능한 chunk를 **늘릴 뿐 줄이지 않고**,
MLIR 한 줄이 `path:line:col: severity:` 형태를 가질 수 없으므로 IR을 지울 수 없다(D47과 같은 규율).
여기에 `entry_chunk_rank_used`·`entry_chunk_parse_failures`를 더해 **폴백이 조용하지 않게** 했다.

**첫 수정은 틀렸고 측정이 잡았다**: 접두어만 지워 메시지 본문이 남았고 MLIR이 이번엔 `Executable`을
op으로 읽었다(`custom op 'Executable' is unknown`). 줄 전체를 지우도록 고쳤다.
보관 14개 IR 전부 `rank=0`(폴백 0건), **보관 14개 계약 diff 0**.

### 2.5 방법론 — **내 가드가 처음엔 약했다**

P0-2 수정을 되돌리고 회귀를 돌렸더니 **0건 FAIL**이었다. 가드가 *"미분류가 없다"*만 보았고,
**아무것도 분류하지 않는 walker도 그 조건을 만족**하기 때문이다 — D89가 경고한 바로 그 형태
(*"revert가 실패를 만들지 않으면 고친 것은 코드가 아니라 기록이다"*)가 이 실험 자신의 시험에 왔다.
분류 버킷이 **실제로 채워져 있음**(≥400)까지 요구하도록 고쳤고, 그 뒤 revert 시 **2건 FAIL**한다.

---

## §3 P0-3 — 순차 실행 전제의 관측

### 3.1 계측

한 번의 모델 실행은 `call_initialize*` 성공부터 `call_deinitialize`까지 자기 호출별 버퍼를 소유하므로,
ENTER/EXIT는 **정확히 그 구간**을 감싼다. 함수 반환이 아니라 `deinitialize` 지점에 EXIT를 둔 이유는
**전수 확인** 때문이다 — cFS 앱에 `call_deinitialize`가 **정확히 3곳**(`Infer`의 조기 반환 경로,
`Infer`의 공통 꼬리, e25 등가성 루프), native 실행기에 **3곳**이고, `initialize`에 성공한 모든 경로가
그중 정확히 하나에 도달한다.

계측 자신이 심을 수 있는 결함도 함께 기록한다 — `active_calls_now`가 보고 시점에 0이 아니거나
감소가 음수로 내려가면 `call_counter_balanced: false`다. **감소의 부재가 *"감소할 것이 없었다"*로
읽히지 않게** 하는 것이 이 필드의 목적이다(D29·D51·D68).

### 3.2 x86-64 native 실측 (첫 관측)

```
max_active_calls = 1 | active_calls_now = 0 | call_counter_balanced = true
```

E49 축 B가 `ARGUED_FROM_SOURCE` · `observed_value: null`로 적어 둔 전제가, 이 경로에 한해
**관측**이 됐다. AArch64 cFS 네 모델의 관측은 §4에 있다.

**E51 stage2의 기록은 그대로 둔다** — 그 실험의 주장은 *"소스를 읽는 것"*에 대한 것이고,
호출부를 읽는 일은 여전히 논증이지 관측이 아니다. 바뀌는 것은 **E49의 전제 레코드**이지
E51의 발견이 아니다.

---

## §4 P0-4 — 네 모델의 AArch64 cFS 조건부 상한 검증

### 4.1 설계 — 변수를 하나로 줄인다

모델마다 **두 셀**이고, 둘의 차이는 **컴파일 타임 knob `AI_LEARNER_ALLOW_CONDITIONAL_MAP`
하나뿐**이다(0 vs 1). 예산은 **양쪽 모두 같은 `P = static_per_call_bytes`**이고 실행 시
`AI_LEARNER_BUDGET_OVERRIDE`로 주입한다.

컴파일 타임 예산은 두 트리 모두 `bounded + 1`이다 — **`bounded`보다 작은 값으로 빌드하면
컴파일러가 admission 실패를 정적으로 접고 뒤 코드를 죽은 코드로 제거한다**(CLAUDE.md 함정표).
E36이 런타임 오버라이드 경로를 만든 이유가 정확히 이것이고, 여기서 그대로 쓴다.

대조 셀이 있어야 조건부 셀의 통과가 **조건부 계층에 귀속**된다 — `P < Bᵤ`이므로 무조건 정책이
거부하는 것이 옳은 동작이고, 대조 셀은 그 거부를 실제로 보인다.

### 4.2 판정 — 지시 §5의 여덟 기준

값은 전부 앱 자신이 남긴 레코드에서 읽는다(`harness/mk_e55_summary.py`, 판독기는
`mk_e36b_summary`에서 **import**한다 — 같은 원자료의 두 번째 판독기는 결함이다, E44/D90).

| 모델 | `P` | 승인 근거 예산 | HAL peak | `arm` | 추론 | `max_active_calls` | 판정 |
|---|---:|---:|---:|---|---:|---:|---|
| b2_resnet | 309,416 | 309,416 | **309,416** | map | 74 | 1 | PASS |
| b3_deepae | 6,208 | 6,208 | **6,208** | map | 74 | 1 | PASS |
| smartcam | 9,382,092 | 9,382,092 | **9,382,092** | map | 48 | 1 | PASS |
| wgan | 131,382,784 | 131,382,784 | **131,382,784** | map | 3 | 1 | PASS |

**HAL peak가 네 모델 모두 `P`와 바이트 단위로 같다** — 조건부 상한이 이 구성에서 sound하면서
동시에 tight하다. 그리고 그 tightness는 모델의 성질이 아니라 **전제조건의 성질**이다(E29):
`module_ptr_mod64 = 0`과 `hal_peak_after_append = 0`이 **측정으로** 확인됐고, 그 둘이 map 분기를
만든다.

여덟 기준 중 **1~7은 전부 `true`**이고 **8(기존 AArch64 출력 기준 일치)은 `null`**이다 —
이 셀들은 Software Bus 텔레메트리 바이트를 feature로 쓰므로 E31/E48의 fixture를 재생하지
않는다. **통과로 적지 않고 미평가로 적는다**(D29·D51·D68). 그 비교는 E55b의 copy 셀이
같은 fixture를 재생해 실제로 수행한다.

**wgan의 추론 3회는 창 길이의 함수다** — 이 게스트는 `platform_check.py`가 `FUNCTIONAL_ONLY`를
반환하므로 그 수를 성능으로 읽지 않는다(작업 규율 4). 기준은 *"최소 1회"*이고 셋은 그것을 넘는다.

### 4.3 사전 보수 두 건 (지시 §5 "사전 보수")

**`line[768]`**: `run` 레코드가 출력 배열 전체를 싣던 것을 **원소 수 · sha256 · 앞뒤 일부 ·
별도 출력 파일**로 바꿨다. `out_record_truncates: false`가 레코드 자신의 증언이고,
`out_full_file_reason`이 파일 쓰기 실패 사유를 적는다. 첫 시도의 경로
`/cf/ai_learner_last_out.json`(24자)은 OSAL의 `OS_MAX_FILE_NAME` 20자를 넘어
`OS_TranslatePath`가 `-104`(`OS_FS_ERR_NAME_TOO_LONG`)로 거부했다 — **추측하지 않고 사유
필드를 먼저 붙여서 알아냈다**. `/cf/last_out.json`으로 바꿔 183 B가 기록된다.
**`outs` 정적 버퍼는 일부러 남겼다** — E54가 센 앱 정적 I/O 바이트와 그 예산이 바뀌지 않아야 한다.

**`WARMUP_CALLS=200`**: 기본값을 보존한 채 `AI_LEARNER_WARMUP_CALLS`(native는 argv) 오버라이드를
허용하고 **적용값과 그 출처를 원자료에 적는다**(`warmup_source`). 해석은 fail-closed다 —
빈 값·형식오류·후행 쓰레기·범위 밖은 **거부**(`WARMUP_INVALID`, rc=2)이지 기본값 복귀가 아니다.

### 4.4 대조 셀의 기대 키를 내가 틀렸다 (방법론)

첫 시나리오의 대조 셀 기대에 `init_count: 0`과 `e25_mode_active: false`를 넣었다. **둘 다
내가 정한 것이지 앱이 말하는 것이 아니었다** — `init_count`는 admission 레코드 수이고
거부된 앱도 하나를 남기며, `e25_mode` 레코드는 그 지점 **이후**에 나오므로 거부 셀에는
존재할 수 없다. 더 **엄격한** `runtime_created: False`로 바꿨고(D80이 고친 그 키), 이미 수집한
로그를 게스트 재실행 없이 `--reparse`로 오프라인 재판정했다.

### 4.5 판정

**P0-4 PASS — 네 모델 전부.** 지시 §8의 종료 조건 중 넷째(*"네 실제 모델 모두 조건부 상한으로
허용되고 상한 이내에서 실행된다"*)가 충족됐다. **단일 모델 의존성이 해소됐다** — 조건부 계층의
AArch64 cFS 증거가 SmartCam 하나에서 **ResNet · DeepAE · SmartCam · WGAN 넷**으로 넓어졌고,
네 모델의 상수:호출 비가 **0.006(WGAN)에서 171.3(DeepAE)까지 양극단**인데도 판정과 관측이 같다.

**그러나 조건부 계층이 주는 예산 감소는 모델마다 전혀 다르다** — `Bᵤ/P`가 DeepAE **172.30×** ·
ResNet 2.00× · SmartCam 1.94× · WGAN **1.03×**다(E46이 이미 정량화한 그대로). 네 셀이 보이는 것은
**계층이 네 모델에서 작동한다**는 것이지 **네 모델에서 똑같이 유용하다**는 것이 아니다.

각 트리의 opt-in은 **바이너리에서** 증언된다(E38/D69) — 12개 트리의 `build_info.json` ·
`witness.json` · `.so` sha256을 `results/*/trees/`에 보관했다(exe 트리는 저장소 밖이라 컨테이너와
함께 사라지므로, 보관 없이는 셀을 빌드에 다시 귀속시킬 수 없다). 가드 `e55b/10`이
**cond1 4개 True · cond0 4개 False · copy 4개 False**를 고정하고, 위저의 `undetermined`를
*"꺼짐"*으로 읽지 않는다.
