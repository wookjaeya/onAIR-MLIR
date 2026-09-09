# EVIDENCE v0.22 — E25: OnAIR↔cFS 동일 모델·의미 동치

- 실험 ID: **E25**
- 날짜: 2026-09-09
- 계획(합격 기준을 **실행 전에** 고정): `docs/plans/E25_same_model_equivalence.md`
- 외부 지침: `ONAIR_MLIR_RESEARCH_SCOPE_REVIEW.md` §9, `E25_AARCH64_COMPLETION_GUIDELINE.md`
- 플랫폼 등급: **결정론적**(출력 비트값·해시·계약 수치·판정). QEMU 지연값은 인용하지 않는다.
- 산출물: `results/e25_equivalence/`

## 0. 판정

**PASS.** 다섯 실행 경로가 같은 canonical 모델을 실행하고, 네 IREE 경로의 출력이
**전부 비트 동일**하다.

| 경로 | 엔진 | 결과 |
|---|---|---|
| NumPy reference | `x @ w0 @ w1` (weights.npz) | 기준 |
| OnAIR-IREE | `iree.runtime` Python 바인딩 (pip) | ✅ |
| native C | `native_learner`, IREE C 런타임 소스 빌드 | ✅ |
| cFS x86-64 | `AI_LEARNER` 앱, 실제 `core-cpu1` 기동 | ✅ |
| **cFS AArch64** | 같은 앱, QEMU 게스트, cortex-a53 크로스빌드 | ✅ |

- reference 대비: 네 경로 × 2 regime = **256/256 원소** 통과, **argmax 64/64** 일치
- IREE 경로 간: **6쌍 전부 비트 동일**
- AArch64 반복 실행: **비트 동일**(결정적)

## 1. 출발점 — 두 경로는 서로 다른 모델을 실행하고 있었다

| | OnAIR fixture | cFS 배포(E14 `mlp16k`) |
|---|---|---|
| 모델 | `mlp_9x65536x2` | `mlp16k` |
| hidden | **65536** | **16384** |
| 가중치 | 외부 `weights.npz` 2,884,078 B | **baked** |
| `.vmfb` | 10,642 B(가중치 없음) | 733,979 B |
| 인터페이스 | [1,9]→[1,2] f32 | [1,9]→[1,2] f32 |

**같은 것은 인터페이스뿐이었다.** 따라서 이전까지 근거가 있던 표현은
*"OnAIR와 cFS에 각각 IREE 실행 경로를 구현했다"*이고,
*"동일한 OnAIR AI 모델을 cFS에 배포했다"*는 근거를 넘어섰다
(`docs/EVIDENCE_v0.18_E23.md` §2가 지적한 그대로이며, 위 표가 그 수치적 확인이다).

## 2. 설계 — 하나의 canonical 가중치

`harness/gen_model_canonical.py`(신규)가 한 seed(20260909)에서 **baked MLIR과
`weights.npz`를 함께** 생성한다. 배포 경로 셋은 그 MLIR을 컴파일한 vmfb를 쓰고,
npz는 NumPy reference 계산에만 쓰인다 — 그래서 `weights.npz`가 **배포 경로에서 사라진다**
(검토가 "weights가 계약 밖에 있다"고 지적한 문제의 해소).

hidden은 E14와 같은 16384다. 그 결과 **계약 값이 E14 `mlp16k`와 정확히 일치**한다
(786476 / 65580 / 720896) — 기존 계약·헤더·시나리오와 비교 가능하다.

## 3. 입력 집합 — 실측으로 발견한 문제와 그 처리

두 플러그인 모두 **정규화를 하지 않는다**: `update()`가 raw CSV 필드에 `float(v)`만
적용한다(코드 확인). 즉 실제 파이프라인이 ~9.5e8 epoch를 모델에 그대로 넣는다.

그 분포는 **배포 동작이므로 반드시 시험해야 하지만**, 한 열이 나머지보다 5~9자릿수 커서
그 regime만으로는 사실상 한 열만 검증된다. 그래서 `normalized`(전 열 O(1)) regime을 절반
추가했다. **tolerance 기준은 손대지 않았고** 입력 집합만 넓혔으며, 이유를 생성기 주석과
manifest에 남겼다.

