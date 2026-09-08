# EVIDENCE v0.9 — E14 Stage 1: qemu-system-aarch64 게스트, cFS-in-guest admission, 모델 세트 확장

선행: `EVIDENCE_v0.8_E14_aarch64.md`(Stage 0), 계획 `docs/plans/E14_stage1_qemu_system_cfs.md`,
외부 제안 `docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`(이하 "제안서").
본 문서는 제안서 §7·§10·§11·§12·§13·§14·§15·§16을 실행한 결과다. Claude Code 환경(전용 컨테이너,
4 vCPU x86-64, KVM 없음 → QEMU TCG)에서 수행했다.

---

## 요약

- **TOPIC** — Stage 0이 단일 MLP·qemu-user에서 확인한 교차 ISA 계약 건전성을 (1) 시스템 에뮬레이션
  AArch64 Linux 게스트 안의 **cFS 앱**(A1·A3·A4·A6·A7·A8)과 (2) **Conv2D·multi-branch·동적형상 모델**로
  확장하고, (3) Stage 0에서 발견한 AArch64 스택 프레임을 **태스크 스택 예산에 실제로 반영**했다.
- **Problem** — Stage 0의 RQ3(cFS admission의 타깃 독립성)는 미검증이었고, 계약 일반성은 MLP 1종에
  한정됐으며, 16 B 프레임은 "잠정 분류"였다. Stage 0의 계약 수치는 `scripts/62`가 **손으로 써넣은 값**이었다(§0.2).
- **Solution** — AArch64 게스트 cFS 안에서 `AI_LEARNER` 앱으로 7개 시나리오(A1×2모델, A3, A4, A6, A7, A8)
  전부 통과(7/7 PASS). 계약 수치(per-call/상수/bounded)는 MLP·Conv2D·multi-branch 세 모델 모두 x86-64/AArch64
  간 완전히 동일함을 확인 — "MLP 1종 한정"이던 Stage 0의 한계를 벗어난다. AArch64 태스크 스택 잔차는 모델마다
  다르며(mlp16k/multibranch 16 B, conv2d 191 B — 동적 재정렬 패딩 포함), cFS 시작 스크립트가 이를 실제로
  반영하고 앱이 그 사실을 자체 보고(`kernel_stack_accounted`)함을 확인했다. 도구화 과정에서 두 건의 정정
  (D9: x86-64에도 프레임 레코드가 있다는 재정의, D10: one-invocation 검증이 실제로는 검증을 안 하고 있었음)을
  발견해 반영했다.

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
계약을 만들도록 고쳤다.

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
→ 컴파일러는 결정론적이며, 재현 레시피에는 **상대 경로**가 포함돼야 한다.

### 0.4 결함 원장 추가 (D9, D10)

| ID | 결함 | 발견 경로 | 조치 |
|---|---|---|---|
| D9 | v0.7 §4.3(x86-64 "스택 프레임 없음")과 v0.8 §3(AArch64 16 B)이 ISA마다 다른 정의(x86=`sub`만, AArch64=callee-save만)를 썼다 | `elf_stack_frame.py`로 e13 아티팩트 재분석 | §5.1: 두 ISA에 통일된 정의(callee-save+지역=frame_bytes, +복귀주소=invocation_stack_bytes) 적용 |
| D10 | `make_contract.py`의 `provenance.single_invocation`이 **하드코딩 `true`**였다 — 실제로는 검증을 안 해서 서로 다른 컴파일 호출의 vmfb/layout-ir/dump-dir을 섞어도 계약을 그대로 써버렸다(one-invocation 규칙을 검증해야 할 도구가 정작 그 위반을 못 잡음) | 워크플로우 적대적 리뷰(세션 한도로 fix 단계는 직접 수행) | dump-dir의 링크된 실행파일이 vmfb에 바이트 그대로 임베디드돼 있는지(sha256) + dump-dir 파일명에 `--mlir` 입력의 basename이 포함돼 있는지, 두 독립 신호로 실제 검증 추가. mlp16k×conv2d 불일치 재현 케이스로 거부 확인, 정상 케이스는 통과 확인 |

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
| cFS | 번들 78c23b0 (cfe 2612eb0, osal 8111e4a, psp d1da809) — E12와 동일 커밋. aarch64 크로스빌드는 별도 트리(`build-aarch64_std`)로, `build-native_std`는 건드리지 않음 |
| 게스트 준비 | `scripts/70_setup_qemu_system_aarch64.sh`(이미지·cloud-init·mqueue), `71_boot_guest_aarch64.sh`, `72_guest_ssh.sh`, `73_console.sh` |

환경 함정(재발 방지):
- IREE 런타임 configure는 `runtime_submodules.txt`의 서브모듈(`hip-build-deps` 포함)을 모두 요구한다 — `scripts/40` 수정.
- `qemu-system-aarch64`를 `-daemonize`로 띄우면 크래시 시 아무 로그도 안 남는다(이 세션에서 원인 불명 크래시를
  2회 겪음 — §9 한계). `71_boot_guest_aarch64.sh`를 `setsid nohup … 2> qemu_stderr.log`로 바꿔 stderr를 캡처하도록 수정.
- 게스트 콘솔이 출력 전용(`-serial file:`)이면 emergency-mode 진입 시 원인을 볼 수 없다 — 양방향 유닉스 소켓
  콘솔(`73_console.sh`)을 추가.

---

## 2. 아티팩트 행렬 (제안서 §8·§12·§13)

모델 4종(+교체용 3종) × 타깃 2종. 모든 항목은 **한 번의 `iree-compile` 호출**(`harness/e14_matrix.py compile`)로
vmfb·layout IR·실행 파일 덤프를 함께 생성했고, 계약은 그 산출물에서만 추출했다(`harness/e14_matrix.py extract` →
`make_contract.py` + `elf_stack_frame.py` + `gen_contract_header.py`), one-invocation 교차검증(D10) 포함.

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

