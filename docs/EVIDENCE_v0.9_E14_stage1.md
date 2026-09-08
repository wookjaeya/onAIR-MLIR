# EVIDENCE v0.9 — E14 Stage 1: qemu-system-aarch64 게스트, cFS-in-guest admission, 모델 세트 확장

선행: `EVIDENCE_v0.8_E14_aarch64.md`(Stage 0), 계획 `docs/plans/E14_stage1_qemu_system_cfs.md`,
외부 제안 `docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`(이하 "제안서").
본 문서는 제안서 §7·§10·§11·§12·§13·§14·§15·§16을 실행한 결과다. Claude Code 환경(전용 컨테이너,
4 vCPU x86-64, KVM 없음 → QEMU TCG)에서 수행했다.

---

## 요약

- **TOPIC** — Stage 0이 단일 MLP·qemu-user에서 확인한 교차 ISA 계약 건전성을 (1) 시스템 에뮬레이션
  AArch64 Linux 게스트 안의 **cFS 앱**(A1–A7)과 (2) **Conv2D·multi-branch 모델**로 확장하고, (3) Stage 0에서
  발견한 AArch64 16 B 스택 프레임을 **태스크 스택 예산에 실제로 반영**했다.
- **Problem** — Stage 0의 RQ3(cFS admission의 타깃 독립성)는 미검증이었고, 계약 일반성은 MLP 1종에
  한정됐으며, 16 B 프레임은 "잠정 분류"였다. 또한 Stage 0의 계약 수치는 `scripts/62`가 **손으로 써넣은 값**이었다(§0.2).
- **Solution** — [TBD: 결과 요약 — 게스트 내 cFS A1–A7 결과, 3 모델 × 2 타깃 행렬, 스택 회계 근거]

---

## 0. 증거 등급과 방법론 정정

### 0.1 등급
- **결정론적(증거)**: vmfb sha256·크기, 계약 수치(bounded/per-call/constants), LLVM IR/ELF 구조(alloca·call·프레임·명령 수),
  HAL allocator 통계, admission/binding 판정, 카운터(attempted/completed/실패), 게스트 내 cFS 이벤트·상태 전이, 수치 출력(out).
- **비증거**: QEMU(system·user 모두)의 실행시간·RSS·jitter. 로그에는 남기되 결론에 쓰지 않는다(제안서 §14·§19).

### 0.2 정정 — Stage 0 계약 수치의 출처
`scripts/62_compile_and_check_aarch64.sh`는 계약 JSON의 `bounded_bytes`(786,476) 등을 **상수로 기입**했고,
IR 파싱(`static_mem_bound.py`)은 **별도의 두 번째 컴파일 호출**로 같은 값을 출력만 했다. 값 자체는 맞았지만
(§2.1에서 보관된 Stage 0 `layout_ir.txt`를 파싱해 재확인), "계약은 배치 아티팩트와 같은 호출의 IR에서 생성한다"는
v0.7 §1.3 규칙을 절차적으로 위반한 것이다. Stage 1은 `harness/make_contract.py`가 **같은 호출이 남긴 IR·vmfb·ELF에서만**
계약을 만들도록 고쳤다(결함 원장 D8).

### 0.3 정정·보강 — 아티팩트 바이트를 바꾸는 요인 (v0.7 §1.3의 정밀화)
같은 MLIR·같은 플래그로도 vmfb 바이트가 달라지는 원인을 통제 실험으로 특정했다(모두 결정론적):

| 변수 | 바이트 영향 | 근거 |
|---|---|---|
| 동일 명령 반복 | **없음** (4/4 동일 sha256) | 같은 경로·같은 dump 디렉터리로 반복 |
| `--mlir-print-ir-after`, `--mlir-elide-elementsattrs-if-larger` | **없음** | 출력 전용 플래그; 같은 dump 디렉터리에서 sha256 동일 |
| 입력 파일 **경로**(디렉터리 포함) | **있음** | 심볼명(basename, v0.7) + DWARF 파일 항목 |
| `--iree-hal-dump-executable-files-to` **디렉터리 경로** | **있음** | 임베디드 ELF `.debug_str`에 `<dump>/configured_module_infer_dispatch_{0,1}.mlir` 경로가 기록됨; 경로 길이만큼 ELF·vmfb 크기 변동 |
| dump 옵션 유무 | **있음** | dump 없이 컴파일하면 732,315 B(문자열이 짧음) |

