# E56 계획 — 조건부 계층의 전제 실패 거부를 평가 타깃(AArch64 cFS)에서 실행

**사전 고정 문서다. 측정 이전에 커밋한다.** 이 파일이 커밋된 뒤에 셀을 돌린다.

## 0. 왜 하는가

연구 책임자 지시(2026-09-22): **x86-64는 이 논문의 타깃도 검증 수단도 아니다. 모든 실험과
V&V는 AArch64 기반이어야 한다.**

원고 §IV.B·그림 4는 *"조건부 계층은 정렬 전제를 런타임 생성 앞에서 검사하고, 어긋나면
거부한다"*를 설계로 제시한다. 그 발동 장면을 보인 셀은 현재 **두 개뿐이고 둘 다 x86-64 cFS**다
(`results/e29_conditional_contract/cfs/b3_deepae_conditional_map_PRECONDITION_FAILED.log`,
`results/e29b_conditional_verify/cfs/bigact_after_fix_condmap_shim_REFUSED.log`).

AArch64 게스트 로그 전수에 `MAP_PRECONDITION` 레코드는 **0건**이다. 게스트의 조건부 셀
(E55/P0-4) 4개는 전부 `module_ptr_mod64: 0`으로 전제가 성립했고, 정렬을 깬 셀(E55b) 4개는
전부 **무조건** 계층이라 앱이 거부할 이유가 없었다. 즉 두 노브가 독립적으로만 검증돼 있고
**그 조합 셀이 없다.**

이 실험은 그 조합을 AArch64 게스트 cFS에서 만든다. 성공하면 x86-64 두 셀은 원고에서
**대체된다**(보관은 유지하되 근거로 인용하지 않는다).

## 1. 착수 전 조사 — 조합을 막는 것이 코드에 있다 (실험 아님, 판정 아님)

`native/cfs_app/fsw/src/ai_learner.c`의 `AI_LEARNER_BlobAlignOffset()`:

```c
#if AI_LEARNER_ALLOW_CONDITIONAL_MAP
  if (v != 0) { *why = "refused: conditional admission is enabled (plan SS2.1)"; return -1; }
#endif
```

E55b가 넣은 가드이고, 주석의 사유는 *"이 노브가 조건부 게이트를 우회(walk around)하는 데
쓰여선 안 된다. copy 셀은 무조건 경로에서만 돈다"*이다.

**그 사유는 이 조합에 성립하지 않는다.** 우회가 되려면 게이트를 통과해 실행에 도달해야 하는데,
조건부 ON + offset≠0이면 게이트가 `module_ptr_mod64 != 0`을 보고 **런타임 생성 전에 거부**한다
(`ai_learner.c`의 append 이전 검사, E29b/D54). 이 조합은 게이트를 우회하는 경로가 아니라
**게이트를 발동시키는 유일한 경로**다. E55b의 문장은 그 실험의 범위 결정(copy 셀은 무조건
경로에서만)이었지 안전 성질이 아니었다.

따라서 이 가드는 이 저장소가 쓰는 두 방향 결함 정의에서 **유형 (B) 과잉 거부**다
(D47·D48·D49·D57·D80과 같은 계열 — fail-closed 규칙이 막으려던 것과 함께 필요한 경로를 닫았다).

### 1.1 채택하는 수정 — 제거가 아니라 좁히기

가드를 **지우지 않는다.** 조건부 경로에서도 offset을 허용하되, 다음을 유지한다.

- `blob_align` 레코드(`requested_offset`·`state`·`module_ptr_mod64`)는 그대로 남는다 —
  적용 여부가 판정과 독립으로 기록된다(D69).
- 나머지 fail-closed 축 5개(비정수·범위 밖·8의 배수 아님·0 아닌 64의 배수·빈 문자열)는 불변.
- 조건부 경로에서 offset이 적용되면 **게이트가 반드시 먼저 발동**해야 한다 —
  그것이 아래 F1·F2 반증 조건이다.

**이 변경으로 새 fail-open이 열리는가**: 열리지 않는다. 조건부 경로의 방어는 두 층이고
(append 전 `module_ptr_mod64 != 0` 거부, append 후 `hal_peak_after_append != 0` 거부)
이 변경은 둘 중 어느 것도 건드리지 않는다. 무조건 경로의 거동은 바이트 불변이다
(`AI_LEARNER_ALLOW_CONDITIONAL_MAP=0`에서 이 `#if`는 애초에 컴파일되지 않는다).

## 2. 셀 — 4모델 × 2조건 = 8셀, 전부 AArch64 게스트 cFS

빌드는 **모델당 하나**(`AI_LEARNER_ALLOW_CONDITIONAL_MAP=1`), 두 셀은 **같은 바이너리**에
환경변수만 다르게 준다. 컴파일 타임 예산 매크로는 `bounded+1`로 두고(더 작게 빌드하면
컴파일러가 admission 실패를 정적으로 접는다 — E36) 실제 예산은 `AI_LEARNER_BUDGET_OVERRIDE`로 준다.

