# EVIDENCE v0.8 — E14 Stage 0: 교차 ISA(x86-64 → AArch64) 계약 건전성

선행: `EVIDENCE_v0.7_E13.md`, 외부 제안 `docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`(2026-09-08)
본 문서는 제안서의 RQ1·RQ2·RQ3를 **QEMU 시스템 에뮬레이션 없이** 가능한 범위(교차 컴파일,
구조 분석, `qemu-aarch64` **user-mode** 빠른 확인)에서 검증한 결과다. 시스템 전체 에뮬레이션
(Linux 게스트 부팅 + cFS-in-guest, 제안서 §7·§11)은 `docs/plans/E14_stage1_qemu_system_cfs.md`로
이관했다 — 사유는 그 문서에 명시.

---

## 요약

- **TOPIC** — 정적 메모리 계약과 admission gate가 x86-64에서 AArch64(Cortex-A53)로 타깃이
  바뀌어도 sound한지, 그리고 코드생성 시 계약 밖 메모리가 생기는지 확인.
- **Problem** — 지금까지의 모든 검증(E6–E13)은 x86-64 한 타깃이었다. "정적 상한은 lowering
  설정과 무관하다"(E6c)는 확인됐지만 "ISA와 무관한가"는 미확인이었다.
- **Solution** — **동일 모델에서 bounded_bytes가 x86-64와 AArch64에서 완전히 같았다**(786,476,
  둘 다). Native 실행(qemu-user)에서 HAL 피크·정상 상태 per-call·경계값·모델교체거부·수치
  출력까지 x86-64와 일치. 다만 **AArch64 코드생성은 x86-64에 없던 16바이트 스택 프레임을
  두 커널 함수 모두에 도입**했다 — 계약 밖 잔차로 명시적 분류가 필요한 첫 사례.

---

## 0. 증거 등급

이 문서의 결과는 두 층위로 나뉜다.
- **결정론적** (증거로 인용 가능): vmfb 해시·크기, `bounded_bytes` 수치, LLVM IR 구조(alloca/declare 개수),
  ELF 명령어 종류·개수, admission 판정(ADMIT/NOT_ADMITTED/UNKNOWN_BOUND/MISMATCH), 수치 출력값(out0).
- **QEMU user-mode 측정값** (증거 아님, 방향 참고만): 지연(median 1807 µs 등), RSS 델타.
  이유는 제안서 §14·§19와 동일 — TCG 명령어 번역과 호스트 프로세스 오버헤드가 섞여 있다.
  **본 문서는 이 값들을 결론에 사용하지 않는다.**

---

## 1. 방법

E13의 "단일 컴파일 호출" 규칙을 그대로 적용:

```bash
iree-compile m16k_baked.mlir --iree-hal-target-backends=llvm-cpu \
  --iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu --iree-llvmcpu-target-cpu=cortex-a53 \
  --mlir-print-ir-after=iree-stream-layout-slices \
  --iree-hal-dump-executable-files-to=aarch64/dump -o aarch64/model.vmfb
```

모델: h=16384 베이킹 MLP (E5–E13과 동일 가중치, `np.random.default_rng(0)`).
IREE 런타임(Native 실행용)은 x86-64와 **같은 커밋**(e4a3b04)에서 `CMAKE_SYSTEM_PROCESSOR=aarch64`
크로스 빌드. `native_learner.c`는 무수정으로 `aarch64-linux-gnu-gcc -static`으로 크로스 컴파일해
`qemu-aarch64`(user-mode, binfmt 없이 직접 실행)로 구동.

---

## 2. RQ1 — 교차 ISA 계약 건전성

### 2.1 계약 수치 자체가 동일

| | x86-64 (host profile) | AArch64 (cortex-a53) |
|---|---:|---:|
| static_transient_bytes | 65,536 | 65,536 |
| static_io_bytes | 44 | 44 |
| module_resident_constant_bytes | 720,896 | 720,896 |
| **bounded_bytes** | **786,476** | **786,476** |
| vmfb sha256 | a48be5b8… (E13) | 053d4973… |
| vmfb bytes | 733,827 | 732,699 |

**바이트는 다르지만(다른 ISA 코드이므로 당연) 계약 수치는 완전히 같다.** 이유는 구조적이다:
`iree-stream-layout-slices`가 수행하는 메모리 계획(버퍼 크기·정렬·수명 재사용)은 `iree-llvmcpu`
타깃별 코드생성보다 **앞선 패스**이므로, 이 모델처럼 계획에 영향을 주는 타깃 종속 요소(예:
타깃별 커널 fusion 전략 차이)가 없으면 계약이 ISA에 불변이다. 이것이 제안서 §19가 허용하는
결론의 정확한 근거다.

