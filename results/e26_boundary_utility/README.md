# E26 — 부분 메모리 계약 경계의 유용성

사전 고정 기준: **`docs/plans/E26_boundary_utility.md`** (측정 시작 전에 커밋됨).
판정 문서: `docs/EVIDENCE_v0.25_E26.md`(작성 예정).

```
instrumentation_check/          v0.22.2 — 계측 분리가 동작함을 확인한 실행 (측정 아님)
mlperf_tiny_resnet_fixture/     E26a/D47 — 실제 공개 CNN 실물 근거 (계약·헤더·ELF)
empty_label_rodata_fixture/     E26b/D48 — 빈 백틱 라벨 상수 세그먼트 실물 근거
x86_64/native/                  native_learner 실행 (모델 × 예산)
x86_64/cfs/                     실제 core-cpu1 기동 (모델 × 예산)
aarch64/native/                 qemu-user AArch64 실행
summary.json                    harness/e26_collect.py 출력 (사전 고정 기준 적용)
```

## 수집

```bash
python3 harness/e26_collect.py --root results/e26_boundary_utility --out results/e26_boundary_utility/summary.json
```

이 도구는 계획 §2의 기준을 그대로 적용한다 — Q1(`peak ≤ bounded`), Q3-i(unsafe admit),
Q2 분기 판정(`peak == per_call` 매핑 / `== per_call + constants` 할당 / 그 외 **가설 반증**).
지연값과 RSS는 등급이 다르므로 판정에 쓰지 않는다(작업 규율 4).

## 측정 위생

모든 실행은 `/cf/e25_inputs.bin` 부재 상태에서 이뤄지며, 앱이
`{"stage":"e25_mode","active":false}`로 **그 사실을 증언한다**. 증언이 없는 로그는
`e25_mode_proven_off: false`로 표시되며 판정에 쓰지 않는다.
