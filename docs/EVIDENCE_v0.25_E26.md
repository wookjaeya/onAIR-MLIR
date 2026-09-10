# EVIDENCE v0.25 — E26: 부분 메모리 계약 경계의 유용성

- 실험 ID: **E26** (core)
- 날짜: 2026-09-09
- **사전 고정 기준**: `docs/plans/E26_boundary_utility.md` — 어떤 수치도 보기 전에 커밋됨
  (커밋 `c8e8980`). §2는 측정 시작 후 수정되지 않았다.
- 회귀 시험: **CI 실측**(커밋 `3afdf80`, 워크플로 run 56): `full` **228/228 + 1 SKIP**(PyYAML 미설치) · `without-iree` **126/126 + 13 SKIP** · `stdlib-only` **126/126 + 13 SKIP**. 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무이며, 두 수치를 조건과 함께 병기한다(D34).
- 플랫폼 등급: **결정론적**(HAL allocator 통계, 계약 수치, admission 판정).
  **지연값은 인용하지 않는다**(작업 규율 4). RSS는 버킷 보고용이며 판정에 쓰지 않는다.
- 산출물: `results/e26_boundary_utility/`

## 0. 판정

| 질문 | 결과 |
|---|---|
| **Q1 상한의 타당성** | **PASS** — 관측된 모든 셀에서 `hal_peak ≤ bounded_bytes`. 위반 0건 |
| **Q3 판정의 유용성** | **PASS** — unsafe admit 0건. `B−1`→DENY, `B`·`B+1`→ADMIT이 native·cFS 모두에서 성립 |
| **Q2 상한의 보수성** | **측정됨.** tightness가 **1.00×에서 45.50×까지** 벌어진다. 원인은 컴파일러가 emit한 분기이며, **그 분기를 결정하는 요인은 런타임 배포 방식**이다 |

`results/e26_boundary_utility/summary.json`(사전 고정 기준을 그대로 적용한 `e26_collect.py` 출력):

```
cells 49, cells_with_a_run 37   (core 35 / ext 2)
q1_pass True    q1_pass_core True    q1_pass_ext True    q1_violations []
q3_pass True    q3_unsafe_admits []  q3_ungradeable []
q2_branches {'allocated': 27, 'mapped': 10}    q2_hypothesis_refuted []
e25_mode_unproven []
```

**§3의 분기 가설은 37개 실행 셀 전부에서 유지됐다**(`q2_hypothesis_refuted: []`) — 모든 peak가
`per_call` 또는 `per_call + constants` 둘 중 하나와 **정확히** 같았고, 그 사이의 값은 하나도 없다.

그리고 이 실험은 **E14가 남기고 E25가 채우지 못한 `both_sound: null` 공백을 실제로 닫았다**
(v0.22.1의 D45 정정이 지적한 바로 그 항목) — 3모델 전부 `both_sound: true`.

## 0.1 측정한 모델 집합 (문서-실행 일치 확인)

**canonical(E25) · mlp16k(E14) · conv2d · multibranch** 네 개다. canonical과 mlp16k는 계약 수치가
같지만(canonical을 hidden=16384로 만들었다) **서로 다른 vmfb**(`0e250c2f…` vs `4d6f3807…`)이며,
둘 다 측정해 같은 값이 나오는 것을 **가정이 아니라 관측**으로 확인했다.

초판 작성 시 계획서는 canonical을, 측정은 mlp16k를 쓰고 있었다 — 이 불일치를 발견해 canonical을
실제로 추가 측정하고 양쪽을 맞췄다. **문서가 말하는 모델과 측정한 모델은 같아야 한다.**

## 1. 측정 위생 (판정의 전제)

모든 cFS 실행은 `/cf/e25_inputs.bin` **부재** 상태에서 이뤄졌고, 앱이
`{"stage":"e25_mode","active":false}`로 **그 사실을 증언한다**(v0.22.2에서 신설).
증언 없는 로그는 `e25_mode_proven_off: false`로 표시되며 판정에 쓰지 않는다.

