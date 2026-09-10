# EVIDENCE v0.31 — E29: 조건부 계약 (try_map 분기 결정 요인 규명·제어·검증)

**실험 ID**: E29 · **플랫폼 등급**: `FUNCTIONAL_ONLY`(이 컨테이너 — 지연값 인용 없음. 이 문서의
수치는 전부 결정론적 값: HAL 통계, 포인터 정렬, 계약 수치) · **날짜**: 2026-09-09
**산출물**: `results/e29_conditional_contract/`
**도구**: `harness/e29_align_probe.c`, `harness/e29_collect.py`, `harness/e29_no_posix_memalign.c`

---

## 1. 질문 — E26이 미확정으로 남긴 것

E26(`docs/EVIDENCE_v0.25_E26.md`)은 IREE가 모듈 상주 상수를
`stream.resource.try_map` + `scf.if(%did_map)`으로 감싼다는 것을 보관 layout IR 12개에서
확인했다. 성공 분기는 HAL 할당이 0, 실패 분기는 상수 전체를 할당한다. 따라서
`bounded = per_call + constants`는 **두 분기의 최댓값**이고, soundness는 구조적으로
성립하며 tightness만 분기의 함수다.

E26은 같은 vmfb가 배포에 따라 서로 다른 분기를 타는 것을 실측했고(core 최대 45.50×,
E26e 2.00× vs 1.00×, E26f **172.30×**), 결정 요인 후보 네 가지를 실측으로 배제한 뒤
**미확정으로 남겼다**. 네 번째 외부 검토가 이 항목을 "조건부 계약(`B_map`/`B_copy`)"이라는
이름으로 새 핵심 기여 후보로 지목했고, 이 저장소의 착수 순위표
(`docs/ASSUMPTIONS_AND_SCOPE.md`)도 **최우선** 세 축 중 하나로 올려 두었다.

E29가 묻는 것은 둘이다.

- **Q-A**: 분기를 정하는 것이 무엇인가?
- **Q-B**: 그것을 배포가 제어할 수 있는가 — 그리고 제어했을 때 계약을 어떻게 읽어야
  fail-open이 생기지 않는가?

---

## 2. Q-A — 결정 요인은 모듈 이미지 포인터의 64바이트 정렬이다

### 2.1 IREE 소스의 근거

`runtime/src/iree/hal/buffer_heap.c`의 `iree_hal_heap_buffer_wrap()`:

```c
if (!iree_any_bit_set(allowed_access, IREE_HAL_MEMORY_ACCESS_UNALIGNED) &&
    !iree_host_size_has_alignment((uintptr_t)data.data,
                                  IREE_HAL_HEAP_BUFFER_ALIGNMENT)) {
  return iree_make_status(IREE_STATUS_OUT_OF_RANGE,
      "imported heap buffer data must be aligned to %d; got %p", ...);
}
```

`IREE_HAL_HEAP_BUFFER_ALIGNMENT`는 `runtime/src/iree/base/config.h:244`에서 **64**다.
map 분기가 하는 일이 정확히 이 import이므로, 모듈 이미지가 놓인 주소가 64로 나누어떨어지지
않으면 wrap이 `OUT_OF_RANGE`를 내고 `%did_map`이 거짓이 되어 copy 분기가 실행된다.
(IREE 커밋 `e4a3b0405d7d23554da26403658d0e8c3c5ecf25`, 3.11.0rc20260316 — 이 저장소 기준 커밋.)

### 2.2 실측 — 8모델 × 8 정렬 클래스 = 64셀

`harness/e29_align_probe.c`는 **같은 파일 바이트**를 (페이지 정렬 기준 + delta) 위치에
적재하고, `append_bytecode_module` **직후**의 HAL 피크를 읽는다. 이 시점에는 입력 버퍼도
추론도 없으므로 그 수치는 상수 블록 단독이다. 판정 기준은 측정 전에 고정했다.

- **D1(이분성)**: 성공한 모든 append는 피크가 `0`(map) 또는 정확히 `계약 constants`(copy)
  둘 중 하나여야 한다. **제3의 값이 나오면 두 분기 모델 자체가 반증된다**(부분 매핑 등).
- **D2(결정 요인)**: map 분기 ⟺ 포인터가 64바이트 정렬.

| | 결과 |
|---|---|
| 셀 | 64 (8모델 × delta {0,8,16,32,64,128,136,192}) |
| 채점 가능 | 64 (append 실패 0) |
| 분기 | **map 32 · copy 32 · OTHER 0** |
| D1 | **성립** (위반 0) |
| D2 | **성립** (위반 0) |

