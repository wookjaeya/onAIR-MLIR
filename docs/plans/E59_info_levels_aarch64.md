# E59 계획 — 정보 수준 비교를 평가 타깃(AArch64) 아티팩트로 다시 한다

**사전 고정 문서다. 측정 이전에 커밋한다.** 이 파일이 커밋된 뒤에 수집기를 돌린다.

## 0. 왜 하는가

연구 책임자 지시(2026-09-22): **x86-64는 이 논문의 타깃도 검증 수단도 아니다.**

원고 §VI.A(*"layout을 읽는 것이 수치를 바꾸는가"*)의 근거는 두 실험이다.

| 원고 주장 | 근거 | 아티팩트 타깃 |
|---|---|---|
| 정상 조건에서 두 수준이 세 수치·커널 스택·24 예산 셀 판정에서 일치 | E35 | 4구성 중 **3개가 x86-64**(smartcam_x86_64·b2_resnet·b3_deepae), AArch64는 smartcam 1개 |
| 드리프트 아티팩트에서 아티팩트 전용 분석기가 5,172 B·빈 unresolved 목록 | E27 | **x86-64**(`results/e27_baselines/iree310_mlp16k`, `elf.json` arch `x86_64`) |
| 굳힌 분석기는 그 아티팩트를 사유와 함께 거부하고 나머지 7개에서 정확 | E27 §7 정오표 | 7개 중 AArch64 3개(합성) |

즉 §VI.A는 **평가 타깃 아티팩트로 거의 측정되지 않았다.** 이 실험은 원고의 네 실물 모델의 **AArch64**
아티팩트로 같은 질문을 다시 잰다. 분석 도구(`iree-dump-module`·`elf_stack_frame.py`·`make_contract.py`)는
지상 측 워크스테이션에서 돈다 — 컴파일러가 그곳에서 도는 것과 같다. **분석 대상이 AArch64 아티팩트**라는 것이
이 실험이 바꾸는 것이다.

## 1. 착수 전 조사 (실험 아님, 판정 아님)

- PyPI의 `iree-base-compiler==3.10.0`은 `iree-compile --version`이 **`3.10.0rc20260107 @ ae97779`**를 보고한다 —
  E27 드리프트 아티팩트를 만든 **바로 그 컴파일러 리비전**이다. 이 저장소의 기준 컴파일러는
  `3.11.0rc20260316 @ e4a3b04`다. 드리프트 조건을 AArch64로 그대로 옮길 수 있다.
- 네 모델의 입력 MLIR은 저장소에 있다(`results/e36b_aarch64_models/{b2_resnet,b3_deepae}/*.mlir`,
  `results/p1_smartcam_feasibility/build/smartcam.mlir.gz`, `results/e53_wgan_aarch64/build/aarch64/wgan.mlir`).
  수집기는 각 계약의 `provenance.mlir_sha256`과 **대조한 뒤에만** 쓴다(불일치면 그 모델은 tool_error).
- E35 수집기의 D72 성질(세 수치가 다른 모델은 정책 셀을 만들지 않는다)은 그대로다 — 24셀 판정 일치는
  **따름정리**이고 독립 측정으로 세지 않는다.

## 2. Part A — 정상 조건 (재컴파일 0)

네 AArch64 아티팩트(원고 표 `tab:components`의 바로 그 계약): b2_resnet·b3_deepae(E36b), smartcam(E32),
wgan(E53).

- (c) 저장된 계약의 `bounded`·`per_call`·`constants`·`kernel_task_stack_invocation_bytes`
- (b′) `harness/e27_baseline_vmfb_only_hardened.py`(vmfb + `iree-dump-module`만) + `elf_stack_frame.py --vmfb`
- 같은 정책 코드(`admission_policy.py`)로 4모델 × 2정책 × 3구간(`B`·`P`·`P−1`) = 24셀 — **따름정리**

**판정 A**: 세 수치 일치 모델 수 / 4, 커널 스택 일치 모델 수 / 4. 불일치가 나오면 **먼저 수집기를 의심한다**
(E35 교훈) — 그래도 남으면 그것이 결과다.

## 3. Part B — 컴파일러 드리프트 (AArch64 재컴파일 4회, 모델당 한 번의 호출)

같은 네 입력 MLIR을 IREE **3.10.0rc20260107**로 `aarch64-unknown-linux-gnu`/`cortex-a53`에 대해 **한 번의
`iree-compile` 호출**(규율 7)로 컴파일한다 — vmfb + `--mlir-print-ir-after=iree-stream-layout-slices` +
`--iree-hal-dump-executable-files-to`, 나머지 플래그는 `harness/e14_matrix.py`와 같다.

세 수준을 적용한다 — (c) `make_contract.py`(이 저장소의 3.11 도구로 3.10 산출물을 읽는다),
(b) `e27_baseline_vmfb_only.py`(출하한 아티팩트 전용 분석기), (b′) 굳힌 변종.

셀 분류(E27 규칙 승계 + 강화):

| 분류 | 조건 |
|---|---|
| `value` | 수치를 냈고 아래의 불가능 조건에 걸리지 않는다 |
| `explicit_refusal` | 수치 없이 사유를 남겼다 |
| `tool_error` | 수집기·입력 결함(트레이스백·파일 부재) — 거부로 세지 않는다(D51) |
| `impossible_value` | 수치를 냈는데 **버전에 무관한 하한**을 어긴다: `per_call < I + O`(인터페이스 텐서 바이트, 형상과 dtype에서 계산 — 컴파일러 리비전과 무관) 또는 `constants < 0` |

3.11 계약 수치는 **보조 참조**로만 기록한다(`differs_from_311_reference`) — E27이 적었듯 3.10 산출물의
정답이 3.11과 같다고 단정할 근거는 없으므로, 3.11과 다르다는 것만으로 `impossible_value`라 부르지 않는다.

**판정 B**(측정 전 고정): 수준별 `impossible_value` 개수. 원고 §VI.A의 문장은 이 개수와 그 셀의 사유
필드에서만 쓴다. 결과가 E27(x86-64)과 다르면 — 예컨대 AArch64 드리프트에서 (b)가 실패하지 않으면 —
**원고 문장을 그 결과로 바꾼다**. E27의 결과를 AArch64 문장으로 옮겨 적지 않는다.

## 4. 반증 조건 / 주의

- **F1**: Part A에서 (b′)가 네 모델 중 하나라도 계약과 다르고, 수집기 결함이 아님이 확인되면 원고의
  *"정상 조건에서 두 수준이 일치"*는 AArch64에서 성립하지 않는다.
- **F2**: Part B에서 (c)가 `impossible_value`를 내면 layout 기반 경로가 드리프트에서 침묵 오류를 낸다 —
  원고 §VI.A의 방향이 뒤집힌다.
- 3.10 산출물은 **판정용이 아니라 드리프트 조건의 재료**다. 그것으로 cFS 셀을 돌리지 않는다.

## 5. 주장하지 않는 것

- 넓은 버전 매트릭스(3.10 한 리비전뿐이다 — n은 모델 수 4이지 리비전 수가 아니다).
- 두 정보원의 **오류 독립성**(여전히 같은 컴파일 체인을 읽는다 — v0.38.1 정정 그대로).
- 정규 MLIR pass(범위 밖, 2026-09-11 결정).
