# E25 계획 — OnAIR↔cFS 동일 모델·의미 동치

- 상태: **계획 (실행 전)**. 이 문서는 **실험 전에** 합격 기준을 못박기 위한 것이다.
- 근거: 외부 검토 v0.19 §5.1 C2 / §7 E25, v0.20 §7-1. `CLAUDE.md` 우선순위 R-1.
- 규율: 이 문서의 §3(tolerance·pass 기준)은 **결과를 보기 전에 고정**한다. 결과를 본 뒤
  기준을 고르면 그 실험은 무효다.

## 1. 출발점 — 실측된 현황

지금 두 경로는 **서로 다른 모델을 실행한다.** 인터페이스만 같다.

| | OnAIR fixture (`plugins/compiled_learner/runtime/`) | cFS 배포 (E14 `mlp16k`) |
|---|---|---|
| 모델 이름 | `mlp_9x65536x2` | `mlp16k` |
| hidden | **65536** | **16384** |
| 가중치 | 외부 `weights.npz` (2,884,078 B) | **baked** (MLIR 상수) |
| `.vmfb` | 10,642 B (가중치 없음) | 733,979 B |
| 인터페이스 | [1,9] → [1,2] f32 | [1,9] → [1,2] f32 |

따라서 현재 근거로 할 수 있는 말은 *"OnAIR와 cFS에 각각 IREE 실행 경로를 구현했다"*이고,
*"동일한 OnAIR AI 모델을 cFS에 배포했다"*는 **근거를 넘어선다**
(`docs/EVIDENCE_v0.18_E23.md` §2가 이미 이렇게 기록했고, 위 표가 그 수치적 확인이다).

## 2. 설계 — 무엇을 통일하는가

**하나의 가중치 집합에서 baked MLIR과 `weights.npz`를 함께 생성한다.** 그러면 "같은 모델"이
정의상 보장되고, 남는 질문은 오직 "출력이 동치인가"가 된다.

```
                        canonical weights (한 번 생성, seed 고정)
                          |                         |
                  baked MLIR                    weights.npz
                          |                         |
                 한 번의 iree-compile               |
                          |                         |
              +-----------+-----------+             |
              |           |           |             |
        OnAIR-IREE    native C    cFS 앱        python_learner
        (compiled_    (native_    (ai_          (NumPy reference)
         learner)     learner)    learner)
```

- **reference**: `plugins/python_learner`가 이미 `weights.npz`로 NumPy 계산을 한다.
- **OnAIR-IREE / native C / cFS**: **같은 baked `.vmfb`** 하나를 공유한다. 이렇게 하면
  `weights.npz`는 reference 계산에만 쓰이고 배포 경로에는 들어가지 않는다 —
  검토가 지적한 "weights가 계약 밖에 있다"는 문제가 **배포 경로에서 사라진다**.
- 크기: hidden은 E14와 같은 **16384**를 쓴다(기존 계약·헤더·시나리오와 비교 가능).

## 3. 합격 기준 — **실행 전에 고정** (규율상 가장 중요한 절)

### 3.1 입력 집합

고정 seed로 생성한 `N = 64`개의 `[1, 9]` f32 입력 벡터. 저장소에 `inputs.npy`로 보존하고
sha256을 기록한다. 값 범위는 OnAIR CSV 예제의 실제 telemetry 범위를 따른다(§5에서 확정).

### 3.2 수치 tolerance

부동소수 재결합(reassociation)과 벡터화 차이로 **비트 동일은 기대하지 않는다.** 기준:

| 비교 쌍 | 기준 |
|---|---|
| NumPy reference ↔ 각 IREE 경로 | `abs_err <= 1e-4` **또는** `rel_err <= 1e-5` (원소별, 둘 중 하나 만족) |
| IREE 경로들 사이 (OnAIR-IREE / native C / cFS x86-64) | **비트 동일**(같은 vmfb·같은 런타임·같은 ISA) |
| cFS AArch64 ↔ x86-64 | `abs_err <= 1e-4` 또는 `rel_err <= 1e-5` |
| `argmax`(분류 결정) | **전 경로·전 입력에서 완전 일치** — 하나라도 다르면 FAIL |
| AArch64 반복 실행(동일 vmfb·입력·환경) | 출력 **결정성**을 별도로 기록(외부 지침 `E25_AARCH64_COMPLETION_GUIDELINE.md` §3에서 추가. AArch64 결과를 보기 전에 고정) |