원자료: `results/e29_conditional_contract/align_sweep.json`.
재현: `IREE_SRC=… python3 harness/e29_collect.py`.

**부수 관측(분기가 아니다)**: delta가 8의 배수가 아니면 HAL에 닿기 전에 FlatBuffer
검증기가 `buffer header not aligned`로 모듈 자체를 거부한다. 이것은 세 번째 분기가 아니라
적재 실패이며, 위 스윕은 8의 배수만 쓴다.

---

## 3. Q-B — 배포가 제어할 수 있다

`native_learner.c`와 `ai_learner.c`는 둘 다 모듈 blob을 자기 손으로 `malloc`한다.
glibc가 이 크기대에 돌려주는 포인터는 이 컨테이너에서 **16 또는 32 mod 64**였고, 그래서
E26·E26e·E26f의 native·cFS 셀이 **전부** copy 분기를 탔다. 한 줄이면 바뀐다:

```c
static void* alloc_module_image(size_t n, int* out_mod64) {
  void* p = NULL;
  if (posix_memalign(&p, 64, n) != 0) p = NULL;
  if (!p) p = malloc(n);                 /* 올바르되 덜 tight한 폴백 */
  *out_mod64 = p ? (int)(((uintptr_t)p) % 64) : -1;
  return p;
}
```

### 3.1 x86-64 native — 7모델 × 2모드

같은 바이너리, 같은 vmfb, 같은 계약. `malloc` 모드는 `harness/e29_no_posix_memalign.c`
(LD_PRELOAD로 `posix_memalign`을 실패시키는 시험 shim)로 만든 **E29 이전의 동작**이다.

| 모델 | bounded | per_call | malloc(ptr%64) → 분기, 피크 | 정렬(0) → 분기, 피크 | bounded/피크 |
|---|---:|---:|---|---|---:|
| conv2d | 3,528 | 1,352 | 32 → copy, **3,528** | map, **1,352** | 2.61× |
| b2_resnet | 618,856 | 309,416 | 16 → copy, **618,856** | map, **309,416** | 2.00× |
| mlp16k | 786,476 | 65,580 | 16 → copy, **786,476** | map, **65,580** | 11.99× |
| canonical | 786,476 | 65,580 | 16 → copy, **786,476** | map, **65,580** | 11.99× |
| multibranch | 38,216 | 840 | 32 → copy, **38,216** | map, **840** | 45.50× |
| manyconst31 | 34,112 | 320 | 32 → copy, **34,112** | map, **320** | 106.60× |
| b3_deepae | 1,069,632 | 6,208 | 16 → copy, **1,069,632** | map, **6,208** | 172.30× |

**두 불변식이 7/7에서 정확히 성립한다**: copy 분기의 종료 피크는 `bounded`와 **같고**,
map 분기의 종료 피크는 `per_call`과 **같다**. 즉 `bounded`는 여전히 두 분기의 최댓값이고
(E26 Q1은 건드려지지 않는다), map 분기에서 `per_call`은 sound할 뿐 아니라 **tight(1.00×)**하다.

그리고 E26·E26e·E26f가 "배포 의존성"으로 보고한 **1.00×~172.30×의 폭 전체가 이 한 포인터의
정렬**이었다. E26f의 172.30×는 정확히 b3_deepae의 `bounded/per_call`이다.

원자료: `results/e29_conditional_contract/native_sweep.jsonl`, 집계
`results/e29_conditional_contract/summary.json`.

### 3.2 cFS x86-64 — 실제 `core-cpu1` 4셀 (b3_deepae)

| 셀 | 예산 | opt-in | admission | 분기 | 종료 피크 | 추론 |
|---|---:|---|---|---|---:|---:|
| 무조건 | 1,069,632 (=bounded) | off | `ADMIT` | map | **6,208** | 5/5 |
| per-call 예산, opt-in 없음 | 6,208 (=per_call) | off | `NOT_ADMITTED` | — | — | 0 |
| **조건부** | 6,208 | **on** | `ADMIT_CONDITIONAL_MAP` | map | **6,208** | 5/5 |
| 조건부 + 정렬 무력화 | 6,208 | on | `ADMIT_CONDITIONAL_MAP` → **`MAP_PRECONDITION_FAILED`** | copy | — | **0** |

세 번째 줄이 이 실험의 실질이다. **예산 6,208 B에서 거부되던 모델이 같은 예산에서 돌고,
실측 피크가 정확히 6,208이다.** 배치에 필요한 예산이 172배 줄었고 그 상한은 여전히 계약이
서명한 값이다. 원자료: `results/e29_conditional_contract/cfs/*.log`(EVS 이벤트와 JSON 원문).