**재현성 확인**: Stage 0과 같은 상대 경로(cwd=모델 디렉터리, 입력 `m16k_baked.mlir`, dump `aarch64/dump`)로 이 머신에서
컴파일하자 vmfb(sha256 `053d4973…`, 732,699 B)와 커널 ELF가 Stage 0 보관본과 **바이트 단위로 동일**했다.
→ 컴파일러는 결정론적이며, 재현 레시피에는 **상대 경로**가 포함돼야 한다. Stage 1의 모든 계약은 `provenance`에
입력 경로·dump 경로·layout IR sha256을 기록한다.

---

## 1. 환경 (제안서 §5·§6·§7·§16)

`results/e14_aarch64_qemu/environment/{host.txt,guest.txt,tool_versions.txt,commits.json}` 참조.

| 항목 | 값 |
|---|---|
| 호스트 | Ubuntu 24.04, x86-64 Xeon 4 vCPU, KVM 없음(TCG) |
| QEMU | 8.2.2, `-machine virt,gic-version=3 -cpu cortex-a53`, 실험 시 `-smp 1 -m 1024`(제안서 §5), UEFI AAVMF 2024.02 |
| 게스트 | Ubuntu 24.04.4 arm64 cloud image (sha256 `afa139ba…`), kernel 6.8.0-138, glibc 2.39, `uname -m`=aarch64, LP64, `lscpu`=Cortex-A53 |
| IREE | compiler 3.11.0rc20260316 @ e4a3b04 (pip), 런타임 소스 빌드 **같은 커밋**(x86-64 `build-rt`, aarch64 `build-rt-aarch64`; local-sync, embedded-ELF, threading off, ukernel off, PIC) |
| 크로스 툴체인 | aarch64-linux-gnu-gcc 13.3.0, binutils 2.42 (`-mcpu=cortex-a53`) |
| cFS | 번들 78c23b0 (cfe 2612eb0, osal 8111e4a, psp d1da809) — E12와 동일 커밋 |
| 게스트 준비 | `scripts/70_setup_qemu_system_aarch64.sh`(이미지·cloud-init·mqueue), `71_boot_guest_aarch64.sh`, `72_guest_ssh.sh` |

환경 함정(재발 방지): IREE 런타임 configure는 `runtime_submodules.txt`의 서브모듈(`hip-build-deps` 포함)을 모두 요구한다 — `scripts/40` 수정.

---

## 2. 아티팩트 행렬 (제안서 §8·§12·§13)

모델 4종(+교체용 3종) × 타깃 2종. 모든 항목은 **한 번의 `iree-compile` 호출**(`harness/e14_matrix.py compile`)로
vmfb·layout IR·실행 파일 덤프를 함께 생성했고, 계약은 그 산출물에서만 추출했다(`harness/e14_matrix.py extract` →
`make_contract.py` + `elf_stack_frame.py` + `gen_contract_header.py`).

| 모델 | 구조 | 입력→출력 | 파라미터 |
|---|---|---|---|
| mlp16k | E5–E13 베이킹 MLP h=16384 (`e14/m16k_baked.mlir`) | 1×9 → 1×2 | 180,224 (720,896 B) |
| conv2d | `gen_model_conv2d.py`: conv3×3×1×4 → bias+ReLU → conv3×3×4×8 → ReLU → flatten 128 → matmul 128×2 | 1×8×8×1 → 1×2 | 584 (2,336 B) |
| multibranch | `gen_model_multibranch.py`: h=ReLU(xW0); a=ReLU(hWa); b=ReLU(hWb); j=(a+b)+h (합류점에서 3 텐서 동시 생존) | 1×16 → 1×2 | 9,344 (37,376 B) |
| dynamic | E8 동적 배치 MLP(가중치 인자) | ?×9 → ?×2 | — |
| *_swap | 같은 ABI, 다른 바이트(seed 1; MLP는 h=4096 베이킹) | 동일 | — |

### 2.1 계약 수치

