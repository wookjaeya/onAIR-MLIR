# EVIDENCE v0.12 — E17: AArch64 게스트 재현 (A5b 최초 실행, A2 경계값, 재시작 2회+DELETE)

## 0. 등급과 범위

**증거 등급: 결정론적**(admission/binding/stack/runtime_load_failed verdict, exit code, cleanup
카운터, EVS 이벤트, JSON 필드) + **결과 재현 확인용 실행**(qemu-system-aarch64 게스트 안에서 실제
`core-cpu1` 기동). 지연값(`mean_us` 등)은 인용하지 않는다 — QEMU TCG 수치는 여전히 비증거
(`docs/EVIDENCE_v0.9_E14_stage1.md` §0.1).

**환경**: 이 세션에서 AArch64 크로스 툴체인(`scripts/60`), IREE 런타임 AArch64 크로스 빌드
(`scripts/61`), qemu-system-aarch64 게스트 이미지(`scripts/70`, Ubuntu 24.04 noble arm64 cloud
image)를 처음부터 준비하고 게스트를 부팅했다(`scripts/71`, SMP=4 MEM=2048, ~170초 만에 정상
기동 — 이번 세션에서는 원인불명 크래시 재발 없음). cFS를 AArch64로 크로스빌드(`scripts/51`,
E16에서 수정된 `ai_learner.c`/`native_learner.c` 소스 포함)해 게스트에 배포했다.

## 1. 배경

이 실험은 `docs/EVIDENCE_v0.9_E14_stage1.md` §11.9와 두 외부 검토가 "환경 재구축 필요"로 남긴
AArch64 게스트 레벨 격차를 닫는다:

- **A5b가 native·cFS 어느 레벨에서도 한 번도 실행되지 않았다**(§11.1, D11) — 이 연구에서 가장 심각한
  증거-서술 불일치였다.
- mlp16k·multibranch의 cFS 레벨 A2(경계값 B-1/B/B+1) 미실행(conv2d만 v0.9에서 확인됨).
- A7이 재시작 1회에 그침(원 계획: 재시작 2회 후 DELETE).
- E16(v0.11)의 신규 C 게이트(스택 실거부, blob 크기 선검사)가 x86-64에서만 검증됐고 AArch64
  타깃에서는 확인되지 않았다.

## 2. A5b — 구조 손상 기반, 최초 실행 (핵심 결과)

### 2.1 손상 방법

`.vmfb`는 ZIP 컨테이너다(`module.fb`= VM bytecode FlatBuffer, `_const.bin`= 가중치,
`*_linked_embedded_elf_*.so`= 임베디드 ELF 커널). 리뷰가 요구한 대로 임의 bit flip이 아니라
`module.fb`의 **첫 4바이트(FlatBuffer 자신의 root-table uoffset)**를 `0xFFFFFFFF`로 고쳐 재압축
했다 — 텐서/가중치 데이터가 아니라 VM bytecode 구조 필드를 정확히 겨냥한 손상이다. 계약은 손상된
파일의 실제 `artifact.bytes`/`sha256`으로 갱신해(정상 계약 생성 파이프라인이 아니라 이 적대적
시험만을 위해 수작업 구성) **binding이 MATCH되도록** 만들었다 — A5b의 정의(계약 해시가 손상 파일을
가리키는 경우) 그대로.

### 2.2 결과 — x86-64 native, x86-64 cFS(native_std), **AArch64 cFS(게스트) 세 레벨 모두 확인**

| 레벨 | admission | binding | runtime_load_failed | cleanup_calls | cFS 상태 |
|---|---|---|---|---|---|
| x86-64 native_learner | ADMIT | MATCH | `append_bytecode_module`: `INVALID_ARGUMENT; FlatBuffer length prefix out of bounds (prefix is 4294967295 but only 733697 available)` | 1 | exit 7 |
| x86-64 cFS `AI_LEARNER`(native_std) | ADMIT | MATCH | 동일 오류 문자열 | 1 | OPERATIONAL 유지 |
| **AArch64 cFS `AI_LEARNER`(게스트)** | ADMIT | MATCH | `append_bytecode_module`: `INVALID_ARGUMENT; FlatBuffer length prefix out of bounds (prefix is 4294967295 but only 732513 available)` | 1 | OPERATIONAL 유지 |