HAL allocator 통계는 **프로세스 전역**이다. 한 프로세스에서 두 모델을 연달아 재면 오염된다 —
실측으로 재현했다(같은 프로세스에서 multibranch가 conv2d의 잔여를 물려받아 840 대신 65,580).
**모든 셀은 모델당 별도 프로세스**로 측정했다.

## 2. Q1 — 상한의 타당성

**위반 0건.** 네 가지 실행 경로(pip `iree.runtime` / 소스 빌드 C 런타임 x86-64 native /
같은 런타임을 링크한 cFS 앱 / 소스 빌드 C 런타임 AArch64 qemu-user)에서 관측된 모든
`hal_peak`가 그 모델의 `bounded_bytes` 이하였다.

이 결과는 **관측 범위 내 경험적 soundness**다. 모든 입력·플랫폼에 대한 형식적 증명이 아니다
(계획 §2 마지막 문단 그대로).

## 3. Q2 — tightness는 컴파일러가 emit한 분기의 함수이고, 그 분기는 런타임 배포가 정한다

### 3.1 기전 (IR에서 직접 확인)

`results/e14_aarch64_qemu/x86_64/layout_ir/conv2d.layout_ir.txt:104`:

```mlir
%did_map, %result = stream.resource.try_map ... %buffer_cst[%c0] : !util.buffer
                        -> i1, !stream.resource<constant>{%c2176}
%2:2 = scf.if %did_map -> (...) {
  scf.yield %1, %result                                   // 매핑 성공: HAL 할당 0
} else {
  %8 = stream.resource.alloc uninitialized ... {%c2176}    // 실패: 상수만큼 HAL 할당
```

보관 모델 전수 확인: `dynamic`을 제외한 **12개 layout IR 전부** 같은 구조
(`try_map` 1 + `alloc` 폴백 1).

따라서 **`bounded_bytes = static_per_call_bytes + module_resident_constant_bytes`는 이
`scf.if` 두 분기의 최댓값**이다. soundness는 두 분기 모두에서 **구조적으로** 성립하고,
tightness만 어느 분기가 실행됐는지의 함수다.

### 3.2 두 분기를 모두 관측했다 — 같은 아티팩트, 다른 런타임 배포

| 런타임 배포 | conv2d | mlp16k | multibranch |
|---|---|---|---|
| pip `iree.runtime` (Python 바인딩), x86-64 | **1,352** 매핑 | **65,580** 매핑 | **840** 매핑 |
| 소스 빌드 C 런타임, x86-64 `native_learner` | 3,528 할당 | 786,476 할당 | 38,216 할당 |
| 같은 런타임을 링크한 **cFS 앱**, x86-64 | 3,528 할당 | 786,476 할당 | 38,216 할당 |
| 소스 빌드 C 런타임, AArch64 qemu-user | **1,352** 매핑 | 786,476 할당 | **840** 매핑 |
| 같은 런타임을 링크한 **cFS 앱, AArch64 게스트** (canonical) | — | 786,476 할당 | — |

AArch64 게스트 cFS 셀(canonical, `B`·`B+1`)은 실제 QEMU 게스트에서 `core-cpu1`을 기동해 얻었고
`e25_mode active=false`로 측정 위생을 증언했다. `mem_init` peak 720,932(추론 0회) → 정상 실행
786,476으로 x86-64 cFS와 같은 분기다. **게스트 `B−1` 셀은 빌드되지 않는다** — 예산이 bound보다
작으면 컴파일러가 admission 실패를 정적으로 판정해 artifact-binding 코드를 죽은 코드로 제거하고
빌드 검증이 사라진 sha256 문자열을 보고한다(앱 결함이 아니며, DENY 동작은 x86-64 cFS의 `B−1`
셀이 이미 보였다. 계획 §4.0).

