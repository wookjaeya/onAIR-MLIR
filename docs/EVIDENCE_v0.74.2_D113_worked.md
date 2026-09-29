# EVIDENCE v0.74.2 — D113 기록 확장: DeepAE 추출 예시와 subview 봉쇄 검사의 범위

**경위**: v31 원고 독립 메타리뷰 §5가 *"실제 layout의 어떤 owning allocation을 어떤 이유로 $I,O,T,C$에 넣었는지 한 사례를 따라갈 수 있게"* 해 달라고
권했다. 원고 v32는 III.C에 DeepAE 한 문장을 넣는다. 그 문장의 수치 중 **4,128 B(중간 텐서 합계)와 subview 19개는 저장소 어떤 기록에도 없었다** —
명세의 `transient_slice_sum_diagnostic`은 post-layout print에 pack op이 없어 0이다. 사실 조사의 적대적 검증이 이를 지적했다(D100 계열: 원자료 없는 수치가 판정 문장에 살면 안 된다).
**평가 수치·판정 불변.**

## 1. 기록

`harness/manuscript_evidence_records.py::worked_extraction_deepae()`가 평가 명세(`results/e65_producer_check/reissued/b3_deepae/`)가 가리키는 **보관 AArch64 layout 표현**
(`results/e36b_aarch64_models/b3_deepae/b3_deepae.layout_ir.txt`, sha256 `e566350a…` = 명세의 `layout_ir_sha256`)에서 **명세 필드를 쓰지 않고** 다시 유도한다.

| 항목 | 유도값 | 명세와 일치 |
|---|---|---|
| 엔트리 입력 import | [2,560] | $I$ ✔ |
| 엔트리 external alloca | [2,560] | $O$ ✔ |
| 엔트리 transient alloca | [1,088] | $T$ ✔ |
| transient slab 쓰기 | 9개, 합계 4,128 B, 오프셋 {0, 64, 512, 576}, 전부 slab 안 | — |
| 초기화 영역 packed composite | [1,063,424] | $C$ ✔ |
| 초기화 영역 constant subview / 엔트리 subview | 19 / 0 | — |
| `try_map` + `scf.if %did_map` + copy 분기 `alloc` | 있음 | — |

## 2. subview 봉쇄 검사의 범위 (원고 표 정정)

원고 표 `tab:extract`의 subview 행은 *"Containment checked"*라고만 적었다. 두 추출기의 봉쇄 검사는 **엔트리 본문에서만** 돈다(`static_mem_bound.py`, `mlir_alloc_walk.py`의
엔트리 추출). 평가 네 엔트리에는 subview가 **없고**(ResNet 0/10 · DeepAE 0/19 · SmartCam 0/93 · WGAN 0/19, 엔트리/파일 전체), 전부 초기화 영역의 상수 블록 view다 —
그것은 할당하지 않으므로 상한에는 영향이 없다. 원고 v32는 그 행을 *"Containment checked in the entry"*로 좁힌다. 봉쇄 검사가 실제로 동작한 것은 두 출력 합성 모델의 엔트리다.

## 3. 가드

`d113/8`: 커밋 기록 = 재유도, 위 표의 값, 네 항목 명세 일치. 되돌림(합계를 4,127로 변조) → `d113/1`·`/8` FAIL.

## 4. 주장하지 않음

- 분석기가 map/copy 분기를 **해석**한다고 쓰지 않는다(D108). $C$는 packed composite 크기를 한 번 읽은 값이고, 두 분기가 한 SSA 값을 내는 것은 IR의 사실이다.
- 초기화 영역 subview의 봉쇄를 검사한다고 쓰지 않는다.
