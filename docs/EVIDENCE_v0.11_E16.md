# EVIDENCE v0.11 — E16: C 게이트 보강 (스택 실거부·blob 크기 선검사·인터페이스 gate)

## 0. 등급과 범위

**증거 등급: 결정론적**(admission/binding/stack verdict, exit code, JSON 필드) + **결과 재현
확인용 실행**(cFS `core-cpu1`을 x86-64 native_std에서 실제로 기동). 지연값은 인용하지 않는다.

**환경**: 이 세션에서 `~/onair-mlir-bench`를 처음부터 재구축했다 — `scripts/10_build_cfs.sh`(cFS
native_std), `scripts/40_setup_iree_source_runtime.sh`(IREE C 런타임, 커밋 `e4a3b0405d7d23554da26403658d0e8c3c5ecf25`,
v0.9와 동일), `scripts/50_wire_cfs_ai_learner.sh`(AI_LEARNER 배선, 이번 실험에서 수정). **AArch64
게스트는 재구축하지 않았다** — 이번 실험은 x86-64 native_std로 검증 가능한 범위로 한정한다.

## 1. 배경

`docs/EVIDENCE_v0.9_E14_stage1.md` §11.5(D15)와 §11.9(R8)이 정정한 두 결함을 실제로 고친다:

- **D15**: `kernel_stack_accounted`가 admission gate가 아니라 텔레메트리였다 — `accounted=false`에서도
  초기화를 거부하는 분기가 없었고, 확인 시점도 IREE 세션·입력버퍼·SB 파이프 생성 **이후**였다.
- **R8**: cFS 앱이 파일 전체 크기만큼 `malloc`한 뒤에야 계약의 `artifact.bytes`와 비교했다 — 예산
  gate가 먼저 있지만 blob 자체는 그 gate의 범위 밖이었다.

두 검토(REVIEW/OPINION v0.9)가 §11 우선순위 2번("C 게이트 보강")으로 남긴 항목이다.

## 2. 변경 사항

### 2.1 `native/cfs_app/fsw/src/ai_learner.c` — 실제 스택 거부 gate (D15)

- 스택 확인(`CFE_ES_GetAppID`/`GetAppInfo` → `es_stack >= base+kernel`)을 `AI_LEARNER_Init()`의
  **맨 앞**으로 이동(기존: admission·binding·IREE 런타임·입력버퍼·SB 파이프 생성 뒤, §5.1 참조).
  이 확인 자체가 아무 자원도 획득하지 않으므로(ES 조회뿐) 맨 먼저 해도 비용이 없다.
- `accounted == false`일 때 **`AI_LEARNER_Cleanup()` 호출 후 `CFE_STATUS_EXTERNAL_RESOURCE_FAIL` 반환**
  하는 거부 분기를 신설(신규 이벤트 `EID_STACK_REJECT=11`, `CRITICAL`). 기존 `EID_STACK`
  (`INFORMATION`)은 통과 시에만 발생.
- 부수: bound-known 계약의 인터페이스가 이 앱이 하드코딩한 단일 f32 입력/단일 f32 출력이 아니면
  거부하는 방어선(`EID_INTERFACE_MISMATCH=12`)도 admission 직후에 추가 — `gen_contract_header.py`
  (E15)가 이미 이런 헤더를 생성하지 않지만, 손으로 고친 헤더에 대한 defense-in-depth.

### 2.2 `native/cfs_app/fsw/src/ai_learner.c` — blob 크기 선검사 (R8)

`fseek`/`ftell`로 얻은 파일 크기를 `malloc` **이전에** `CONTRACT_ARTIFACT_BYTES`와 비교한다. 크기가
다르면 `CONTRACT_ARTIFACT_MISMATCH`(해시 계산 없이, `malloc`/`fread` 없이) 즉시 거부한다. 크기가
같은 경우에만 기존과 동일하게 `malloc`→`fread`→sha256 비교로 진행한다 — 즉 이미 크기가 일치하는
정상/A5a 시나리오의 동작은 바뀌지 않는다(§4에서 검증).

### 2.3 `native/native_learner.c` — 동일 패턴 두 가지 추가

