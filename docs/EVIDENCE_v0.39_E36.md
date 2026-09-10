# EVIDENCE v0.39 — E36: AArch64 cFS 증거 완성 (단계 2의 잔여 셀)

**사전 고정 기준**: `docs/plans/E36_aarch64_cfs_completion.md`(커밋 `f3ac80c`, **측정 전**).
**출처**: 아홉 번째 외부 검토 §10 단계 2의 **미충족 완료 기준**, 열 번째 검토가 원자료로 지적한
`stage_2_complete: false`.
**앞 단계**: E31 → **E32(미완료로 남았던 것)** → E33 → E34 → E35 → **E36(이 문서)**.

---

## 0. 한 줄 요약

**Q1·Q2·Q4 전부 PASS — E32가 `stage_2_complete: false`로 남긴 단계 2를 닫았다.** AArch64 cFS에서
실제 비행 모델(OPS-SAT SmartCam, 8.9 MB)의 **예산 미달 거부 셀이 처음으로 실행**됐고(추론 0회, cFS는
남은 앱 8개를 계속 로드), **조건부 계층이 전제를 지키며 완주**했다(승인 예산 **9,382,092** = `per_call`,
피크 **정확히 9,382,092**, arm=`map`). 배포 예산이 `bounded` 18,222,796에서 **1.94× 줄었다.**

그리고 **이 변경이 심은 결함 2건을 이 실험 자신의 계측이 잡았다**(§6) — 시험이 아니라, 계획서 §3.1이
*"측정이 어느 예산으로 판정했는지 증명할 수 있어야 한다"*고 요구한 `budget_source` 필드가 잡았다.

## 1. 무엇이 막혀 있었는가

E32에서 cFS의 `B−1` 셀은 **빌드 자체가 불가능**했다: 앱 예산이 컴파일 타임 매크로라
`CONTRACT_BOUNDED_BYTES > budget`이 정적으로 접히고, 배포 코드(빌드가 검증하는 계약 sha256 문자열 포함)가
죽은 코드로 제거돼 **빌드 검증이 거부**했다. fail-open이 아니라 빌드 거부였고, 그래서 **런타임 거부 경로가
한 번도 실행된 적이 없었다.**

**신설**: 초기화 시점의 런타임 예산 오버라이드(`AI_LEARNER_BUDGET_OVERRIDE`). 예산이 상수가 아니면
배포 코드가 살아남고 실제 거부 경로가 돈다. knob 자체가 결함의 자리이므로 규칙을 **측정 전에** 고정했다.

| 조건 | 동작 | 실측 |
|---|---|---|
| 미설정 | 매크로 값, **기존 동작과 동일** | `budget_source: "macro"`, 18,222,797 |
| 설정·파싱 성공 | 그 값 | `budget_source: "override"` |
| 설정·파싱 실패·0·음수 | **초기화 거부** | `BUDGET_INVALID`, 추론 0 |
| 모든 경우 | `budget`·`budget_source`를 **항상** 기록 | 7셀 전부 |

마지막 줄이 §6의 결함 2건을 잡았다.

## 2. 셀별 결과 (전부 AArch64 게스트 cFS 실기동)

| 셀 | 예산 | 판정 | 추론 | HAL 피크 | 승인 예산 내 |
|---|---:|---|---:|---:|---|
| `regression_no_override` | 18,222,797 (macro) | ADMIT | 35 | **9,382,092** | true |
| `admit_B` | 18,222,796 (override) | ADMIT | 34 | **9,382,092** | true |
| **`deny_B_minus_1`** | 18,222,795 | **NOT_ADMITTED** | **0** | — | — |
| `malformed_abc` | `"abc"` | **BUDGET_INVALID** | **0** | — | — |
| `zero_budget` | `0` | **BUDGET_INVALID** | **0** | — | — |
| `cond_denied_without_optin` | 9,382,092 (opt-in 없음) | **NOT_ADMITTED** | **0** | — | — |
| **`cond_positive`** | 9,382,092 (opt-in 있음) | **ADMIT_CONDITIONAL_MAP** | 35 | **9,382,092** | **true** |

**추론 횟수는 판정 근거가 아니다** — 전부 `timeout -s INT`로 끝나므로 횟수는 실행 시간의 함수다.
비교하는 것은 **결정론적 값**(판정·예산·피크·모드)이다. 계획서 §3.4가 *"E32의 70회"*를 재현 대상으로 적은 것은
그 점에서 부정확했고, 그대로 적는다.