## 4. 합격 기준이 실행 전에 고정돼야 했던 이유 (실측 증명)

계획 §3.2는 reference 대비 `abs ≤ 1e-4` **또는** `rel ≤ 1e-5`로 썼다. 실측:

| regime | 출력 크기 | abs 기준만 | rel 기준만 | 둘 중 하나 |
|---|---|---|---|---|
| telemetry | ~1.3e9 | **1/64** | 64/64 | 64/64 |
| normalized | ~12 | 64/64 | **59/64** | 64/64 |

**어느 한 기준만 요구했어도 정직한 결과가 FAIL이 됐다.** 두 regime이 서로 다른 기준으로
통과한다. `harness/e25_compare.py`는 `would_pass_abs_only` / `would_pass_rel_only`를 함께
기록해 이 설계가 사후 합리화가 아님을 감사 가능하게 한다.

## 5. 실행 — 게이트를 통과한 뒤의 수치

세 C/앱 경로 모두 **모든 게이트를 통과한 뒤** 이 수치를 냈다. 순수 추론 하네스가 아니다.

native C(`native_learner.c`)와 cFS 앱(`ai_learner.c`)에 각각 파일 기반 동치 모드를 추가했고,
**모든 게이트 뒤에** 배치했다(스택·admission·인터페이스·artifact 크기·sha256). 입력 파일이
없으면 동작은 이전과 완전히 동일하다.

cFS x86-64(실제 `core-cpu1` 기동):
```
admission ADMIT  bounded 786476 ≤ budget 786477
binding   MATCH  artifact_sha256 0e250c2f16e704db
e25_equivalence  inputs:64 completed:64
```

cFS AArch64(QEMU 게스트, 실제 `core-cpu1` 기동):
```
stack      es_stack 262160 = 262144 + 16   accounted=true
admission  ADMIT   target=aarch64-unknown-linux-gnu  bounded 786476
binding    MATCH   artifact_sha256 4e5b2972c0bd9704
e25_equivalence  inputs:64 completed:64
```

## 6. 결과와 그 해석

### 6.1 비트 동일이 네 경로 전부에서 성립

`build/comparison_all.json`:

```
bit-identical  ireepy ↔ nativec            True
bit-identical  ireepy ↔ cfs_x86            True
bit-identical  ireepy ↔ cfs_aarch64        True
bit-identical  nativec ↔ cfs_x86           True
bit-identical  nativec ↔ cfs_aarch64       True
bit-identical  cfs_x86 ↔ cfs_aarch64       True
```

x86-64 세 경로가 비트 동일한 것은 설계상 기대한 결과다(**같은 vmfb**, IREE 런타임 빌드만
다름: pip 바이너리 / 소스 빌드 최소 구성 / cFS 앱에 링크된 것).

**AArch64가 함께 비트 동일한 것은 계획이 예상하지 않은 결과다.** 계획 §3.2는 AArch64를
**다른 vmfb**(`4e5b2972` vs `0e250c2f`)로 보고 tolerance 비교 대상으로 분류했다. 실제로는
두 ISA의 코드생성이 같은 누산 순서를 만들어 비트까지 같았다.

**이 결과를 일반화하지 않는다.** 관측된 것은 이 모델(활성화 없는 `x @ w0 @ w1`, 1×9 @
9×16384 @ 16384×2)에서 이 컴파일러 버전·이 두 타깃 설정이 같은 순서로 누산했다는 사실이다.
다른 할당·연산 구조(예: conv2d, multi-branch)나 다른 타깃 설정에서도 성립한다는 근거는 없다.
그런 경우를 위해 계획의 tolerance 기준은 그대로 유지한다.

### 6.2 계약은 ISA 독립, 아티팩트는 아님

| | x86-64 | AArch64 |
|---|---|---|
| `bounded_bytes` | 786476 | 786476 |
| `static_per_call_bytes` | 65580 | 65580 |
| `module_resident_constant_bytes` | 720896 | 720896 |
| `kernel_task_stack_invocation_bytes` | 16 | 16 |
| `artifact.sha256` | `0e250c2f…` | `4e5b2972…` |

두 vmfb가 같은 canonical source·weight에서 나왔음은 `invocation.json`이 연결한다.

### 6.3 반복 실행 결정성

