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

---

## 11. 정오표 (외부 검토 v0.22 반영, E25b 시점)

일곱 번째 외부 검토(`docs/reviews/REVIEW_v0_22_E25.md`, 기준 커밋 `44c27ac`)가 E25를 "실질적
연구 진전"으로 인정하면서 **주장 범위 네 곳의 과대 서술과 판정 도구 한 곳의 계획 불일치**를
지적했다. 저장소를 직접 대조한 결과 **전부 사실**이었다. 작업 규율 5에 따라 본문은 고치지 않고
여기에 정정을 덧붙인다. **판정(PASS)과 수치 자체는 바뀌지 않는다** — 바뀌는 것은 그 수치가
무엇을 말하는지의 범위다.

### 11.1 (a) 원소 수는 256이 아니라 512 — 집계 표현 정정

§0의 "네 경로 × 2 regime = **256/256 원소**"는 집계 오기다. 실제 구성은

| 단위 | 수 |
|---|---|
| 입력 벡터 | 64 (telemetry 32 + normalized 32) |
| 출력 원소/입력 | 2 |
| 경로당 비교 원소 | **128** |
| 경로 | 4 (ireepy / nativec / cfs_x86 / cfs_aarch64) |
| **합계** | **512** |

`build/comparison_all.json`의 `vs_reference`를 합산하면 경로당 `telemetry 64 + normalized 64
= 128`이고 네 경로 합계 **512/512 통과**다. argmax는 경로당 64/64(합계 256/256)이며, 256이라는
수가 argmax 쪽 집계와 섞인 것으로 보인다. **PASS 판정에는 영향이 없다.**

### 11.2 (b) "같은 누산 순서"는 관측이 아니라 설명 가설 — 철회

§6.1의 *"두 ISA의 코드생성이 같은 누산 순서를 만들어 비트까지 같았다"*는 **관측을 넘어선
서술이다.** 이 실험이 관측한 것은 **출력 바이트의 동일성**뿐이고, 누산(reassociation) 순서는
어디에서도 측정하지 않았다(두 타깃의 dispatch ELF를 대조한 적이 없다). 출력이 같다는 사실은
누산 순서가 같다는 것의 근거가 되지 못한다 — 서로 다른 순서가 같은 부동소수 결과를 낼 수도
있기 때문이다.

정정된 서술: **"서로 다른 vmfb인데도 출력이 비트 동일했다. 그 원인은 확인하지 않았다."**
원인을 확인하려면 두 ELF의 dispatch 코드를 대조해야 하며, 이는 E27의 후보 항목이다.

이 정정은 이 저장소의 가장 오래된 교훈(CLAUDE.md "가장 중요한 교훈")의 변종이다 —
*"두 관측이 서로 모순되지 않는다"*가 *"그 원인을 안다"*로 번진 형태다.

### 11.3 (c) `both_sound` 갭 해소 주장 철회 — 출력 동치와 메모리 soundness는 다른 관측

§6.4는 E25가 E14의 `both_sound: null`을 채웠다고 서술했다. **틀렸다.**
`harness/cross_target_compare.py:201`이 정의하는 `both_sound`는

```python
both_sound = all(v is True for v in sound_vals) if (len(rows) >= 2 and all(...)) else None
```

즉 **각 타깃 실행 요약의 `peak_within_bounded`(메모리 관측)를 종합한 값**이다. E25는 메모리를
전혀 계측하지 않았다 — cFS E25 실행 로그의 stage는 `stack` / `admission` / `binding` /
`e25_equivalence` 넷뿐이고 `mem` 레코드가 없다.

E25가 실제로 채운 것은 같은 지표의 **다른 칸**, `out0_agreement`(출력 대조)이며 그것도
**canonical 모델 한 개에 한해서**다. E14의 4모델(mlp16k·conv2d·multibranch·dynamic)에 대한
`both_sound`와 `out0_agreement`는 **여전히 `null`이고 E26의 대상**이다.

정정된 서술: **"E25는 canonical 모델에 한해 cross-target 출력 대조를 실제 실행으로 수행했다.
E14가 남긴 메모리 soundness 공백(`both_sound`)은 닫히지 않았다."**

### 11.4 (d) "OnAIR-IREE"는 OnAIR 실행이 아니다 — 명칭 정정

§0 표의 `OnAIR-IREE`는 **`iree.runtime` Python 바인딩을 직접 호출한 것**이며, OnAIR 프레임워크를
통과한 실행이 아니다. 사실 관계:

- OnAIR 플러그인 `plugins/compiled_learner/compiled_learner_plugin.py:118-138`은 여전히 외부
  `weights.npz`를 읽어 `self._fn(self._x, *self._weights)`로 호출한다. E25의 baked-weight vmfb
  경로로 **전환되지 않았다.**
- cFS E25 모드(`native/cfs_app/fsw/src/ai_learner.c:326-372`)는 계약·binding 게이트를 통과한 뒤
  **파일에서 읽은 입력**을 직접 추론한다. Software Bus 메시지 수신과 `CFE_ES_HK_TLM_MID` payload의
  feature 변환은 이 시험 경로에 **포함되지 않는다.**

정정된 명칭: **"IREE Python 바인딩(pip `iree-base-runtime`) 직접 호출"**.
E25가 입증한 범위는 **"canonical 모델의 계산 결과 동치 + cFS 앱 내부 추론 경로(게이트 통과 후
파일 입력)의 통합"**이며, OnAIR 프레임워크 전체의 데이터 흐름 동치는 **범위 밖**이다
(검토 §4.1은 이 확대가 현재 목표에 불필요하다고 판단했다).

### 11.5 (e) 완료 범위 문장 — 정본

검토 §3이 제시한 문장을 정본으로 채택한다:

> 고정한 canonical 모델과 64개 입력에 대해 IREE Python, native C, cFS x86-64 및 cFS AArch64의
> 계산 결과가 사전 허용 오차 내에서 reference와 일치했다. 네 IREE 실행 경로 사이에서는 비트
> 동일도 관측됐다.

적용 범위: **이 모델·이 입력 집합·이 컴파일러 버전·이 두 타깃 설정**. 두 번의 AArch64 실행
일치는 그 조건에서의 반복성 증거다.

### 11.6 (f) 계약값의 ISA 동일성은 이 구성의 관측

§6.2의 제목 "계약은 ISA 독립"은 일반 명제로 읽힌다. 관측된 것은 **canonical 모델에서
`bounded=786476` / `per_call=65580` / `constants=720896`이 두 타깃에서 같았다**는 사실이며
(E14의 4모델도 `identical_bounded_bytes: true`), 4~5개 모델·1개 컴파일러 버전의 관측이다.
정정된 제목: **"이 구성에서 계약값은 ISA 독립, 아티팩트는 아님"**.

### 11.7 (g) 판정 도구가 사전 고정 기준과 어긋나 있었다 (E25b에서 수정)

`harness/e25_compare.py`(원본)는 **모든 IREE 경로 쌍에 비트 동일을 요구**했다
(`if not same: report["pass"] = False`). 그러나 계획 `docs/plans/E25_same_model_equivalence.md`
§3.2·§3.3-5는 실행 **전에** 이렇게 정해 두었다:

| 쌍 | 사전 고정 기준 |
|---|---|
| 같은 vmfb를 쓰는 IREE 경로들 | **비트 동일**(핵심 주장) |
| cFS AArch64 ↔ x86-64 (다른 vmfb) | `abs ≤ 1e-4` 또는 `rel ≤ 1e-5` + argmax 일치 |

즉 도구가 계획보다 **강한** 조건을 걸고 있었다. 이번 데이터는 그 강한 조건도 만족했으므로
**E25의 PASS 판정은 유효**하지만, 다른 모델의 cross-ISA 결과가 tolerance를 만족하면서 비트만
다를 때 **정직한 결과를 FAIL로 만드는 과잉 거부(유형 B 결함)** 경로였다.

E25b에서 쌍별 규칙을 계획대로 구현했다(§12). **기준 완화가 아니라 이미 정한 비교 조건의
구현**이며, 보관 출력으로 재판정해 PASS와 모든 수치가 불변임을 확인했다.

### 11.8 (h) §7의 "emergency mode 2회" 중 두 번째는 산출물로 검증되지 않는다 + 원시 로그가 커밋되지 않았다 (D46)

§7은 *"환경 실패는 2건 있었고 모두 부팅 단계"*라고 서술하고 근거로
`results/e25_equivalence/aarch64_env/`를 가리킨다. v0.22.1에서 그 디렉터리를 실제로 대조한 결과
두 가지가 확인됐다.

