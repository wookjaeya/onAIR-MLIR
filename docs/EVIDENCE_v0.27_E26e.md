# EVIDENCE v0.27 — E26e: E26-ext, 실물 MLPerf Tiny CNN에서의 계약 경계

- 실험 ID: **E26e**
- 날짜: 2026-09-09
- 층: **E26-ext**(`docs/plans/E26_boundary_utility.md` §0.1) — coverage와 외적 타당성을 보고한다.
  **E26의 판정(v0.25)을 바꾸지 않는다.**
- 플랫폼 등급: **결정론적**(HAL 할당자 통계, 계약 수치). 지연값은 인용하지 않는다.
- 산출물: `results/e26_boundary_utility/x86_64/ext_b2_resnet/`

## 0. 판정

**E26-core의 결과가 실물 워크로드에서 그대로 재현된다.** B0(합성 4모델)에서 얻은 세 결론이
MLPerf Tiny ResNet(CIFAR-10, 원본 `pretrainedResnet.tflite` 318,144 B, 16 dispatch)에서
모두 성립했다.

| 질문 | B0(E26-core) | B2 ResNet(여기) |
|---|---|---|
| Q1 `peak ≤ bounded` | 21셀 위반 0 | **4셀 위반 0** |
| Q2 분기 가설(`peak`는 `per_call` 또는 `per_call + constants`) | 37셀 반증 0 | **반증 0** |
| Q3 `B−1`→DENY, `B`·`B+1`→ADMIT | PASS | **PASS** |

## 1. 계약

| 항목 | 값 |
|---|---|
| `static_io_bytes` | 12,328 (입력 12,288 = 1×3×32×32×4, 출력 40) |
| `static_transient_bytes` | 297,088 |
| `static_per_call_bytes` | 309,416 |
| `module_resident_constant_bytes` | 309,440 |
| `bounded_bytes` | **618,856** |
| `dispatches` | 16 |
| `kernel_task_stack_bytes` | 368 (호출 체인 포함 439 — E26a/D47의 호출 해소) |
| 오버라이드 | **0개** |

## 2. 핵심 관측 — 같은 vmfb, 두 배포, 두 분기

같은 아티팩트를 두 런타임 배포에서 돌렸다.

| 배포 | HAL `device_bytes_peak` | 분기 | tightness (`bounded/peak`) |
|---|---|---|---|
| pip `iree.runtime` (local-sync) | **309,416** | `mapped` | **2.00×** |
| 소스 빌드 C 런타임 (`native_learner`) | **618,856** | `allocated` | **1.00×** |

차이 **309,440 B는 정확히 `module_resident_constant_bytes`**다. 즉 E26 §3이 규명한
`stream.resource.try_map` + `scf.if(%did_map)` 두 분기가 실물 CNN에서도 그대로 나타나고,
**어느 분기가 도는지는 모델이 아니라 런타임 배포가 정한다**는 E26의 결론이 재확인된다.
정적 계약은 두 분기의 최댓값이므로 **배포에 독립**이고, 그 대가가 여기서는 2배의 보수성이다.

## 3. Q3 — 예산 경계

| 예산 | 결과 |
|---|---|
| `bounded − 1` = 618,855 | **DENY** (`exit rc=3`, `reason=not admitted`, `cleanup_calls=0`) |
| `bounded` = 618,856 | ADMIT, 50회 추론, `cleanup_calls=1` |
| `bounded + 1` = 618,857 | ADMIT |
| 1 MiB | ADMIT |

## 4. 재현성 — 계약 수치는 안정적이고 아티팩트 동일성은 아니다

이 실험은 fixture가 vmfb를 보존하지 않아 **재컴파일해야 했고**, 그 과정에서 다음을 실측했다.

| 조건 | 관측 |
|---|---|
| ResNet, 스레딩 기본값, 3회 컴파일 | **매번 다른 vmfb sha256**(345,616 / 345,576 / 345,576 B) |
| ResNet, `--mlir-disable-threading`, 2회 | **동일**(343,064 B, sha `974dc14e…`) |
| 2-dispatch 소형 모델, 덤프·프린트 플래그 없이 2회 | **동일** |
| 같은 소형 모델, 덤프·프린트 플래그 포함 2회 | **서로 다름** |