## 3. Q1 — §10 단계 2가 요구한 거부 셀

완료 기준 원문: *"비승인 상태에서도 cFS의 다른 기능이 계속 동작함을 확인한다."*

```
{"stage":"admission","verdict":"NOT_ADMITTED","budget":18222795,"budget_source":"override", ...}
EVS  AI_LEARNER NOT_ADMITTED: contract bounded=18222796 > budget=18222795; app will not start
{"stage":"cleanup","released":true,"cleanup_calls":1}
CFE_ES_ExitApp: Application AI_LEARNER called CFE_ES_ExitApp
```

그 뒤 **같은 cFS 인스턴스가 앱 8개를 계속 로드**했다(`cs ds fm hk hs md mm sc`, 종료 후 64줄).
`CFE_ES 14: ErrExit Application AI_LEARNER Success.` 즉 **거부는 앱 하나의 사건이고 시스템은 살아 있다.**
`malformed_abc`도 같다(앱 9개, 69줄).

## 4. Q2 — 조건부 계층이 실물 모델·AArch64 cFS에서 전제를 지켰다

E29가 세우고 E29b가 고친 조건부 계층은 지금까지 **입력이 수십 바이트인 모델**에서만 cFS로 돌았다.
D59는 그 전제(`per_call`의 io 항 = *동시에 살아 있는 입력 하나*)가 8.9 MB 입력에서 재생 하네스 패턴에
의해 깨지는 것을 보였다. 이번에 **cFS 배포 경로에서** 확인했다.

```
{"stage":"map_branch","module_ptr_mod64":0,"hal_peak_after_append":0,"arm":"map","admission_mode":"conditional_map"}
{"stage":"admission","verdict":"ADMIT_CONDITIONAL_MAP","budget":9382092,"budget_source":"override", ...}
{"stage":"mem","completed":35,"hal_peak":9382092,"admitted_budget_bytes":9382092,
 "peak_within_admitted_budget":true,"admission_mode":"conditional_map"}
```

- E29b가 요구한 **두 전제조건이 실측으로 만족**: `module_ptr_mod64 = 0`(append 전 정렬 검사),
  `hal_peak_after_append = 0`(map 분기의 append 피크는 정확히 0).
- 피크가 **승인 근거 예산과 정확히 같다** — 초과 0 B.
- **배포 예산 18,222,796 → 9,382,092 (1.94× 감소).** 이 모델의 상수:per-call 비가 0.94:1이라 E29의
  b3_deepae(172×)만큼 극적이지 않지만, 방향과 정확도는 같다.

**대조군이 이 셀을 의미 있게 만든다**: 같은 예산 9,382,092에서 **opt-in이 없는 빌드는 NOT_ADMITTED**다.
즉 통과의 원인은 예산이 느슨해서가 아니라 **조건부 계층이 명시적으로 켜졌기 때문**이다.

## 5. Q4 — knob이 기존 판정을 바꾸지 않았다

오버라이드 **미설정** 셀이 E32 `cfs_B_plus_1`과 **결정론적 값에서 전부 동일**하다.

| 값 | E32 `cfs_B_plus_1` | E36 `regression_no_override` |
|---|---:|---:|
| budget | 18,222,797 | **18,222,797** |
| verdict | ADMIT | **ADMIT** |
| hal_peak | 9,382,092 | **9,382,092** |
| admission_mode | unconditional | **unconditional** |
| peak_within_admitted_budget | true | **true** |

**Q4가 실패했다면 Q1을 PASS로 적지 않기로 계획서 §4에 미리 정해 두었다.** 통과했으므로 적는다.

## 6. 이 실험이 심고 잡은 결함 2건 (D61)

둘 다 **내가 이번에 넣은 변경**이고, 둘 다 **시험이 아니라 계측이** 잡았다.

### 6.1 매크로 읽기가 자기 대입이 됐다

`(long)AI_LEARNER_BUDGET_BYTES` → `g.budget_bytes` 일괄 치환이 **resolver 자신의 초기화 줄까지** 바꿔
`g.budget_bytes = g.budget_bytes;`가 됐다. 결과: 오버라이드 미설정 시 예산이 **0**이 되고 모든 실행이
`NOT_ADMITTED`. **그 거부는 정직해 보인다** — bounded > 0이므로 논리적으로 맞는 판정이다.