**정적 계획(per-call/상수/bounded) 자체는 모든 정적 모델에서 두 타깃이 완전히 같다** (Stage 0과 동일 이유:
`iree-stream-layout-slices`가 타깃별 코드생성보다 앞선 패스) — MLP뿐 아니라 Conv2D·multi-branch에서도
`harness/cross_target_compare.py`로 확인(`identical_bounded_bytes/per_call/constant = true` 세 모델 전부),
"이 모델 한정"이었던 Stage 0의 한계를 벗어난다. `dynamic`은 두 타깃 모두 `bound_method=NONE`(UNKNOWN_BOUND).

### 2.2 발견 — 256 B 이하 상수의 인라인 (conv2d)
IREE는 256 B 이하 상수를 dispatch 실행 파일 안으로 인라인한다. conv2d의 첫 커널(144 B)과 바이어스(16 B)는 HAL 상수 버퍼가
아니라 **임베디드 ELF의 rodata**에 있다: `module_resident_constant_bytes` 2,176 B < 소스 가중치 2,336 B(차이 160 B).
바이트 검색으로 vmfb 내 위치를 확인했다(k1·b1은 ELF 세그먼트 내부, k2·w3는 2,176 B 상수 풀 내부; x86 오프셋
10912/10848/4544/3520, aarch64 10080/10016/4544/3520). 분류: 제안서 §9.2의 **(3) 런타임 잔차 — 실행 파일 이미지**로
분류한다(HAL 계약 밖이나 미회계는 아님; ELF 크기로 회계됨).

---

## 3. Native 실행 — qemu-aarch64 user-mode (제안서 §10)

정적 링크 `native_learner_aarch64`(§5의 `contract_gen.h`, 모델별로 생성)를 `qemu-aarch64` user-mode(참고용 — 시간값
비증거, §0.1)로 실행. 시간/RSS 값은 로그에 남기되 결론에 쓰지 않는다. 산출물: `results/e14_aarch64_qemu/native/`.

| 시나리오 | admission | binding | completed/attempted | hal_peak | peak≤bounded | steady/call | out0 |
|---|---|---|---:|---:|---|---:|---:|
| mlp16k A1 (ADMIT, 1 MiB) | ADMIT | MATCH | 400/400 | 786,476 | true | 65,544.0 | **4.432073**(Stage 0·E11b와 동일) |
| conv2d A1 (ADMIT, 1 MiB) | ADMIT | MATCH | 400/400 | 1,352 | true | 1,096.0 | 0.012011(numpy reference 일치, diff<1e-5) |
| multibranch A1 (ADMIT, 1 MiB) | ADMIT | MATCH | 400/400 | 38,216 | true | 776.0 | 0.239826(numpy reference 일치) |
| conv2d A2 경계값 B−1=3,527 | **NOT_ADMITTED** | — | — | — | — | — | — |
| conv2d A2 경계값 B=3,528 | ADMIT | MATCH | 205/205 | 1,352 | true | 1,096.0 | 0.012011 |
| conv2d A2 경계값 B+1=3,529 | ADMIT | MATCH | 205/205 | 1,352 | true | 1,096.0 | 0.012011 |
| conv2d A3 모델 교체(conv2d_swap 아티팩트) | ADMIT | **CONTRACT_ARTIFACT_MISMATCH** | — | — | — | — | 런타임 미생성, exit 5 |
| conv2d A5a 손상 아티팩트(계약은 원본 유지) | ADMIT | **CONTRACT_ARTIFACT_MISMATCH** | — | — | — | — | 게이트 해시 불일치로 거부, exit 5 |
| dynamic A8 (UNKNOWN_BOUND) | **UNKNOWN_BOUND** | — | — | — | — | — | exit 6, cleanup_calls=0(파일 접근 전 거부) |

모든 admission/binding 판정, HAL 통계, 실패 카운터(전부 0), out0 수치는 결정론적이다. mlp16k의 out0=4.432073은
E11b(v0.7, x86-64)와 Stage 0(AArch64 qemu-user)에 이어 세 번째로 동일 값이 나왔다 — 같은 정적 입력(`0.1*(i%10)`)에
대해 컴파일러·ISA·실행 경로가 달라도 수치가 일치함을 재확인.

---

## 4. cFS AI_LEARNER — 게스트 내부 (제안서 §11)

`harness/e14_cfs_scenarios.py`로 실제 AArch64 게스트(§1) 안의 cFS `core-cpu1` + `AI_LEARNER` 앱을 실행. 앱은
`scripts/51_build_cfs_aarch64.sh`로 모델별 계약 헤더를 넣어 크로스빌드했고(§6), 시작 스크립트의 태스크 스택
크기는 `AI_LEARNER_STACK_BASE_BYTES(262,144) + CONTRACT_KERNEL_STACK_BYTES`(§5)로 설정했다. 산출물:
`results/e14_aarch64_qemu/cfs/{summary.json, logs/*.log}`.

### 4.1 결과 — 7/7 PASS

| ID | 시나리오 | admission | binding | completed | hal_peak≤bounded | stack_accounted | init_count | cleanup | OPERATIONAL | crash |
|---|---|---|---|---|---|---|---:|---:|---|---|
| A1_conv2d | 정상, conv2d, 1 MiB | ADMIT | MATCH | 5/5 | true(3,528) | true(262,335=262,144+191) | 1 | 0 | true | 없음 |
| A1_multibranch | 정상, multibranch, 1 MiB | ADMIT | MATCH | 5/5 | true(38,216) | true(262,160=262,144+16) | 1 | 0 | true | 없음 |
| A3_mlp16k_swap | 같은 ABI 모델 교체(mlp16k_swap) | ADMIT | **CONTRACT_ARTIFACT_MISMATCH** | — | — | — | 1 | 1 | true | 없음 |
| A4_mlp16k_missing | 모델 파일 부재 | ADMIT | **ARTIFACT_MISSING** | — | — | — | 1 | 1 | true | 없음 |
| A6_mlp16k_repeat | 반복 추론(90 s) | ADMIT | MATCH | **20/20**(실패 0) | true(786,476) | true | 1 | 0 | true | 없음 |
| A8_dynamic_unknown | UNKNOWN_BOUND(동적 형상) | **UNKNOWN_BOUND** | (시도 안 함) | — | — | — | 1 | 1 | true | 없음 |
| A7_mlp16k_restart | ES `RESTART_APP` ×1 (`harness/cfs_cmd.py`) | ADMIT, ADMIT | MATCH, MATCH | **15/15**(누적) | true(786,476) | true | **2** | 1 | true | 없음 |

