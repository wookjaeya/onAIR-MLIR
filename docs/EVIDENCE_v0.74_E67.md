# EVIDENCE v0.74 — E67: 평가 리비전에서 IREE 자체 transient 크기 조회가 주는 것과 빠뜨리는 것

**경위**: v31 원고 독립 메타리뷰(2026-09-29, 저자 전달) §3이 *"가장 가까운 기존 기능과 비교하라"*고 요구했다 — ExecuTorch MethodMeta와
IREE의 transient 크기 조회·reflection metadata(`iree-stream-annotate-constant-transient-size`, `iree-stream-materialize-transient-size-queries`,
`samples/external_transients`). 검토자 자신이 *"평가에 쓴 리비전·옵션·모델에서 그 기능이 활성화됐는지, 같은 크기를 반환하는지는 확인하지 않았다"*고
적었으므로, 원고가 그 비교를 **관측으로** 적을 수 있게 평가 리비전에서 기록한다. **평가 수치·판정은 바뀌지 않는다.**

**순서의 정직성**: 이 값들은 먼저 검토 대응 사실 조사의 scratch 프로브에서 보였다(저장소 밖). 이 실험은 사전 등록이 아니라 **그 관측을 저장소 내용만으로
재현 가능하게 기록**하는 것이다. 판정 기준은 두 가지 사실(평가 아티팩트에 기능이 있는가, 켜면 무엇을 보고하는가)뿐이라 해석 여지가 없다.

## 1. 소스에서 확인한 것 (평가 리비전 `e4a3b04`, 로컬 체크아웃)

- 세 pass 모두 기본 파이프라인에 있다(`Dialect/Stream/Transforms/Passes.cpp:338-340, 374`). 그러나 `hal.tensor.transients`가 없으면 아무것도 하지 않는다
  (`EmplaceTransients.cpp:92-96`; `AnnotateConstantTransientSize`는 *"no-op if none of the functions exist"*). 세 pass의 설명은 **experimental**이다(`Passes.td:504-549`).
- 켜는 방법: 공개 엔트리에 `!hal.buffer {iree.abi.transients}` 인자를 **추가**(`Bindings/Native/Transforms/WrapEntryPoints.cpp:617-634`), 또는 torch 입력
  변환의 `--iree-torch-externalize-transients`(기본 false). linalg 입력용 플래그는 없다.
- 보고 대상: `EmplaceTransients`가 **transient 수명 alloca만** 호출자 저장소로 옮기고(`:158`), `MaterializeTransientSizeQueries`가 그 pack 총량을
  `<entry>_transients_size` 함수로 만들며, 상수로 접히면 `AnnotateConstantTransientSize`가 `iree.abi.transients.size.constant`를 기록한다.
  입력(import), 출력(external alloca), 상수·copy 분기 할당(initializer), 적재 분기 조건, 수명 전제는 대상이 아니다.
- 읽는 시점: 상수 reflection은 **모듈 적재만으로** 읽힌다(`vm/module.c:367-386`). 동적 크기 조회 함수는 VM context가 필요하고, context 생성은 모듈
  `__init`을 돌려 map/copy 분기가 이미 결정된 뒤다.

## 2. 측정 (`harness/e67_native_transient_query.py`, `results/e67_native_transient_query/summary.json`)

같은 컴파일러(3.11.0rc20260316 @ e4a3b04), 같은 AArch64 타깃 플래그(llvm-cpu · aarch64-unknown-linux-gnu · cortex-a53). 각 모델의 **평가 MLIR**(sha256이
명세 `model.sha256`과 일치)에서 `@infer`에 인자 하나만 추가해 컴파일하고 `iree-dump-module`로 읽었다. **실행하지 않았다.**

| 모델 | 평가 아티팩트 export | 평가 아티팩트 `transient` 언급 | opt-in 보고값 | 명세 $T$ | 다른 수치($I$·$O$·$C$·$P$·$B_u$)와 일치 |
|---|---|---|---|---|---|
| ResNet | `infer`, `__init` | 0 | 297,088 | 297,088 | 0 |
| DeepAE | `infer`, `__init` | 0 | 1,088 | 1,088 | 0 |
| SmartCam | `infer`, `__init` | 0 | 8,779,968 | 8,779,968 | 0 |
| WGAN | `infer`, `__init` | 0 | 130,178,560 | 130,178,560 | 0 |

opt-in 아티팩트의 `infer`는 인자가 둘이고 `infer_transients_size`가 추가로 export된다 — **엔트리 ABI가 평가 아티팩트와 다르다.**

## 3. 가드

| 가드 | 내용 | 되돌림 |
|---|---|---|
| `e67/1` | 네 모델·평가 리비전·모델/아티팩트 해시가 명세와 일치 | — |
| `e67/2` | 평가 아티팩트에 크기 조회·reflection 없음 | — |
| `e67/3` | opt-in 보고값 = 명세 $T$(명세에서 다시 읽음), 다른 수치와 불일치, 인자 2개 | 보고값을 6,208로 변조 → FAIL |
| `e67/4` | DeepAE 라이브 재유도 = 커밋 기록(도구 없으면 SKIP) | 같은 변조 → FAIL |

## 4. 수치

- 이 컨테이너: **1013/1013 + 2 SKIP → 1017/1017 + 2 SKIP**(새 파일을 스테이징한 뒤 실행). 보관 14개 계약 diff 0.

## 5. 주장하지 않음

- opt-in 아티팩트를 **실행하지 않았다**. 호출자가 준 저장소가 모자랄 때의 동작은 이 실험의 기록이 아니다(소스에는 크기 검증이 없다는 주석이 있고, 사실 조사의
  scratch 프로브는 qemu-user에서 거부 없이 넘치는 것을 보였지만 저장소 기록이 아니므로 원고에 쓰지 않는다).
- 동적 크기 조회 함수는 다루지 않았다(네 모델 모두 상수로 접힌다).
- 이 기능을 쓰면 transient 저장소가 호출자 메모리로 옮겨가 HAL 통계의 범위가 달라진다 — 평가 구성은 이 기능을 쓰지 않았다.
- ExecuTorch는 실행하지 않았다. 원고의 ExecuTorch 서술은 원고가 이미 인용하는 커밋(`df6147af`)의 `method_meta.h`·`memory_manager.h` 소스 판독이다.
