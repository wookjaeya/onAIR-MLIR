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
| multibranch | `gen_model_multibranch.py`: h=ReLU(xW0); a=ReLU(hWa); b=ReLU(hWb); j=(a+b)+h; y=jW2 (합류점에서 3 텐서 동시 생존) | 1×16 → 1×2 | 9,344 (37,376 B) |
| dynamic | E8 동적 배치 MLP(가중치 인자) | ?×9 → ?×2 | — |
| *_swap | 같은 ABI, 다른 바이트(seed 1; MLP는 h=4096 베이킹) | 동일 | — |

### 2.1 계약 수치 [TBD 표: 모델 × 타깃: transient / io / per-call / constants / bounded / vmfb sha·bytes / ELF bytes / alloca / call / frame]

### 2.2 발견 — 256 B 이하 상수의 인라인 (conv2d)
IREE는 256 B 이하 상수를 dispatch 실행 파일 안으로 인라인한다. conv2d의 첫 커널(144 B)과 바이어스(16 B)는 HAL 상수 버퍼가
아니라 **임베디드 ELF의 rodata**에 있다: `module_resident_constant_bytes` 2,176 B < 소스 가중치 2,336 B(차이 160 B).
바이트 검색으로 vmfb 내 위치를 확인했다(k1·b1은 ELF 세그먼트 내부, k2·w3는 2,176 B 상수 풀 내부).
분류: 제안서 §9.2의 (3) **런타임 잔차 — 실행 파일 이미지**(ELF 크기로 회계), HAL 계약 밖이나 미회계 아님.
[TBD: 계약 필드 `executable_elf_bytes`로 기록]

---

## 3. Native 실행 — 게스트 내부 (제안서 §10) [TBD]

## 4. cFS AI_LEARNER — 게스트 내부 (제안서 §11) [TBD: A1–A7 × 3 모델 + dynamic]

## 5. 16 B 스택 프레임의 회계 (제안서 §14-8) [TBD]

## 6. 교차 타깃 비교 (제안서 §13) [TBD: comparison/cross_target.json]

## 7. 합격 기준 판정 (제안서 §14) [TBD: 9개 항목 표]

## 8. 판정 (v0.9) [TBD]

## 9. 한계 [TBD]

## 10. 재현 [TBD]
