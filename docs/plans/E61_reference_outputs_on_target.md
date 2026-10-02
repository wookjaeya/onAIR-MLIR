# E61 계획 — 원고 표 `tab:outputs`의 기준값(원본 TFLite 런타임 출력)을 평가 타깃에서 생성한다

**사전 고정 문서다. 게스트에서 기준값을 생성하기 전에 커밋한다.**

## 0. 왜

연구 책임자 지시(2026-09-22): **x86-64는 이 논문의 타깃도 검증 수단도 아니다. 모든 실험과 V&V는 AArch64 기반이어야 한다.**

원고 표 `tab:outputs`(평가 타깃의 IREE 출력 ↔ 원본 TFLite 런타임 출력)의 **피검 쪽**은 전부 평가 타깃이다(E48 ResNet·
DeepAE·SmartCam, E53 WGAN, E60 층 분해). 그러나 **기준값 쪽**은 전부 **지상 측(x86-64) LiteRT**가 만들었다
(`results/e45_real_inputs/cells/<model>/oracle_tflite.json` — 레코드에 실행 기계가 적혀 있지 않다; E53 WGAN은
`/tmp` 경로를 인용하고 저장소에 없다). 판정(V&V)의 한쪽 다리가 지상 측에 있는 셈이다.

착수 전 조사(실험 아님): 지상 측과 **같은 버전**(`ai-edge-litert 2.2.0`)의 AArch64 휠
(`ai_edge_litert-2.2.0-cp312-cp312-manylinux_2_27_aarch64.whl`)이 존재한다. 게스트는 Ubuntu 24.04·Python 3.12라
설치 조건을 만족한다(게스트에 pip가 없으므로 E57과 같이 휠을 풀어 `PYTHONPATH`로 올린다).

## 1. 질문

- **Q1**: 같은 LiteRT 버전·같은 원본 `.tflite`·같은 fixture 텐서에서, 평가 타깃이 만든 기준값이 지상 측 기준값과
  **비트 동일**한가(모델별·샘플별)?
- **Q2**: 평가 타깃의 IREE 출력(보관 원자료, 재실행 없음)을 **평가 타깃 기준값**과 E25 규칙(무변경 승계)으로 다시
  판정하면 `tab:outputs`의 네 행이 어떻게 되는가?

## 2. 셀 — 전부 게스트(AArch64 QEMU 시스템 에뮬레이션), 재컴파일 0, IREE 재실행 0

| 모델 | fixture | 샘플 | 피검(보관, 재판정만) |
|---|---|---:|---|
| ResNet | E48 fixture(E45 규칙으로 재생성, 샘플별 sha256 대조) | 200 | `results/e48_real_inputs_aarch64/b2_resnet/{native_real,iree_cfs_aarch64}.json` |
| DeepAE | 같음(입력 바이트는 저장소 밖 — E45) | 34 | `results/e48_real_inputs_aarch64/b3_deepae/…` |
| SmartCam | 같음 | 19 | `results/e48_real_inputs_aarch64/smartcam/…` |
| WGAN | `results/e46_wgan/cell/fixture`(E53이 쓴 실이미지 1장) | 1 | `results/e53_wgan_aarch64/…` |
| DeepAE 층(E60) | E60 실패 창 1개 | 1 | `results/e60_deepae_layers_aarch64/guest/guest_outputs.json` — 원고 §V.G의 층별 수치도 기준값 쪽 중간 텐서를 지상 측 LiteRT로 얻었으므로, 게스트 LiteRT의 **보존 실행 중간값**(E52/E60과 같은 보존 실행 검사 포함)으로 다시 판정한다 |

도구는 `harness/tflite_oracle.py`를 게스트에서 돌린다. 원본 `.tflite`는 각 모델의 보존 원본(해시 대조). 이 실험 전에
그 도구에 **기록 필드 하나**(`machine` = `platform.machine()`)만 더한다 — 실행·출력 계산 경로는 바꾸지 않는다.

## 3. 판정 (측정 전 고정)

- **V**: 게스트 기준값 레코드의 `machine == "aarch64"`, 원본 `.tflite` sha256이 보존 원본과 일치, fixture 샘플 수·
  입력 sha256이 매니페스트와 일치. 어긋나면 그 모델은 INVALID이며 판정에 쓰지 않는다.
- **Q1 기록**: 모델별 `bitwise_identical_samples / samples`와 불일치 샘플의 최대 원소 차. **어느 결과든 기록**한다 —
  이것은 PASS/FAIL이 아니라 관측이다.
- **Q2 판정 규칙(원고 반영)**: `tab:outputs`는 **평가 타깃 기준값**으로 다시 쓴다. Q1이 전부 비트 동일이면 수치는
  바뀌지 않고 원고는 기준값의 생성 위치만 고친다. 비트 동일이 아니면 **평가 타깃 기준값에 대한 재판정 수치**를 쓰고,
  지상 측 수치는 원고에 인용하지 않는다(디스크에는 남긴다 — E56 규칙).
- 허용오차는 E25 그대로다(원소별 `abs ≤ 1e-4` OR `rel ≤ 1e-5`). **재판정 결과를 보고 기준을 고치지 않는다**(D74).

## 4. 반증·주의 조건

- **F1**: 게스트에서 LiteRT가 적재·실행되지 않음 — 기록하고 그 모델은 지상 측 기준값으로 남기되 원고에 그 사실을 적는다.
- **F2**: 게스트 기준값이 지상 측과 다르고 재판정 판정이 바뀜(예: DeepAE 실패 수 변화, 다른 모델 FAIL 전환) — **숨기지
  않고** 원고 표와 본문 수치를 그대로 바꾼다.
- 기본 delegate(XNNPACK)는 지상 측과 같이 **기본값 그대로** 둔다 — 기준값의 정의는 "원본 런타임의 기본 실행"이다.

## 5. 주장하지 않는 것

- LiteRT의 정확성·제3의 기준값(E52 §4.3과 같다).
- 정확도(평가셋 아님 — E45 §5).
- 두 ISA 사이 LiteRT 차이의 기전.