| 모델 | 타깃 | per-call(B) | 상수(B) | bounded(B) | vmfb bytes | vmfb sha256(16) | ELF bytes | alloca | call | frame(B) | 호출당 스택(B) |
|---|---|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|
| mlp16k | aarch64 | 65,580 | 720,896 | 786,476 | 732,795 | a439de2130def66b | 4,960 | 0 | 0 | 16 | 16 |
| mlp16k | x86_64 | 65,580 | 720,896 | 786,476 | 733,979 | 4d6f3807d37f0902 | 5,248 | 0 | 0 | 8 | 16 |
| mlp16k_swap(h=4096) | aarch64 | 16,428 | 180,224 | 196,652 | 192,140 | b0b4f6e5068052bf | 4,976 | 0 | 0 | 16 | 16 |
| mlp16k_swap(h=4096) | x86_64 | 16,428 | 180,224 | 196,652 | 193,308 | 9f0fd4b5fb845f9b | 5,248 | 0 | 0 | 8 | 16 |
| conv2d | aarch64 | 1,352 | 2,176 | 3,528 | 15,505 | f56ba5352cfcb036 | 6,344 | 4 | 0 | 128 | **191**(재정렬 패딩 63 포함) |
| conv2d | x86_64 | 1,352 | 2,176 | 3,528 | 16,601 | bd6bfd73b4705238 | 6,608 | 3 | 0 | 168 | **239**(재정렬 패딩 63 포함) |
| conv2d_swap | aarch64 | 1,352 | 2,176 | 3,528 | 15,614 | 9c685a3fcf170f4c | 6,368 | 4 | 0 | 128 | 191 |
| conv2d_swap | x86_64 | 1,352 | 2,176 | 3,528 | 16,710 | bce0633decbc97d5 | 6,632 | 3 | 0 | 168 | 239 |
| multibranch | aarch64 | 840 | 37,376 | 38,216 | 51,594 | bfd681833ef9c3b5 | 6,872 | 0 | 0 | 16 | 16 |
| multibranch | x86_64 | 840 | 37,376 | 38,216 | 53,186 | 0a62ca0e8f2bc3db | 7,568 | 0 | 0 | 8 | 16 |
| multibranch_swap | aarch64 | 840 | 37,376 | 38,216 | 51,679 | 4d4b7deb01200dfe | 6,888 | 0 | 0 | 16 | 16 |
| multibranch_swap | x86_64 | 840 | 37,376 | 38,216 | 53,207 | 6c7acb043f2d82a3 | 7,584 | 0 | 0 | 8 | 16 |
| dynamic | aarch64 | — | — | UNKNOWN_BOUND | 13,482 | b19498666a94c19d | 7,440 | 0 | 0 | 144(스필) | 144 |
| dynamic | x86_64 | — | — | UNKNOWN_BOUND | 18,914 | f7e165679424fffa | 12,040 | 0 | 0 | 3,376(스필) | 3,447 |

(`harness/make_contract.py`로 SAME 컴파일 호출의 산출물에서만 생성, `harness/elf_stack_frame.py`(§5) ELF 정적 분석 결합;
7모델×2타깃 전부 one-invocation 교차검증 통과 — §0.2 참조.)
**정적 계획(per-call/상수/bounded) 자체는 모든 모델에서 두 타깃이 완전히 같다** (Stage 0과 동일 이유:
`iree-stream-layout-slices`가 타깃별 코드생성보다 앞선 패스) — MLP뿐 아니라 Conv2D·multi-branch에서도 확인,
"이 모델 한정"이었던 Stage 0의 한계를 벗어난다. `dynamic`은 두 타깃 모두 `bound_method=NONE`(UNKNOWN_BOUND).

### 2.2 발견 — 256 B 이하 상수의 인라인 (conv2d)
IREE는 256 B 이하 상수를 dispatch 실행 파일 안으로 인라인한다. conv2d의 첫 커널(144 B)과 바이어스(16 B)는 HAL 상수 버퍼가
아니라 **임베디드 ELF의 rodata**에 있다: `module_resident_constant_bytes` 2,176 B < 소스 가중치 2,336 B(차이 160 B).
바이트 검색으로 vmfb 내 위치를 확인했다(k1·b1은 ELF 세그먼트 내부, k2·w3는 2,176 B 상수 풀 내부; x86 오프셋
10912/10848/4544/3520, aarch64 10080/10016/4544/3520). 분류: 제안서 §9.2의 **(3) 런타임 잔차 — 실행 파일 이미지**로
분류한다(HAL 계약 밖이나 미회계는 아님; ELF 크기로 회계됨). `contracts/contract.schema.json`에 `executable_elf_bytes`
필드로 기록한다.

