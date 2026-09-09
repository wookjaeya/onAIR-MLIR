# E25 — OnAIR↔cFS 동일 모델·의미 동치 (진행 중)

계획과 **실행 전에 고정한 합격 기준**: `docs/plans/E25_same_model_equivalence.md`.

## 지금까지 실행된 경로

| 경로 | 상태 | 출력 |
|---|---|---|
| NumPy reference (`x @ w0 @ w1`, `weights.npz`) | ✅ | `build/ref_numpy.npy` |
| OnAIR-IREE 엔진 (`iree.runtime` Python 바인딩) | ✅ | `build/out_ireepy.npy` |
| native C (`native/native_learner.c`, IREE C 런타임 소스 빌드) | ✅ | `build/out_nativec.bin` |
| cFS 앱 x86-64 (`native/cfs_app/`, 실제 `core-cpu1` 기동) | ✅ | `build/out_cfs.bin` |
| cFS AArch64 게스트 | ⏳ 미실행 | — |

## 판정 (`build/comparison.json`)

`harness/e25_compare.py`가 계획 §3.2 기준으로 판정한다. 현재 **PASS**:

- reference 대비 **세 IREE 경로 모두 128/128 원소 통과**(regime당 64), argmax 64/64 일치
- **세 경로가 서로 전부 비트 동일**: OnAIR-IREE ↔ native C ↔ cFS 앱. 세 경로는 IREE 런타임
  빌드가 서로 다르다(pip `iree-base-runtime` 바이너리 / 소스 빌드 최소 구성 / cFS 앱에
  링크된 같은 소스 빌드). 같은 vmfb에서 같은 비트가 나온다.
- 세 경로 모두 **모든 게이트를 통과한 뒤** 이 수치를 냈다. cFS는 실제 `core-cpu1`을 기동해
  stack → admission ADMIT(bounded 786476 ≤ budget 786477) → binding MATCH
  (artifact sha256 `0e250c2f16e704db`) → 64/64 추론 순으로 진행했다
  (`build/cfs_run_excerpt.jsonl`). 순수 추론 하네스가 아니라 실제 배포 경로다

### 왜 "abs 또는 rel"이어야 했는지 (실측)

| regime | 출력 크기 | abs 기준만 | rel 기준만 | 둘 중 하나 |
|---|---|---|---|---|
| telemetry | ~1.3e9 | **1/64** | 64/64 | 64/64 |
| normalized | ~12 | 64/64 | **59/64** | 64/64 |

어느 한 기준만 요구했어도 정직한 결과가 FAIL이 됐다. `comparison.json`은
`would_pass_abs_only` / `would_pass_rel_only`를 함께 기록해 이 설계가 사후 합리화가
아님을 감사 가능하게 한다.

## 재현

```bash
python3 harness/gen_model_canonical.py --outdir results/e25_equivalence/model   # 결정적(seed 20260909)
# invocation.json의 compile_argv로 한 번 컴파일 → 계약·헤더 생성
cd native && bash build.sh <contract.json> e25
./native_learner_e25 <vmfb> 1048576 3 inputs.bin out_nativec.bin
# cFS 경로: canonical 계약으로 헤더를 만들고 재배선·빌드한 뒤 입력을 /cf에 두고 기동
python3 harness/gen_contract_header.py <contract.json> native/cfs_app/fsw/src/contract_gen.h
MODEL_VMFB=<vmfb> bash scripts/50_wire_cfs_ai_learner.sh
cp inputs.bin $CFS_EXE/cf/e25_inputs.bin && (cd $CFS_EXE && ./core-cpu1)   # /cf/e25_outputs.bin 생성
git checkout native/cfs_app/fsw/src/contract_gen.h    # 저장소 기본 헤더 원복

python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \
  --reference build/ref_numpy.npy --path ireepy=build/out_ireepy.npy \
  --path nativec=build/out_nativec.bin --path cfs=build/out_cfs.bin \
  --out build/comparison.json
```