`rel_err`는 `|a-b| / max(|a|,|b|, 1e-30)`로 정의한다. 두 기준 중 하나만 만족하면 통과로
보는 이유: 출력이 0 근처일 때 상대오차가 무의미해지고, 크기가 클 때 절대오차가 무의미해진다.

**IREE 경로들 사이에 비트 동일을 요구하는 것이 이 실험의 핵심 주장이다.** 같은 vmfb를
같은 런타임으로 돌리므로 다르면 그 자체가 결함이며, tolerance로 가려서는 안 된다.

### 3.3 통과 조건

1. 네 경로(reference / OnAIR-IREE / native C / cFS x86-64)가 **64/64 입력에서** §3.2를 만족
2. `argmax` 64/64 전 경로 일치
3. 모든 경로가 **같은 `.vmfb` sha256**을 로드했음을 각자 로그로 증명
4. 계약↔아티팩트 결속(크기→sha256)이 네 경로에서 전부 MATCH
5. AArch64 게스트 포함 — 환경(게스트 이미지·IREE AArch64 런타임·크로스 툴체인·qemu)이
   그대로 남아 있음을 확인해 재구축 없이 진행한다. x86-64 vmfb와는 **비트 동일이 성립하지
   않는다**(다른 ISA용 산출물이므로): 그 쌍만 §3.2의 tolerance로 판정하고, 같은 canonical
   source·weight에서 나왔음을 invocation 기록으로 연결한다.
6. **환경 실패와 의미 동치 실패를 같은 결과로 취급하지 않는다**(지침 §7). 실패 시
   빌드·배선·QEMU / 계약·binding / IREE 실행 / shape·dtype / 수치 오차 / argmax 순으로
   지점을 분류해 기록한다.

### 3.4 실패 시의 처리

기준 미달이면 **기준을 낮추지 않는다.** 원인을 규명해 결함으로 등록하거나, 주장 범위를
좁힌다(예: "x86-64 세 경로에서 동치, AArch64는 미검증"). 이 저장소가 D2·D3·D16·D17에서
해 온 방식과 같다.

## 4. 산출물

- `harness/gen_model_canonical.py` — 한 seed에서 baked MLIR + `weights.npz` + `inputs.npy`를
  함께 생성(세 파일의 sha256을 manifest에 기록)
- `results/e25_equivalence/` — 한 번의 `iree-compile` 호출 산출물 + 경로별 출력 JSON +
  비교표 + manifest
- `harness/e25_compare.py` — 경로별 출력을 §3.2 기준으로 대조, 통과/실패를 JSON으로 판정
- `docs/EVIDENCE_v0.22_E25.md`

## 5. 착수 전 확인해야 할 것

- OnAIR CSV 예제의 실제 telemetry 값 범위(§3.1의 입력 분포를 그것에 맞춘다)
- `characterize_baked.py::make_src`가 만드는 baked MLIR이 hidden=16384에서 `iree-compile`
  시간·메모리를 감당하는지(E14가 이미 했으므로 가능할 것으로 보이나 재확인)
- cFS 앱을 이 세션에서 재빌드할 수 있는지(cFS 빌드와 IREE C 런타임은 존재 확인됨)

## 6. 범위 밖 (명시)

- 성능·지연 비교 — `platform_check.py`가 `FUNCTIONAL_ONLY`인 한 하지 않는다
- 정확도(accuracy) 자체 — 이 실험은 **동치**를 보는 것이지 모델이 좋은지를 보지 않는다
- OnAIR 데이터 소스·플러그인 프레임워크의 다른 부분