`bounded_bytes`: conv2d 3,528 · mlp16k 786,476 · multibranch 38,216 (두 ISA 동일).

**tightness(`bounded/peak`) 범위: 1.00× ~ 45.50×.**

| 모델 | 최소 | 최대 |
|---|---|---|
| conv2d | 1.00× | 2.61× |
| mlp16k | 1.00× | **11.99×** |
| multibranch | 1.00× | **45.50×** |

### 3.3 분기를 결정하는 요인 — 배제한 것과 남은 것

**실측으로 배제한 것**:

| 후보 | 배제 근거 |
|---|---|
| 실행마다 무작위(주소 정렬·ASLR) | 같은 바이너리 **5회 연속 실행이 5/5 동일**(세 모델 전부) |
| 런타임 빌드 **구성** 차이 | 두 CMake 캐시가 ISA별 ukernel 플래그와 경로 외에 **동일** |
| 모델 내재적 성질 | E14는 **같은 aarch64 vmfb**(sha 일치)로 multibranch 38,216을 기록했고 이번엔 840이다 |
| 상수의 embedded/external 저장 형태만으로 설명 | multibranch의 37,376은 **external인데도** AArch64에서 매핑됐다 |

**확인된 것**: 분기는 **런타임 배포 방식**과 함께 바뀐다 — pip 바인딩에서는 세 모델 전부 매핑,
같은 호스트의 소스 빌드 C 런타임에서는 세 모델 전부 할당.

**미확정**: 그 배포 차이의 **어느 요소**가 `try_map` 성공을 가르는지는 이 실험에서
확정하지 않았다. 확정하려면 IREE HAL의 import 경로를 계측해야 한다. **추측하지 않는다.**

### 3.4 v0.9 §11.6이 남긴 질문에 대한 답

`EVIDENCE_v0.9_E14_stage1.md` §11.6은 conv2d의 native 1,352 vs cFS 3,528을 보고하며
*"tightness는 런타임 구성과 상수 매핑 방식에 따라 달랐다"*고 쓰고 **인과를 확정하지 않은 채**
후속 조사 대상으로 남겼다. E26이 그 인과를 채운다: 두 값은 컴파일러가 emit한
`scf.if(%did_map)`의 **두 분기**이고, 어느 분기가 실행되는지는 런타임 배포가 정한다.

v0.9의 서술은 **철회할 것이 없다** — "런타임 구성에 따라 달랐다"는 정확했고, 다만 그 기전이
미확정이었다. 다만 그 문장을 *"native는 느슨하고 cFS는 tight하다"*로 읽으면 안 된다는 것이
E26에서 분명해졌다: x86-64에서는 **native도 cFS도 똑같이 3,528**이다. 축은 native-vs-cFS가
아니라 (모델, 타깃, 런타임 배포)다.

### 3.5 이것이 R-2에 주는 답

같은 아티팩트의 HAL 관측 peak가 **런타임 배포에 따라 최대 45.5배 달라진다.** 즉

- **런타임 계측으로 얻은 상한은 그 배포에만 유효하다.** 한 배포에서 잰 840을 예산으로 삼으면
  다른 배포에서 38,216을 쓰는 순간 틀린다.
- **정적 계약은 배포에 독립이다.** 컴파일러가 emit한 두 분기의 최댓값을 서명하므로 관측된 네
  배포 전부에서 sound했다.

**이것이 "부분 계약이 배치 판단에 유용한가"에 대한 이 실험의 답이다** — 유용성의 근거는
tightness가 아니라 **배포 독립성**이다. 그 대가가 최대 45.5배의 보수성이며, 이 실험이 그것을
정량화했다.

## 4. Q3 — 판정의 유용성

예산 `B ∈ {bounded−1, bounded, bounded+1}` sweep을 native와 cFS 양쪽에서 실행했다.