무엇이 잡았는가: `"budget":0,"budget_source":"macro"`. 계획서 §3.1이 이 필드를 **요구했기 때문에**
"정당한 거부"와 "설정이 0인 거부"가 구분됐다. 수정은 로컬 변수로 매크로를 읽고, **매크로 경로에서도
`budget <= 0`이면 `BUDGET_INVALID`로 거부**한다 — 원인을 감추는 거부를 만들지 않기 위해서다.

### 6.2 빌드 opt-in이 공유 CMake 캐시에서 잔류했다

`scripts/51_build_cfs_aarch64.sh`에 `${ALLOW_CONDITIONAL_MAP:+-D...}`로 통과 경로를 붙였다.
*"미설정 = 이전 동작"*으로 보였지만 `build-aarch64_std`는 **호출 간 공유되는 영속 트리**라,
조건부 빌드가 남긴 `CMakeCache.txt`의 `1`이 다음 무조건 빌드에 그대로 살아남았다.

증상: **`deny_B_minus_1`이 `ADMIT_CONDITIONAL_MAP`을 냈다.** 거부해야 할 셀이 승인했다 — 유형 (A)다.
수정: 기본값 `0`으로 **항상 명시 전달**하고, `AI_LEARNER_BUDGET_BYTES`와 **같은 방식으로 컴파일 명령에
도달했는지 검증**(도달 못 하면 셀이 아니라 **빌드가 죽는다**). 재빌드는 **조건부 트리를 먼저** 만들어
캐시에 `1`을 남긴 뒤 무조건 트리를 만들었다 — 결함이 남아 있었다면 그 순서가 재현했을 조건이다.

**교훈**: D52가 *"계약이 준 숫자를 게이트가 실제로 쓰는지 확인하라"*, D53·D54가 *"어느 숫자로 승인했고
어느 숫자로 검증하는가"*였다면 이것은 ***"판정에 쓴 설정이 무엇이었는지를 판정 자신이 기록하게 하라"***다.
그 기록이 없었다면 6.1은 정당한 거부로, 6.2는 정당한 승인으로 보였을 것이다.

## 7. 보존한 원자료

`results/e36_aarch64_cfs/`에 7개 셀의 게스트 raw log와 `summary.json`을 넣었고,
결함 재현 로그도 **지우지 않고** 보존한다.

| 디렉터리 | 내용 |
|---|---|
| `smartcam/` | 최종 7셀(수정 후 빌드, 조건부-먼저 순서로 재빌드) |
| `prefix_bug/` | §6.1 재현 — `"budget":0,"budget_source":"macro"` |
| `cache_leak_bug/` | §6.2 재현 — `deny_B_minus_1`이 `ADMIT_CONDITIONAL_MAP` |

## 8. 판정 (계획서 §4)

| 질문 | 결과 |
|---|---|
| **Q1** cFS 예산 미달 거부 | **PASS** — NOT_ADMITTED·추론 0·cFS 앱 8개 계속 로드 |
| **Q1b** knob 자신의 fail-closed | **PASS** — 파싱 실패·0 전부 `BUDGET_INVALID`, 추론 0 |
| **Q2** 조건부 계층 수명주기 | **PASS** — 피크 = 승인 예산 = `per_call` 정확히, arm=map, 대조군은 거부 |
| **Q4** 오버라이드 미설정 무변경 | **PASS** — E32와 결정론적 값 전부 동일 |
| **Q3** ResNet·DeepAE AArch64 | **미실행** — E36b로 이연. 이 커밋은 주장하지 않는다 |

**`stage_2_complete: true`.** E32가 `false`로 남긴 자리를 원자료로 닫았다.

## 9. 하지 않은 것 (범위)

- **Q3(ResNet·DeepAE의 AArch64 native·cFS)**: 미실행. §10 단계 4는 그것까지 요구하므로 **단계 4는
  여전히 잔여 셀이 있다.**
- **정확도**: 평가셋이 없다.
- **지연·처리량**: `FUNCTIONAL_ONLY` 호스트다. 추론 횟수도 시간의 함수이지 성능 지표가 아니다.
- **OnAIR AArch64·SBN 연계**: 범위 밖(E33 §9).
- **OnAIR 경로의 메모리 해제**: D60이 미검증으로 남긴 항목이며 여기서 다루지 않았다.
- **계약 재생성**: 0회. E32의 단일 호출 산출물을 그대로 썼다(규율 7).
- **일반화**: 이 모델·이 컴파일러 버전·이 게스트 구성의 관측이다.
