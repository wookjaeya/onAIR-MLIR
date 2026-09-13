# EVIDENCE v0.48 — E44: 예산 출처(budget provenance)

**사전 고정 기준**: `docs/plans/E44_budget_provenance.md` (커밋 `2aa93cf`, **측정 이전**)

---

## §0 한 줄 요약

로드맵 §6.2가 요구한 세 필드 중 **하나만 실제로 부족했고**, 그 하나도 **계약 필드가 아니라
유도값으로** 채웠다. 결과는 **세 배포 경로가 전부 자기 예산의 출처를 말하고**, 선행연구
비교표의 `declared` 판정이 **저장소에서 계산된다**는 것이다.

| Q | 판정 |
|---|---|
| Q1 세 경로가 전부 출처를 말하는가 | **PASS** — 실행으로 확인 |
| Q2 A5가 저장소에서 유도되는가 | **PASS** |
| Q3 `declared`의 근거가 참인가 | **PASS** — 소스 85파일에서 예약 호출 **0건** |
| Q4 기존 pin이 깨지지 않는가 | **PASS** — 5곳 수정 없이 통과, 값 개명 0 |
| Q5 과잉 거부 0 | **PASS** — §5 |

---

## §1 로드맵 §6.2를 셋 중 하나로 좁혔다

| 필드 | 착수 전 실측 | 채택 |
|---|---|---|
| `budget_source` | **이미 있다** — `ai_learner.c` **8회**(`:139` `macro`, `:150` `override`), 요약 생성기 4개, `contract_negative_tests.py` **5곳**(`:2514·:2521·:2580·:2700·:2839`)이 pin | **확장** — 값을 바꾸지 않고 **라벨 없던 두 경로**에 붙였다 |
| `budget_scope` | **이미 세 곳에 있다** — `make_contract.py:1056`의 `resources.scope`, `accounting_rules.excluded`(E40), admission의 `"scope":"per_app_local_budget"` | **신설하지 않았다** |
| `reservation_semantics` | 저장소엔 로드맵 문서에만. **그러나 개념은 E39a의 사전 등록 축 A5로 이미 존재** | **계약 필드로 만들지 않고 A5를 유도로 바꿨다** |

### §1.1 `budget_scope`를 안 만든 이유 — 네 번째 이름은 D65의 형태다

한 개념이 네 곳에 살면 그중 **어떤 가드도 대조하지 않는 자리**가 생긴다. D65가 명명한 것이
정확히 그것(*"정정이 산문에만 남았는지, 기계가 읽는 자리에도 닿았는지 확인하라"*)이고,
새 이름을 더하는 것은 그 조건을 **만드는** 일이다.

### §1.2 로드맵 enum을 안 쓴 이유 — 근거 없는 승격이 된다

제안값 `{mission configuration, cFS table, experiment override}`:

- **`cFS table`** — 이 앱은 CFE Table Service를 쓰지 않는다. `CFE_TBL`이 저장소에 **15번** 나오지만
  **소스 파일에서는 0번**이고 15건 전부 `native/results/*.log`의 **cFS 부팅 로그**다(직접 확인).
- **`mission configuration`** — 실제로는 빌드가 정의하는 **CMake 매크로**다.

**있는 그대로의 기전을 이름으로 썼다** — `macro` · `override` · `argv` · `deployment_config` · `none`.
개명했다면 **pin 5곳이 깨졌을 것**이고, 깨뜨려서 얻는 것이 없다.

---

## §2 Q1 — 세 경로가 전부 말한다 (실행으로 확인)

| 경로 | `budget_source` | 기전 | 확인 |
|---|---|---|---|
| cFS 앱 | `override` (또는 `macro`) | 컴파일 타임 매크로 / 초기화 시 런타임 오버라이드(E36) | **인용** — `results/e38_optin_record/cells/cond_denied_without_optin.log`(§2.2) |
| **native 실행기** | **`argv`** | 명령행 인자 `argv[2]` | **실행** — 재빌드 후 `stage:admission` 레코드 |
| **OnAIR 플러그인** | **`deployment_config`** | 배포 JSON의 `budget_bytes` | **실행** — `smartcam` 셀 재실행 |
| OnAIR (예산 없음) | **`none`** | 선언 자체가 없다 | **실행** — `smartcam_no_budget` 셀 |

