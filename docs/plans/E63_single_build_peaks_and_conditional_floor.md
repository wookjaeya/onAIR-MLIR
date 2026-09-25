# E63 계획 — 원고 표 7을 한 빌드로 닫는 셀 1개 + 조건부 정책의 하한(`M = P − 1`) 셀 4개

**사전 고정 문서다. 시나리오 파일(`results/e63_single_build_and_conditional_floor/scenarios_{t7,cf}.json`)과 함께 셀 실행
전에 커밋한다.** 두 질문 모두 v19 원고 검토 두 건(2026-09-23)에서 나왔다: v19 메타리뷰 M2(*표 7의 copy 열이 다른
빌드*)와 19차 메타리뷰 §4(*조건부 정책의 `M = P − 1`은 아직 실행하지 않았다 — 작은 추가 시험으로 권장*).

## 0. 착수 전 조사 (실험 아님 — 보관 원자료 판독)

- 표 7의 **copy 열**은 E55b 셀이고 그 바이너리는 E55b 무조건 빌드(`variants/e55b_<m>_copy/ai_learner.so`,
  소스 `3e746a8`)다. **E58 스윕이 같은 바이너리**를 썼다(`results/e58_alignment_sweep_aarch64/summary.json::binary_note`).
- 표 7의 **map 열**은 보관 셀(E36b·E37·E53)이라 다른 빌드다. 그런데 E58의 오프셋 0 셀이 같은 E55b 빌드에서
  map 분기 최종 피크를 이미 남겼다 — ResNet 309,416 · DeepAE 6,208 · SmartCam 9,382,092(각각 `P`와 같다). **WGAN
  오프셋 0 셀은 90초 창이라 추론 전에 끝나 최종 피크가 없다**(`final_hal_peak_observed: null`). 빠진 것은 이 한 칸이다.
- 조건부 정책 아래 `M < B_m = P`인 셀은 한 번도 실행하지 않았다(원고 §IV.B가 그렇게 적는다).

## 1. 질문

- **Q1**: E55b 빌드에서 WGAN을 오프셋 0으로 실행하면 최종 HAL 피크가 **정확히 `P` = 131,382,784**인가? 그러면 표 7의
  두 열이 **모델마다 한 바이너리**에서 나온다(map: E58 오프셋 0 ×3 + 이 셀, copy: E55b ×4).
- **Q2**: 조건부 계층을 켠 빌드에서 예산 `P − 1`은 **런타임 생성 전에** `NOT_ADMITTED`인가(네 모델)?

## 2. 셀 — AArch64 게스트 cFS, 재컴파일 0, 새 빌드 0

| 셀 | 바이너리 | 예산 | 오프셋 | 창 |
|---|---|---:|---|---:|
| T7-W | E55b `e55b_wgan_copy`(무조건) | `B_u` = 135,666,432 | **0**(명시) | 5,400 s (E54 교훈: WGAN 첫 추론 창) |
| CF ×4 | E56 `e56_<m>`(조건부 ON, E56과 같은 바이너리) | `P − 1` | 없음 | 120 s |

T7-W는 E55b WGAN copy 셀과 **같은 1샘플 fixture**(`results/e53_wgan_aarch64/e25_inputs_1sample.bin`)를 재생하므로 두 셀의
출력을 비교할 수 있다. 게스트에서 실행 직전 `.so` sha256을 계산해 보관 기록과 대조한다. OnAIR E62 셀과 같은 게스트에서
**동시에** 돌 수 있다 — 판정량은 결정론적 HAL 통계이고 프로세스마다 따로다(시간값은 쓰지 않는다).

## 3. 판정 기준 (측정 전 고정)

- **V**: 게스트 `.so` sha256이 보관 기록과 일치(T7-W ↔ `results/e55b_copy_path/trees/e55b_wgan_copy/ai_learner.so.sha256`,
  CF ↔ `results/e56_conditional_refusal_aarch64/trees/e56_<m>/so_sha256.json`). 불일치 셀은 INVALID.
- **Q1 PASS**: T7-W가 `ADMIT`·`MATCH`, `blob_align.module_ptr_mod64 = 0`, `hal_peak_after_append = 0`(map), 추론 ≥ 1,
  최종 HAL 피크 **= `P`**. 부수(판정 아님): 출력이 E55b copy 셀과 비트 동일.
- **Q2 PASS**: CF 4셀 전부 `NOT_ADMITTED`, `mem_init` 레코드 부재, 추론 0, cFS 운영 유지, build_config
  `allow_conditional_map = 1`.
- **보고 규칙**: Q1 PASS면 원고 표 7·그림 5의 캡션에서 *"map과 copy 셀은 서로 다른 응용 빌드"*를 *"모델마다 한 빌드"*로
  바꾸고 §V.D의 교란 서술을 지운다(수치가 같으면 표의 숫자는 바뀌지 않는다). Q1이 어긋나면 그 값을 그대로 쓰고 교란
  서술을 유지한다. Q2 PASS면 §IV.B의 *"조건부 정책 아래 `B_m`보다 낮은 예산은 실행하지 않았다"*를 결과로 바꾼다.

## 4. 주장하지 않는 것

- 조건부 계층의 append 후 거부(정렬 외 원인의 copy 분기) — 여전히 미실행 · 지연 · OnAIR 경로(E62가 다룬다).