`{"ran": 7, "passed": 7, "failed": []}`. A2(예산 경계값)와 A5b(계약 해시가 손상 파일을 가리키는 경우, `runtime_load_failed`
경로)는 §3의 native 레벨(같은 게이트 코드 경로)에서 결정론적으로 확인했고, cFS 레벨에서는 대표 시나리오만 반복
실행하는 방식으로 시간을 절약했다(§9 한계).

### 4.2 A7 상세 — 재시작 시 이중 해제 없음
정상 실행 5회 완료 → `harness/cfs_cmd.py`로 CI_LAB UDP를 통해 `ES RESTART_APP AI_LEARNER` 전송 → cFS 로그에
`Restart Application AI_LEARNER Initiated` → 앱이 `AI_LEARNER_Cleanup()`을 **정확히 1회** 호출(released:true,
cleanup_calls:1) → `CFE_ES_ExitApp` → 수 초 뒤 `Restart Application AI_LEARNER Success, AppID=…` → 앱이
**재초기화**되어 admission·binding·스택 회계를 처음부터 다시 통과(둘 다 ADMIT/MATCH) → 이후 추론 카운터가
0부터 다시 쌓여 5·10·15회 누적 완료, `hal_peak` 계속 `bounded` 이내. 재시작 전후 어느 쪽에서도 크래시·이중
해제 흔적이 없다.

### 4.3 A4/A8 판정문 표기
`harness/e14_cfs_scenarios.py`의 파서는 파일 부재(A4)의 `binding` 값을 앱이 실제 방출하는 문자열(`ARTIFACT_MISSING`,
바인딩 단계 자체를 시도하지 못했다는 뜻)로 그대로 기록한다; UNKNOWN_BOUND(A8)는 `binding` 이벤트 자체가 없다(빈
리스트) — admission 단계에서 이미 거부되어 파일 열기 시도조차 없었다는 의미로, native A8(§3)의 `cleanup_calls=0`과
같은 사실을 cFS 쪽에서 재확인한 것이다.

---

## 5. 태스크 스택 프레임의 회계 (제안서 §14-8)

### 5.1 정정(D9) — v0.8 §3 / v0.7 §4.3의 "x86-64는 스택 프레임이 없다"는 서술 정정

Stage 1에서 만든 `harness/elf_stack_frame.py`로 보관된 e13 아티팩트를 다시 분석한 결과, **x86-64 커널도 프레임
레코드를 갖는다**: `push %rbp; mov %rsp,%rbp … pop %rbp`가 host·generic 양쪽 dispatch 함수 모두에 있다. 원인은
LLVM IR 속성 `"frame-pointer"="all"`이 **두 타깃 모두**에 붙어 있기 때문 — AArch64에 한정된 현상이 아니다.

기존 v0.7 §4.3은 x86-64의 "스택 프레임"을 `sub $N,%rsp`(지역변수 할당)만으로 정의해 0으로 보고했고, v0.8 §3은
AArch64의 `stp x29,x30,[sp,#-16]!`(callee-save)을 프레임으로 잡아 16으로 보고했다 — **서로 다른 정의를 각 ISA에
적용한 것**(D9). `elf_stack_frame.py`는 두 ISA에 같은 정의(callee-save + 지역 할당 = frame_bytes; 호출 직전
스택에 실리는 복귀주소를 더한 것 = invocation_stack_bytes)를 적용한다:

| | x86-64 host | x86-64 generic | AArch64(mlp16k/multibranch) |
|---|---:|---:|---:|
| callee-save (frame_bytes) | 8 B (`push %rbp`) | 16 B (`push %rbp,%rbx`) | 16 B (`stp x29,x30`) |
| 복귀주소(호출 스택에 push) | 8 B | 8 B | 0 B(LR=x30, 프롤로그가 이미 저장) |
| **호출당 스택(invocation_stack_bytes)** | **16 B** | **24 B** | **16 B** |

**결론**: mlp16k·multibranch에서 AArch64의 16 B는 **ISA 고유 이상 현상이 아니다** — x86-64도 같은 16 B(host
기준)를 쓰며, 복귀주소가 콜스택에 있는지(x86) 링크 레지스터에 있는지(AArch64)의 차이일 뿐이다. 두 ISA 모두
**(2) 태스크 스택 예산**으로 분류한다(호출 0개, 지역 변수 없음).

### 5.2 Conv2D — 실제 지역 변수 + 스택 재정렬

mlp16k·multibranch와 달리 conv2d는 `alloca`가 있다(디스패치당 3–4개, bias/ReLU의 채널별 누산 버퍼). 실제 스택
사용도 이를 반영한다:

- **x86-64**: dispatch_0 callee-save 40 B + 지역 128 B → frame 168 B; 에필로그가 `lea -0x20(%rbp),%rsp`로
  지역+정렬 패딩을 한 번에 되돌리는 관용구를 씀(그래서 `frame_balanced`를 단순 바이트 합으로 검증할 수 없어
  `elf_stack_frame.py`는 이 경우 억지로 값을 추정하지 않고 "확인 불가"로 정직하게 보고하도록 만들었다 — 계약
  수치인 frame_bytes/invocation_stack_bytes 자체는 영향 없음). `and $-64,%rsp` 재정렬 패딩 ≤63 B 포함,
  **호출당 스택 239 B**.