지침 §3의 사전 고정 항목. AArch64 게스트에서 같은 vmfb·같은 입력으로 두 번 실행한 결과가
**비트 동일**이다(`build/out_cfs_aarch64.bin` vs `out_cfs_aarch64_run2.bin`).

### 6.4 E14가 남긴 cross-target 갭 해소

`results/e14_aarch64_qemu/comparison/*.json`은 `native`·`both_sound`·`out0_agreement.agree`가
전부 `null`이었다 — v0.9.1 정정이 *"cross-target 비교는 계약 수치 비교일 뿐 실행 대조가
아님"*이라고 명시한 한계다. E25가 **같은 입력에 대한 실제 출력 대조**로 그 자리를 채웠다.

## 7. 환경 실패 기록 (의미 동치와 구분)

지침 §7은 환경 실패와 의미 동치 실패를 같은 결과로 취급하지 말라고 요구한다. 이번 실험에서
**환경 실패는 2건 있었고 모두 부팅 단계**이며, 계약·binding·수치 결과와 무관하다.

AArch64 게스트 부팅이 두 번 emergency mode로 실패했다 — `/boot`(LABEL=BOOT)·
`/boot/efi`(LABEL=UEFI) 장치 타임아웃으로 `local-fs.target` 의존성 실패. 호스트에서 qcow2를
raw로 변환해 루트 파티션을 loop 마운트해 확인한 결과 **파티션과 label은 정상 존재**했다
(게스트 커널의 장치 인식 지연). 조치: fstab의 두 항목에 `nofail` 추가, 그리고 두 번 다
정체 지점이던 cloud-init 비활성화(ssh 공개키가 호스트 키와 일치하고 sshd host key도 이미
디스크에 있음을 먼저 확인). 3차 부팅에서 emergency mode 0건. 상세와 원시 시리얼 로그:
`results/e25_equivalence/aarch64_env/`.

이 게스트의 부팅 안정성은 여전히 일반화하지 않는다 — v0.9 무로그 크래시, v0.12 ~170초
정상, 이번 emergency mode 2회 후 성공. 표본이 작고 결과가 일정하지 않다.

## 8. 이 실험으로 주장할 수 있는 것 / 없는 것

**주장 가능**(지침 §8)
- 하나의 canonical 모델·가중치가 x86-64와 AArch64에서 **의미상 동등하게** 실행된다
  (이 모델·이 컴파일러 버전에서는 비트 동일까지 관측)
- AArch64 ISA에서의 기능적 이식성
- AArch64 cFS의 admission·binding·inference 통합 실행
- E14의 미확인 cross-target 출력 비교 보완

**주장하지 않음**
- QEMU 지연시간을 실제 하드웨어 성능으로 일반화 / WCET·deadline / 전력·열·실시간 스케줄링
- 실제 우주용 OBC 전체의 자원 안전성(계약은 `per-call + module constants` 부분 경계)
- **비트 동일의 일반화**(§6.1)
- 이 실험은 **동치**를 본 것이지 모델의 정확도(accuracy)를 본 것이 아니다

## 9. 재현

```bash
python3 harness/gen_model_canonical.py --outdir results/e25_equivalence/model   # 결정적
# invocation.json의 compile_argv(x86-64 / aarch64)로 각각 한 번씩 컴파일 → 계약·헤더
cd native && bash build.sh <contract.json> e25
./native_learner_e25 <vmfb> 1048576 3 inputs.bin out_nativec.bin
python3 harness/gen_contract_header.py <contract.json> native/cfs_app/fsw/src/contract_gen.h
MODEL_VMFB=<vmfb> bash scripts/50_wire_cfs_ai_learner.sh          # x86-64 cFS
MODEL_VMFB=<aarch64 vmfb> bash scripts/51_build_cfs_aarch64.sh ... canonical_e25   # AArch64 cFS
# 각 exe 트리의 cf/에 e25_inputs.bin을 두고 core-cpu1 기동 → cf/e25_outputs.bin
python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \
  --reference build/ref_numpy.npy --path ireepy=... --path nativec=... \
  --path cfs_x86=... --path cfs_aarch64=... --out build/comparison_all.json
```

## 10. 다음

연구 순서는 **E26 부분 메모리 경계 유용성 → E27 MLIR 고유 기여**다.
