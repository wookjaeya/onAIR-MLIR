# E25 — 동일 canonical 모델의 계산 결과 동치 + cFS 내부 추론 경로 통합 (**PASS**)

계획과 **실행 전에 고정한 합격 기준**: `docs/plans/E25_same_model_equivalence.md`.
판정 근거: `docs/EVIDENCE_v0.22_E25.md` (**§11 정오표 · §12 E25b 필수 확인**).

> **주장 범위**(v0.22.1 정정): 이 실험이 보인 것은 *"고정한 canonical 모델과 64개 입력에 대해
> IREE Python, native C, cFS x86-64, cFS AArch64의 계산 결과가 사전 허용 오차 내에서 reference와
> 일치했고, 네 IREE 경로 사이에서는 비트 동일도 관측됐다"*는 것이다.
> **OnAIR 프레임워크 전체의 데이터 흐름 동치가 아니고**(플러그인은 여전히 외부 `weights.npz`
> 경로, cFS는 SB 수신·feature 변환을 거치지 않음), **메모리 soundness도 아니다**
> (`both_sound`는 E26 대상).

## 실행된 경로 (전부 완료)

| 경로 | 엔진 | 상태 | 출력 |
|---|---|---|---|
| NumPy reference | `x @ w0 @ w1` (`weights.npz`) | ✅ 기준 | `build/ref_numpy.npy` |
| IREE Python 바인딩 | pip `iree-base-runtime` (`iree.runtime`) | ✅ | `build/out_ireepy.npy` |
| native C | `native/native_learner.c`, IREE C 런타임 소스 빌드 | ✅ | `build/out_nativec.bin` |
| cFS 앱 x86-64 | `native/cfs_app/`, 실제 `core-cpu1` 기동 | ✅ | `build/out_cfs.bin` |
| **cFS AArch64 게스트** | 같은 앱, cortex-a53 크로스빌드, QEMU 게스트 | ✅ | `build/out_cfs_aarch64.bin`, `build/out_cfs_aarch64_run2.bin` |

## 판정

| 항목 | 결과 |
|---|---|
| reference 대비 | **512/512 원소** 통과 (경로당 128 = 입력 64 × 출력 2) |
| argmax | 경로당 **64/64** 일치 |
| IREE 경로 간 | **6쌍 전부 비트 동일** |
| AArch64 반복 실행 | **비트 동일**(결정적) |
| 계약값 (두 ISA) | `bounded=786476` / `per_call=65580` / `constants=720896` / `kernel_stack=16` 동일 |
| 아티팩트 | vmfb는 다름 — x86 `0e250c2f…`, AArch64 `4e5b2972…` (`invocation.json`이 같은 canonical source·weight에서 나왔음을 연결) |

- 판정 파일: `build/comparison_all.json`(원본, E25 시점) 및
  `build/comparison_all.pairrule.json`(E25b의 쌍별 규칙으로 재판정 — **판정·`vs_reference`·
  `argmax` 전부 불변**).
- 네 경로 모두 **모든 게이트를 통과한 뒤** 이 수치를 냈다. cFS는 실제 기동으로
  stack → admission ADMIT(bounded 786,476 ≤ budget 786,477) → binding MATCH → 64/64 추론
  순으로 진행했다(`build/cfs_run_excerpt.jsonl`, `build/cfs_aarch64_run_excerpt.jsonl`).
  순수 추론 하네스가 아니라 실제 배포 경로다.
- **AArch64가 다른 vmfb인데도 비트 동일한 것은 계획이 예상하지 않은 결과이며 일반화하지 않는다.**
  원인은 확인하지 않았다(v0.22.1 정정: "같은 누산 순서" 서술 철회 — 관측한 것은 출력 바이트뿐).

### 왜 "abs 또는 rel"이어야 했는지 (실측)

| regime | 출력 크기 | abs 기준만 | rel 기준만 | 둘 중 하나 |
|---|---|---|---|---|
| telemetry | ~1.3e9 | **1/64** | 64/64 | 64/64 |
| normalized | ~12 | 64/64 | **59/64** | 64/64 |

어느 한 기준만 요구했어도 정직한 결과가 FAIL이 됐다. 보고서가
`would_pass_abs_only` / `would_pass_rel_only`를 함께 기록해 이 설계가 사후 합리화가 아님을
감사 가능하게 한다.

### 판정 규칙 (E25b)

쌍마다 **적재한 아티팩트 sha256으로 규칙을 선택**한다 — 같은 vmfb면 비트 동일 필수(이 실험의
핵심 주장), 다른 vmfb면 사전 tolerance + argmax 일치. 모든 `--path`에 `--vmfb`가 필수이며
누락되면 거부하고 아무 파일도 쓰지 않는다. 자세한 배경과 과잉 거부 재현은 EVIDENCE §12.

## 환경 실패 기록

`aarch64_env/BOOT_LOG.md` — 부팅 시도 3회의 이력, 디스크·fstab 수정, 보존된 산출물 대조표,
그리고 시도 2의 시리얼 로그가 복구 불가한 이유. **의미 동치 결과와 분리해** 기록한다.

## 재현

```bash
python3 harness/gen_model_canonical.py --outdir results/e25_equivalence/model   # 결정적(seed 20260909)
# invocation.json의 compile_argv(x86-64 / aarch64)로 각각 한 번씩 컴파일 → 계약·헤더
cd native && bash build.sh <contract.json> e25
./native_learner_e25 <vmfb> 1048576 3 inputs.bin out_nativec.bin
python3 harness/gen_contract_header.py <contract.json> native/cfs_app/fsw/src/contract_gen.h
MODEL_VMFB=<x86 vmfb>     bash scripts/50_wire_cfs_ai_learner.sh                       # x86-64 cFS
MODEL_VMFB=<aarch64 vmfb> bash scripts/51_build_cfs_aarch64.sh ... canonical_e25       # AArch64 cFS
# 각 exe 트리의 cf/에 e25_inputs.bin을 두고 core-cpu1 기동 → cf/e25_outputs.bin
git checkout native/cfs_app/fsw/src/contract_gen.h    # 저장소 기본 헤더 원복

X=$(python3 -c "import json;print(json.load(open('results/e25_equivalence/build/model_canonical.contract.json'))['artifact']['sha256'])")
A=$(python3 -c "import json;print(json.load(open('results/e25_equivalence/aarch64/model_canonical.aarch64.contract.json'))['artifact']['sha256'])")
python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \
  --reference build/ref_numpy.npy \
  --path ireepy=build/out_ireepy.npy        --vmfb ireepy=$X \
  --path nativec=build/out_nativec.bin      --vmfb nativec=$X \
  --path cfs_x86=build/out_cfs.bin          --vmfb cfs_x86=$X \
  --path cfs_aarch64=build/out_cfs_aarch64.bin --vmfb cfs_aarch64=$A \
  --out build/comparison_all.pairrule.json
```