- `B−1`: **전부 NOT_ADMITTED** — 런타임이 만들어지기 전에 거부된다.
- `B`, `B+1`: 전부 ADMIT, 그리고 **ADMIT된 셀 중 `peak > budget`인 것은 0건**(unsafe admit 0).
- 과보수 거부 대역(`peak ≤ budget < bounded`)은 매핑 분기에서만 존재하며, 그 폭이 §3.2의
  tightness다. **즉 배포가 매핑 분기를 쓰는 환경에서는 계약이 최대 45.5배의 예산을 요구한다.**

## 5. 귀속 분리 (계약 밖 버킷)

v0.22.2의 계측으로 초기화 시점이 분리 관측된다. canonical(E25) x86-64 기준:

| 버킷 | 관측 |
|---|---|
| ① 계약 영역(HAL) | 초기화 직후 `constants + 입력 버퍼`, 최초 추론 후 `bounded` |
| ② IREE 런타임 컨텍스트 | cFS RSS +304 KB (세션 생성 직후) |
| ③ 모듈 로드 | cFS RSS +864 KB |
| ④ 래퍼/앱 입력 버퍼 | conv2d 256 B · canonical 36 B (= `CONTRACT_INPUT_ELEMS` × 4) |
| ⑤ OSAL/cFS 기저 | 앱 Init 이전 프로세스 RSS |

②③⑤는 RSS 기반이라 **결정론적이지 않다** — 표시용이며 판정에 쓰지 않는다(작업 규율 4).
①④는 HAL 통계·계약 수치라 그대로 인용 가능하다.

## 6. E14의 `both_sound` 공백을 실제로 닫았다

`results/e26_boundary_utility/comparison/cross_target.*.json`:

| 모델 | `identical_bounded_bytes` | `both_sound` | `out0_agreement.agree` |
|---|---|---|---|
| conv2d | true | **true** | true |
| mlp16k | true | **true** | true |
| multibranch | true | **true** | true |

E14는 `--native-summaries`를 주지 않아 이 세 값이 전부 `null`이었고, E25가 그것을 닫았다는
서술은 **v0.22.1에서 철회했다(D45)** — 출력 동치와 메모리 soundness는 다른 관측이기 때문이다.
E26이 **두 타깃의 실제 실행 요약**으로 채웠다. `dynamic`은 `UNKNOWN_BOUND`라 대상이 아니다.

## 7. 이 실험으로 주장할 수 있는 것 / 없는 것

**주장 가능**
- 동일 메모리 경계에서 정적 계약과 HAL 관측 peak를 **네 가지 런타임 배포**에 걸쳐 비교했고,
  관측된 모든 셀에서 `peak ≤ bounded`였다.
- cFS가 실행 전 예산 경계(`B−1`/`B`/`B+1`)에서 일관되게 DENY/ADMIT하며 unsafe admit이 없다.
- tightness가 배포에 따라 1.00×~45.50×로 달라지는 것을 정량화하고, 그 원인이 컴파일러가
  emit한 `scf.if(%did_map)` 분기임을 IR에서 확인했다.
- E14 3모델의 cross-target `both_sound`를 실제 실행으로 채웠다.

**주장하지 않음**
- **형식적 soundness** — 관측 범위 내 경험적 결과다.
- `try_map` 성공을 가르는 **구체적 요인** — 미확정이다.
- QEMU 결과의 **성능적 해석** — 지연값은 인용하지 않았다.
- 온보드 컴퓨터 **전체** 메모리 수용성 — 계약은 per-call + 모듈 상주 상수의 부분 경계다(R-4).
- 이 3모델을 넘어선 **일반화** — B2·B3(MLPerf Tiny)의 실행 측정은 E26-ext로 남아 있다.

## 8. 재현