**결론은 두 갈래이고 둘 다 중요하다.** (a) `iree-compile`은 이 구성에서 바이트 재현적이지
않다 — 작업 규율 7("한 번의 호출에서 생성")이 파일명 함정뿐 아니라 **이 이유로도** 필요하다.
(b) 그럼에도 **계약이 서명하는 메모리 수치는 전부 동일했다**: 새 호출의 계약은 fixture에
보관된 계약과 `bounded`·`per_call`·`constants`·`transient`·`io`·`dispatches`가 **모두 일치**하고
`artifact.bytes`/`sha256`만 다르다. 즉 흔들리는 것은 **아티팩트 동일성**이지 **경계 수치**가 아니다.

메커니즘은 "스레딩이 관여한다"까지만 확인했고 그 이상은 규명하지 않았다. 실무적 귀결은
하나다 — **측정에 쓴 vmfb는 저장소에 보존해야 한다. 레시피만으로는 되돌아오지 않는다.**

## 5. 방법론 결함 하나를 스스로 잡았다 (D50)

첫 pip 런타임 측정은 `peak = 309,576`을 냈고 저장소 분류기는 그것을
**`refutes_hypothesis`**로 판정했다 — B0 37셀에서 한 번도 나오지 않던 값이다. 원인은 모델이
아니라 **측정 방식**이었다: 반환된 출력 버퍼 5개를 리스트에 담아 두어 이전 호출의 40 B 출력이
해제되지 않았다(`309,416 + 4×40 = 309,576`). 호출마다 결과를 놓아주면(= `native_learner.c`가
하는 것) 피크는 **정확히 309,416**이고 `allocated == freed`다.

**HAL 통계는 관측자가 무엇을 붙들고 있는지에 반응한다.** E26이 이미 "HAL 통계는 프로세스
전역"이라는 같은 계열의 함정을 겪었고, 이것은 그 두 번째 얼굴이다. 하마터면 "실물 CNN이
분기 가설을 반증했다"는 틀린 헤드라인을 쓸 뻔했다.

## 6. 주장하지 않음

- **정확도** — CIFAR-10 평가 데이터셋 호스트가 이 환경에서 막혀 있어 Top-1은 재현하지 않았다.
  여기서 쓴 것은 가중치와 그래프 구조뿐이고, 답한 질문은 "메모리 계약이 성립하는가"다.
- **cFS 배포** — 이 모델의 cFS 셀은 돌리지 않았다. 두 배포(pip·native C)까지다.
- **B3(Deep AutoEncoder)** — 아직 fixture가 없다. 남은 ext 항목이다.
- **E26 판정 변경** — ext는 판정을 산출하지 않는다(§0.1).

## 7. 재현

```bash
# fixture의 MLIR은 컴파일 당시 basename이 b2_resnet_infer.mlir이었다(작업 규율 7: 심볼명에 들어간다)
cp results/e26_boundary_utility/mlperf_tiny_resnet_fixture/resnet.mlir /tmp/b2_resnet_infer.mlir
# 보존된 vmfb·layout IR·dump로 계약을 재생성한다(재컴파일하면 §4대로 아티팩트가 달라진다)
python3 harness/make_contract.py --mlir /tmp/b2_resnet_infer.mlir \
  --vmfb   results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.vmfb \
  --layout-ir results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.layout_ir.txt \
  --dump-dir  results/e26_boundary_utility/x86_64/ext_b2_resnet/dump \
  --triple x86_64-unknown-linux-gnu --cpu generic --model-name b2_resnet \
  --elf-analysis results/e26_boundary_utility/x86_64/ext_b2_resnet/b2.elf.json --out /tmp/b2.json
cd native && IREE_SRC=$HOME/onair-mlir-bench/ext/iree-src bash build.sh ../<contract> e26_b2resnet
./native/native_learner_e26_b2resnet <vmfb> 618856 50
```
