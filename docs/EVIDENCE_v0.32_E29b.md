# EVIDENCE v0.32 — E29b: 조건부 계약의 검증 논리 수정 (D54 — 시험이 결함을 고정하고 있었다)

**실험 ID**: E29b · **결함**: D54 · **플랫폼 등급**: `FUNCTIONAL_ONLY`(지연값 인용 없음; 이 문서의
수치는 전부 결정론적 HAL 통계·계약 수치) · **날짜**: 2026-09-10
**계기**: 일곱 번째 외부 검토 `docs/reviews/ONAIR_MLIR_RESEARCH_CONSOLIDATED_REVIEW_20260909.md`
§4.1·§4.2 (P0 "E29b")
**산출물**: `results/e29b_conditional_verify/` · **도구 변경**: `native/native_learner.c`,
`native/cfs_app/fsw/src/ai_learner.c`, `harness/contract_negative_tests.py`

---

## 0. 판정

검토서 §4.1의 지적은 **코드를 읽고 예측한 fail-open**이었고, **실물로 재현됐다.** E29가 출하한
조건부 admission의 사후 검증 `hal_peak_after_append > CONTRACT_PER_CALL_BYTES`는 copy 분기가
정확히 `constants`만큼 할당한다는 사실 때문에 **`constants < per_call`인 모든 모델을 통과**시킨다.
앱은 그 분기를 스스로 `copy`라고 기록해 놓고도 실행했고, 승인 근거 예산의 **131%**에서 완주했으며,
`peak_within_bounded`는 `true`였다.

보관된 계약 21개가 **전부 `constants > per_call`**(가장 가까운 b2_resnet이 24 B 차이)이라 E29의
revert-and-confirm-fail은 이 조건을 한 번도 밟지 못했다. 게다가 **E29의 회귀 시험 자신이 그
비교식(`> CONTRACT_PER_CALL_BYTES`)의 존재를 pin하고 있었다** — 결함을 고정하는 시험이었다.

수정은 둘이며 둘 다 native·cFS 양방향으로 실측했다. 시험 **310/310 → 320/320**, 보관 계약 diff 0.

---

## 1. D54 — 무엇이 어떻게 뚫렸나

E29(§4)는 조건부 계층을 이렇게 설계했다: 예산이 `bounded`는 못 덮지만 `per_call`은 덮으면
`B_map = per_call`로 승인하고, **append 직후 HAL 피크를 읽어 전제조건을 검증**한다. 그 검증식이

```c
if (g.conditional_map && g.hal_peak_after_append > (long)CONTRACT_PER_CALL_BYTES) refuse;
```

였다. 그런데 E29 §2가 직접 측정한 대로 copy 분기의 append 직후 피크는 **정확히 `constants`**다.
따라서 `constants < per_call`이면 이 식은 거짓이고 앱은 계속 간다. 승인 근거는 `B_map = per_call`인데
실제 종료 피크는 `per_call + constants`다. **어느 숫자로 승인했는지와 어느 숫자로 검증하는지가
같아야 한다**(D53의 교훈)를 E29가 스스로 어겼다 — 승인은 "map 분기"를 전제했는데 검증은 "크기 비교"였다.

### 1.1 왜 E29가 못 봤나

| | per_call | constants | constants < per_call |
|---|---:|---:|---|
| 보관 계약 21개 전부 | — | — | **아니오** (b2_resnet: 309,416 vs 309,440, 24 B 차이) |
| **bigact (E29b 신규)** | **45,444** | **14,016** | **예** |

E29의 7모델 양방향 실측은 전부 `constants > per_call`이었으므로 copy 분기의 append 피크가 항상
`per_call`을 넘었고, 결함 검증식이 우연히 옳은 답을 냈다. **"과잉 거부 위험을 측정했다"는 주장이
어떤 입력 집합에서 측정했는지에 전적으로 의존한다**(D40)의 fail-open 쪽 판본이다.

