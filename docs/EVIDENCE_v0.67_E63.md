# EVIDENCE v0.67 — E63: 원고 표 7을 모델마다 한 앱 빌드로 닫고, 조건부 정책의 하한 `M = P − 1`을 실행했다

**사전 고정 계획**: `docs/plans/E63_single_build_peaks_and_conditional_floor.md`(커밋 `78dfda1`, **셀 실행 이전**).
**요약 생성기**: `harness/mk_e63_summary.py`(판독기 `stages()`·`record_count()`는 `mk_e36_summary`에서 import — D68).
**원자료**: `results/e63_single_build_and_conditional_floor/cells/logs/*.log`(게스트 raw log, 앱 자신의 레코드) ·
`cells/summary.json`(시나리오 러너 기록) · `guest_so_sha256.txt`(게스트에서 계산한 바이너리 해시) · `summary.json`.
**증거 등급**: 결정론적(앱이 스스로 남긴 HAL 할당자 통계·판정 레코드·sha256). 게스트는 `FUNCTIONAL_ONLY` — 시간값은 쓰지 않는다.

## 0. 왜

v19 원고 검토 두 건(2026-09-23)에서 나온 두 질문이다.

- **메타리뷰 A, M2**: 표 7(`tab:peaks`)의 copy 열은 E55b 셀(무조건 빌드 `e55b_<m>_copy`)이고 map 열은 보관 셀
  (E36b·E37·E53)이라 **앱 빌드가 다르다** — 원고 §V.D가 그 교란을 스스로 적고 있었다.
- **메타리뷰 B, §4**: 조건부 정책 아래 `M < B_m = P`인 셀은 한 번도 실행하지 않았다(원고 §IV.B가 그렇게 적는다).

착수 전 조사(계획 §0)가 첫 질문의 빈칸을 **한 칸**으로 좁혔다: E58의 오프셋 0 셀이 같은 E55b 빌드에서 ResNet·DeepAE·
SmartCam의 map 분기 최종 피크를 이미 남겼고, WGAN만 90초 창이라 최종 피크가 없었다.

## 1. 셀 — AArch64 게스트 cFS, 재컴파일 0, 새 빌드 0

| 셀 | 바이너리 | 예산 | 오프셋 | 창 |
|---|---|---:|---|---:|
| T7-W `e63_wgan_map_e55b_build` | E55b `e55b_wgan_copy`(무조건) | `B_u` = 135,666,432 | **0**(명시) | 5,400 s |
| CF ×4 `e63_<m>_cond_Pm1` | E56 `e56_<m>`(조건부 ON, E56과 같은 바이너리) | `P − 1` | 없음 | 120 s |

**V(바이너리 동일성)**: 셀 직전 게스트에서 계산한 `.so` sha256이 보관 트리 기록과 **5/5 일치**
(`e55b_wgan_copy` 28d85cf7… · `e56_b2_resnet` 631e96f8… · `e56_b3_deepae` 58112d26… · `e56_smartcam` 225925a8… ·
`e56_wgan` 8d89a41c…). T7 셀이 도는 동안, E58 오프셋 0 셀이 적재한 경로(`results/e58_alignment_sweep_aarch64/scenarios.json`의
`so`)의 **나머지 세 E55b 바이너리도 해시해** 보관 기록과 일치함을 적었다 — 표 7 map 열을 copy 열과 **같은 파일**에 묶는
근거다(`guest_so_sha256.txt` 하단 주석).

## 2. 판정 (계획 §3, 측정 전 고정)

### Q2 — 조건부 정책의 하한: **PASS 4/4**

| 모델 | 예산 `P − 1` | `allow_conditional_map` | 판정 | `mem_init` | `map_branch` | 추론(`run`/`mem`) | cFS |
|---|---:|---:|---|---:|---:|---:|---|
| b2_resnet | 309,415 | 1 | `NOT_ADMITTED` | 0 | 0 | 0 / 0 | 운영 유지 |
| b3_deepae | 6,207 | 1 | `NOT_ADMITTED` | 0 | 0 | 0 / 0 | 운영 유지 |
| smartcam | 9,382,091 | 1 | `NOT_ADMITTED` | 0 | 0 | 0 / 0 | 운영 유지 |
| wgan | 131,382,783 | 1 | `NOT_ADMITTED` | 0 | 0 | 0 / 0 | 운영 유지 |

