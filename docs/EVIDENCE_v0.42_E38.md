# EVIDENCE v0.42 — E38: 조건부 opt-in 설정을 판정과 독립적으로 기록한다

**실험 ID**: E38 · **날짜**: 2026-09-10 · **플랫폼 등급**: FUNCTIONAL_ONLY(qemu-system-aarch64 게스트 cFS)
**촉발**: 여덟 번째 외부 검토 `docs/reviews/DECISIONS_v0_41_INTEGRATED_REVIEW.md` §4.1 · 실행 순서 §10-2
**판정**: **Q1~Q5 전부 PASS** (`results/e38_optin_record/summary.json`, `optin_independently_recorded: true`)

---

## 1. 검토가 지적한 것

> **§4.1** 조건부 계층의 실행 결과는 opt-in 설정이 실제로 적용된 상태에서 얻은 것인지 확인해야 한다.
> 설정을 판정 결과로부터 역추정하고 그 판정을 다시 설정의 근거로 쓰면 순환이다.
>
> **§10-2** 조건부 두 셀의 opt-in 설정을 독립 기록과 연결한다. **기록이 없을 때만** 두 셀을 재실행한다.

검토가 정한 절차를 그대로 따랐다: (1) 해당 실행 바이너리에 대응하는 컴파일 명령·빌드 로그·설정 검증
기록에서 opt-in 값을 확인한다 → (2) 있으면 연결하고 종료 → (3) 없으면 그 두 셀만 재실행.

---

## 2. (1) 기존 기록 조사 — **독립 기록은 없었다** (D69)

E36의 두 조건부 셀은 예산 **9,382,092 B**로 같고 `AI_LEARNER_ALLOW_CONDITIONAL_MAP`만 다르다.
그 값이 남아 있을 수 있는 자리를 전부 확인했다.

| 자리 | 결과 |
|---|---|
| `…/cfs-aarch64-exe/e36_smartcam{,_cond}/build.log` (84 KB씩) | `ALLOW_CONDITIONAL_MAP=` **0건**, 문자열 `CONDITIONAL` 자체가 **0건** |
| 같은 트리의 `build_info.json` → `app_knobs` | `route`·`BUDGET_BYTES`·`STACK_BASE_BYTES`·`REPORT_EVERY` 넷뿐. **두 트리가 완전히 동일** |
| 같은 트리의 `ai_learner.CMakeLists.txt` | `AI_LEARNER_ALLOW_CONDITIONAL_MAP=${AI_LEARNER_ALLOW_CONDITIONAL_MAP}` — **미전개 CMake 변수**. 두 파일 diff 0 |
| 게스트 raw log (`cond_positive.log`, `cond_denied_without_optin.log`) | stage는 `build_config` 없이 `stack`/`admission`/(`map_branch`/`mem`/`run`)/`cleanup`뿐 |
| `results/e36_aarch64_cfs/summary.json` | opt-in 필드 없음 |
| `docs/EVIDENCE_v0.39_E36.md` §3 표 | *"opt-in 있음/없음"*은 **산문**이며 원자료 출처가 없다 |

즉 **그 두 셀의 설정을 말해 주는 것은 그 셀의 판정(`ADMIT_CONDITIONAL_MAP` / `NOT_ADMITTED`)뿐**이었다.
E36 스스로 D61에서 *"판정에 쓴 설정이 무엇이었는지를 판정 자신이 기록하게 하라"*는 교훈을 세우고
`budget`·`budget_source`를 그 이유로 넣었는데, **조건부 opt-in은 그 규칙에서 빠져 있었다.**

**심각도**: 판정을 뒤집지 않는다(아래 §3이 그 이유다). **기록 결함**이며 D55·D60·D65와 같은 계열이다.

---

## 3. 소급 증거 — 보관 바이너리는 실제로 opt-in에서만 다르다

기록은 없었지만 **바이너리 자체는 증언한다**. `AI_LEARNER_ALLOW_CONDITIONAL_MAP`은
`if (AI_LEARNER_ALLOW_CONDITIONAL_MAP && (long)CONTRACT_PER_CALL_BYTES <= g.budget_bytes)`의
컴파일 타임 상수라, 0이면 `0 && …`가 파싱 단계에서 접혀 **비교 자체가 방출되지 않는다.**

두 보관 `.so`를 디스어셈블해 `AI_LEARNER_Init`을 비교했다(주소 시프트를 정규화):