### 1.2 실물 재현 — `bigact`

`harness/gen_model_conv2d.py --in-hw 32 --c1 8 --c2 4 --n-out 1 --seed 3`: 활성화가 크고 가중치가
작은 conv(1×32×32×1 → 30×30×8 → 28×28×4 → 1). **한 번의 `iree-compile` 호출**(작업 규율 7,
`results/e29b_conditional_verify/invocation.json`), 오버라이드 0개, 구조적 크로스체크 일치.

| 셀 | admission | append 직후 | 분기 | 종료 피크 | 추론 |
|---|---|---:|---|---:|---:|
| native, 정렬, 예산 = bounded 59,460 | ADMIT | 0 | map | 45,444 | 3/3 |
| native, shim(copy), 예산 = bounded | ADMIT | 14,016 | copy | 59,460 | 3/3 |
| **native, shim + 조건부, 예산 = per_call 45,444** | ADMIT_CONDITIONAL_MAP | 14,016 (< 45,444 → 통과) | **copy** | **59,460** | **3/3** |
| **cFS x86-64, shim + 조건부, 예산 = 45,444 (수정 전 소스)** | ADMIT_CONDITIONAL_MAP | 14,016 | **copy** | **59,460** | **5/5** |

두 fail-open 셀 모두 `peak_within_bounded: true`다 — 그 필드는 `bounded`(59,460)와 비교하지
승인 예산(45,444)과 비교하지 않는다. 원자료: `native/native_before_fix_D54_*.jsonl`,
`cfs/bigact_before_fix_condmap_shim_FAILOPEN.log`(수정 전 `ai_learner.c`를 cFS 트리에 직접 넣고 빌드,
`MAP_PRECONDITION_UNMET` 문자열 0개 확인).

---

## 2. 수정 — 두 검사, 두 C 경로

### 2.1 append **전** 전제조건 검사 (검토서 §4.2 선택지 1)

E29의 D2(map ⟺ 64바이트 정렬, 64/64 위반 0)는 **append 전에** 분기를 확정할 수 있다는 뜻이다.
앱은 이미지를 자기 손으로 할당하므로 그 포인터의 정렬을 안다. 조건부 모드에서
`module_ptr_mod64 != 0`이면 **런타임 인스턴스를 만들기도 전에** 거부한다
(`MAP_PRECONDITION_UNMET`). 검토서 §4.2가 우려한 "거부 전 `B_copy`만큼의 일시 할당"은 이 경로에서
**발생하지 않는다** — copy 분기의 상수 블록 할당 자체가 일어나지 않는다.

### 2.2 append **후** 검증을 크기 비교가 아니라 분기 판정으로

`B_map`은 map 분기에서만 성립하고, map 분기의 append 직후 피크는 **정확히 0**이다(E29 32/32).
따라서 검증은 `hal_peak_after_append != 0 → 거부`다. `copy`든 `other`든 전부 거부한다.

```c
if (g.conditional_map && g.module_ptr_mod64 != 0) { /* before runtime creation */ refuse; }
...append...
if (g.conditional_map && g.hal_peak_after_append != 0) { /* map arm or refuse */ refuse; }
```

### 2.3 수정 후 실측

| 셀 | 결과 |
|---|---|
| native, shim + 조건부, 45,444 | `MAP_PRECONDITION_UNMET` — **런타임 생성 전 거부**, rc=10, 추론 0 |
| cFS, shim + 조건부, 45,444 (수정 후 소스) | `MAP_PRECONDITION_UNMET` → cleanup 1 → `CFE_ES_ExitApp`, **추론 0**, cFS는 OPERATIONAL 진입·유지 |
| native, 정렬 + 조건부, 45,444 | ADMIT_CONDITIONAL_MAP, map, 종료 피크 **정확히 45,444**, 3/3 |
| cFS, 정렬 + 조건부, 45,444 | ADMIT_CONDITIONAL_MAP, map, 종료 피크 **정확히 45,444**, 5/5 |
| E29 회귀: b3_deepae 정렬 + 조건부 6,208 | 그대로 6,208, 완주 |
| E29 회귀: b3_deepae shim + 조건부 | 거부 — 이제 append 전(`UNMET`) |

