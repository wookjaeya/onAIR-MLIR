# E53 계획 — WGAN AArch64 종단 검증

- 근거: `docs/reviews/DECISIONS_v0_52_REVIEW_R2_WGAN.md` §7.2(선행조건·7단계·완료 기준), §9 실행 순서
- 이 문서는 **측정·구현 이전에 커밋**한다(작업 규율).
- 기준 커밋: `0a9b223` (v0.55 + 결정 갱신 반영까지)

## §0 이 실험이 답하는 것과 답하지 않는 것

검토서 §7.2가 명시한 선행조건(E50 강제 경로 연결·순차 호출 근거·회계 매핑·DeepAE 원인)은
E51(단계 1~3)과 E52로 **이번 세션에서 전부 닫혔다**. §7.2는 WGAN을 "모델 하나 추가"가 아니라
**호출당 메모리가 기존 AArch64 최대 사례(SmartCam `per_call` 9,382,092 B)의 14배인 스트레스
사례"로 규정하고, 7단계·완료 기준을 측정 전에 이미 못박아 두었다 — 이 계획은 그 7단계를
그대로 채택하고 산출물 경로만 정한다.

**답하는 것**: WGAN의 AArch64 계약 생성(한 번의 `iree-compile`) · I·O·T·C 원장 대조 · AArch64
native에서 원본 TFLite oracle과의 의미 동치 · cFS `B`(=bounded) 승인·추론 · cFS `B−1` 거절·추론 0 ·
승인 셀 HAL peak와 계약의 같은 회계 영역 대조 · x86-64 대비 구성/판정 차이 기록.

**답하지 않는 것(§7.2가 요구하지 않음)**: **조건부 계층**(`AI_LEARNER_ALLOW_CONDITIONAL_MAP`) —
E46이 이미 "3.3%밖에 못 준다"고 정량화했고 §7.2의 7단계는 무조건 계층(`B=bounded`)만 요구한다.
새로 켜지 않는다. **VMFB 비트 동일성**(§7.2 마지막 줄이 명시적으로 요구하지 않음 — ISA가 다르다).
**정확도**(E46 G2 그대로, 평가셋 없음). **지연·처리량**(`FUNCTIONAL_ONLY` 호스트). **OnAIR AArch64**
(§7.1과 분리, 이번 실험 범위 밖). **환경 재구축**(§10 단계 0의 규율 — 이 컨테이너에 이미 생존해 있다,
아래 §1 확인).

## §1 착수 전 확인 (측정 아님)

이 컨테이너에 AArch64 빌드·런타임 환경이 이미 존재한다(재구축 없음, E36/E36b와 같은 전제):
`~/onair-mlir-bench/ext/{iree-src/build-rt-aarch64, cFS/build-aarch64_std, cfs-aarch64-exe, guest}`,
`aarch64-linux-gnu-gcc`·`aarch64-linux-gnu-objdump`·`iree-compile`(3.11.0rc20260316 @ `e4a3b04`,
저장소 기준 커밋과 동일)·`qemu-aarch64`·`qemu-system-aarch64` 전부 확인됨. 게스트는 부팅돼 있지
않으며 §3.4에서 부팅한다.

WGAN의 x86-64 계약(`results/e46_wgan/build/wgan.contract.json`)이 이미 있다 — AArch64 계약과의
대조 기준선이다: `bounded_bytes=135666432` = `static_per_call_bytes=131382784` +
`module_resident_constant_bytes=4283648`, `static_external_input_bytes=602112`,
`static_external_output_bytes=602112`, entry `infer(tensor<1x3x224x224xf32>) ->
tensor<1x3x224x224xf32>`(NCHW 양쪽), `bound_method=static_from_stream_layout`, 오버라이드 0.

