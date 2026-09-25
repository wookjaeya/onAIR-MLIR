# EVIDENCE v0.61 — E56: 조건부 계층의 전제 실패 거부를 평가 타깃에서 실행

**판정: PASS.** 거부 4/4 · 양성 대조 4/4 · 사전 고정 반증 조건 F1~F5 **발동 0건**.
사전 고정 기준은 `docs/plans/E56_conditional_refusal_aarch64.md`(커밋 `ad2c1ba`, **측정 이전**).

## 1. 무엇이 문제였나

연구 책임자 지시(2026-09-22): **x86-64는 이 논문의 타깃도 검증 수단도 아니다. 모든 실험과
V&V는 AArch64 기반이어야 한다.**

원고 §IV.B와 그림 4는 *"조건부 계층은 정렬 전제를 런타임 생성 앞에서 검사하고, 어긋나면
거부한다"*를 설계로 제시한다. 그 발동을 보인 셀은 **두 개뿐이고 둘 다 x86-64 cFS**였다.

| 셀 | 위치 | 모델 | 정렬을 깬 방법 |
|---|---|---|---|
| 사후 거부 | `results/e29_conditional_contract/cfs/b3_deepae_conditional_map_PRECONDITION_FAILED.log` | b3_deepae | E29b 이전 빌드(앱이 아직 자기 blob을 정렬하지 않음) |
| 사전 거부 | `results/e29b_conditional_verify/cfs/bigact_after_fix_condmap_shim_REFUSED.log` | **합성** bigact | `e29_no_posix_memalign` **shim** |

AArch64 게스트 로그 전수에 `MAP_PRECONDITION` 레코드는 **0건**이었다. 게스트의 조건부 셀
(E55/P0-4) 4개는 전부 `module_ptr_mod64: 0`으로 전제가 성립했고, 정렬을 깬 셀(E55b) 4개는
전부 **무조건** 계층이라 앱이 거부할 이유가 없었다. **두 노브가 독립적으로만 검증돼 있었다.**

## 2. 착수 전 조사가 찾은 것 — 그 조합을 코드가 막고 있었다

`ai_learner.c`의 `AI_LEARNER_BlobAlignOffset()`:

```c
#if AI_LEARNER_ALLOW_CONDITIONAL_MAP
  if (v != 0) { *why = "refused: conditional admission is enabled (plan SS2.1)"; return -1; }
#endif
```

E55b가 넣은 가드이고 사유는 *"이 노브가 조건부 게이트를 우회하는 데 쓰여선 안 된다"*였다.

**그 사유는 이 조합에 성립하지 않는다.** 우회가 되려면 게이트를 통과해 실행에 도달해야 하는데,
조건부 ON + offset≠0이면 게이트가 `module_ptr_mod64 != 0`을 보고 **런타임 생성 전에 거부**한다.
우회하는 경로가 아니라 **게이트를 발동시키는 유일한 경로**다. E55b의 문장은 그 실험의 범위
결정(*"copy 셀은 무조건 경로에서만"*)이었지 안전 성질이 아니었다.

이 저장소의 두 방향 결함 정의에서 **유형 (B) 과잉 거부**이고, D47·D48·D49·D57·D80과 같은
계열이다 — fail-closed 규칙이 막으려던 것과 함께 **필요한 경로를 닫았다**. 그 결과
*"이 연구가 타깃으로 삼지 않는 호스트에만 증거가 있는"* 상태가 만들어졌다.

### 2.1 제거가 아니라 좁히기

| 유지 | 제거 |
|---|---|
| 나머지 **여섯** fail-closed 축(빈 문자열·비정수·trailing garbage·범위·8의 배수·0 아닌 64의 배수) | 조건부-계층 축 **하나** |
| append 전 `MAP_PRECONDITION_UNMET` | |
| append 후 `MAP_PRECONDITION_FAILED` | |
| `blob_align` 레코드(`requested_offset`·`state`·`module_ptr_mod64`) — 설정이 판정과 독립으로 기록된다(D69) | |
| 무조건 빌드의 거동(그 `#if`는 애초에 컴파일되지 않는다) | |

## 3. 셀 — 8개, 전부 AArch64 게스트 cFS

빌드는 모델당 하나(`ALLOW_CONDITIONAL_MAP=1`), 두 셀은 **같은 바이너리**에 환경변수만 다르다.

### 3.1 거부 셀 (예산 `M = P`, `BLOB_ALIGN_OFFSET=8`)

| 모델 | 예산 `P` | `blob_align` | admission | map_branch | `mem_init` | 추론 |
|---|---:|---|---|---|---|---:|
| b2_resnet | 309,416 | applied / mod64 **8** | `ADMIT_CONDITIONAL_MAP` | **`MAP_PRECONDITION_UNMET`** | 부재 | **0** |
| b3_deepae | 6,208 | applied / mod64 **8** | `ADMIT_CONDITIONAL_MAP` | **`MAP_PRECONDITION_UNMET`** | 부재 | **0** |
| smartcam | 9,382,092 | applied / mod64 **8** | `ADMIT_CONDITIONAL_MAP` | **`MAP_PRECONDITION_UNMET`** | 부재 | **0** |
| wgan | 131,382,784 | applied / mod64 **8** | `ADMIT_CONDITIONAL_MAP` | **`MAP_PRECONDITION_UNMET`** | 부재 | **0** |