standalone 실행기에도 동일한 두 가지를 추가했다(§2.1의 인터페이스 gate, §2.2의 blob 크기 선검사).
스택 확인은 native_learner.c에는 애초에 없다(ES 태스크가 아니므로 해당 없음) — 이 실행기가 검증할 수
없는 유일한 항목이 cFS 전용 스택 gate라는 점이 두 실행기를 병행 유지하는 이유 중 하나다. 신규 종료
코드 9(인터페이스 불일치)를 추가했다.

### 2.4 `scripts/50_wire_cfs_ai_learner.sh` — startup 스택 계산 버그 수정

기존 스크립트는 시작 스크립트의 태스크 스택을 **항상 262144로 하드코딩**했다 — `WIRING.md` §4가
줄곧 "`<STACK> = AI_LEARNER_STACK_BASE_BYTES + CONTRACT_KERNEL_STACK_BYTES`"라고 명시했음에도, 실제로
그 계산을 하는 것은 `scripts/51_build_cfs_aarch64.sh`(AArch64 크로스빌드)뿐이었다. §2.1의 실제
거부 gate를 x86-64 native_std에 적용해보니 이 버그가 **즉시 드러났다** — mlp16k(kernel=16 B)처럼
kernel stack이 0이 아닌 모델은 `262144 < 262160`이 되어 항상 거부됐을 것이다(§3에서 재현). 51번
스크립트와 동일한 패턴(`contract_gen.h`에서 `CONTRACT_KERNEL_STACK_BYTES`를 읽어 합산)으로 수정했다.
부수로 `MODEL_VMFB`/`AI_LEARNER_BUDGET_BYTES`/`AI_LEARNER_STACK_BASE_BYTES` 환경변수 오버라이드를
추가해 시나리오별 재구성을 스크립트 수정 없이 할 수 있게 했다(§3의 시험에 사용).

## 3. 검증 — x86-64 native_std에서 실제 cFS 기동

`scripts/10_build_cfs.sh` → `scripts/40_setup_iree_source_runtime.sh` → 규리 절제된
`scripts/50_wire_cfs_ai_learner.sh`로 실제 `core-cpu1` + `AI_LEARNER` 앱을 빌드하고, mlp16k(x86-64)
계약으로 5가지 시나리오를 **실제로 기동해** 관찰했다(전부 `results/e14_aarch64_qemu/x86_64/{vmfb,contracts}`
의 실물 아티팩트 사용). 결정론적 필드만 인용(실행 시간은 비증거).

| 시나리오 | 조작 | 결과 (JSON `stage`) | cFS 상태 |
|---|---|---|---|
| 정상 | 없음(기본 배선, startup stack=262160=262144+16) | `stack{accounted:true}` → `admission{ADMIT}` → `binding{MATCH}` | OPERATIONAL, EID_INIT_OK |
| **스택 거부(신규 gate)** | 배포된 startup script만 262160→200000으로 축소(컴파일된 코드의 기대치는 그대로 262160) | `stack{es_stack_size:200000,...,accounted:false}` → 그 자리에서 `cleanup{calls:1}` — admission/binding 단계 **도달 안 함** | OPERATIONAL(AI_LEARNER만 거부), EVS 11 CRITICAL "stack insufficient: es=200000 needed=262160" |
| **blob 크기 선검사(신규)** | `/cf/model.vmfb`를 mlp16k_swap(193,308 B, 계약은 733,979 B 기대)으로 교체 | `admission{ADMIT}` → `binding{CONTRACT_ARTIFACT_MISMATCH, reason:"size mismatch, refused before allocation"}` → `cleanup{calls:1}` | OPERATIONAL, 해시 계산·malloc 없이 즉시 거부 |
| NOT_ADMITTED | 예산 1000 B로 재구성 | `stack{accounted:true}` → `admission{NOT_ADMITTED}` → `cleanup{calls:1}` | OPERATIONAL, 기존과 동일 |
| (회귀) 정상 재확인 | 배선 원복 | 정상 시나리오와 동일 | OPERATIONAL |

**스택 거부 시나리오가 이번 실험의 핵심 결과**다 — v0.9까지는 이 값이 텔레메트리로만 기록됐고, 실제로
부족한 스택에서도 앱이 초기화를 계속 진행했다(§5.1 정정에서 지적된 그대로). 이번엔 admission/binding
단계에 아예 도달하지 못하고 자원 획득 전에 거부되는 것을 EVS 이벤트와 JSON 양쪽에서 직접 확인했다.