세 레벨 모두 크래시 지표(`Segmentation fault`, `double free`, `SIGSEGV`, `SIGABRT` 등) 전무. IREE의
FlatBuffer 검증기가 구조 손상을 안전하게 거부하고, `runtime_load_failed` → `AI_LEARNER_Cleanup()`
(D4 순서) → 초기화 실패로 이어지는 경로가 실제로 실행되는 것을 처음으로 확인했다.

**이것으로 `docs/EVIDENCE_v0.9_E14_stage1.md` §11.1(D11)이 "미검증"으로 남긴 A5b를 실제 실행 증거로
채운다.** 정오표는 철회를 유지한다(v0.9의 원래 서술은 여전히 사실무근이었다) — 이 문서가 그 후속으로
실제 실행 결과를 제공한다.

## 3. A2 경계값 — mlp16k·multibranch (native + cFS, 두 타깃)

conv2d는 v0.9에서 이미 4/4(native)로 확인됐다. 이번엔 나머지 두 정적 모델을 x86-64에서 확인했다
(AArch64 게스트에서의 반복은 §2·§4가 이미 신규 게이트의 타깃 무관성을 입증했으므로 생략 — 근거는
`bounded_bytes`가 세 모델 전부 x86-64=AArch64로 동일함이 v0.9/§6에서 이미 구조적으로 확인됐다는 점).

| 모델 | bounded | 레벨 | B−1 | B | B+1 |
|---|---:|---|---|---|---|
| mlp16k | 786,476 | native | NOT_ADMITTED | ADMIT | ADMIT |
| mlp16k | 786,476 | cFS(native_std) | NOT_ADMITTED | ADMIT | ADMIT |
| multibranch | 38,216 | native | NOT_ADMITTED | ADMIT | ADMIT |

6/6 정확. `docs/EVIDENCE_v0.9_E14_stage1.md` §7 합격기준 #4("부분 PASS")를 이 결과로 갱신할 근거가
생겼다 — 세 정적 모델(mlp16k·conv2d·multibranch) 전부 native 레벨에서 4/4(B−1/B/B+1 및 완주) 확인,
cFS 레벨은 mlp16k와 conv2d(v0.9) 확인, multibranch cFS 레벨은 여전히 생략(동일 게이트 코드 재확인
성격이라 우선순위 낮음).

## 4. 재시작 2회 후 DELETE (A7 확장)

v0.9의 A7은 재시작 1회에 그쳤다. 이번엔 원래 제안서 계획대로 **재시작 2회 → DELETE**를 x86-64
native_std와 AArch64 게스트 양쪽에서 실행했다(`harness/cfs_cmd.py`로 CI_LAB UDP 명령 전송, ES
명령이 `AI_LEARNER_AppMain()`의 `CFE_ES_RunLoop`를 false로 만들어 **정상(비-SIGINT) 종료 경로**로
`AI_LEARNER_Cleanup()`에 도달하게 한다 — v0.9가 "정상 종료 시 자원 회수 미검증"으로 남긴 항목도
이 경로로 함께 닫힌다).

| 레벨 | 순서 | 결과 |
|---|---|---|
| x86-64 native_std | 정상기동→재시작→재시작→DELETE | `init_count`(admission 발생 횟수) 3, `cleanup_calls` 3(재시작마다 1 + delete 1), 매 단계 EVS(`Restart Application AI_LEARNER Success` ×2, `Delete Application AI_LEARNER Initiated`→`ExitApp`), 크래시 지표 0, DELETE 후에도 `core-cpu1` 프로세스 생존(cFS OPERATIONAL, `es-noop` 응답) |
| **AArch64 게스트** | 동일 순서 | 동일 패턴(`init_count` 3, `cleanup_calls` 3), 크래시 지표 0, DELETE 후 `core-cpu1` 생존 |

이중 해제·리소스 누수 흔적 없음(각 재시작에서 `cleanup_calls`가 정확히 1씩만 증가). D4 순서(버퍼→
세션→디바이스→인스턴스→blob→SB 파이프)가 재시작 매 회 동일하게 지켜짐을 로그로 확인했다.

## 5. E16 신규 게이트의 AArch64 교차 확인

E16(v0.11)에서 x86-64로만 검증했던 두 신규 게이트를 AArch64 게스트에서 재확인했다:

- **스택 실거부**: 배포된 startup script의 스택 값만 262160→200000으로 축소(코드가 기대하는 값은
  그대로) → `kernel_stack_accounted:false` → admission/binding 단계 도달 전 거부(EVS 11 CRITICAL),
  `cleanup_calls:1`, cFS OPERATIONAL 유지. x86-64와 완전히 동일한 패턴.
