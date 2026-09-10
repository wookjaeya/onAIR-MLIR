# MLPerf Tiny ResNet — 실물 근거 (E26a / D47)

이 디렉터리는 **결함 D47을 정당화한 실물 산출물**이다. "실제 공개 CNN에서는 dispatch가 컴파일러
생성 헬퍼를 호출한다"는 주장을 저장소 내용만으로 재현할 수 있게 보존한다 — E24c/D43이
`results/e24c_manyconst31/`로 확립한 관례를 그대로 따른다.

## 출처 (provenance)

| 항목 | 값 |
|---|---|
| 저장소 | `mlcommons/tiny` (Apache License 2.0) |
| 커밋 | `4addd0fa08d216e20637637874e084895f289da4` (검토 지침이 지정한 SHA, 실존 확인) |
| 원본 파일 | `benchmark/training/image_classification/trained_models/pretrainedResnet.tflite` |
| 원본 크기·해시 | 318,144 B, sha256 `b5c0046d6e0328b4956afd6baa29555a29b1f1c65bdd45aaed75b7cd484d9f79` |
| 벤치마크 | MLPerf Tiny Image Classification (CIFAR-10, 32×32×3, 10 클래스) |
| 조달 방법 | `git clone --depth 1 --filter=blob:none --no-checkout` + `git sparse-checkout` |

**정확도(Top-1)는 재현하지 않았다** — 평가 데이터셋 호스트가 이 환경에서 막혀 있다(§한계).
여기서 쓰는 것은 **가중치와 그래프 구조**뿐이며, 그것으로 답하는 질문은 "메모리 계약을 뽑을 수
있는가"이지 "정확도가 얼마인가"가 아니다.

## 반입 경로 (TensorFlow 없이)

`iree-import-tflite`는 이 컨테이너에서 쓸 수 없다 — 메타데이터에 선언돼 있지 않은
TensorFlow 전체를 요구하고, cp311 휠이 570~640 MB라 세션 디스크 규칙에 걸린다. 대신:

```
tflite2onnx (순수 파이썬: numpy/onnx/tflite만)      # .tflite -> .onnx (opset 11)
onnx: graph.name = "infer"                          # 'pre-alpha' 같은 비식별자 이름 정규화
iree-import-onnx --opset-version 17                 # 17 승격 필수(opset 11 Softmax는 legalize 실패)
iree-opt --pass-pipeline='builtin.module(
    torch-onnx-to-torch-backend-pipeline,
    torch-backend-to-linalg-on-tensors-backend-pipeline)'   # -> resnet.mlir (고정 산출물)
```

**이 사전 lowering이 핵심이다.** `iree-import-onnx`의 출력(torch-onnx dialect)을 그대로
컴파일하면 `$async` coarse-fence 래퍼가 12개 생기고 `iree.abi.declaration`이 0개라
`make_contract.py`의 세 게이트(ABI 반사 부재·구조적 크로스체크 파싱 실패·`interface` None)에
연쇄로 막힌다. 사전 lowering 후에는 이 저장소의 수기 linalg 모델과 **동형**이 되어
계약 도구를 한 줄도 고치지 않고 통과한다.

**작업 규율 7(one-invocation)은 지켜진다**: 전처리는 `.mlir` 입력 파일을 만들 뿐이고,
계약·layout IR·dump·vmfb는 보존된 `resnet.mlir` 하나에서 **한 번의 `iree-compile` 호출**로
나온다(`provenance.single_invocation = true`).

## 이 fixture가 드러낸 것 (D47)

`elf_stack_frame.py`의 분류 문구는 처음부터 *"resolve targets (imports/runtime) before
classifying"*이라고 적혀 있었지만 **그 해석 단계는 구현된 적이 없었다.** 호출 명령이 하나라도
있으면 bucket (3)/(4)로 분류됐고, `gen_contract_header.py`(E21/D22)가 그 분류를 "신뢰 불가"로
읽어 배치 가능한 헤더를 거부했다.

이 모델의 실측:

| 관측 | 값 |
|---|---|
| `total_call_insns` | **80** (전부 `infer_dispatch_15_softmax_10xf32_dispatch_tensor_store` 하나에서) |
| 서로 다른 call 타깃 | **2개** — `0x53c0`, `0x5440` |
| `.text` 범위 | `0x2e50`–`0x54fc` → **두 타깃 모두 내부** |
| `.plt` 섹션 | **없음** |
| `undefined_symbols` | **`[]`** |
| 두 헬퍼의 프레임 | **0 B**, 중첩 호출 0, leaf (`ret`만) |
| 실제 추가 스택 | 반환 주소 **8 B** |

즉 **진짜 미지의 스택이 아니라 분석기의 보수적 분류**였고, 정직한 모델을 거부하는
유형 (B) 결함(과잉 거부)이다. 기존 14개 계약과 E25 canonical은 전부 `total_call_insns = 0`이라
**합성 모델셋으로는 구조적으로 드러날 수 없었다** — 벤치마크 지침이 말하는 외적 타당성 문제의
구체적 실례다.

수정 후(E26a):

```
unresolved_call_insns = 0
distinct_targets      = ['0x53c0', '0x5440']
callees               = [{frame_bytes:0, invocation_stack_bytes:8, chain_stack_bytes:8}, ...]
max_dispatch_invocation_stack_bytes            = 439
max_dispatch_invocation_stack_bytes_with_calls = 439      (호출하는 softmax dispatch는 240 -> 248)
```

## 계약 수치

| 항목 | 값 |
|---|---|
| `bounded_bytes` | 618,856 |
| `static_per_call_bytes` | 309,416 (io 12,328 + transient 297,088) |
| `module_resident_constant_bytes` | 309,440 |
| dispatches | 16 |
| `kernel_task_stack_invocation_bytes` | 439 |
| artifact | 345,952 B, sha256 `b24e1523aa1ba37d…` |
| provenance | `single_invocation=true`, `overrides_applied=[]`, `verification_grade=verified` |
| 구조적 크로스체크 | `agrees_with_regex_parser=true` |

상수와 per-call이 거의 1:1(309,440 대 309,416)이라는 점은 기존 모델셋에 없던 구간이다
(E25 canonical은 720,896 대 65,580으로 11:1). R-2의 "계약 경계의 유용성" 논의에 직접 쓰인다.

## 파일

| 파일 | 무엇 |
|---|---|
| `resnet.mlir` | 사전 lowering된 linalg-on-tensors MLIR — **계약을 만든 그 입력** |
| `embedded_elf.so` | 그 컴파일이 만든 임베디드 ELF (26,928 B) |
| `embedded_elf.objdump.txt` | 위 ELF의 `objdump -d --no-show-raw-insn` |
| `resnet.elf.json` | `elf_stack_frame.py` 출력 (해석 결과 포함) |
| `resnet.contract.json` | `make_contract.py` 출력 (오버라이드 0개) |
| `resnet.h` | `gen_contract_header.py` 출력 (배치 가능: `BOUND_KNOWN=1`, `KERNEL_STACK_BYTES_KNOWN=1`) |

`vmfb`와 dump 디렉터리 전체는 보존하지 않았다(용량). 계약을 재생성하려면 `resnet.mlir`로
한 번 컴파일하면 되고, 그때 나오는 임베디드 ELF는 여기 보존된 것과 같아야 한다.

## 한계 (반드시 함께 인용)

- **정확도 미검증**: CIFAR-10 평가셋을 이 환경에서 받을 수 없다
  (`www.cs.toronto.edu`·`zenodo.org`·`huggingface.co` 전부 연결 거부, 직접 확인).
  따라서 이 모델로 *"MLPerf Tiny의 Top-1 기준을 만족한다"*고 쓰면 안 된다.
- 이 fixture는 **계약 생성 가능성과 스택 해석**의 근거이지 성능·정확도 근거가 아니다.
- `tflite2onnx`는 int8 텐서에 대해 미검증 경고를 낸다 — **f32 변종만** 사용했다
  (`pretrainedResnet.tflite`는 f32).