`native_learner.c`(standalone)에서도 동일 패턴을 native 레벨로 재확인했다: NOT_ADMITTED, A3(크기가
다른 모델 교체 → 신규 크기 선검사로 즉시 거부, `cleanup_calls:0`), A4(파일 없음), A5a(같은 크기의
손상 아티팩트 → 기존과 동일하게 `malloc`→해시 경로, `cleanup_calls:1`, **동작 불변 확인**), 신규
인터페이스 불일치(손으로 `CONTRACT_NUM_INPUTS=2`로 고친 헤더 → exit 9로 거부).

계약 도구 회귀(E15의 51/51)도 이 세션 전체에서 재확인했다 — 이번 변경은 `harness/`를 건드리지 않았다.

## 4. 이번 실험이 다루지 않는 것 (범위 밖)

- **AArch64 게스트 재현**: 이번 검증은 x86-64 native_std로 한정했다. `scripts/51_build_cfs_aarch64.sh`도
  이미 base+kernel을 올바르게 계산하고 있었으므로(§2.4의 버그는 50번에만 있었다) 로직 변경은 없지만,
  AArch64 게스트에서 새 거부 gate·크기 선검사를 실제로 재현하지는 않았다 — 다음 우선순위(A2 경계값,
  A5b, 재시작 2회+DELETE 등)와 함께 후속 과제.
- **`CONTRACT_NUM_INPUTS/OUTPUTS` 런타임 gate의 다중-입출력 실제 실행**: 이 검증은 "거부하는지"만
  확인했다. 다중 입출력을 실제로 push/pop하는 별도 실행 경로는 이 세션에서도 만들지 않았다(scope:
  두 앱 모두 여전히 단일 f32 입출력 전용).
- **UNKNOWN_BOUND(A8)의 실제 cFS 재기동**: 이번엔 dynamic 모델의 cFS 빌드를 다시 만들지 않았다 —
  admission 게이트 순서(스택→admission)에서 `GATE_BOUND_KNOWN`이 여전히 그 뒤에 있고 로직도 바뀌지
  않았으므로 v0.9의 A8 결과가 유효하다고 판단한다(코드 검토로 확인, 재기동으로 재확인은 안 함).

## 5. 판정

D15(스택 텔레메트리→gate)와 R8(blob 크기 선검사)을 실제 cFS `core-cpu1` 기동으로 검증했다. 이 과정에서
`scripts/50_wire_cfs_ai_learner.sh`가 `WIRING.md`가 명시한 규칙을 어기고 있었다는, 신규 gate가 아니면
드러나지 않았을 기존 버그를 하나 더 찾아 고쳤다(§2.4) — 이는 "게이트를 강화하면 숨어있던 배선
버그가 드러난다"는 이 저장소의 반복되는 교훈(D2·D3·D9 등)과 같은 패턴이다.

## 6. 재현

```bash
# 환경 (최초 1회, 이 컨테이너는 세션마다 비어 있음)
echo 512 > /proc/sys/fs/mqueue/msg_max
bash scripts/10_build_cfs.sh ~/onair-mlir-bench/ext
bash scripts/40_setup_iree_source_runtime.sh ~/onair-mlir-bench/ext

# 정상 배선 + 기동
python3 harness/gen_contract_header.py \
  results/e14_aarch64_qemu/x86_64/contracts/contract.mlp16k.x86_64.json \
  native/cfs_app/fsw/src/contract_gen.h
MODEL_VMFB="$PWD/results/e14_aarch64_qemu/x86_64/vmfb/mlp16k.vmfb" \
  bash scripts/50_wire_cfs_ai_learner.sh ~/onair-mlir-bench/ext/cFS ~/onair-mlir-bench/ext/iree-src/build-rt
cd ~/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && timeout -s INT 12 ./core-cpu1

# 스택 거부 재현: 배포된 startup script의 스택 값만 줄여서 재기동
sed -i 's/AI_LEARNER,   55,   262160,/AI_LEARNER,   55,   200000,/' cf/cfe_es_startup.scr
timeout -s INT 12 ./core-cpu1   # -> EVS 11 CRITICAL, admission/binding 단계 도달 안 함
```