---

## 3. Native 실행 — 게스트 내부 (제안서 §10)

[TBD: `scripts/82_run_native_guest.sh`로 게스트 내부에서 정적 링크 `native_learner_aarch64`를 각 모델(mlp16k, conv2d,
multibranch)에 대해 실행. ADMIT(1 MiB), 경계값 B-1/B/B+1, 모델 교체(swap) MISMATCH, 파일 부재, 손상 아티팩트(§4의 A5a/A5b와
동일 두 경로 — 게이트 단계 해시 불일치 vs. 계약이 손상 파일의 해시를 담고 있어 IREE 로드 자체가 실패하는 경우) 확인.
dynamic 모델은 UNKNOWN_BOUND로 즉시 거부(exit 6) 확인. 워밍업 200회, 측정 10,000회(제안서 §10.3). 시간값은 QEMU 게스트
내부 실행이라도 KVM이 아닌 TCG(호스트에 KVM 미탑재)이므로 비증거로 기록한다.]

---

## 4. cFS AI_LEARNER — 게스트 내부 (제안서 §11)

[TBD: `harness/e14_make_scenarios.py`로 모델별 A1–A7 + UNKNOWN_BOUND(A8) 시나리오를 생성하고
`harness/e14_cfs_scenarios.py`로 게스트에서 실행. 시나리오 정의:
A1 정상(1 MiB) / A2 예산 B-1·B·B+1 / A3 같은 ABI 모델 교체 / A4 파일 부재 /
A5a 손상 vmfb(게이트의 바이트 해시가 걸러냄) / A5b 손상 vmfb인데 계약이 그 손상 파일의 해시를 담고 있는 경우
(IREE 로드 자체가 안전하게 실패해야 함 — `runtime_load_failed` 이벤트, exit 없이 cFS는 OPERATIONAL 유지) /
A6 반복 추론(attempted==completed, 실패 0) / A7 ES 재시작×2 + 삭제(`harness/cfs_cmd.py`로 CI_LAB UDP 명령 전송,
매 재시작마다 정확히 1회의 cleanup, 이중 해제 없음).]

---

## 5. 16 B 스택 프레임의 회계 (제안서 §14-8)

### 5.1 정정(정정) — v0.8 §3 / v0.7 §4.3의 "x86-64는 스택 프레임이 없다"는 서술 정정

Stage 1에서 만든 `harness/elf_stack_frame.py`로 보관된 e13 아티팩트를 다시 분석한 결과, **x86-64 커널도 프레임
레코드를 갖는다**: `push %rbp; mov %rsp,%rbp … pop %rbp`가 host(0x15a0/0x1710)·generic(0x15b0에 `push %rbx` 추가/0x1690)
양쪽 dispatch 함수 모두에 있다. 원인은 LLVM IR 속성 `"frame-pointer"="all"`이 **두 타깃 모두**에 붙어 있기 때문
(각 `.ll`에 3회 출현) — AArch64에 한정된 현상이 아니다.

기존 v0.7 §4.3은 x86-64의 "스택 프레임"을 `sub $N,%rsp`(지역변수 할당)만으로 정의해 0으로 보고했고, v0.8 §3은
AArch64의 `stp x29,x30,[sp,#-16]!`(callee-save)을 프레임으로 잡아 16으로 보고했다 — **서로 다른 정의를 각 ISA에
적용한 것**(신규 결함 D9). `elf_stack_frame.py`는 두 ISA에 같은 정의(callee-save + 지역 할당 = frame_bytes; 호출
직전 스택에 실리는 복귀주소를 더한 것 = invocation_stack_bytes)를 적용한다:

| | x86-64 host | x86-64 generic | AArch64 |
|---|---:|---:|---:|
| callee-save (frame_bytes) | 8 B (`push %rbp`) | 16 B (`push %rbp,%rbx`) / 8 B | 16 B (`stp x29,x30`) |
| 복귀주소(호출 스택에 push) | 8 B | 8 B | 0 B(LR=x30, 프롤로그가 이미 저장) |
| **호출당 스택(invocation_stack_bytes)** | **16 B** | **24 B** | **16 B** |
| 지역 할당(`sub sp,sp,#N`) | 0 | 0 | 0 |
| 호출 명령 | 0 | 0 | 0 |

**결론**: mlp16k·multibranch에서 AArch64의 16 B는 **ISA 고유 이상 현상이 아니다** — x86-64도 같은 16 B(host
기준)를 쓰며, 복귀주소가 콜스택에 있는지(x86) 링크 레지스터에 있는지(AArch64)의 차이일 뿐이다. 두 ISA 모두
**(2) 태스크 스택 예산**으로 분류한다(호출 0개, 지역 변수 없음).

### 5.2 Conv2D의 추가 발견 — 실제 지역 변수 + 스택 재정렬

mlp16k·multibranch와 달리 conv2d는 `alloca`가 있다(디스패치당 2개, `alloca float, i64 4, align 64` 등 — bias/ReLU의
채널별 누산 버퍼). 코드에도 이를 반영하는 실제 스택 사용이 나타난다:

- **x86-64**: dispatch_0 callee-save 40 B + 지역 128 B + 재정렬 패딩 ≤63 B(`and $-64,%rsp`) → 프레임 168 B, 호출당
  176 B. dispatch_1 160/168 B.
- **AArch64**: `sub x9, sp, #0x70; and sp, x9, #0xffffffffffffffc0 …[함수 본문]… mov sp, x29` — 64바이트 정렬을
  위해 SP를 재계산하는 **동적 스택 재정렬** 시퀀스. `elf_stack_frame.py` 첫 버전은 이 패턴을 인식하지 못해
  callee-save 16 B만 보고했다(과소 계상) — [TBD: 도구 수정 후 재측정]. 코드상 지역 공간은 0x70(112 B)를 요청하고
  64바이트 경계로 재정렬하므로, 최악의 경우 16(레코드) + 112(지역) + 63(정렬 패딩) = **191 B**까지 쓸 수 있다.

**분류**: conv2d는 (2) 태스크 스택 예산에 **실측 지역 변수를 포함해** 분류해야 한다 — mlp16k·multibranch처럼
"고정 16 B, 호출 0개, 지역 없음"이 아니라 **정렬 요구가 있는 가변 크기 지역 버퍼**가 있다는 점이 다르다. 이는
제안서 §12가 Conv2D를 요구한 정확한 이유(tiling·workspace 구조)를 보여준다.

### 5.3 게스트 cFS 앱 반영

Stage 1의 `native/cfs_app/CMakeLists.txt`·시작 스크립트는 태스크 스택 크기를
`AI_LEARNER_STACK_BASE_BYTES(262,144, E12 이후 기본값) + CONTRACT_KERNEL_STACK_BYTES`로 설정하고, 앱은 자신의
`CFE_ES_GetAppInfo` 결과(`StackSize`)가 이 합계 이상인지 매 초기화마다 `stage:"stack"` JSON 줄로 보고한다(§4).
conv2d처럼 계약의 `kernel_task_stack_bytes`가 재정렬 패딩까지 포함한 최악값을 담도록 `make_contract.py`가
`max_dispatch_invocation_stack_bytes`(재정렬 도구 수정 후 값)를 사용한다.

---
## 3. Native 실행 — 게스트 내부 (제안서 §10) [TBD]

## 4. cFS AI_LEARNER — 게스트 내부 (제안서 §11) [TBD: A1–A7 × 3 모델 + dynamic]

## 5. 16 B 스택 프레임의 회계 (제안서 §14-8) [TBD]

## 6. 교차 타깃 비교 (제안서 §13) [TBD: comparison/cross_target.json]

## 7. 합격 기준 판정 (제안서 §14) [TBD: 9개 항목 표]

## 8. 판정 (v0.9) [TBD]

## 9. 한계 [TBD]

## 10. 재현 [TBD]