- 조건부 빌드가 **정확히 12개 명령 더 길다**(861,504 B vs 861,472 B, `Init` 1,067행 vs 1,055행).
- 추가된 블록: `mov x0,#0x28cb; movk x0,#0x8f,lsl#16` → **0x8F28CB = 9,382,091 = `per_call` − 1**,
  이어 `cmp x1, x0; b.le …`, 그리고 `g.conditional_map = 1`에 해당하는 `mov w1,#1; str w1,[x0,#…]`.
- 나머지 차이는 전부 `.rodata` 오프셋이 0x30(=12 명령) 밀린 것뿐이다.
- `movk #0x8f, lsl #16`(= `per_call` 상위 절반) 출현: 무조건 빌드 **5회**, 조건부 빌드 **6회**.
  무조건 빌드의 5회는 전부 JSON 인쇄 인수이고 **`cmp`로 이어지는 것이 하나도 없다.**

이것이 `harness/optin_witness.py`다. **양성 대조를 먼저 요구한다**: 같은 패턴 매처가
`ai_learner.c:331`의 무조건 비교(`CONTRACT_BOUNDED_BYTES`, 0x1160ECB = `bounded` − 1)를 찾지 못하면
*"per_call 비교가 없더라"*는 진술은 정보가 아니므로 **`false`가 아니라 `undetermined`를 낸다**
(D25·D29 계열: 관측 못 함 ≠ 관측했고 없음). 두 보관 바이너리에서 양성 대조는 **각각 3곳** 잡힌다.

보관 위치: `results/e38_optin_record/e36_binaries/`(두 `.so` 1.7 MB + 각각의 `build_info.json`·
`CMakeLists`·witness JSON). 시험이 **매번 재판정**한다.

**이것이 보이는 것과 보이지 않는 것**: 보이는 것은 *빌드 시점의 대조가 실재했다*는 사실이다.
보이지 않는 것은 **어느 바이너리가 어느 셀을 돌렸는가**다 — 게스트 로그에도, 요약에도 그 링크가 없다.
따라서 검토의 (2)로 종료할 수 없고 (3)으로 간다.

---

## 4. (3) 수정 — 세 개의 독립 기록

| # | 기록 | 어디에 | 판정과 독립인 이유 |
|---|---|---|---|
| 1 | **런타임**: 앱이 `{"stage":"build_config","allow_conditional_map":N,…}`을 **모든 게이트보다 먼저** 쓴다 | 게스트 raw log | 거부하는 셀도 기록한다. 실측: 두 셀 모두 **89행**에 나오고 admission은 91·92행 |
| 2 | **빌드**: `build_info.json` `app_knobs`에 knob과 **실제 `-D` 목록**(`compile_commands.json`에서 추출) | 배포 트리 | D61의 컴파일 도달 검증이 *증명한 것*을 **기록으로 남긴다** |
| 3 | **바이너리**: `optin_witness.py`가 산출물에서 값을 읽어 요청값과 다르면 **빌드를 죽인다**(`--expect`) | 배포 트리 + build_info | 소스도 명령도 아닌 **최종 산출물**을 본다 |

`native_learner.c`에도 같은 계열의 결함이 있었다 — opt-in이 환경변수인데 전제 미충족 시
`g.conditional_map = 0`으로 **조용히 되돌린다**. `conditional_map_requested`를 분리해 기록한다.

---

## 5. 재실행 — 두 셀만

계획대로 **두 셀만** 재실행했다(나머지 다섯은 opt-in에 의존하지 않으므로 E36 결과가 그대로 증거다).
빌드 순서는 **조건부 먼저**로 했다 — 공유 `build-aarch64_std` 트리가 D61(b)의 잔류 조건이므로
결함이 재발한다면 드러나는 순서다.

| 셀 | `build_config.allow_conditional_map` | 예산 | 판정 | 추론 | HAL peak | 승인 근거 예산 | 이내 |
|---|---|---|---|---|---|---|---|
| `cond_positive` | **1** (89행, 판정보다 앞) | 9,382,092 | **ADMIT_CONDITIONAL_MAP** | 17 | **9,382,092** | 9,382,092 | true |
| `cond_denied_without_optin` | **0** (89행, 판정보다 앞) | 9,382,092 | **NOT_ADMITTED** | **0** | — | — | — |