### 2.2 Native 실행 (qemu-aarch64 user-mode) — 결정론적 부분만

| 항목 | 값 |
|---|---|
| admission (예산 1 MiB) | ADMIT |
| binding | MATCH (아티팩트 해시 일치) |
| HAL `device_bytes_peak` | **786,476 = bounded_bytes** |
| `peak_within_bounded` | true |
| 정상 상태 per-call (워밍업 후) | **65,544.0 = 65,536 + 8** (x86-64 E11b/E13과 동일 산식) |
| `steady_within_per_call` | true |
| attempted / completed / 실패 | 700 / 700 / 0 |
| **out0 (수치 출력)** | **4.432073** — x86-64 native_learner(E11b/E13)와 **동일** |

### 2.3 경계값 (B−1 / B / B+1)

| 예산 | 판정 |
|---:|---|
| 786,475 | NOT_ADMITTED |
| 786,476 | ADMIT |
| 786,477 | ADMIT |

x86-64 E10과 동일 패턴. 18/18(x86-64) + 3/3(AArch64, 이번) 모두 정확.

### 2.4 모델 교체 (같은 ABI, 다른 아티팩트)

x86-64 h=16384 아티팩트(95e8caff…)를 AArch64 계약(053d4973…)으로 실행 → 즉시
`CONTRACT_ARTIFACT_MISMATCH`, exit 5, **런타임 미생성**. ISA가 다른 아티팩트조차 실수로
바이트 비교를 통과하지 못함을 확인(당연하지만 실제로 확인함).

### 2.5 동적 형상

같은 동적 배치 차원 모델을 AArch64로 컴파일해도 `all_sizes_static=false` →
`bound_method=UNKNOWN_BOUND`. E8(x86-64)과 동일하게 예산과 무관히 거부.

**RQ1 결론(시험 조건 내)**: 정적 상한은 sound하고, 그 값 자체가 이 모델에서는 ISA 불변이다.
Native 실행 레벨의 admission·binding·경계값·실패 처리 로직은 AArch64에서도 x86-64와
동일하게 동작한다.

---

## 3. RQ2 — 커널 외부 메모리 (AArch64 고유 발견)

| 항목 | x86-64 (host, E13) | **AArch64 (cortex-a53)** |
|---|---:|---:|
| LLVM IR `alloca` | 0 | **0** |
| LLVM IR 외부 `declare` | `llvm.assume`, `llvm.fmuladd.v32f32/v2f32` | `llvm.assume`, `llvm.fmuladd.v2f32/v8f32` |
| `malloc`/`free` 참조 | 0 | **0** |
| ELF `call`/`bl`/`blr` 명령 | 0 | **0** |
| **ELF 스택 프레임** | **없음** | **`stp x29,x30,[sp,#-16]!` / `mov x29,sp` … `ldp x29,x30,[sp],#16` — 두 dispatch 함수 모두, 16 B** |
| 추가 스필 (`sub sp` 등) | — | **없음** (16 B 프롤로그 외 지역 스택 없음) |
| 벡터 ISA | AVX-512 (zmm, 32-wide fmuladd) | NEON (v.4s, 4-wide, `fmla` 14회) |
| ELF 크기 / 총 명령 수 | 5,160 B / 122 | 4,864 B / 88 |

### 발견: AArch64 표준 프롤로그는 "호출이 없어도" 나타난다

두 dispatch 함수 모두 내부에 `bl`/`blr`(함수 호출) 명령이 **0개**인데도 AAPCS64 표준
프롤로그(x29=frame pointer, x30=link register 저장)를 갖는다. LLVM AArch64 백엔드가
호출 유무와 무관하게 프레임 레코드를 생성한 것으로 보인다(스택 언와인딩/디버그 정보
생성 관례; 본인 분석, LLVM 코드생성 내부 동작에 대한 확정적 근거는 별도 확인 필요).