**`none`은 `null`이 아니다.** *"예산을 선언하지 않았으므로 출처가 없다"*를 말하는 값이고,
`budget_source_note`가 그 문장을 함께 싣는다 — 부재를 값으로 적되 **어떤 부재인지** 적는다.

### §2.1 생성기의 첫 판이 "기록 없음"을 보고했다 — 기록은 있었다

`mk_e44_summary.py`의 첫 glob이 `cells/*/*.log`로 **한 단계 깊었고**, cFS 행에
*"budget_source를 실은 보관 admission 줄을 찾지 못함"*을 냈다. 실제로는
`results/e38_optin_record/cells/cond_positive.log`에 그 줄이 **있었다**.

**D51이 명명한 구분을 내 도구가 다시 밟을 뻔했다** — *"볼 수 없었다"*를 *"보았더니 없더라"*로
기록하는 것. 고친 뒤 주석에 그 사유를 남겼다.

### §2.2 그 다음 판은 **결함 재현 로그**를 정상 셀처럼 인용했다

넓힌 glob이 이번엔 **정렬 순서상 먼저인** 파일을 집었고, 그것이 하필
`results/e36_aarch64_cfs/cache_leak_bug/deny_B_minus_1.log` — 이 저장소가 **D61(b)를 재현하려고
일부러 보관하는 로그**다(누출된 CMake 캐시 값이 거부해야 할 셀을 `ADMIT_CONDITIONAL_MAP`으로
만든 기록).

**주장 자체는 참이었다** — 그 레코드도 `budget_source`를 싣는다. 틀린 것은 한 행 안에서
`detail`이 *"E38 재실행 셀에서 인용"*이라 말하는데 `cell`은 다른 곳을 가리킨 것이다.
**한 행의 두 필드가 서로 다른 말을 하는 것이 D65의 형태**이고, 이번에는 그것이 *산문과 기계 판독*이
아니라 **기계 판독끼리** 어긋난 판본이다.

수정: 인용을 **의도적으로** 한다 — E38 재실행 셀을 먼저 찾고, 폴백이 발동하면
`cited_from: "fallback_scan"`과 함께 **그렇다고 적는다**(먼저 찾은 것처럼 읽히지 않게).
`budget_source`를 싣는 보관 로그가 **몇 개인지**(21개)도 함께 적는다 — *"하나를 찾았다"*와
*"하나뿐이다"*는 다른 문장이다. **revert-and-confirm-fail**: 선호 목록을 비우면 신규 가드 2건이
실제로 실패한다(`fallback_scan` · 결함 재현 로그 인용).

### §2.3 `native/contract_gen.h`는 되돌렸다

native 실행기를 재빌드하면서 추적 중인 `native/contract_gen.h`가 `build.sh`의 **기본 예시 계약**
(`contracts/contract.filled.example.json`, `mlp_9x65536x2`)으로 덮였다. 그 재생성은 이 실험의
산출물이 아니므로 **되돌렸다** — 추적본은 나머지 저장소가 전제하는 `canonical_e25`로 유지한다
(`build.sh`가 빌드마다 재생성하므로 추적본은 기준점이지 빌드 입력이 아니다).
E44의 native 셀 레코드는 실제로 돈 모델(`mlp_9x65536x2`)을 그대로 적고 있고, `budget_source` 라벨은
모델과 무관하다. 가드 1건이 추적본을 고정한다.

---

## §3 Q2·Q3 — A5를 손으로 쓰지 않고 계산한다

E39a의 비교표는 이웃 축을 **계약에서 읽는다**:

```python
"A2": "... (계약이 scope=%s 로 매 판정마다 명시)" % r.get("scope"),
"A3": "예 (bound_method=%s)" % r.get("bound_method"),
```

**A5만 리터럴이었다**:

```python
"A5": "**declared** (예산은 앱에 부여한 값이며 물리 RAM을 예약하지 않는다)",
```

여기에 계약 필드 `reservation_semantics`를 신설하면 **같은 사실이 두 곳**에 살고 그중 하나는
아무도 대조하지 않는다. 그래서 **반대로 갔다** — A5를 **저장소에서 유도**한다.

`harness/budget_provenance.py`가 예약 능력이 있는 호출 8종(`mlock` · `mlockall` ·
`MAP_POPULATE` · `MAP_LOCKED` · `CFE_ES_PoolCreate` · `CFE_ES_GetPoolBuf` ·
`CFE_ES_RegisterCDS` · `OS_MemPoolCreate`)을 소스 트리에서 센다.