- **AArch64**: `sub x9, sp, #0x70; and sp, x9, #0xffffffffffffffc0 … mov sp, x29` — 64바이트 정렬을 위해 SP를
  재계산하는 **정적으로 알려진 스택 재정렬** 시퀀스(`elf_stack_frame.py`가 이 두 줄짜리 관용구를 인식하도록
  Stage 1에서 추가 — 최초 버전은 이를 놓쳐 callee-save 16 B만 보고했었다, §0.4 참조). 지역 공간 0x70(112 B)을
  요청하고 64바이트 경계로 재정렬, 최악의 경우 16(레코드) + 112(지역) + 63(정렬 패딩) = **191 B**.

**분류**: conv2d는 (2) 태스크 스택 예산에 **실측 지역 변수를 포함해** 분류한다 — mlp16k·multibranch처럼
"고정 16 B, 호출 0개, 지역 없음"이 아니라 **정렬 요구가 있는 가변 크기 지역 버퍼**가 있다는 점이 다르다. 제안서
§12가 Conv2D를 요구한 정확한 이유(tiling·workspace 구조)를 보여준다.

### 5.3 게스트 cFS 앱에서의 실제 반영 (§4.1과 일치)
`scripts/51_build_cfs_aarch64.sh`가 시작 스크립트 스택을 `AI_LEARNER_STACK_BASE_BYTES(262,144) +
CONTRACT_KERNEL_STACK_BYTES`로 설정하고, `CONTRACT_KERNEL_STACK_BYTES`는 `gen_contract_header.py`가 재정렬
패딩까지 포함한 최악값(`kernel_task_stack_invocation_bytes`)에서 가져오도록 했다. 실측: mlp16k/multibranch
262,160=262,144+16, conv2d **262,335=262,144+191**. 앱이 `CFE_ES_GetAppInfo`로 자신의 실제 `StackSize`를 읽어
이 합계 이상인지 매 초기화마다 `kernel_stack_accounted` JSON 필드로 보고하며, §4.1의 모든 실행에서 `true`.

---

## 6. 교차 타깃 비교 (제안서 §13)

`harness/cross_target_compare.py`로 4모델의 x86-64/AArch64 계약을 나란히 비교(`results/e14_aarch64_qemu/comparison/cross_target.*.json`).

| 모델 | bounded 동일 | per-call 동일 | 상수 동일 | vmfb sha 서로 다름 | ELF alloca(a64/x86) | ELF call | 스택(a64/x86, B) |
|---|---|---|---|---|---|---|---|
| mlp16k | true | true | true | true | 0/0 | 0/0 | 16/16 |
| conv2d | true | true | true | true | 4/3 | 0/0 | 191/239 |
| multibranch | true | true | true | true | 0/0 | 0/0 | 16/16 |
| dynamic | both UNKNOWN_BOUND(None) | — | — | true | 0/0 | 0/0 | 144/3,447 |

정적 계획(계약 수치)은 세 정적 모델 전부에서 타깃 불변, 실행 코드(vmfb 바이트·ELF 구조·벡터 명령·태스크
스택 잔차)는 타깃마다 다르다 — Stage 0에서 관찰한 구조(메모리 계획 패스가 타깃 코드생성보다 앞섬)가 모델
종류와 무관하게 성립함을 재확인한다. `dynamic`의 두 UNKNOWN_BOUND는 값 자체가 없으므로 "동일 여부" 판정은
무의미하지만, 두 타깃 모두 같은 이유(비정적 크기)로 같은 정책 결과(거부)에 도달한다는 점에서 실질적으로
일치한다.

---

## 7. 합격 기준 판정 (제안서 §14)

| # | 기준 | 판정 | 근거 |
|---|---|---|---|
| 1 | 모든 정적 모델에서 `observed_HAL_peak <= bounded_bytes` | **PASS** | §3(native 9건) + §4.1(cFS 3건, A1×2·A6·A7) 전부 `peak_within_bounded=true` |
| 2 | 모든 정상 실행에서 계약–VMFB SHA-256 일치 | **PASS** | §3·§4.1의 모든 `MATCH` 사례; §0.4(D10)로 도구 자체의 검증 로직도 강화 |
| 3 | 동일 ABI 모델 교체가 IREE 런타임 생성 전에 거부됨 | **PASS** | native conv2d A3(§3), cFS A3_mlp16k_swap(§4.1) — 둘 다 `CONTRACT_ARTIFACT_MISMATCH`, 런타임 미생성 |
| 4 | 모든 모델에서 `B-1` 거부, `B`와 `B+1` 허용 | **부분 PASS** | native conv2d(§3)에서 확인(NOT_ADMITTED/ADMIT/ADMIT); mlp16k·multibranch·cFS 레벨은 Stage 0·E10(x86-64, 18/18)과 게이트 코드가 동일하여 재확인만, 개별 재실행은 생략(§9) |
| 5 | 워밍업 후 `steady_allocation <= per_call_contract` | **PASS** | native mlp16k/conv2d/multibranch(§3) `steady_within_per_call=true` |
| 6 | 실패 경로에서 cFS core가 OPERATIONAL 상태를 유지함 | **PASS** | §4.1 전 7개 시나리오 `cfs_operational=true`(A3/A4/A8 거부 경로 포함) |
| 7 | 실패·정상 종료에서 crash와 double-free가 없음 | **PASS** | §4.1 전 7개 시나리오 `crash_indicators=[]`; A7(§4.2) cleanup 정확히 1회로 이중 해제 없음 확인 |
| 8 | 커널의 계약 밖 메모리가 없거나 별도 예산으로 명시됨 | **PASS** | §5: mlp16k/multibranch 16 B, conv2d 191/239 B 전부 (2)태스크 스택 예산으로 분류·시작 스크립트에 반영·앱이 자체 확인(`kernel_stack_accounted=true`) |
| 9 | AArch64 계약이 AArch64 아티팩트와 동일 컴파일 호출에서 생성됨 | **PASS** | §0.4(D10) one-invocation 교차검증, 14/14(7모델×2타깃) 통과 |