**분류(제안서 §9.2의 4분류 적용)**: 이 16 B는 HAL이 관리하는 per-call/상수 버퍼가 아니라
**OS 태스크 스택** 위에 있다. 따라서 **(2) 태스크 스택 예산에 포함할 메모리**로 분류하고,
현재의 `bounded_bytes`(HAL 계약)에는 넣지 않되 **미회계로 방치하지도 않는다** — Stage 1의
cFS 앱 스택 크기 설정에 명시적으로 반영해야 한다(`docs/plans/E14_stage1_qemu_system_cfs.md`
에 조치 사항 기록).

**RQ2 결론(시험 조건 내)**: 힙 할당·malloc·외부 함수 호출은 AArch64에도 없다. 다만
**아키텍처 표준 프롤로그로 인한 고정 16 B/함수의 태스크 스택 사용**이 x86-64에는 없던
차이로 새로 나타났다. "4번 미회계 메모리"는 아니다(원인과 크기를 특정했고 (2)번으로
분류했으므로) — 단, Stage 1에서 실제로 예산에 반영하기 전까지는 **잠정 분류**로 취급한다.

---

## 4. RQ3 — cFS admission의 타깃 독립성

**부분 검증.** Native 실행(§2)의 admission·binding·실패 처리는 AArch64에서 x86-64와
동일하게 동작함을 확인했다. **cFS 앱 자체를 AArch64 게스트 안에서 빌드·실행하는 것은
Stage 1(시스템 에뮬레이션 필요)로 이관**했으며, 이 문서는 그 결과를 포함하지 않는다.

---

## 5. 가설/주장 판정 (v0.8)

| 항목 | v0.7 | **v0.8** |
|---|---|---|
| 정적 상한의 일반성 | lowering 설정 불변(E6c), 할당 구조 4종 불변(E9) | **+ ISA 불변** (x86-64=AArch64=786,476, 이 모델 한정) |
| 커널 수준 계약 밖 메모리 | 없음(x86-64, E13) | **x86-64: 없음. AArch64: 16 B/함수 스택 프레임 발견** — 최초의 "계약 밖" 사례, (2)로 분류 |
| Native admission·binding | x86-64에서 검증 | **AArch64(qemu-user)에서도 동일 동작 확인** |
| cFS 통합 타깃 독립성 (RQ3) | — | **미검증** (Stage 1로 이관) |
| H1/H2/H3 | 변화 없음 | 변화 없음. H3(메모리 축)의 일반성 범위가 넓어짐(ISA 축 추가) |

---

## 6. 한계 (그대로 인용할 것)

이 실험으로 **허용되지 않는** 결론(제안서 §19 그대로):
- 실제 AArch64 하드웨어에서의 실행시간 보장
- 실제 탑재 컴퓨터의 RSS/물리 메모리 예측
- 실시간 데드라인·WCET 보장
- 비행급/방사선 내성 검증
- 단일 MLP로 Conv2D·multi-branch 등 다른 할당 구조에 대한 일반화 (제안서 §12 요구 — 미착수)
- cFS-in-guest 통합 검증 (Stage 1 미착수)
- Cortex-A53 이외 AArch64 마이크로아키텍처(예: Cortex-A72, Neoverse)로의 일반화

이 실험으로 **허용되는** 결론:
> 시험한 정적 MLP 모델과 단일 in-flight 조건에서, x86-64와 AArch64(Cortex-A53, QEMU
> user-mode 확인)용으로 각각 생성된 메모리 계약은 수치가 동일했고 해당 타깃의 HAL 관측
> 피크를 포괄했다. 계약–아티팩트 결합, 경계값 판정, 모델 교체 거부, 동적 형상 거부는
> AArch64에서도 x86-64와 동일하게 동작했다. AArch64 코드생성은 x86-64에 없던 16바이트
> 고정 스택 프레임을 커널 함수마다 도입했으며, 이는 HAL 계약이 아닌 태스크 스택 예산으로
> 별도 회계해야 한다.

---

## 7. 재현

```bash
bash scripts/60_setup_aarch64_cross.sh
bash scripts/40_setup_iree_source_runtime.sh      # (이미 했다면 생략)
bash scripts/61_build_iree_runtime_aarch64.sh
bash scripts/62_compile_and_check_aarch64.sh
```
산출물: `e14/aarch64/{model.vmfb, layout_ir.txt, *.codegen.ll, kernel_aarch64.elf,
kernel_aarch64.objdump.txt, summary.json}`, `contracts/contract.e14_aarch64.json`.

Stage 1(시스템 에뮬레이션, cFS-in-guest, Conv2D/multi-branch 모델): `docs/plans/E14_stage1_qemu_system_cfs.md`.
