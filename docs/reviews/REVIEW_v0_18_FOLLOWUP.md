# onAIR-MLIR v0.18 후속 검토

- 검토 대상: [`wookjaeya/onAIR-MLIR`](https://github.com/wookjaeya/onAIR-MLIR)
- 대상 커밋: [`52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a`](https://github.com/wookjaeya/onAIR-MLIR/commit/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a)
- 이전 검토 기준: `6e9ac102bf024ddea6c3166bd4ff3b0329b8c3e9`
- 변경 범위: E21–E23, v0.16–v0.18
- 검토일: 2026-09-08

## 1. 결론

E21–E23은 형식적인 문서 보강이 아니라 실제 품질 향상이다. 구조적 파서 미설치, ABI 반사 누락,
비상수 `stream.resource.pack`, VMFB 손상 방식, OnAIR의 VMFB 해시 검증, fresh-checkout CI를 코드와
회귀시험으로 다뤘다. 최신 커밋의 GitHub Actions push/PR 실행도 `with-deps`와 `without-deps` 두
matrix job 모두 성공했다.

그러나 **현재 상태를 “fail-closed 배치 계약이 완성됐다”고 평가할 수는 없다.** 새 반례를 직접
실행한 결과, 알려진 모순 또는 검증 불가 상태에서도 `CONTRACT_BOUND_KNOWN=1` 헤더가 생성되는
경로가 남아 있다. 특히 상수량의 아티팩트 측 관측이 계약과 불일치해도 계약이 생성되는 문제와,
연결 ELF가 없는 dump를 받아 `single_invocation=false`로 기록하면서도 배치 가능한 헤더를 만드는
문제는 논문의 핵심 주장과 직접 충돌한다.

또한 E23의 OnAIR 바인딩 수정은 helper 수준에서는 옳지만, 저장소에 포함된 기본
`CompiledLearner` 계약이 새 게이트의 필수 필드인 `artifact.bytes`를 갖지 않아 **기본 실행 경로가
즉시 거부되는 회귀**가 있다. 외부 `weights.npz`도 여전히 계약에 묶이지 않는다.

따라서 냉정한 판정은 다음과 같다.

| 축 | 판정 |
|---|---|
| 연구 문제의 타당성 | 유지됨. 부분 메모리 계약과 배치 전 거부 문제는 분명하다. |
| E21–E23 구현 진전 | 큼. 이전 검토 지적 다수가 실제 코드와 CI로 반영됐다. |
| fail-closed 구현 완성도 | 미완성. 핵심 사각지대 4건을 재현했다. |
| OnAIR↔cFS 동일 배포 경로 | 미완성. VMFB 검사만 추가됐고 모델 전체·출력 동치는 아직 없다. |
| 논문 핵심 결론을 뒷받침할 준비 | 아직 부족. 아래 P0/P1을 먼저 닫아야 한다. |

## 2. 독립 확인 결과

### 2.1 로컬 실행

Python 3.12 환경에서 IREE compiler/runtime와 `jsonschema`가 모두 없는 상태로 다음을 실행했다.

```text
python3 harness/contract_negative_tests.py
48/48 checks passed
6 skipped
```

저장소가 보고한 무-IREE 경로의 수치와 일치했고, 크래시도 없었다. `python3 -m compileall`도
통과했다. 단, 이 환경에는 IREE가 없어 구조적 walker, 실제 A5b IREE load, 14개 계약 재생성은
SKIP되었다. 따라서 로컬에서 `125/125`를 독립 재현했다고 말하지는 않는다.

### 2.2 GitHub 상태

- Draft PR: [#1 E19–E23](https://github.com/wookjaeya/onAIR-MLIR/pull/1)
- 최신 push workflow: [run 34243691641](https://github.com/wookjaeya/onAIR-MLIR/actions/runs/34243691641)
- 최신 PR workflow: [run 34243699029](https://github.com/wookjaeya/onAIR-MLIR/actions/runs/34243699029)
- 두 실행 모두 `with-deps`와 `without-deps` job 성공

PR은 284개 파일, 약 11만 줄 추가 규모다. 그중 242개, 약 6.4 MiB의 compiler dump가 회귀시험
재현성을 위해 포함됐다. 재현성에는 도움이 되지만 코드 변경 검토와 데이터 반입을 별도 commit 또는
artifact bundle로 구분하는 편이 감사 가능성은 더 좋다.

## 3. 이전 지적사항의 현재 상태

| 기존 항목 | 현재 판정 | 근거 |
|---|---|---|
| F1: `None` provenance 통과 | **부분 수정** | 빈 dump-dir은 거부하지만, non-empty dump에서 ELF가 없으면 여전히 계약 생성 가능 |
| F2: ABI 반사 누락 | **수정 확인** | 기본 hard fail 및 명시적 override 분리 |
| F3: 구조적 checker 미설치 | **수정 확인** | 기본 hard fail, 명시적 `--allow-missing-structural-checker`만 허용 |
| F4: 정규 MLIR pass 과장 | **표현 정정** | 실제 구현은 여전히 MLIR API 기반 post-processing verifier |
| F5: `resource.pack` 비상수 누락 | **수정 확인** | 미해결 operand가 `unresolved`로 들어감 |
| F6: 불신뢰 스택을 KNOWN 처리 | **부분 수정** | 명시적 불신뢰 값은 잡지만 classification 필드 자체가 없으면 KNOWN 처리 |
| F7: C dtype 미검사 | **부분 수정** | 매크로는 추가됐지만 스키마의 단수형 interface만 있으면 f16 우회 가능 |
| F8: A5b 재현성 | **코드 수정, 실험 부분 완료** | 결정적 생성기와 Python IREE load는 확인. 새 생성기로 cFS/AArch64 재실행한 raw log는 없음 |
| F9: fresh clone 재현성 | **대체로 수정** | dump 보관, dependency pin, CI matrix 추가. 아래 CI 명칭 caveat 존재 |
| F10: OnAIR 바인딩 | **부분 수정** | VMFB helper는 추가됐으나 기본 fixture가 새 게이트와 불일치하고 외부 weights/E2E 동치는 미해결 |
| F11: 전체 시스템 수용성 | **범위 명시** | `per_app_local_budget`로 오독 가능성은 줄었지만 전역 reservation 문제는 그대로 연구 과제 |

## 4. 신규·잔존 finding

### N1 — P0: 상수량의 독립 관측이 계약과 모순돼도 계약과 KNOWN 헤더가 생성됨

[`make_contract.py`의 상수 확인](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/harness/make_contract.py#L458-L481)은
`iree-dump-module`을 실행하지 못한 `None`만 hard fail 대상으로 삼는다. 도구가 실행되어
`consts_confirmed=False`가 나온 경우는 설명 문자열만 기록하고 거부하지 않는다.

실제 반례에서 conv2d 계약의 IR 상수량은 2,176 B인데 아티팩트 측 관측을 1 B로 주입했다.

```text
make_contract exit       = 0
single_invocation        = true
constants confirmed      = false
constants_check_note     = "2176 B NOT matched ... [1]"
gen_contract_header exit = 0
CONTRACT_BOUND_KNOWN     = 1
CONTRACT_BOUNDED_BYTES   = 3528
```

즉 “관측 불가”는 거부하면서 더 강한 부정 증거인 “관측 결과 불일치”는 통과한다. 부분 메모리 경계의
핵심 수치가 아티팩트와 모순돼도 cFS admission이 이를 알 수 없으므로 최우선 수정 대상이다.

**필요 조치:** `consts_confirmed is not True`를 기본 거부한다. 불가피한 연구용 override는
`--allow-unverified-invocation`과 분리해 이름과 provenance에 명시하고, C 헤더에도 확인 여부를
전파해 defense-in-depth를 둔다.

### N2 — P0: F1 수정이 빈 디렉터리만 막고 개별 provenance `None`은 막지 못함

[`make_contract.py`의 판정식](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/harness/make_contract.py#L577-L605)은
`dump_files`가 완전히 비었을 때만 unverifiable 상태를 거부한다. non-empty dump에서 최종 `.so`만
빠지면 `dump_elf_in_vmfb=None`이지만 오류 목록에 들어가지 않는다.

실제 보관 conv2d dump에서 `.so`만 제거하여 실행한 결과는 다음과 같다. 이 실행에는
`--allow-unverified-invocation`을 사용하지 않았다.

```text
make_contract exit        = 0
provenance.single_invocation = false
provenance.dump_elf       = null
dump_elf_sha256_in_vmfb   = null
gen_contract_header exit  = 0
CONTRACT_BOUND_KNOWN      = 1
```

또한 `layout_dispatches_in_dump`는 계산되지만 계약 provenance에 저장되지 않으며, 최종 식은
`None is not False`를 참으로 취급한다. 이는 E21 문서의 “검증 불가를 불일치와 동일하게
fail-closed 처리했다”는 표현보다 구현 범위가 좁다는 뜻이다.

**필요 조치:** 정상 계약의 필요조건을 명시적으로
`dump_elf_in_vmfb is True and stem_in_dump is True and layout_dispatches_in_dump is True`로 둔다.
신호별 값과 대상 목록도 provenance에 저장한다. `single_invocation is not True`인 계약에서는
헤더 생성을 거부한다.

### N3 — P0: 스키마의 단수형 interface만 쓰면 f16 계약이 `ALL_F32=1`로 변환됨

스키마는 `interface.input`과 `interface.output`을 required로 정의한다. 그러나
[`gen_contract_header.py`](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/harness/gen_contract_header.py#L162-L180)는
개수와 dtype을 비필수 확장 필드인 `interface.inputs/outputs`에서만 읽는다. 두 배열이 없으면
입출력 개수는 1로 기본 설정되고 dtype 집합은 빈 집합이 된다. 빈 집합에 대해
`dtypes - {"f32"}`가 비어 있으므로 f32로 인정된다.

저장 계약에서 배열형 필드를 제거하고 단수형 input/output을 f16으로 바꾼 반례 결과:

```text
gen_contract_header exit = 0
CONTRACT_NUM_INPUTS      = 1
CONTRACT_NUM_OUTPUTS     = 1
CONTRACT_DTYPES_ALL_F32  = 1
```

**필요 조치:** 계약 인터페이스 표현을 하나로 정규화한다. 최소 수정은 배열이 없을 때 단수형
input/output에서 dtype을 읽고, `dtypes == {"f32"}`일 때만 참으로 하는 것이다. 더 좋은 수정은
스키마에 canonical `inputs[]/outputs[]`를 정의·필수화하고 단수형 필드와 동치인지 검증하는 것이다.

### N4 — P1: 스택 classification 누락을 신뢰 가능한 상태로 간주

[`gen_contract_header.py`](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/harness/gen_contract_header.py#L120-L159)는
`kernel_stack_classification=None`을 `none` 및 `bucket_2_task_stack_budget`과 함께 허용한다.
보관 conv2d 계약에서 classification 필드만 제거해도 다음 헤더가 생성됐다.

```text
CONTRACT_KERNEL_STACK_BYTES_KNOWN = 1
CONTRACT_KERNEL_STACK_BYTES       = 191
```

“수치는 있지만 그 분석이 신뢰 판정을 내렸는지 알 수 없음”은 fail-closed 정책에서 UNKNOWN이어야
한다. bound-known 계약에서는 classification 필드를 required로 만들고, 정확히 `none` 또는
`bucket_2_task_stack_budget`인 경우에만 KNOWN을 허용해야 한다.

### N5 — P1: E23의 OnAIR 바인딩 수정이 기본 `CompiledLearner` fixture를 깨뜨림

새 [`artifact_binding.py`](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/plugins/compiled_learner/artifact_binding.py#L28-L54)는
`artifact.bytes`가 없으면 올바르게 거부한다. 그러나 저장소의
[`plugins/compiled_learner/runtime/contract.json`](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/plugins/compiled_learner/runtime/contract.json)은
그 필드를 갖지 않는다.

```text
verify_artifact_binding(default contract, default model.vmfb)
→ ArtifactBindingError: contract.artifact.bytes missing
```

helper 단위시험은 E14의 최신 계약을 사용해 통과하지만, 플러그인이 실제로 기본 runtime fixture를
사용하는 통합 경로는 시험하지 않는다. 더구나 기본 VMFB는 입력 `x` 외에 `w0`, `w1`을 받으며,
2,884,078 B의 `weights.npz`를 별도로 로드한다. 계약에는 이 파일의 해시·크기·메모리 기여가 없다.
따라서 VMFB 해시가 일치해도 가중치를 교체할 수 있고 “배포된 모델 전체의 identity”는 보장되지
않는다.

**필요 조치:** 기본 fixture를 현재 스키마와 게이트에 맞게 재생성하고 실제 플러그인 smoke test를
추가한다. 연구의 cFS 경로와 동일성을 주장하려면 OnAIR도 baked-weight VMFB를 사용하도록 맞추는
것이 가장 단순하다. 외부 weights를 유지한다면 계약을 단일 파일이 아닌 artifact bundle manifest로
확장해 모든 구성요소의 SHA-256, 크기, ABI, 메모리 귀속을 묶어야 한다.

### N6 — P2: `without-deps` CI 명칭과 증거 범위가 정확히 일치하지 않음

[`contract-negative-tests.yml`](https://github.com/wookjaeya/onAIR-MLIR/blob/52bff0d3a8cdbed40aac0fd9d5b394620fe84b6a/.github/workflows/contract-negative-tests.yml)은
`without-deps` job에서도 `jsonschema==4.26.0`을 설치한다. 따라서 이 job은 정확히는
“without IREE”이지 “완전 무의존”은 아니다. 이번 독립 환경에서는 `jsonschema`조차 없이도
48/48+6 SKIP을 재현했으므로 현재 숫자 자체는 맞지만, CI는 향후 `jsonschema` 부재 회귀를 잡지
못한다.

**필요 조치:** matrix를 `full`, `schema-only`, `stdlib-only` 세 개로 분리하거나 명칭과 문서를
`without-iree`로 정정한다.

## 5. 실험·논문 관점에서 아직 남은 증거

1. **새 A5b 생성기로 cFS/AArch64 재실행:** 현재 저장소의 cFS raw log/summary에는 새 생성기로
   실행한 A5b가 없다. Python `iree.runtime` 거부는 유효하지만 게스트 설치·실행 체인의 재현성을
   직접 증명하지는 않는다.
2. **동일 모델 의미의 end-to-end 동치:** 같은 입력 벡터에 대해 Python reference, OnAIR IREE,
   native C, cFS AArch64의 출력과 tolerance를 한 matrix에서 비교해야 한다.
3. **모델 전체 identity:** VMFB뿐 아니라 외부 가중치·전처리 mapping까지 계약에 묶거나,
   baked-weight 단일 artifact로 통일해야 한다.
4. **전체 시스템 메모리와의 경계 유지:** 현재 계약은 `per_app_local_budget`이다. IREE runtime,
   cFS/OSAL, 다른 앱, 동시 실행, allocator fragmentation을 포함한 전역 admission으로 확대했다고
   쓰면 안 된다.
5. **MLIR 명칭 엄격화:** 현재 구현은 compiler pipeline에 등록된 pass가 아니라 dump를 읽는 MLIR
   API 기반 post-processing verifier다. README와 과거 evidence의 “정규 MLIR pass” 표현도
   정오표 링크에만 의존하지 말고 현재 설명에서는 직접 제거하는 편이 안전하다.

## 6. 권장 다음 실험: E24

**E24: Fail-closed contract invariant closure + shipped-path integration**으로 묶는 것이 좋다.

필수 합격조건은 다음과 같다.

1. `constants_independently_confirmed_in_artifact is not True`이면 기본 계약 생성 실패.
2. provenance의 모든 필수 신호가 정확히 `True`가 아니면 계약 생성 실패.
3. `provenance.single_invocation is not True`이면 C 헤더 생성 실패.
4. interface 단수/복수 표현 불일치, dtype 부재, f16, 다중 I/O를 모두 거부.
5. stack classification 부재를 거부.
6. 저장소의 기본 `CompiledLearner` fixture로 binding 및 load smoke test 통과.
7. `weights.npz` 교체가 계약 단계에서 거부되거나, baked-weight VMFB로 외부 가중치 제거.
8. 위 반례 각각을 수정 전 실패·수정 후 통과하는 고정 회귀시험으로 등록.
9. 새 A5b generator를 사용해 AArch64 cFS 시나리오를 재실행하고 raw log와 summary 보관.

이 E24를 닫은 뒤에야 다음 문장을 논문 핵심 주장으로 안전하게 사용할 수 있다.

> MLIR/IREE 컴파일 산출물에서 도출한 부분 메모리 계약은 명시된 경계와 전제 안에서 검증되며,
> 검증 불가·불일치·아티팩트 교체 시 cFS 애플리케이션은 런타임 자원 획득 전에 fail-closed로 거부한다.

현재 저장소는 이 문장에 가까워졌지만, 아직은 “대부분의 정상·음성 시나리오에서 동작하는 강한
프로토타입”이지 “모든 계약 불변식이 닫힌 verifier”는 아니다.