`cond_positive`의 `map_branch`: `module_ptr_mod64: 0`, `hal_peak_after_append: 0`, `arm: map`,
`admission_mode: conditional_map` — E29b의 두 전제조건이 **측정으로** 확인됐다(E36과 동일).
`cond_denied_without_optin`은 `CFE_ES_ExitApp` 뒤에도 같은 cFS가 **앱 8개를 계속 로드**했다
(`cs ds fm hk hs md mm sc`, 종료 후 61줄).

**바이너리 링크**(E36에 없던 것): 게스트에서 계산한 `ai_learner.so` sha256이 그 셀의 빌드 기록이
지목하는 값과 같다 — `32db6e4d…`(opt-in 0) / `d8d28388…`(opt-in 1). `core-cpu1`은 두 트리가 동일하다.

**E36 대비 불변**: 결정론적 값(설정·판정·예산·피크·arm·모드)이 전부 같다. 추론 **횟수**는 비교하지
않는다 — 모든 셀이 `timeout -s INT`로 끝나므로 실행 시간의 함수다(E36 계획서 §3.4 정정과 같은 이유).

---

## 6. native 경로 실측 — 요청과 적용의 분리

`results/e38_optin_record/native_requested_vs_applied.json`(B3 DeepAE 계약, x86-64):

| 셀 | env | 예산 | 판정 | requested | applied |
|---|---|---|---|---|---|
| 무조건 | — | 1,069,632 | ADMIT | false | false |
| 조건부, 예산 = per_call | 1 | 6,208 | ADMIT_CONDITIONAL_MAP | true | true |
| opt-in 없음, 예산 = per_call | — | 6,208 | NOT_ADMITTED | false | false |
| **조건부 요청, 예산이 이미 bounded를 덮음** | **1** | 1,069,632 | **ADMIT** | **true** | **false** |

마지막 줄이 요점이다: 이 상태는 **이전엔 어디에도 흔적이 없었다**. 판정만 보면 무조건 승인과
구분되지 않는다. 추가한 필드는 **보고할 뿐 결정하지 않는다** — 나머지 세 셀의 판정은 그대로다.

---

## 6b. x86-64 교차 확인 — 같은 D61 결함이 형제 스크립트에 남아 있었다

D61(b)(공유 CMake 캐시 잔류)는 `scripts/51_build_cfs_aarch64.sh`에서만 고쳐졌고,
**`scripts/50_wire_cfs_ai_learner.sh`는 같은 `${AI_LEARNER_ALLOW_CONDITIONAL_MAP:+-D…}` 모양**을
똑같이 영속적인 `build-native_std` 트리에 대해 쓰고 있었다(D62의 *"같은 하드코딩이 두 도구에"*와 같은 계열).
같은 방식으로 고치고 — 기본 0 명시 전달 + 컴파일 도달 검증 + witness `--expect` — **실제로 세 번 빌드해
확인**했다(`results/e38_optin_record/x86_64_cross_check/`):

| 단계 | env | 기대 | witness | `.so` sha256 |
|---|---|---|---|---|
| 1 | `ALLOW_CONDITIONAL_MAP=1` | 1 | **1** | `177ce344…` |
| 2 | (미설정) — **D61(b) 조건** | 0 | **0** | `67d6ada5…` |
| 3 | (미설정, 반복) | 0 | **0** | `67d6ada5…` (2와 바이트 동일) |

2단계가 요점이다: 바로 앞 빌드가 캐시에 `1`을 남긴 상태에서 미설정으로 다시 빌드했고, 산출물이 **0을
증언**한다. 수정 전이라면 `:+`가 아무것도 전달하지 않아 캐시의 `1`이 살아남았을 자리다.
부수로 이 셀은 **witness의 x86-64 분기가 실물에서 동작함**을 보인다 — `AI_LEARNER_Init` 안에서
`cmp $65579`(= `per_call` − 1)를 찾았고 양성 대조도 3곳 잡혔다. AArch64의 `mov`/`movk` + `cmp`와 같은 성질을
다른 인코딩에서 확인한 것이다.

**여기서 주장하지 않는 것**: 이 셀은 **빌드 knob에 관한 것**이지 모델의 메모리 거동이 아니다. cFS를 기동하지 않았다.

---

## 7. 회귀 시험과 revert-and-confirm-fail

