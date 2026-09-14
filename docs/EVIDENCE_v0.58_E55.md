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

### 1.3 취득 결과

*(§1.3은 재프로브 결과로 채운다.)*

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