네 셀 모두 `budget_source: "override"`, `target: aarch64-unknown-linux-gnu`,
`cleanup released=true`, `CFE_ES_ExitApp`, 이후 cFS가 남은 앱을 계속 로드(크래시 0).

EVS 원문(b2_resnet):
```
AI_LEARNER MAP_PRECONDITION_UNMET: admitted on per_call=309416 but module image is 8 mod 64;
refused before runtime
```

### 3.2 양성 대조 (같은 바이너리, offset 미설정)

**D97의 교훈 때문에 필요하다** — 가드를 좁히며 바이너리가 바뀌었으므로, 거부가 *"게이트가
발동했다"*인지 *"빌드가 깨졌다"*인지는 같은 바이너리의 통과 경로로만 가른다.

| 모델 | mod64 | arm | append 피크 | 추론 | 최종 HAL 피크 | `= P`? |
|---|---:|---|---:|---:|---:|---|
| b2_resnet | 0 | map | 0 | 223 | **309,416** | 정확히 |
| b3_deepae | 0 | map | 0 | 224 | **6,208** | 정확히 |
| smartcam | 0 | map | 0 | 139 | **9,382,092** | 정확히 |
| wgan | 0 | map | 0 | 1 | **131,382,784** | 정확히 |

## 4. 반증 조건 (측정 전에 고정, 발동 0건)

| | 조건 | 결과 |
|---|---|---|
| F1 | 거부 셀에 `mem_init` 레코드가 있다 | 4/4 부재 |
| F2 | 거부 셀의 추론 > 0 | 4/4 = 0 |
| F3 | `module_ptr_mod64 != 8` 또는 `state != applied` | 4/4 applied·8 |
| F4 | 양성 셀의 최종 피크 ≠ `P` | 4/4 정확히 일치 |
| F5 | 거부 후 cFS가 앱 로드를 멈춘다 | 4/4 OPERATIONAL 유지 |

## 5. 무엇을 대체하는가

x86-64 두 셀은 **디스크에 남기되 근거로 인용하지 않는다.** 대체본이 세 축에서 더 강하다.

| | 기존 (x86-64 cFS) | E56 (AArch64 cFS) |
|---|---|---|
| 실행 환경 | 개발 호스트 | **평가 타깃** |
| 모델 | 합성 bigact 1 + DeepAE 1 | **실물 4모델 전부** |
| 정렬 제어 | 시험용 shim | **앱 자신의 노브** |
| 거부 시점 | 사전 1 + 사후 1 | **4/4 런타임 생성 전** |

## 6. 부수 — D102: 끝점이 하나만 고정된 유도 기록

`ai_learner.c` 변경이 `e55b/15`를 빨갛게 만들었는데 **원인은 그 변경이 아니라 가드였다.**
E55b의 `app_source_delta`는 끝점이 둘인데 `git diff --numstat <baseline> --`로 **작업 트리와**
비교하고 있었다. 그래서 앱 소스가 다시 바뀌는 순간 기록값이 드리프트하고, 가드는
**그 셀들이 빌드된 적 없는 소스에 맞춰 역사적 기록을 고쳐 쓰라고** 요구한다.
HEAD를 따라 움직이는 유도는 재현 가능하지 않다.

수정: `cells_built_at`(= `3e746a8`, 셀 실행 전 앱 소스를 바꾼 마지막 커밋)을 싣고 범위로
diff한다. **수치는 195/11 · 166/10 그대로 불변**이다. 가드는 끝점 미고정을 거부한다.

같은 변경으로 E51 stage2의 `AI_LEARNER_Init` 감싸는 루프 줄번호가 693→703으로 밀렸다.
판정·state·개수·루프 형태가 전부 같고 줄번호만 이동했으므로 유도를 다시 돌려 보관본을 갱신했다.

## 7. 방법론 — 가드가 자기 설명 주석에 걸렸다

`e56/2`(*"조건부 축이 제거됐는가"*)의 첫 판이 **FAIL**했다. 좁히기를 설명하는 주석이
`AI_LEARNER_ALLOW_CONDITIONAL_MAP`을 명시하고 있어서, 원문을 grep하는 가드가
**규칙을 문서화한 문장을 규칙 위반으로** 보고한 것이다. D85(*규칙을 설명하는 문장이 규칙을
만족시켰다*)와 E54 가드 8(*규칙을 설명하는 문장이 규칙을 위반시켰다*)의 세 번째 얼굴이다.
주석을 걷어내고 **실행되는 줄만** 보도록 고쳤다.

## 8. 회귀

가드 16건(`e56/1`~`/8`), 이 컨테이너 **897/897 + 1 SKIP**.
revert-and-confirm-fail: 가드를 되돌리면 `e56/2`가 실제로 FAIL, 복원하면 PASS.

## 9. 주장하지 않음

- **이 실험을 위해 x86-64에서는 아무것도 돌리지 않았다.**
- *"런타임 생성 전 거부"*는 `mem_init` 레코드의 **부재**로 추론한 것이다(D80). 직접 신호는
  여전히 없고, 이 문서도 그 한계를 물려받는다.
- 정확도·지연·전력 — 범위 밖(`platform_check.py`가 `FUNCTIONAL_ONLY`).
- 양성 대조는 SB 텔레메트리를 feature로 쓰므로 E31/E48 fixture를 재생하지 않는다 —
  **출력 동치는 이 셀들이 주장하지 않는다.**
- 합성 모델(MLP·conv2d·multibranch·constant-heavy)의 AArch64 이식은 하지 않았다.