- 정상 A1(ADMIT/MATCH, `stack_accounted:true`, 실제 추론 30회 완료 확인)도 재확인 — E16의 코드가
  cross-compile되어 AArch64에서도 올바르게 동작함을 보여준다.

## 6. 이번 실험이 다루지 않는 것 (범위 밖)

- **A2 경계값의 AArch64 cFS 레벨 반복**: §3에서 설명한 대로, 정적 계획 수치의 타깃 불변성이 이미
  구조적으로 확립돼 있어 생략했다 — "게이트 코드 자체"가 다를 여지가 있는 케이스(스택 거부, A5b)만
  교차 확인했다.
- **multibranch cFS 레벨 A2, dynamic의 게스트 재현**: 시간 예산으로 생략.
- **정상 STOP(재시작이 아닌, 최초 기동에서 바로 DELETE)**: 이번엔 재시작 경로를 거친 뒤의 DELETE만
  확인했다. "최초 기동 → 바로 정상 DELETE"는 다르지 않은 코드 경로이므로 추가 근거는 아니라고
  판단해 생략.
- **QEMU 안정성 일반화**: 이번 세션에서는 크래시가 재발하지 않았지만(부팅 1회, 실행 세션 다수),
  표본이 작아 "이 환경에서 QEMU가 항상 안정적이다"라고 일반화하지 않는다(v0.9 §9의 한계 유지).

## 7. 판정

A5b는 이제 세 레벨(native x86-64, cFS x86-64, cFS AArch64 게스트) 모두에서 실행 증거를 갖췄다 —
이 연구가 가장 크게 정정했던 항목(D11)의 실제 해소다. A2는 세 정적 모델 전부 native 레벨에서,
두 모델은 cFS 레벨에서도 확인됐다. 재시작 2회+DELETE는 원래 제안서 계획대로 완주했고, 부수적으로
"정상 종료 시 자원 회수 미검증"(v0.9 §11.2) 문제도 ES-명령 기반 종료 경로로 해소했다(SIGINT 강제
종료가 아닌 정상 경로에서 cleanup이 매번 정확히 1회 호출됨을 확인). 남은 명시적 격차는 §6과
`docs/EVIDENCE_v0.9_E14_stage1.md` §9(RTEMS, 다중 앱, 시간 축 계약, 정규 MLIR pass)에 정리돼 있다.

## 8. 재현

```bash
# 환경 (최초 1회)
bash scripts/60_setup_aarch64_cross.sh
bash scripts/61_build_iree_runtime_aarch64.sh ~/onair-mlir-bench/ext
bash scripts/70_setup_qemu_system_aarch64.sh ~/onair-mlir-bench/ext/guest
GUEST_DIR=~/onair-mlir-bench/ext/guest SMP=4 MEM=2048 bash scripts/71_boot_guest_aarch64.sh

# 정상 배선 (mlp16k, aarch64)
python3 harness/gen_contract_header.py \
  results/e14_aarch64_qemu/aarch64/contracts/contract.mlp16k.aarch64.json /tmp/hdr.h
MODEL_VMFB="$PWD/results/e14_aarch64_qemu/aarch64/vmfb/mlp16k.vmfb" \
  bash scripts/51_build_cfs_aarch64.sh ~/onair-mlir-bench/ext/cFS \
  ~/onair-mlir-bench/ext/iree-src/build-rt-aarch64 /tmp/hdr.h 1048576 262144 "" v1
bash scripts/72_guest_ssh.sh scp ~/onair-mlir-bench/ext/cfs-aarch64-exe/v1/cpu1 cfs_e17/
bash scripts/72_guest_ssh.sh ssh "cd cfs_e17/cpu1 && timeout -s INT 15 ./core-cpu1 > a1.log 2>&1"
bash scripts/72_guest_ssh.sh scpback cfs_e17/cpu1/a1.log /tmp/a1.log

# A5b: module.fb 첫 4바이트를 0xFFFFFFFF로 재압축한 뒤 그 파일의 sha256/bytes로 계약을 갱신,
# 그 계약으로 헤더를 만들어 다시 배선·배포 (본문 §2.1 참조)

# 재시작 2회 + DELETE
python3 harness/cfs_cmd.py --host 127.0.0.1 --port 1234 es-restart-app AI_LEARNER
python3 harness/cfs_cmd.py --host 127.0.0.1 --port 1234 es-restart-app AI_LEARNER
python3 harness/cfs_cmd.py --host 127.0.0.1 --port 1234 es-delete-app AI_LEARNER
```