---

## 4. 조건부 admission의 설계 — 왜 fail-open이 아닌가

계약은 이미 두 값을 다 싣고 있었다(`static_per_call_bytes`, `module_resident_constant_bytes`).
**스키마도 헤더도 새 필드가 필요 없다** — `B_map = CONTRACT_PER_CALL_BYTES`,
`B_copy = CONTRACT_BOUNDED_BYTES`. 바뀐 것은 그 값을 게이트가 읽는 방식이다.

1. **기본은 그대로.** `AI_LEARNER_ALLOW_CONDITIONAL_MAP`의 기본값은 **0**이고,
   native는 `ONAIR_CONDITIONAL_MAP` 환경변수가 있어야 켜진다. 기존 배포의 판정은
   바이트 단위로 동일하다(보관 14개 계약 diff 0, 헤더 무변경).
2. **전제조건을 가정하지 않고 구성으로 강제한다.** 앱이 스스로 정렬 할당을 한다.
3. **강제했다고 믿지 않고 검증한다.** append 직후 HAL 피크를 읽어 `> per_call`이면
   **추론 한 건도 하기 전에 거부**한다(`MAP_PRECONDITION_FAILED`, cleanup 1회, cFS는
   나머지 앱 로드 계속).
4. **넓히기만 한다.** 조건부 계층은 `bounded ≤ budget`이 이미 참인 경우에는 아예 진입하지
   않으므로, 지금 통과하는 배포를 새로 거부할 수 없다 — **유형 (B) 과잉 거부 위험 0**.
   `budget < per_call`이면 opt-in 여부와 무관하게 `NOT_ADMITTED`(실측).

**정직하게 남는 비용**: 전제조건이 깨진 경우 거부 시점 이전에 이미 copy 분기가 실행돼
`bounded`까지의 일시 할당이 발생한다. 그 값은 계약이 서명한 `B_copy` 이하이며, 그래서
조건부 계층이 그 검증을 건너뛰는 것은 허용되지 않는다.

---

## 5. revert-and-confirm-fail

`results/e29_conditional_contract/revert_confirm_fail.txt`(원문 보존).
검증 블록 **하나만** 제거하고 나머지는 동일하게 두면:

```
"verdict":"ADMIT_CONDITIONAL_MAP"   "arm":"copy"
"hal_device_bytes_peak":1069632     "peak_within_bounded":true     "reason":"ok"   rc=0, 3 inferences
```

예산 6,208 B로 승인된 앱이 **1,069,632 B(172배 초과)**로 3회 추론을 완주한다.
그리고 **기존 텔레메트리는 이것을 잡지 못한다** — `peak_within_bounded`가 `true`인데,
그 필드는 피크를 `CONTRACT_BOUNDED_BYTES`와 비교하지 승인 근거가 된 예산과 비교하지 않기
때문이다. E28의 교훈("계약이 준 숫자를 게이트가 실제로 쓰는지 확인하라")의 자매편이다:
**어느 숫자로 승인했는지와 어느 숫자로 검증하는지가 같아야 한다.**

소스 수준 revert(정렬 할당을 `malloc`으로 되돌림)도 즉시 실패한다: 261건 중 1건 FAIL.

회귀 시험 **284/284 → 304/304**(이 컨테이너 실측, 신규 20건; `EVIDENCE_v0.29_E27.md` §7 정오표 6건을 더해 최종 310/310). **CI 실측**(커밋 `58757b3`, run 96): `full` **309/309 + 1 SKIP**(PyYAML 미설치) · `without-iree` **202/202 + 15 SKIP** · `stdlib-only` **202/202 + 15 SKIP** — 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무다(D34: 추정하지 않고 조건과 함께 병기). 보관 14개 계약 diff 0.

---

## 6. 기존 판정과의 관계 — 정정이 아니라 정밀화

- **E26 Q1(soundness)**: 그대로다. `bounded`는 두 분기의 최댓값이고, copy 분기가
  그 값에 정확히 닿는다는 것을 E29가 7/7에서 다시 확인했다. 위반 0.
- **E26 Q2(tightness)**: 값은 그대로이되 **원인이 규명됐다.** "미확정"이던 결정 요인이
  64바이트 정렬로 확정됐고, E26이 배제한 네 후보(무작위·런타임 빌드 구성·모델 내재·
  embedded/external)는 여전히 배제된 채다 — 정렬은 그중 어느 것도 아니다.