입력 fixture(`results/e46_wgan/cell/fixture/manifest.json`, 11샘플 = 실이미지 9 + 경계 2)는
`.npy` 배열이 저장소에 vendored돼 있지 않다는 E46의 관례(합성·seed 재생성과 같은 이유는 아니고,
실제로는 소스 jpeg 9장이 `results/e46_wgan/inputs/`에 vendored돼 있어 결정적으로 재생성된다)를
따라 **이 세션에서 이미 `harness/model_fixture.py`로 재생성**했고, 재생성된 manifest.json이 커밋된
것과 **JSON 전체 동일**(diff 0), 22개 배열 전부 매니페스트의 sha256과 일치함을 확인했다(이 자체는
계약값·판정에 영향이 없는 준비 작업이므로 별도 실험으로 등록하지 않는다).

## §2 셀 — **측정 전 고정** (검토서 §7.2의 7단계를 그대로 따른다)

| 단계 | 셀 | 내용 | 산출물 |
|---|---|---|---|
| 1 | `build/aarch64` | 같은 `wgan.mlir`(x86-64와 동일 소스, one-invocation) → AArch64 vmfb + dump + layout IR, **한 번의 `iree-compile`** | `wgan.vmfb`, `dump/`, `wgan.layout_ir.txt`, `wgan.contract.json`, `contract_gen.wgan.h` |
| 2 | ledger | `harness/e49_alloc_ledger.py`로 I·O·T·C를 계약값과 대조(새 모델 목록에 추가하는 것이 아니라 그 도구가 이미 값으로 모델을 받는지 먼저 확인, D65 회피) | `ledger.json` |
| 3 | native | qemu-user AArch64에서 11샘플 실행, 원본 TFLite oracle(E46 x86-64 실행에서 이미 계산된 값을 **재사용**, 재계산 안 함)과 원소별 대조(기준 E25→E31→…→E46 무변경 승계: `abs<=1e-4` OR `rel<=1e-5`) | `comparison_native_aarch64.json` |
| 4 | `cfs_B` | cFS AArch64 게스트, 런타임 예산 오버라이드(`AI_LEARNER_BUDGET_OVERRIDE`, E36이 이미 배선) = `bounded` = 135,666,432 → ADMIT·완주, 전체 출력을 native와 같은 기준으로 대조 | raw log + `comparison_cfs_aarch64.json` |
| 5 | `cfs_Bm1` | 같은 게스트, 예산 = `bounded − 1` = 135,666,431 → NOT_ADMITTED·추론 0·cFS 잔여 기능 생존(로그로 확인) | raw log |
| 6 | HAL 대조 | `cfs_B`의 관측 HAL peak를 계약의 **같은 회계 영역**(무조건 계층이므로 `bounded_bytes`)과 대조 | `summary.json`에 기록 |
| 7 | 구성 비교 | x86-64 vs AArch64: 계약 세 수치·`bound_method`·상수 신뢰 상태·판정을 표로 기록(비트 동일성 요구 안 함) | `summary.json` |

**미리 정한 제약**:
- `native/cfs_app/ai_learner.c`·`native_learner.c`는 **수정하지 않는다** — D75(`static yv[]`)는
  이미 병합돼 모델과 무관하게 적용되고, 두 실행기의 출력 arity 처리는 E36b에서 이미 `--contract`
  값으로 일반화됐다(D62). 이 실험이 그 코드를 건드려야 하면 그 자체가 결함 재현이고 별도로 기록한다.
- `e32_native_aarch64.py`·`e32_cfs_outputs.py`는 **값으로만** 호출한다(새 모델별 분기 0줄,
  E36b의 완료 기준을 그대로 승계).
- **새 하네스는 요약 생성기 하나만**(`harness/mk_e53_summary.py`, E36b/E38/E48의 관례와 동일 —
  각 실험이 자기 raw material을 판정으로 접는 스크립트를 새로 갖는 것은 "새 하네스 0개" 규율이
  가리키는 실행기 재사용과 별개다).
- 보관 계약 재생성 없음, 계약 스키마 변경 없음.

## §3 판정 기준 — **측정 전 고정**