- 네 셀 전부 `build_config.allow_conditional_map = 1`을 **판정보다 먼저** 기록했다(E38/D69 — 설정이 판정과 독립으로 남는다).
- `budget_source = override`, 판정 레코드의 `budget`이 정확히 `P − 1`.
- 앱이 `CFE_ES_ExitApp`을 부른 뒤 cFS는 다른 앱을 계속 돌렸다(러너의 `cfs_operational = true`, 크래시 지표 0).
- EVS 원문: *"AI_LEARNER NOT_ADMITTED: contract bounded=618856 > budget=309415; app will not start"*(ResNet).

### Q1 — 표 7의 WGAN map 셀: **PASS**

| 항목 | 값 |
|---|---|
| 바이너리 | `e55b_wgan_copy` — E55b copy 셀·E58 스윕과 **같은 파일**(게스트 sha256 28d85cf7… = 보관) |
| `build_config.allow_conditional_map` | 0 (무조건 빌드) |
| 판정 · 결속 | `ADMIT`(예산 135,666,432 = `B_u`, `budget_source=override`) · `MATCH` |
| `blob_align` | 요청 오프셋 0 · `applied` · `module_ptr_mod64 = 0` |
| append 직후 HAL 할당 | **0** (map 분기) |
| 추론 | 2회(창 5,400 s — E54 교훈대로 부팅·적재·e25 1회 + 런루프 1회를 넘도록 잡았다) |
| 최종 HAL 피크 | **131,382,784 = `P`** |
| `max_active_calls` | 1 |
| cFS | 운영 유지, 크래시 지표 0 |

**부수(판정 아님)**: 이 셀은 E55b WGAN copy 셀과 같은 1샘플 fixture를 재생했고 출력 602,112 B가 그 셀과 **비트 동일**하다 —
같은 바이너리 안에서 적재 분기만 달라도 값이 같다.

## 3. 표 7 — 모델마다 한 바이너리

| 모델 | 바이너리(게스트 sha256 = 보관) | map 최종 피크 (출처) | = `P` | copy 최종 피크 (출처) | = `P + C` |
|---|---|---:|---|---:|---|
| b2_resnet | `e55b_b2_resnet_copy` f43281dd… | 309,416 (E58 `off00`) | ✔ | 618,856 (E55b) | ✔ |
| b3_deepae | `e55b_b3_deepae_copy` 146158d7… | 6,208 (E58 `off00`) | ✔ | 1,069,632 (E55b) | ✔ |
| smartcam | `e55b_smartcam_copy` 592bf99f… | 9,382,092 (E58 `off00`) | ✔ | 18,222,796 (E55b) | ✔ |
| wgan | `e55b_wgan_copy` 28d85cf7… | 131,382,784 (E63 T7) | ✔ | 135,666,432 (E55b) | ✔ |

**표의 숫자는 바뀌지 않는다** — 바뀌는 것은 두 열이 **한 빌드**에서 나왔다는 진술이다.

## 4. 가드

`harness/contract_negative_tests.py::e63_single_build_and_conditional_floor_cases` — 6건. `e63/6`은 판정·표 7 행·하한
셀을 **게스트 raw log에서 임시 파일로 다시 유도**해 커밋된 summary와 대조한다(D89).

## 5. 원고 반영 (계획 §3 보고 규칙)

- Q1 PASS → 표 7·그림 5 캡션의 *"서로 다른 응용 빌드"*를 *"모델마다 한 빌드"*로 바꾸고 §V.D의 교란 서술을 지운다.
- Q2 PASS → §IV.B의 *"조건부 정책 아래 `B_m`보다 낮은 예산은 실행하지 않았다"*를 결과로 바꾸고, §V.E에 네 셀을 적고,
  §VI.C의 거부 셀 수를 16 → 20으로 고친다.

## 6. 주장하지 않는 것

- 조건부 계층의 **append 후** 거부(정렬 외 원인의 copy 분기) — 여전히 미실행.
- *"런타임이 만들어지지 않았다"*를 앱이 직접 기록한다는 것 — `mem_init`·`map_branch` 레코드의 **부재**로 추론한다(D80, E56과 같다).
- 지연(게스트는 `FUNCTIONAL_ONLY`) · OnAIR 경로(E62가 다룬다).