**(1) 두 번째 emergency는 보존된 산출물로 확인할 수 없다.** `scripts/71_boot_guest_aarch64.sh:24`가
매 부팅마다 `: > serial.log`로 콘솔 기록을 잘라내므로, 시도 3의 부팅이 시도 2의 시리얼 로그를
덮어썼다. 남은 것은 드라이버 로그(`guest up after ~370 s`)뿐이고, 그것은 이 시도가 sshd까지
도달했음을 보일 뿐 emergency 여부를 말해주지 않는다. **철회가 아니라 증거 등급의 명시다** —
그 서술은 세션의 실시간 관찰에 근거하며, 저장소만으로는 재현되지 않는다. 산출물로 확인되는 것은
시도 1의 emergency 1건(`boot_attempt1_serial.log`에 `You are in emergency mode` 1회, cloud-init
언급 33줄)과 시도 3의 정상 부팅(emergency 0회, cloud-init 0줄)이다.

**(2) D46 — 그 원시 로그들이 애초에 커밋되지 않고 있었다.** `.gitignore:7`의 포괄 규칙 `*.log`에
대해 예외가 `results/e14_aarch64_qemu/**/*.log`에만 있어, E25의 게스트 로그는 전부 제외되고
있었다. **문서가 가리키는 근거가 클론에 존재하지 않는 상태**였고, 이는 E22가 F9에서 찾은 것과
같은 계열이다(회귀 시험이 요구하는 `dump/`가 같은 이유로 빠져 있었음). v0.22.1에서
`!results/e25_equivalence/**/*.log`를 추가하고 시리얼 로그 2개·드라이버 로그 2개·qemu stderr 1개를
커밋했다. 상세한 이력 재구성과 대조표는 `results/e25_equivalence/aarch64_env/BOOT_LOG.md`에 있다.

이 결함은 **외부 검토가 지적한 것이 아니라** 검토 §5의 "README의 AArch64 미실행 표기 등을 E25 완료
현황과 동기화" 항목을 처리하다가 발견됐다.

---

## 12. E25b — 판정 도구를 사전 고정 기준에 맞춤 (과잉 거부 1건 실제 재현·수정)

정오표 §11.7의 조치. **기준 완화가 아니라 이미 정한 비교 조건의 구현**이다.

### 12.1 무엇을 바꿨나

`harness/e25_compare.py`가 경로 쌍마다 **어느 규칙을 적용할지 아티팩트 sha256으로 결정**한다.

| 쌍의 조건 | 적용 규칙 | 근거 |
|---|---|---|
| 두 경로가 **같은 vmfb**를 적재 | **비트 동일 필수** | 계획 §3.2 *"같은 vmfb를 같은 런타임으로 돌리므로 다르면 그 자체가 결함이며 tolerance로 가려서는 안 된다"* |
| 두 경로가 **다른 vmfb**를 적재 | 원소별 `abs ≤ 1e-4` 또는 `rel ≤ 1e-5` **그리고** argmax 전 행 일치 | 계획 §3.2 "cFS AArch64 ↔ x86-64" 행, §3.3-5 |

규칙 선택은 **추측하지 않는다**. 모든 `--path`에 `--vmfb NAME=SHA256`이 필수이며, 하나라도
없으면 계약 도구들과 같은 방식으로 **거부하고 아무 파일도 쓰지 않는다**(rc≠0). 경로 이름으로
ISA를 추론하거나 한쪽 규칙을 기본값으로 두면, 둘 중 하나가 반드시 결함이 된다 — 전자는 이
과잉 거부를 되살리고, 후자는 이 실험의 핵심 주장인 비트 동일 요구를 조용히 약화시킨다.

cross-vmfb 쌍에서도 `bit_identical`은 **관측값으로 계속 기록**한다(합격 조건이 아닐 뿐). E25가
관측한 AArch64 비트 동일이 보고서에서 사라지지 않아야 하기 때문이다.

### 12.2 과잉 거부의 실제 재현 (revert witness)

수정 전 도구를 그대로 두고, **정직한 cross-ISA 결과를 흉내낸 입력**(한 원소만 1 ulp 차이,
`abs_max=1.192e-07`, `rel_max=6.255e-08`)을 넣었다:

```
=== 옛 comparator (E25b 이전) ===
  cfs_aarch64 synthetic 16/16  abs_max=1.192e-07 rel_max=6.255e-08  (abs-only 16, rel-only 16)
  bit-identical cfs_aarch64__vs__cfs_x86  False
VERDICT: FAIL     rc=1

=== 새 comparator (E25b), 같은 데이터, 서로 다른 vmfb 선언 ===
  cross_vmfb cfs_aarch64__vs__cfs_x86  pass=True bit_identical=False
             (16/16 elems, abs_max=1.192e-07 rel_max=6.255e-08, argmax 8/8)
VERDICT: PASS     rc=0
```

**모든 원소가 두 tolerance를 각각 단독으로 만족(16/16 · 16/16)하는데도 옛 도구는 FAIL**이었다.
이것이 유형 (B) 결함(과잉 거부)의 정의다. 이 저장소가 D31·D40·D42에서 세 번 확인한 것과 같은
계열이며, **어떤 입력 집합에서 재검토했는지에 전적으로 의존**한다는 점도 같다 — E25의 보관
출력만 보면 이 결함은 영원히 보이지 않는다(그 데이터는 강한 조건도 만족하므로).

시험 하네스 자체를 revert해 돌리는 것은 **약한 증인**이다: 모든 케이스가 `rc=2`(argparse가
`--vmfb`를 모름)로 죽는데 그것은 새 인터페이스이지 결함이 아니다. 위의 직접 실행이 정본 증인이다.

### 12.3 보관 출력 재판정 — 판정·수치 불변

보관된 E25 출력 네 개를 새 도구로 재판정해 **새 파일**
`results/e25_equivalence/build/comparison_all.pairrule.json`에 기록했다
(원본 `comparison_all.json`은 이력 보존을 위해 **수정하지 않았다**).

| 확인 | 결과 |
|---|---|
| 판정 | `pass: true` (불변) |
| `vs_reference` 전체 | 원본과 **완전 동일** |
| `argmax` 전체 | 원본과 **완전 동일** |
| 쌍 규칙 배정 | `same_vmfb` 3 (x86 세 경로 상호) · `cross_vmfb` 3 (AArch64 관련) |
| `bit_identical` | 6쌍 전부 `true` (cross_vmfb 3쌍은 요구되지 않았으나 관측됨) |
| 결정성 | 두 번 실행 시 JSON 바이트 동일 |

### 12.4 회귀 시험

`harness/contract_negative_tests.py::e25_compare_rule_cases()` **12건** 신설:
보관 출력 PASS·규칙 3/3 배정, 커밋된 결과와 `vs_reference`/`argmax` 불변,
cross_vmfb 1 ulp 통과(+`bit_identical=False` 기록), **same_vmfb 1 ulp는 여전히 FAIL**,
cross_vmfb tolerance 초과 FAIL, cross_vmfb argmax 불일치 FAIL(수치가 통과해도 분류가 다르면 거부),
`--vmfb` 누락 시 거부·미기록, **형식 불량 sha 4종**(잘림·빈 값·비16진·둘 다 잘림) 거부,
보고서 결정성. `numpy` 부재 환경에서는 그룹 전체 SKIP.

### 12.5 자체 검토에서 닫은 fail-open 하나

E25b의 첫 구현은 `--vmfb` 값을 **형식 검증 없이 문자열로만 비교**했다. 그러면 실제로 같은
아티팩트를 쓰는 두 경로의 sha를 잘못 적었을 때(빈 값, 잘린 값, 축약형) 두 값이 서로 달라
**더 약한 `cross_vmfb` 규칙이 조용히 적용된다** — 이 저장소가 D28·D29·D30에서 세 번 닫은 것과
같은 모양(부재·사용 불가 증거를 유효한 증거로 취급)이다. 커밋 전에 발견해, 64자리 16진수
digest가 아니면 **거부하고 아무 파일도 쓰지 않도록** 했다. 시험 4건으로 고정했다.

이 컨테이너 실측: `--skip-regression` **160/160**, 전체 스위트 **203/203**(14/14 계약 회귀 포함,
직전 191/191·199/199에서 증가). 이후 E26a·E26b가 시험을 더 추가했으므로 CI 실측은 그 뒤의
최종 상태로 기록한다 — **CI 실측**(커밋 `3afdf80`, 워크플로 run 56): `full` **228/228 + 1 SKIP**(PyYAML 미설치) · `without-iree` **126/126 + 13 SKIP** · `stdlib-only` **126/126 + 13 SKIP**. 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무이며, 두 수치를 조건과 함께 병기한다(D34).