```bash
# 계약·vmfb는 E14 보관본을 그대로 쓴다(재컴파일 금지, 작업 규율 7)
cd native && bash build.sh ../results/e14_aarch64_qemu/x86_64/contracts/contract.<m>.x86_64.json e26_<m>
./native/native_learner_e26_<m> results/e14_aarch64_qemu/x86_64/vmfb/<m>.vmfb <budget> 50
# cFS: 모델·예산마다 헤더 재생성 + 재배선 후 core-cpu1 기동 (cf/e25_inputs.bin 부재 확인)
# pip 런타임: harness/static_mem_bound.py::runtime_peak_check, 모델당 별도 프로세스
python3 harness/e26_collect.py --root results/e26_boundary_utility --out results/e26_boundary_utility/summary.json
```

---

## 9. 정오표 (E26d, 2026-09-09) — 계획 §5-3의 A5b_canonical

**누락을 정정한다.** 사전 고정 계획서(`docs/plans/E26_boundary_utility.md` §5 3단계)는
게스트 세션에서 **A5b_canonical 1건**을 함께 실행하라고 지정했다. 이 문서는 그것을 **보고하지도,
미실행이라고 밝히지도 않았다.** 판정(Q1·Q3 PASS, Q2 정량화)에는 영향이 없다 — A5b는 메모리 경계
질문이 아니라 손상 아티팩트 거부 경로의 질문이며 §2의 기준 어디에도 들어가지 않는다. 그러나
**사전에 고정한 단계를 조용히 건너뛴 것**은 이 저장소가 v0.9.1에서 A5b를 두고 이미 한 번
정정한 바로 그 유형이므로 이렇게 남긴다.

**E26d에서 실제로 실행했다.** 게스트가 아직 살아 있어 재구축 없이 돌렸다.

| 항목 | 값 |
|---|---|
| 손상 방식 | `flatbuffer_root_uoffset` (`harness/corrupt_vmfb.py`, 임의 bit flip 아님) |
| 원본 → 손상 vmfb | `4e5b2972…` → `b118305d…`, **크기 동일 732,760 B** |
| 계약 | 손상된 파일의 실제 해시로 재생성 → **해시 게이트가 잡을 수 없는 조건** |
| 빌드 | `e26d_canon_a5b` (cFS aarch64_std 크로스빌드, budget = bounded = 786,476) |

게스트 `core-cpu1` 관측 순서:

```
stage=stack             kernel_stack_accounted=true (es=262160 = base 262144 + kernel 16)
stage=admission         verdict=ADMIT   bounded=786476  budget=786476
stage=binding           verdict=MATCH   artifact_sha256=b118305d… == contract_sha256
stage=runtime_load_failed  step=append_bytecode_module
                        INVALID_ARGUMENT; FlatBuffer length prefix out of bounds
                        (prefix is 4294967295 but only 732692 available)
stage=cleanup           released=true  cleanup_calls=1
CFE_ES_ExitApp: Application AI_LEARNER called CFE_ES_ExitApp
```

`harness/e14_cfs_scenarios.py::check_expect`의 불일치 **0건**. AI_LEARNER 종료 후에도 cFS는
남은 앱을 계속 로드했고(SC·MM·HS·MD·CS), 크래시·abort **0건**이다. 즉 손상은 admission도
binding도 아니라 **IREE 자신의 FlatBuffer 검증기**가 잡았고, 앱은 자원을 회수하고 시작을
포기했으며 시스템은 살아남았다 — E17이 관측한 것과 **같은 오류 문자열**이다.

**`e25_mode` 레코드는 이 셀에 없다. 구조상 그렇다** — `ai_learner.c`는 그 레코드를 `:406`에서
찍는데 여기서는 `:317`의 바이트코드 로드가 먼저 실패해 도달하지 않는다. E26의 계측 위생
점검이 요구하는 것은 **추론에 도달하는 셀**의 증언이므로 이것은 갭이 아니다.

산출물: `results/e26_boundary_utility/aarch64/a5b_canonical/`
(손상 vmfb·계약·게스트 raw log·`canonical_A5b.json`).