**과잉 거부 0**: 정렬 셀은 native·cFS 모두 예산 = per_call에서 그대로 돈다.

---

## 3. 시험이 결함을 고정하고 있었다

`harness/contract_negative_tests.py`의 E29 그룹은

```python
"hal_peak_after_append > (long)CONTRACT_PER_CALL_BYTES" in src
```

를 "조건부 계층이 전제조건을 검증한다"의 근거로 pin하고 있었다. 수정을 넣자마자 그 시험 2건이
FAIL했고, 그것이 정확한 신호였다 — **시험이 지키던 것은 검증의 존재가 아니라 결함의 문자열**이었다.
그 assertion을 `!= 0`으로 바로잡고 이유를 주석으로 남겼다(삭제하지 않음).

E29b 그룹 10건 신설(fixture 성질·D54 산술·양방향 원자료·소스 수준 두 검사×두 파일·단일 호출
재생성 diff 0). revert-and-confirm-fail: `native_learner.c`의 비교식만 되돌리면 **2건 FAIL**
(E29 그룹 1 + E29b 그룹 1), 복원하면 전부 PASS. 이 컨테이너 **320/320**.

---

## 4. 검토서 §4.2 (`B_init` / `B_steady`)에 대한 답

검토서는 세 선택지를 제시했다. **선택지 1(append 전에 map 가능성 확정)을 채택**했고 그 근거가
E29의 D2다. 선택지 3(`B_init`에 `B_copy` 요구)은 채택하지 않았다 — 그러면 조건부 계층이 무의미해진다
(어차피 `B_copy` 예산이 필요하므로). 정직하게 남는 잔여: 정렬됐는데도 map이 실패하는 원인이
**이 세션에서 관측되지 않았을 뿐** 원리적으로 배제된 것은 아니다. 그 경우 §2.2의 append 후 검증이
잡지만 `B_copy`까지의 일시 할당은 이미 발생한다. 즉 **`B_init = B_map`은 정렬 전제조건 아래에서
성립하고, 그 전제조건은 append 전에 앱이 직접 확인한다**가 정확한 진술이다.

---

## 5. 주장하지 않는 것

- append 후 검증(§2.2)이 **정렬된 이미지에서 실제로 발동한 적** — 없다. 64/64에서 정렬 ⟹ map이라
  관측 가능한 copy 사례는 전부 append 전 검사가 먼저 잡는다. §2.2는 defense in depth다.
- AArch64 게스트 cFS 셀 — 미실행.
- `constants < per_call`이 실물 모델에서 흔하다/드물다는 어떤 주장도 — bigact는 합성 모델이다.
  검토서 §5의 실물 모델(SmartCam·WGAN)이 어느 쪽인지는 반입 후에야 안다.
- 지연·WCET(`FUNCTIONAL_ONLY`).

---

## 6. 재현

```bash
python3 harness/contract_negative_tests.py            # 320/320 (이 컨테이너)
# fixture 재생성(단일 호출 산출물에서): 시험이 매번 수행 — make_contract.py → 수치 diff 0
gcc -shared -fPIC -o /tmp/e29_nopm.so harness/e29_no_posix_memalign.c
cd native && bash build.sh ../results/e29b_conditional_verify/bigact.contract.json bigact
LD_PRELOAD=/tmp/e29_nopm.so ONAIR_CONDITIONAL_MAP=1 ./native_learner_bigact ../results/e29b_conditional_verify/bigact.vmfb 45444 3   # rc=10, UNMET
ONAIR_CONDITIONAL_MAP=1 ./native_learner_bigact ../results/e29b_conditional_verify/bigact.vmfb 45444 3                             # 45,444, ok
```
