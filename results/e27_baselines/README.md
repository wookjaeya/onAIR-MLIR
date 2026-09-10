# E27 기준선 — 실물 근거

`docs/plans/E27_mlir_contribution.md`의 사전 관측을 재현하기 위한 산출물이다.
**E27 본 실험은 아직 수행되지 않았다** — 여기 있는 것은 그 설계를 바꾼 검증된 관측이다.

## `iree310_mlp16k/`

IREE **3.10.0rc20260107**로 컴파일한 mlp16k(9→16384→2). 이 저장소의 기준 컴파일러는
3.11.0rc20260316이므로, **컴파일러 버전 드리프트** 조건을 실물로 보존한 것이다.

| 파일 | 무엇 |
|---|---|
| `mlp16k.vmfb` | 3.10 산출물 (734,459 B) |
| `mlp16k.layout_ir.txt` | 같은 호출의 `--mlir-print-ir-after=iree-stream-layout-slices` |
| `elf.json` | `elf_stack_frame.py` 출력 |
| `dump/` | 같은 호출의 `--iree-hal-dump-executable-files-to` |

### 이 fixture로 확인된 것

| 분석기 | 결과 |
|---|---|
| `harness/e27_baseline_vmfb_only.py` (아티팩트만) | `b2_bounded = 5,172` — **152배 과소**, 그리고 `alloca_unresolved = []`로 **문제 없음이라 보고** |
| 이 저장소의 MLIR 경로 (`make_contract.py`) | `bounded = 786,476` / `per_call = 65,580` / `constants = 720,896` — **정확**, `constants_confirmation_state = confirmed`, `iree-dump-module` 디스어셈블 실패는 note로 기록 |

b2가 틀리는 이유는 VM 바이트코드 **디스어셈블리**에서 `hal.device.queue.alloca`를 읽는데
그 디스어셈블이 바이트코드 버전 경계(모듈 16.0 / 런타임 17.0)를 넘지 못하기 때문이다.
그런데 b2에는 **"할당이 없다"와 "할당을 읽지 못했다"를 구분할 방법이 없다** — 이 저장소가
D25·D28·D29에서 세 번 고친 바로 그 실패 양식이며, 여기서는 **조용히** 일어난다.

**주의**: 3.10 vmfb는 다른 컴파일이므로 그 산출물의 "정답"이 3.11의 786,476과 같다고 단정할
근거는 없다. 확실한 것은 **9→16384→2 MLP의 은닉층만 65,536 B라서 per-call 36 B는 불가능**하며,
b2가 그것을 아무 경고 없이 내놓았다는 사실이다.