- **E26 결론("정적 계약은 배포 독립, 런타임 계측은 그 배포 한정")**: 유지된다. 다만
  **보수성의 대가는 내재적이지 않다**는 것이 추가된다 — 전제조건을 제어하면 조건부 값이
  1.00×로 tight하다.
- **E26e/E26f의 배포 간 폭(2.00×, 172.30×)**: 이제 설명된다. 그 폭은 모델의 성질도
  런타임 빌드의 성질도 아니고, 모듈 이미지를 누가 어떻게 할당했는가였다.
- **E27(R-3)**: 영향 없다. E27은 정보 *수준*을 비교했고 E29는 실행 *배포*를 바꾼다.

---

## 7. 주장하지 않는 것

- `bounded_bytes`가 건전하지 않았다는 주장 — **아니다.** 두 분기의 최댓값이며 양쪽에서
  유효한 상한이다.
- 정렬이 모든 IREE 버전·드라이버에서 copy 분기의 **유일한** 원인이라는 주장 — 여기서
  측정된 원인이다. 그래서 앱이 분기를 가정하지 않고 **측정해서 검증**한다.
- AArch64 게스트 cFS 셀 — **미실행**(이 세션에서 게스트를 띄우지 않았다).
- 다중 앱 전역 예산에 대한 함의 — 계약 범위는 여전히 `per_app_local_budget`이다(R-4).
- 지연·WCET에 대한 어떤 주장도 하지 않는다(`FUNCTIONAL_ONLY`).
- 조건부 계층이 켜진 배포가 `bounded`만큼의 일시 할당을 **절대** 하지 않는다는 주장 —
  전제조건이 깨지면 거부 직전까지 그 할당이 발생한다(§4).

---

## 8. 재현

```bash
# 결정 요인 스윕 (8모델 x 8 정렬 클래스)
IREE_SRC=$HOME/onair-mlir-bench/ext/iree-src python3 harness/e29_collect.py

# native before/after (shim으로 E29 이전 동작 재현)
gcc -shared -fPIC -o /tmp/e29_nopm.so harness/e29_no_posix_memalign.c
cd native && bash build.sh ../results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.contract.json b3_deepae
./native_learner_b3_deepae ../results/.../b3_deepae.vmfb 1069632 5        # 정렬 -> peak 6,208
LD_PRELOAD=/tmp/e29_nopm.so ./native_learner_b3_deepae ... 1069632 5      # malloc  -> peak 1,069,632
ONAIR_CONDITIONAL_MAP=1 ./native_learner_b3_deepae ... 6208 5             # 조건부 ADMIT, peak 6,208
LD_PRELOAD=/tmp/e29_nopm.so ONAIR_CONDITIONAL_MAP=1 ./native_learner_b3_deepae ... 6208 5   # rc=10 거부

# cFS 조건부 셀
MODEL_VMFB=$PWD/results/.../b3_deepae.vmfb AI_LEARNER_BUDGET_BYTES=6208 \
  AI_LEARNER_ALLOW_CONDITIONAL_MAP=1 bash scripts/50_wire_cfs_ai_learner.sh
(cd $HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && timeout -s INT 25 ./core-cpu1)

python3 harness/contract_negative_tests.py     # 304/304 (이 컨테이너)
```


---

## 9. 정오표 (v0.32 / E29b — D54)

§4 3항의 *"append 직후 HAL 피크를 읽어 `> per_call`이면 추론 한 건도 하기 전에 거부한다"*는
**결함이 있는 검증**이었다. copy 분기의 append 직후 피크는 §2.2가 측정한 대로 **정확히 `constants`**이므로,
`constants < per_call`인 모델에서는 그 비교가 거짓이 되어 copy 분기가 통과한다 — 앱은 그 분기를
`copy`라고 기록해 놓고도 실행해 `per_call + constants`에서 완주한다(일곱 번째 외부 검토 §4.1이 코드에서
예측, `bigact`로 native·cFS 양방향 재현: 예산 45,444에 피크 59,460). §3의 7모델은 전부
`constants > per_call`이라 이 조건을 한 번도 밟지 않았고, 이 문서의 §5 revert-and-confirm-fail은
따라서 이 결함을 검출할 수 없는 입력 집합 위에서 수행된 것이다. 수정(append 전 정렬 검사 +
`hal_peak_after_append != 0` 분기 판정)과 재실측은 `docs/EVIDENCE_v0.32_E29b.md`. §2·§3·§6의 판정
(결정 요인·이분성·7/7 양방향 불변식)은 바뀌지 않는다.
