# E25 — OnAIR↔cFS 동일 모델·의미 동치 (진행 중)

계획과 **실행 전에 고정한 합격 기준**: `docs/plans/E25_same_model_equivalence.md`.

## 지금까지 실행된 경로

| 경로 | 상태 | 출력 |
|---|---|---|
| NumPy reference (`x @ w0 @ w1`, `weights.npz`) | ✅ | `build/ref_numpy.npy` |
| OnAIR-IREE 엔진 (`iree.runtime` Python 바인딩) | ✅ | `build/out_ireepy.npy` |
| native C (`native/native_learner.c`, IREE C 런타임 소스 빌드) | ✅ | `build/out_nativec.bin` |
| cFS 앱 (`native/cfs_app/`) | ⏳ 미실행 | — |
| cFS AArch64 게스트 | ⏳ 미실행 | — |

## 판정 (`build/comparison.json`)

`harness/e25_compare.py`가 계획 §3.2 기준으로 판정한다. 현재 **PASS**:

- reference 대비 두 IREE 경로 모두 **128/128 원소 통과**(regime당 64), argmax 64/64 일치
- **OnAIR-IREE ↔ native C: 비트 동일** — 서로 다른 IREE 런타임 빌드(pip 바이너리 vs
  소스 빌드 최소 구성)인데도 같은 vmfb에서 같은 비트가 나온다
- native C는 **모든 게이트를 통과한 뒤** 이 수치를 냈다(admission ADMIT, binding MATCH,
  artifact sha256 `0e250c2f16e704db`) — 순수 추론 하네스가 아니라 실제 배포 실행기다

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
python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \
  --reference build/ref_numpy.npy --path ireepy=build/out_ireepy.npy \
  --path nativec=build/out_nativec.bin --out build/comparison.json
```