| 셀 | 예산 `M` | `AI_LEARNER_BLOB_ALIGN_OFFSET` | 목적 |
|---|---|---|---|
| `R_<model>` | `P` | **8** | 전제 실패 → 런타임 생성 전 거부 |
| `P_<model>` | `P` | 미설정 | 전제 성립 → 승인·추론 (같은 바이너리의 통과 경로) |

`P_*` 셀을 함께 도는 이유는 **D97의 교훈** 때문이다 — 가드를 좁히면서 바이너리가 바뀌므로,
거부가 "게이트가 발동했다"인지 "빌드가 깨졌다"인지 구분할 양성 대조가 같은 바이너리에 필요하다.

모델별 값(계약에서 읽는다, 이 파일이 값의 출처가 아니다):

| 모델 | `P` | `C` | `B_u` |
|---|---:|---:|---:|
| b2_resnet | 309,416 | 309,440 | 618,856 |
| b3_deepae | 6,208 | 1,063,424 | 1,069,632 |
| smartcam | 9,382,092 | 8,840,704 | 18,222,796 |
| wgan | 131,382,784 | 4,283,648 | 135,666,432 |

## 3. 사전 고정한 기대 레코드

`R_*` 셀 (거부):
1. `{"stage":"build_config", ...}` — opt-in 설정이 **판정보다 먼저** 기록된다 (E38/D69)
2. `{"stage":"blob_align","requested_offset":8,"state":"applied","module_ptr_mod64":8}`
3. `{"stage":"admission","verdict":"ADMIT_CONDITIONAL_MAP","budget":P,"budget_source":"override"}`
4. `{"stage":"binding","verdict":"MATCH"}`
5. `{"stage":"map_branch","verdict":"MAP_PRECONDITION_UNMET","module_ptr_mod64":8}`
6. `mem_init` 레코드 **부재** — 런타임이 만들어지지 않았다는 신호 (D80: 부재로 추론하는 것이고
   직접 신호는 여전히 없다. 그 한계를 결과에도 적는다)
7. `{"stage":"cleanup",...}` → `CFE_ES_ExitApp` → cFS가 남은 앱을 계속 로드
8. 추론 **0회**

`P_*` 셀 (승인):
1. `blob_align`: `requested_offset:0`, `state:"unset"`, `module_ptr_mod64:0`
2. `admission`: `ADMIT_CONDITIONAL_MAP`, `budget = P`
3. `map_branch`: `arm:"map"`, `hal_peak_after_append:0`
4. `mem_init` 존재, 추론 **≥1**, 최종 HAL 피크 **정확히 `P`**

## 4. 반증 조건 (측정 전에 고정)

하나라도 발생하면 그 셀은 실패로 기록하고 판정을 바꾸지 않는다.

- **F1** — `R_*` 셀에 `mem_init` 레코드가 있다 → 거부가 런타임 생성을 앞서지 않았다.
- **F2** — `R_*` 셀의 추론 > 0 → 거부가 실행을 막지 못했다.
- **F3** — `R_*` 셀의 `module_ptr_mod64 != 8` 또는 `blob_align.state != "applied"` →
  offset이 적용되지 않았으므로 그 셀은 주장하는 것을 시험하지 않았다.
- **F4** — `P_*` 셀의 최종 피크 ≠ `P` → 가드 좁히기가 통과 경로를 깨뜨렸다.
- **F5** — `R_*` 셀 이후 cFS가 남은 앱 로드를 멈춘다 → 거부가 시스템을 망가뜨렸다.

## 5. 하지 않는 것 (명시)

- **x86-64에서는 아무것도 돌리지 않는다.** 보관된 x86-64 두 셀은 지우지 않되 이 실험의
  근거로 인용하지 않는다.
- 무조건 계층의 거동 변경 — 없다(바이트 불변을 빌드 산출물로 확인한다).
- 정확도·지연·전력 — 범위 밖. 이 게스트는 `platform_check.py`가 `FUNCTIONAL_ONLY`다.
- 합성 모델(MLP·conv2d·multibranch·constant-heavy)의 AArch64 이식 — 별건.
- OnAIR·§V.G 층별 분해의 AArch64 이식 — 별건(원고 x86-64 제거의 나머지 항목).

## 6. 산출물

- `results/e56_conditional_refusal_aarch64/cells/logs/*.log` — 게스트 raw log 8개
- `results/e56_conditional_refusal_aarch64/trees/*` — 빌드별 `build_info.json`·witness·`.so` 해시
- `results/e56_conditional_refusal_aarch64/summary.json` — 셀별 판정과 F1~F5
- `docs/EVIDENCE_v0.61_E56.md`
- 회귀 시험: `harness/contract_negative_tests.py::e56_*`, 가드 좁히기의 revert-and-confirm-fail