```
verdict: declared · files_scanned: 85 · hits: 0
```

표에는 **값과 근거가 함께** 실린다: *"**declared** — 예산은 앱에 부여한 값이며 물리 RAM을
예약하지 않는다 (예약 호출 0건 / 소스 85파일, `harness/budget_provenance.py`)"*.

### §3.1 호출이 발견되면 **`enforced`로 올리지 않는다**

`verdict()`는 hit가 있으면 **`unknown`**을 낸다. 호출이 **있다**는 것과 그 호출이 **이 예산을**
예약한다는 것은 다르고, 그 구분은 **E28/D52가 게이트에 대해 배운 것**과 같다 — 게이트가
도는 것과 게이트가 계약의 수를 쓰는 것이 다른 것처럼. 시험이 `verdict([])`와
`verdict([mlock hit])`를 **실제로 호출해** `declared`/`unknown`을 확인한다(단언이 아니라 실증).

### §3.2 로그를 읽지 않는 이유가 실제 사례에서 나왔다

스캐너는 **소스만** 읽는다. 이것은 결벽이 아니라 **이 실험 중에 실제로 일어난 일**이다 —
감사가 *"`CFE_TBL` 0회"*라 보고했고 직접 grep하니 **15건**이 나왔는데, 전부 cFS 부팅 로그였다.
로그를 세는 스캐너였다면 **이 앱이 쓰지 않는 테이블 서비스를 보고**했을 것이다.

---

## §4 Q4 — 기존 pin이 깨지지 않았다

`budget_source`의 기존 값 `macro`·`override`를 **개명하지 않았다**. `contract_negative_tests.py`의
5곳(`:2514` `budget_source == "macro"`, `:2521` `in ("macro","override")`, `:2580`, `:2700`, `:2839`)이
**수정 없이** 통과한다. 선행연구 비교표는 **이 연구 행 한 줄만** 바뀌었고 그 안에서 A5 칸만
달라졌다(`git diff --stat` = 1 insertion / 1 deletion).

---

## §5 Q5 — 과잉 거부 점검 (계획서 §5의 4건)

| # | 위험 | 결과 |
|---|---|---|
| P1 | `budget_source`를 필수로 만들어 기존 레코드를 거부 | **보고 필드이지 게이트가 아니다.** 없는 레코드는 그대로 읽힌다 |
| P2 | 로드맵 어휘로 개명해 pin 5곳이 깨짐 | **개명 0건**(§1.2) |
| P3 | 예약 호출 검사가 문자열 우연 일치로 오탐 | 단어 경계 매칭 + **소스만** + 찾은 위치를 `파일:줄`로 기록(사람이 재검증 가능). 자기 자신의 표는 제외 |
| P4 | A5 유도가 표의 다른 칸을 바꿈 | **1줄만 변경**(§4) |

**revert-and-confirm-fail**: A5를 리터럴로 되돌리면
*"mk_prior_art_table.py no longer carries a literal A5 verdict"* 시험이 실패한다.

---

## §6 하지 않은 것 (명시)

- **`budget_scope` 신설** · **계약 스키마 변경** · **기존 값 개명** · **로드맵 enum 채택** ·
  **새 admission 판정 경로** — 전부 §1의 결정이다
- **cFS 셀 재실행** — E38의 보관 셀을 인용했다(그 경로는 E36부터 이미 라벨하고 있었다)
- **AArch64에서의 native/OnAIR 예산 출처** — x86-64에서만 실행했다
- ***"예산이 메모리를 예약한다"*** · ***"예산이 cFS 테이블에서 온다"*** ·
  ***"임무 설정이 예산을 정한다"*** — 전부 근거가 없다(§1.2)

---

## §7 교훈

로드맵이 요구한 것은 **세 필드**였고 실제로 부족한 것은 **한 경로의 라벨**과 **한 축의 유도**였다.

> ***요구된 필드가 이미 있는지 먼저 세어 보라 — 없는 줄 알고 더하면, 같은 사실이 서로를
> 대조하지 않는 두 자리에 살게 된다.***

그리고 §2.1이 같은 교훈의 도구 판본이다: **생성기가 "없다"고 말할 때, 없는 것인지 못 본 것인지
먼저 가른다**(D51).