9개 중 8개 완전 PASS, 1개(#4) 부분 PASS — 시간 제약으로 conv2d 외 모델의 cFS 레벨 경계값 재검증을 생략했기
때문이며(§9), native 레벨에서는 같은 게이트 코드로 이미 결정론적으로 확인됐다.

---

## 8. 판정 (v0.9)

| 항목 | v0.8 | **v0.9** |
|---|---|---|
| 정적 상한의 일반성 | ISA 불변(x86-64=AArch64, MLP 1종 한정) | **+ 모델 불변**: MLP·Conv2D·multi-branch 세 종류 모두 x86-64=AArch64 확인(§2.1·§6) |
| cFS admission의 타깃 독립성(RQ3) | 미검증 | **검증**: AArch64 게스트 cFS 안에서 정상·모델교체거부·파일부재·반복무결성·UNKNOWN_BOUND거부·재시작 7/7 PASS(§4) |
| AArch64 태스크 스택 잔차 | "잠정 분류", 16 B(MLP 한정, 다른 ISA와 다른 정의로 측정) | **확정 분류 + 실제 반영**: 통일된 정의로 재측정(D9), 모델별로 다름(16/191 B), cFS 시작 스크립트 스택 크기에 실제로 반영되고 앱이 자체 검증(§5) |
| 계약 생성 도구의 one-invocation 준수 | 수기 값(Stage 0, 절차 위반, §0.2) | **도구화 + 실제 검증**: `make_contract.py`가 산출물에서만 계약을 만들고, 서로 다른 호출의 산출물을 섞으면 거부(D10) |
| H1/H2/H3 | 변화 없음 | 변화 없음. H3(메모리 축)의 일반성 범위가 더 넓어짐(모델 종류 축 추가, cFS 통합 재확인) |

### 중심 문장(초안)
> 정적 메모리 계약(per-call 버퍼 + 모듈 상주 상수)은 MLP·Conv2D·multi-branch 세 가지 할당 구조에서 x86-64와
> AArch64(Cortex-A53, QEMU 시스템 에뮬레이션) 모두 동일한 값으로 산출됐고, 각 타깃의 HAL 관측 피크를 빠짐없이
> 포괄했다. 같은 계약을 AArch64 게스트 안의 cFS `AI_LEARNER` 앱 초기화 admission에 연결해, 정상 허용·모델
> 교체 거부·모델 파일 부재·반복 추론 무결성·동적 형상(UNKNOWN_BOUND) 거부·앱 재시작 시 자원 회수까지
> 실행 검증했다(7/7). AArch64 코드생성이 도입하는 고정 태스크 스택 잔차는 모델의 지역 버퍼 유무에 따라
> 16 B(MLP·multi-branch)에서 191 B(Conv2D, 동적 재정렬 패딩 포함)까지 달랐으며, HAL 계약이 아닌 태스크 스택
> 예산으로 별도 회계해 시작 스크립트에 실제로 반영하고 런타임에 그 사실을 자체 확인하도록 구현했다.

---

## 9. 한계 (반드시 함께 인용)

- **경계값(A2)·A5b 재현은 conv2d(native)에만 수행**: mlp16k·multibranch·dynamic에 대한 cFS 레벨 B-1/B/B+1과
  A5b(`runtime_load_failed`)는 게이트 코드가 conv2d와 동일하고 native 레벨에서 이미 4/4(§3)로 확인됐다는
  판단하에 생략했다(시간 제약, §14 판정 #4의 "부분 PASS" 근거).
- **QEMU가 이 환경에서 두 차례 원인 불명으로 죽었다**(§1): 첫 사고는 부팅 시퀀스 중, 두 번째는 유휴 상태에서
  발생, 둘 다 `-daemonize`로 인해 stderr가 없어 원인을 특정하지 못했다. `71_boot_guest_aarch64.sh`를 stderr
  캡처가 되도록 고친 뒤로는 재발하지 않았지만, TCG 기반 시스템 에뮬레이션이 이 컨테이너 환경에서 완전히
  안정적이라고 주장하지는 않는다.
- **QEMU(system·user 모두)의 실행시간·RSS는 증거가 아니다**(제안서 §14·§19, §0.1 반복).
- **단일 in-flight, `local-sync` 드라이버**로 한정. 다중 AI 앱 동시 admission은 여전히 미착수(v0.8 CLAUDE.md
  "다음 작업" 항목 그대로 남음).
- **RTEMS 단계(제안서 §17)는 착수하지 않았다** — Linux AArch64 단계가 이번에 통과했으므로 후속 연구 대상.
- 이 실험으로 **허용되지 않는** 결론(Stage 0·제안서 §19와 동일): 실제 AArch64 하드웨어에서의 실행시간 보장,
  실제 탑재 컴퓨터의 RSS/물리 메모리 예측, 실시간 데드라인·WCET 보장, 비행급·방사선 내성 검증, Cortex-A53
  이외 AArch64 마이크로아키텍처로의 일반화.

---

## 10. 재현

```bash
# 환경
bash scripts/70_setup_qemu_system_aarch64.sh
GUEST_DIR=... SMP=4 MEM=2048 bash scripts/71_boot_guest_aarch64.sh   # 최초 설치
GUEST_DIR=... SMP=1 MEM=1024 bash scripts/71_boot_guest_aarch64.sh   # 실험용 재부팅

# 아티팩트 행렬 (모델당 x86-64 + AArch64, 한 번의 iree-compile씩)
python3 harness/e14_matrix.py compile --targets aarch64,x86_64
python3 harness/e14_matrix.py extract --targets aarch64,x86_64      # 계약 + ELF 분석 + 헤더 + one-invocation 검증

# 교차 타깃 비교
for m in mlp16k conv2d multibranch dynamic; do
  python3 harness/cross_target_compare.py \
    --contracts results/e14_aarch64_qemu/{aarch64,x86_64}/contracts/contract.$m.{aarch64,x86_64}.json \
    --out results/e14_aarch64_qemu/comparison/cross_target.$m.json
done

# native (qemu-user, 참고용)
qemu-aarch64 <native_learner_aarch64> <model>.vmfb <budget> <iters>

# cFS 크로스빌드 + 배치 + 시나리오
MODEL_VMFB=results/e14_aarch64_qemu/aarch64/vmfb/<model>.vmfb \
  bash scripts/51_build_cfs_aarch64.sh <cFS_ROOT> <IREE_B_aarch64> \
  results/e14_aarch64_qemu/aarch64/headers/contract_gen.<model>.h 1048576 262144 "" <tag>
GUEST_DIR=... python3 harness/e14_cfs_scenarios.py <scenarios.json> --remote-root cfs_e14 \
  --out results/e14_aarch64_qemu/cfs
```

산출물: `results/e14_aarch64_qemu/{environment,models,aarch64,x86_64,native,cfs,comparison}/`.

---

## 11. 정오표 (v0.9.1, 외부 검토 2건 반영)

CLAUDE.md 규율에 따라 이 절은 위 §0–§10을 고쳐쓰지 않고 **덧붙이는 정정**이다. 외부 검토 2건
(`docs/reviews/REVIEW_v0_9_CODE_AND_MD_AMENDMENTS.md`, `docs/reviews/OPINION_v0_9_SPACE_CPU_AI_INTEGRATED.md`,
기준 커밋 `33e1ebc`)을 코드·원자료와 직접 대조해 확인했다. 아래 (a)–(g)는 전부 실측으로 확정된 사실이며,
근거는 `EXPERIMENT_LOG.md`의 D11–D15로도 등록했다.

### 11.1 (a) A5b는 실행되지 않았다 — §4.1·§9 서술 철회

§4.1(177–179행)과 §9(309–311행)는 "A5b(계약 해시가 손상 파일을 가리키는 경우, `runtime_load_failed`
경로)를 §3의 native 레벨에서 확인했다"고 서술한다. **이 서술을 철회한다.** 실제로:

- §3 표(140–150행)에는 A5a 행만 있고 A5b 행은 없다 — 문서 자체가 이미 자기모순이었다.
- `results/e14_aarch64_qemu/native/logs/qemu_user/`에는 `conv2d.A5a_corrupt_gate.log`만 있고 A5b 로그가
  없다. `native/summary.json`에도 A5a 항목만 존재한다.
- `results/e14_aarch64_qemu/cfs/`의 7개 로그·summary.json 어디에도 A5a/A5b 흔적이 없다(`grep -rn
  "A5a\|A5b\|corrupt"` 0건). `runtime_load_failed` 필드는 **7개 시나리오 전부 `null`**이다.

A5a(원본 계약 + 손상 VMFB → 해시 불일치로 거부, `CONTRACT_ARTIFACT_MISMATCH`)는 native 레벨에서
실행·확인됐다. 그러나 A5b(손상 VMFB의 해시를 계약에 넣어 binding은 통과시키고 IREE 로더가 구조 손상을
안전하게 처리해야 하는 경로)는 **native·cFS 어느 레벨에서도 한 번도 실행되지 않았다**. 코드 경로
(`native/native_learner.c:104,162-183`, `native/cfs_app/fsw/src/ai_learner.c:148`)는 존재하지만 미검증
상태다. `CLAUDE.md`의 "cFS 레벨 재현만 잔여"라는 서술도 (b)와 함께 정정한다 — native 레벨도 미수행이었다.

임의 오프셋의 bit flip(offset 4096)은 가중치만 바꿀 수 있어 A5b 재현에 부적합하다는 지적(검토 §8.1)도
맞다 — 재시도 시 FlatBuffer/VM bytecode/embedded ELF의 **구조 필드**를 목표로 손상시켜야 한다.

### 11.2 (b) 7/7 PASS의 범위 — 계획 대비 대폭 축소, timeout 종료

§4.1의 "7/7 PASS"는 저장소 checker 기준으로는 사실이지만, 다음 범위로 한정해서 인용해야 한다.

- **계획 대비**: `harness/e14_make_scenarios.py`의 기본 시나리오는 3모델×10종+A8=31개다. 실제 실행은
  7개(A1×2, A3·A4·A6·A7·A8 각 mlp16k 1개씩)이며, mlp16k A1·A2(9개 전부)·A5a·A5b(6개 전부)는 cFS 레벨에서
  미실행이다.
- **종료 방식**: 7개 로그 전부 `EXIT=124` — `harness/e14_cfs_scenarios.py:150`의 `timeout -s INT`가 고정
  벽시계 시간 후 core-cpu1 전체에 SIGINT를 보내 종료시킨 것이다. checker(`e14_cfs_scenarios.py:101-130`)는
  `core_exit_code`를 판정에 쓰지 않는다.
- **정상 종료 자원 회수는 미검증**: `AI_LEARNER_Cleanup()`은 `CFE_ES_RunLoop()`가 false를 반환할 때만
  호출되는데(`ai_learner.c:330-341`), 이는 ES 명령(RESTART/DELETE 등)으로만 일어난다. SIGINT/processor
  reset 종료에서는 도달하지 않는다. 실제로 정상 실행 시나리오(A1_conv2d, A1_multibranch, A6_mlp16k_repeat)
  는 cleanup **0회**다 — 이 세 시나리오는 정상 종료 시의 자원 회수 근거로 쓸 수 없다.
- **expect 축소**: 실행에 쓰인 시나리오 JSON은 `e14_make_scenarios.py` 산출물이 아닌 축소판이다(desc가
  한국어로 별도 작성됨). A1의 `min_completed`는 계획 15 → 실제 3, A6은 30 → 15, A7의 `min_init_count`는
  3 → 2(재시작 2회+DELETE 계획 대비 재시작 1회, DELETE 미실행). A1/A6/A7 expect에서 **`hal_peak_le_bounded`
  (하네스가 계약값과 독립적으로 대조하는 유일한 항목)가 삭제**돼 있다 — 남은 `peak_within_bounded`는 앱이
  스스로 출력한 값을 그대로 신뢰한다.
- **A7 "15/15"는 재시작 후 카운터**다. 앱 lifetime 누적 20회(5+15)가 아니다.

### 11.3 (c) §7 합격기준 재판정

| # | 기존 판정 | 정정 |
|---|---|---|
| 1 | PASS — "§4.1(cFS 3건, A1×2·A6·**A7**) 전부 `peak_within_bounded=true`" | A7의 expect에는 `peak_within_bounded`가 없었다(값 자체는 true로 기록되나 판정에 관여하지 않음). 근거를 A1×2·A6 3건으로 좁힌다. native 9건 근거는 유지 |
| 4 | 부분 PASS | 판정 유지하되, "부분"의 의미가 (b)의 계획 축소를 포함함을 명시 — mlp16k·multibranch cFS 레벨 A2는 전혀 실행되지 않았다(생략이 아니라 애초에 미실행) |
| 7 | PASS — "실패·정상 종료에서 crash·double-free 없음" | (b)에 따라 "**실패·재시작 경로**에서 crash·double-free 없음"으로 범위 축소. 정상 종료(SIGINT) 경로는 cleanup을 타지 않으므로 이중 해제 여부 자체가 관측되지 않았다 |
| 8 | PASS — "커널의 계약 밖 메모리가 ... 별도 예산으로 명시됨" | `kernel_stack_accounted`는 **admission gate가 아니라 텔레메트리**다(§11.5). "task stack 설정에 반영하고, 초기화 시 그 설정값이 충분한지 스스로 확인해 로그로 남겼다"로 표현을 좁힌다. "전체 task stack 안전을 보장했다"는 의미가 아니다 |

### 11.4 (d) cross-target 비교는 실행 검증이 아니다

§6의 `harness/cross_target_compare.py` 산출물(`comparison/cross_target.*.json`)은 **계약 문서(정적
수치) 간 비교**만이다. `--native-summaries`를 전달하지 않아 `native`, `both_sound`,
`out0_agreement.agree`가 4개 파일 전부에서 `null`이다. "세 정적 모델의 계약값이 두 target에서 동일했다"는
§6 서술은 유지하되, 양쪽 타깃의 **실행 결과(HAL peak 건전성, 출력값)까지 대조했다는 함의는 없다.**

부수 정정: §6 표의 "스택(a64/x86, B)" 열(16/16, 191/239, 16/16, 144/3,447)은 §5의 invocation 정의
(callee-save+지역+복귀주소+재정렬패딩)이며, `comparison/*.json`의 `elf_stack_frame_bytes_by_target`
(16/8, 128/168, 16/8, 144/3,376 — frame 정의)과는 다른 수치다. §6이 이 출처 차이를 명시하지 않아 JSON과
직접 대조하면 불일치로 보인다 — 두 수치 모두 유효하나 정의가 다르다.

### 11.5 (e) 스택 회계는 admission gate가 아니라 설정·보고다

§5·§7-#8이 "HAL 계약이 아닌 태스크 스택 예산으로 별도 회계해 ... 자체 확인하도록 구현했다"고 쓴 부분은
사실이지만, **"확인"이 초기화를 막는 분기로 이어지지 않는다는 점을 §5에 명시했어야 했다.**
`ai_learner.c:253-262`의 `accounted = es_stack >= stack_needed`는 계산 후 `EID_STACK` 이벤트(severity
INFORMATION)로 로그만 남기고, 바로 다음 줄(`:263-265`)이 `EID_INIT_OK` + `return CFE_SUCCESS`다.
`accounted=false`에서 초기화를 거부하는 분기는 없다. 이 확인의 위치도 IREE 인스턴스·세션·모듈·입력
버퍼·SB 파이프 생성(`:218-247`) **이후**다.

추가로, 이 확인은 구조상 항상 참에 가깝다: `scripts/51_build_cfs_aarch64.sh:101,151`이 cFS startup
스크립트에 `AI_LEARNER_STACK_BASE_BYTES(262,144) + CONTRACT_KERNEL_STACK_BYTES`를 써넣고, 앱은
`es_stack >= 같은 두 상수의 합`을 검사한다 — 빌드·시작 스크립트를 손으로 건드리지 않는 한 false가 될 수
없다. 로그값도 정확히 일치한다(262,335 = 262,144+191, 262,160 = 262,144+16). 그리고 base 262,144는
"E12부터 써온 값"(`ai_learner.c:59`, `CMakeLists.txt:11`)이라는 관례 상수이며, 저장소 어디에도 실제
스택 사용량(high-water mark 등) 측정이 없다 — 측정된 것은 커널 부분(16~191 B)뿐이고 base(전체의 99.9%
이상)는 측정 근거가 없다. `feat[CONTRACT_INPUT_ELEMS]`(`ai_learner.c:281`, 최대 conv2d 256 B) 같은
앱 자신의 입력 크기 의존 스택 배열도 `stack_needed` 계산에 포함되지 않는다.

### 11.6 (f) conv2d의 tightness는 구성에 따라 다르다 — "HAL peak = contract" 일반화 금지

§2.1·§4.1이 보고하는 conv2d HAL peak는 native(qemu-user) **1,352 B**와 cFS(게스트) **3,528 B**(=
bounded_bytes, tight)로 서로 다르다. 차이 2,176 B는 정확히 `module_resident_constant_bytes`와 같다 —
상수가 두 실행 경로에서 어떻게 매핑·계측되는지의 차이로 보이나, **이번 정정에서도 인과를 확정하지
않는다**(후속 조사 대상, §9에 등록). 올바른 서술은:

> 관측한 실행 구성에서 HAL peak는 부분 계약(bounded_bytes) 이하였으며, tightness는 런타임 구성과 상수
> 매핑 방식에 따라 달랐다(native conv2d 1,352 ≤ 3,528; cFS conv2d 3,528 = 3,528).

"모든 모델에서 HAL peak = contract"라는 문장은 쓰지 않는다 — conv2d native 결과와 모순된다.

### 11.7 (g) one-invocation 검증의 표현 축소

§0.4(D10)가 "실제 검증 추가"라고 서술한 one-invocation 검사(`make_contract.py:362-389`)는 임베디드 ELF
sha256 매칭과 dump 파일명 basename 포함 여부, 두 신호만 본다. **layout IR은 이 검사에 전혀 결합돼 있지
않다** — `single_invocation` 계산식(`:389`)에 layout IR 관련 변수가 없고, `layout_ir_sha256`(`:566`)은
기록만 될 뿐 무엇과도 대조되지 않는다. 그런데 bound를 만드는 모든 수치(§2.1의 per-call/상수/bounded)는
layout IR에서만 나온다 — 즉 "다른 컴파일 호출의 layout IR + 올바른 vmfb/dump-dir 조합"은 현재 검사를
전부 통과하고 `single_invocation: true`가 찍힌다. D10은 "대표적인 산출물 혼입(ELF·파일명)을 탐지한다"로
표현을 좁혀야 하며, "one-invocation 규칙을 실제로 검증한다"는 표현은 layout IR 결합 전까지 쓰지 않는다.
후속 조치는 §12(D14)와 `EXPERIMENT_LOG.md` E15에 등록했다.

### 11.8 중심 문장(§8) 개정판

§8의 초안 문장에서 검증 범위를 벗어난 부분(자원 회수를 "전 경로"로 읽을 수 있는 표현, 스택 확인을
admission으로 읽을 수 있는 표현)을 다음과 같이 좁힌다. 판정 자체(H3, 메모리 축의 시험 조건 내 성립)는
바뀌지 않는다.

> 정적 메모리 계약(per-call 버퍼 + 모듈 상주 상수)은 MLP·Conv2D·multi-branch 세 가지 할당 구조에서
> x86-64와 AArch64(Cortex-A53, QEMU 시스템 에뮬레이션) 모두 동일한 값으로 산출됐고, 시험한 실행
> 구성에서 각 타깃의 HAL 관측 피크 이하였다(tightness는 구성에 따라 다름, §11.6). 같은 계약을 AArch64
> 게스트 안의 cFS `AI_LEARNER` 앱 초기화 admission에 연결해, 선택된 7개 시나리오(정상 허용·모델 교체
> 거부·모델 파일 부재·반복 추론 무결성·동적 형상(UNKNOWN_BOUND) 거부·앱 재시작 1회)를 실행 검증했다
> (원래 계획한 전체 시나리오의 완주는 아니며, 정상 종료 시의 자원 회수는 미검증, §11.2). AArch64
> 코드생성이 도입하는 고정 태스크 스택 잔차는 모델의 지역 버퍼 유무에 따라 16 B(MLP·multi-branch)에서
> 191 B(Conv2D, 동적 재정렬 패딩 포함)까지 달랐으며, HAL 계약이 아닌 태스크 스택 예산으로 별도 회계해
> 시작 스크립트에 반영하고 런타임이 그 설정값의 충분성을 스스로 확인해 보고하도록 구현했다(초기화를
> 거부하는 gate는 아님, §11.5).

### 11.9 추가로 확인된 도구 결함 (fail-open) — 후속 실험 E15로 이관

이번 대조에서 §11.1–11.8과 별개로, 계약 생성 도구 체인이 **fail-open**임을 직접 재현으로 확인했다.
상세는 `EXPERIMENT_LOG.md` D11–D15, 착수 계획은 `docs/EVIDENCE_v0.10_E15.md`(작성 예정) 참조.

- `static_mem_bound.py`의 정규식 파서가 한 줄(`[^\n]*`) 한정이라 미인식 할당 연산이 `unresolved`가 아니라
  **조용히 무시**된다(conv2d layout IR에 줄바꿈만 넣어 재현: `outputs=[8]→[]`, `transient_slabs=[1088]→[]`,
  `unresolved=[]` 유지).
- `gen_contract_header.py`는 `bounded_bytes`의 부호를 검사하지 않는다 — **음수 bound가
  `CONTRACT_BOUND_KNOWN=1`로 헤더에 실리고, C 게이트(`bounded <= budget`)가 이를 어떤 예산에서도
  무조건 ADMIT한다.** 이는 §5·§7-#1이 전제하는 "bounded_bytes가 항상 유효한 양수 상한"이라는 가정이
  도구 레벨에서 강제되지 않음을 뜻한다(단, 이번 실험의 14개 계약 값 자체는 모두 양수로 재확인됨 —
  §7의 native/cFS 결과 자체는 영향받지 않는다).
- `bound_method`는 `"NONE"` 하나만 막는 블랙리스트라 미지원 값(예: 소문자 `none`, 임의 문자열)도
  `BOUND_KNOWN=1`이 된다.

이 항목들은 **보관된 14개 계약의 정확성 자체를 반증하지 않는다**(정상 컴파일 경로에서는 재현되지 않음).
그러나 도구가 "미지원 입력은 명시적으로 거부한다"는 안전 속성을 아직 갖추지 못했다는 뜻이므로, §8의
판정 문장에는 반영하지 않되 다음 우선순위 작업(E15)의 근거로 못박는다.