| 질문 | PASS 조건 |
|---|---|
| Q1 계약 생성 | 한 번의 `iree-compile` · 오버라이드 0 · 구조적 추출기 크로스체크 통과 |
| Q2 원장 일치 | ledger의 I·O·T·C가 계약값과 **일치** (E49의 4모델과 같은 방법) |
| Q3 native 의미 동치 | 11샘플 전 원소가 사전 고정 기준(OR 규칙) 만족 |
| Q4 예산 경계 | `cfs_Bm1` = NOT_ADMITTED·추론 0·cFS 생존, `cfs_B` = ADMIT·완주 |
| Q5 HAL 대조 | `cfs_B`의 HAL peak ≤ `bounded_bytes`(soundness), 값을 그대로 기록(tightness는 관찰만) |
| Q6 구성 비교 | 계약 세 수치·판정을 x86-64와 나란히 기록(같을 수도, 다를 수도 있다 — 미리 방향을 정하지 않는다) |

**완료 기준(검토서 그대로)**: Q1~Q6이 **하나의 추적 가능한 경로로 연결**돼야 한다 — 개별 PASS의
나열이 아니라, 계약 생성 → 원장 대조 → 의미 동치 → cFS 승인/거절 → 같은 회계 영역의 실행 관측이
서로를 참조하는 하나의 산출물(`summary.json`)에서 확인 가능해야 한다.

## §4 무엇이 이 실험을 반증하는가 (미리 적는다)

1. **AArch64 계약 세 수치가 x86-64와 다르다** → "계약값은 ISA 독립"이라는 관측이 이 모델에서
   깨진 것이다. 숨기지 않고 그대로 보고한다(§6 Q6이 이미 "다를 수도 있다"고 열어 둠).
2. **`cfs_Bm1`이 ADMIT되거나 추론이 1회라도 돈다** → 게이트의 fail-open(D52·D59와 같은 자리).
   즉시 결함으로 등록한다.
3. **`cfs_B`의 HAL peak가 `bounded_bytes`를 넘는다** → soundness 위반. E26 이래 관측 범위에서
   위반 0이었던 것이 이 모델에서 깨진 것이므로 원인을 규명하기 전에는 PASS로 적지 않는다.
4. **native와 cFS의 출력이 다르다**(같은 vmfb, 같은 입력) → 실행 경로 사이의 비결정성이거나
   버그이며, 판정을 유예하고 원인을 기록한다.
5. **e32_native_aarch64.py/e32_cfs_outputs.py에 새 모델별 분기가 필요하다** → 필요한 변경을
   정확히 기록하고 "값으로만" 확장했는지 diff로 보인다(E36b가 D62를 고친 방식 그대로).

## §5 결과별로 무엇을 쓸 것인가 — **미리 정한다**

- Q1~Q6 전부 PASS: *"AArch64 cFS에서 호출당 메모리가 기존 최대 사례의 14배인 실물 모델에 대해서도
  계약 생성·원장 대조·의미 동치·실행 전 예산 판정·같은 회계 영역의 실행 관측이 하나의 경로로
  연결됨을 확인했다."* 조건부 계층은 다루지 않았음을 명시한다.
- Q3만 실패(레이아웃/수치): E31·E45·E46의 관례대로 FAIL을 그대로 보고하고 원인을 조사하되,
  기준을 결과에 맞춰 바꾸지 않는다(D74).
- Q5에서 soundness 위반: 판정을 PASS로 적지 않고 결함으로 등록, 원인 규명 전까지 "미해결"로 남긴다.
- 하나라도 결함으로 밝혀지면: 수정 후 양방향 revert-and-confirm-fail로 확인한다.

## §6 산출물

```
results/e53_wgan_aarch64/
  build/aarch64/         wgan.vmfb · dump/ · wgan.layout_ir.txt · wgan.contract.json · contract_gen.wgan.h
  ledger.json             harness/e49_alloc_ledger.py 출력
  native/                 qemu-user 실행 raw output + comparison_native_aarch64.json
  cfs/                    cfs_B.log · cfs_Bm1.log
  comparison_cfs_aarch64.json
  summary.json            Q1~Q6 판정 + x86-64/AArch64 구성 비교표
docs/EVIDENCE_v0.56_E53.md
```

회귀: 보관 14개 계약 diff 0, `contract_negative_tests.py` 전건 유지, 기존 21개 계약(WGAN x86-64
포함) diff 0.