`harness/contract_negative_tests.py` **544/544 → 570/570**(이 컨테이너 실측, 신규 **26건**).
보관 14개 계약 diff 0.
**CI 실측**(커밋 `827e08d`, run 165, 3레그 success): `full` **565/565 + 3 SKIP** ·
`without-iree` **425/425 + 28 SKIP** · `stdlib-only` **425/425 + 28 SKIP**.
이 컨테이너(570/570 + 0 SKIP)와 `full`의 차이 **5건**은 전부 설명된다 — PyYAML 미설치 1건(D34),
`aarch64-linux-gnu-objdump` 미설치로 **정직하게 SKIP되는 2건**, 그리고 그 툴체인이 없으면 witness를
실제로 돌리는 분기가 아예 없어 **존재하지 않는 2건**이다(있을 때 4개 항목 · 없을 때 2개 SKIP).
축소 두 레그가 403→425로 **정확히 +22**라, E38 신규 26건 중 objdump를 요구하는 4건을 뺀 22건이
**전부 나타난다** — 보관 JSON 판독·소스 텍스트 검사·게스트 raw log 판독이라 툴체인 없이 실제로 돈다.


되돌려서 실제로 실패하는지 확인했다(네 건 전부 실패 확인 후 복원):

| 되돌린 것 | 결과 |
|---|---|
| witness의 양성 대조 제거 | 엉뚱한 `bounded`에서 `undetermined`가 아니라 **`false`**를 냄 → 1건 FAIL |
| `build_config`를 예산 게이트 **뒤**로 이동 | 순서 시험 1건 FAIL |
| 빌드 스크립트의 `--expect`·knob 기록 제거 | 2건 FAIL |
| (주입) 보관 E36 `app_knobs`에 opt-in 키 추가 | **결함 자체를 고정한 시험** 1건 FAIL |

마지막 항목이 의도적이다 — 보관 원자료를 나중에 손봐서 갭이 없었던 것처럼 만들 수 없게 한다.

---

## 8. 검토 §10-1 재확인 (E37 연결·재현 보고)

- `harness/e37_reproduce_check.py` 재실행: **13/13 동일**, 다름 0, 도구오류 0.
- `harness/mk_evidence_linkage.py` 재생성: **21/21 present**, 산출물 diff 0.
- **독립 감사**: 연결표가 `present`로 적은 **198개 셀 전부**를, 생성기와 무관하게 새로 쓴 locator
  resolver로 원자료에서 다시 읽어 대조 — **불일치 0**. 항목 7의 15개 문서 참조도 `broken: []`이고
  `script_exists`·`raw_exists`·`raw_git_tracked`가 전부 참이다.
- 부수(방법론): 그 감사기의 첫 판이 `files[0]` 같은 대괄호 locator를 해석하지 못해 **8건을 MISSING**
  으로 냈다. 연결표의 결함이 아니라 **감사기의 결함**이었다 — D67·E35와 같은 순간이다.

---

## 9. 주장하지 않는 것

- E36의 나머지 다섯 셀은 재실행하지 않았다. opt-in에 의존하지 않으며, 해당 커밋의 증거로 유지한다.
- 이 실험은 **기록**을 고쳤을 뿐 조건부 계층의 **판정을 바꾸지 않았다**. E36·E29·E29b의 수치는 그대로다.
- 정확도·지연·다른 모델·OnAIR 경로에 대해 아무것도 주장하지 않는다.
- witness는 **게이트가 아니라 관측기**다. 이 툴체인·최적화 수준에서 확인한 패턴이며, 다른 컴파일러가
  같은 코드를 다르게 방출하면 **`undetermined`를 내도록** 설계했다(그래서 `false`는 양성 대조를 요구한다).
- 추론 횟수(17)는 실행 시간의 함수이지 불변량이 아니다.

---

## 10. 결함 원장

**D69** — 조건부 admission의 opt-in 설정이 빌드 로그·`build_info.json`·보관 CMakeLists·게스트 raw log
어디에도 없어, 그 설정으로 얻은 판정 자체가 설정의 유일한 근거였다(순환). E36이 D61에서 세운
*"판정에 쓴 설정을 판정 자신이 기록하게 하라"*를 **그 설정 자신이 지키지 않았다.**

**교훈**: D61이 *"설정을 기록하라"*였다면 이것은 ***"기록해야 할 설정 목록에 그 설정이 실제로
들어 있는지 확인하라 — 그리고 기록이 판정과 독립인지 확인하라"***다.
