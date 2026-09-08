# onAIR-MLIR v0.9 소스·실험 이력 검토와 기존 의견서 반영안

검토일: 2026-09-08

- 저장소: <https://github.com/wookjaeya/onAIR-MLIR>
- 검토 브랜치: `claude/review-and-proceed-4y1sag`
- 기준 커밋: `33e1ebc50de30e110f1947e60def308b35b4ed1d`
- 확보한 Git 이력: 최초 커밋부터 기준 커밋까지 41개
- 비교 대상: `SPACE_CPU_AI_MLIR_RESEARCH_OPINION.md`

## 1. 종합 판단

**앞선 의견서보다 구현 성숙도를 높게 평가해야 한다. AArch64 Linux 게스트 안에서 cFS 앱을 실제로 실행한 근거가 추가됐고, 모델 종류 및 커널 스택 분석도 확장됐다. 다만 “7/7 PASS”와 “계약의 일반적 건전성”은 구분해야 한다.**

연구를 계속할 이유는 충분하다. 이제 중심 과제는 환경 구축보다 **계약 생성기의 거부 조건과 실험 판정의 신뢰성을 강화하는 것**이다. 동일 경계의 대안 비교도 필요하지만, 현재 분석기가 어떤 입력을 허용하는지부터 명확히 해야 비교 결과가 의미 있다.

이번 검토에서 특히 중요한 판단은 다음 네 가지다.

1. **진전 확인:** cFS-in-QEMU는 계획 단계가 아니다. 원시 로그와 실행 요약이 존재한다.
2. **성과 범위 정정:** 7건은 선택된 실행 사례다. A2·A5b·재시작 2회+삭제를 포함한 원래 계획 전체를 통과한 것이 아니다.
3. **새로운 실증적 약점:** 텍스트 파서의 할당 누락, 헤더 생성기의 미지원 값 허용을 재현했다.
4. **MLIR 타당성 강화 방향:** Stream 버퍼 계약과 ELF 커널 스택 분석을 연결하는 방향은 구체화됐지만, 구조적 pass와 완전한 조건 검증은 아직 구현되지 않았다.

## 2. 검토 방법과 범위

README만 읽고 판단하지 않았다. Git 변경 이력, 실험 원장, v0.9 근거 문서, 계약 생성·헤더 생성 코드, Native/cFS 초기화·실행·해제 코드, AArch64 빌드 및 시나리오 도구, 저장된 계약·VMFB·실행 로그를 대조했다.

수행한 재검증:

| 검증 | 결과 | 의미 |
|---|---|---|
| 최신 커밋의 7개 모델 변형 × 2개 타깃 VMFB 크기·SHA-256 재계산 | 14/14 일치 | 보관된 계약의 아티팩트 식별값이 파일과 일치 |
| cFS 원시 로그 재파싱 및 저장된 expect 조건 재평가 | 7/7 일치 | 저장된 PASS는 현재 checker 규칙에 부합 |
| Conv2D IR 텍스트의 allocation 줄바꿈에 대한 파서 진단 | 할당 누락 재현 | 파서가 미해석을 항상 UNKNOWN으로 처리하지 않음 |
| 헤더 생성기에 음수 bound·미지원 method 입력 | 모두 종료 코드 0, bound known | 직접 호출 경로의 검증 부족 |
| cross-target 비교 JSON 확인 | `both_sound=null`, 수치 비교 입력 없음 | 계약 비교와 양쪽 타깃 실행 검증을 구분해야 함 |

**이번에 cFS/QEMU 전체 환경을 새로 빌드하거나 추론 실험을 재실행하지는 않았다.** 해시·로그 재집계와 Python 분석기의 제한된 진단을 수행했다. 따라서 실행 결과는 저장소가 보관한 실험 근거이며, 전체 시스템의 독립 재현 결과는 아니다. 검토는 핵심 경로 중심이며 모든 파일에 대한 전수 정형 검증도 아니다.

## 3. 실제 연구 구조

현재 저장소에는 서로 다른 실행 경로가 공존한다.

| 경로 | 소스 | 역할 |
|---|---|---|
| 초기 OnAIR Python 플러그인 | `plugins/compiled_learner/compiled_learner_plugin.py`, `plugins/python_learner/` | OnAIR AIPlugin 인터페이스와 초기 성능 비교 |
| Native C 실행기 | `native/native_learner.c` | Python 없는 IREE 실행, admission·binding·HAL 계측 |
| cFS C 앱 | `native/cfs_app/fsw/src/ai_learner.c` | cFS 초기화에 admission·binding 연결, SB 메시지로 추론 유발 |
| 모델 컴파일·계약 생성 | `harness/e14_matrix.py`, `make_contract.py`, `static_mem_bound.py` | 모델 MLIR을 IREE로 컴파일하고 post-layout 정보를 계약으로 추출 |
| 하위 코드 분석 | `harness/elf_stack_frame.py` | ELF 프롤로그·명령 및 LLVM IR을 이용한 커널 스택 분석 |

**최신 cFS 경로를 “OnAIR Python 플러그인이 cFS 안에서 그대로 실행된다”고 그리면 틀린다.** AI_LEARNER는 IREE C runtime을 직접 사용하는 별도 cFS 앱이다. 초기 OnAIR 플러그인의 계약 확인 기능과 최신 Native/cFS gate도 동일하지 않다.

또한 현재 MLIR/IREE가 컴파일하는 대상은 **AI 모델 표현**이다. cFS 전체 C 소스를 MLIR로 변환·최적화하는 연구가 아니다. 논문 구조도에서 cFS는 모델 계약의 소비자이자 통합 실행 환경으로 표시해야 한다.

## 4. 이력상 성과와 정정의 의미

| 단계 | 주요 변화 | 현재 평가 |
|---|---|---|
| E0–E5 | OnAIR 통합, 크기·lowering 설정별 성능 비교 | 탐색 실험. 최초 성능 해석을 그대로 인용하면 안 됨 |
| E6–E6c | 가중치 per-call 복사와 상수 오귀속 정정 | 성능 비교의 교란요인을 공개적으로 수정한 점이 긍정적 |
| E7–E10 | admission, 동적 shape 거부, slice 합 과소계상 발견 및 slab 방식 도입 | 메모리 계약으로 연구 중심이 이동한 근거 |
| E11–E13 | Native/cFS 통합, 해제 순서 정정, 해시 결합, LLVM/ELF 대응 | 단순 모델 벤치마크에서 배포 검증 프로토타입으로 진전 |
| E14 Stage 0 | AArch64 교차 컴파일·qemu-user | ISA 확장의 첫 확인. 수기 계약값·스택 정의 오류는 후속 정정 필요 |
| E14 Stage 1 / v0.9 | 14개 아티팩트, 세 정적 모델 계열, cFS guest 로그 7건 | 이전 의견서의 “향후 구현” 일부는 완료로 갱신해야 함 |

특히 D9 정정은 중요한 성과다. 초기의 “AArch64에만 16바이트 스택 프레임이 있다”는 결론은 ISA별 집계 정의가 달랐기 때문이었다. 현재 MLP·multibranch의 호출당 스택 추정은 x86-64 host와 AArch64 모두 16바이트다. Conv2D는 각각 239·191바이트의 보수적 분석값을 기록한다.

이력에 오류와 정정을 남기는 방식은 연구 신뢰성에 도움이 된다. 반면 최신 요약 문서에 여전히 근거보다 강한 완료 표현이 남아 있으므로, **정정 원장과 최종 주장 사이의 일관성**을 한 번 더 확인해야 한다.

## 5. 현재 근거로 인정할 수 있는 결과

### 5.1 모델·타깃 행렬

| 모델 계열 | 부분 버퍼 계약(B), 두 타깃 공통 | AArch64 호출당 커널 스택 분석값(B) | x86-64 분석값(B) | AArch64 Native HAL peak(B) | AArch64 cFS HAL peak(B) |
|---|---:|---:|---:|---:|---:|
| MLP h=16384 | 786,476 | 16 | 16 | 786,476 | 786,476 |
| Conv2D | 3,528 | 191 | 239 | **1,352** | **3,528** |
| multibranch | 38,216 | 16 | 16 | 38,216 | 38,216 |

동적 배치 모델은 두 타깃에서 계약 bound가 없으며 UNKNOWN_BOUND로 거부된다. 여기서 “7개 모델”은 정적 기본 모델 3개, 교체용 3개, 동적 모델 1개를 뜻한다. 독립적인 실제 임무 모델 7종으로 세면 안 된다.

Conv2D의 Native와 cFS HAL 피크 차이는 특히 중요하다. 차이 2,176바이트는 계약의 상수 영역과 같다. 이는 상수가 해당 계측 경로에서 어떻게 매핑·할당되는지 조사할 단서다. **정확한 원인은 이번 검토에서 확정하지 않았다.**

따라서 “동일 모델은 언제나 HAL peak=contract”가 아니라, **“관측한 실행 구성에서 HAL peak≤partial contract이며, tightness는 자원 매핑·계측 경계에 따라 달랐다”**로 써야 한다. 부분 계약의 범위에 상주 상수를 포함한다면 Native HAL peak만으로 실제 상수 메모리가 없어졌다고 판단해서도 안 된다.

### 5.2 cFS-in-guest의 실제 7건

| 저장된 시나리오 | 로그가 뒷받침하는 결과 |
|---|---|
| A1_conv2d | 정상 실행 5/5, HAL peak 3,528, 설정 스택 262,335 |
| A1_multibranch | 정상 실행 5/5, HAL peak 38,216, 설정 스택 262,160 |
| A3_mlp16k_swap | 같은 ABI의 다른 VMFB 해시 불일치, cleanup 1회 |
| A4_mlp16k_missing | 파일 부재 이벤트, cleanup 1회 |
| A6_mlp16k_repeat | 마지막 보고 시점 20/20, 보고된 추론 실패 0 |
| A8_dynamic_unknown | UNKNOWN_BOUND, binding 이벤트 없음, cleanup 1회 |
| A7_mlp16k_restart | 재시작 명령 1회, 초기화 2회, cleanup 1회, 재시작 후 마지막 보고 15/15 |

이는 실제 통합 진전이다. 단, A7의 15/15는 **재시작 후 카운터**다. 앱 lifetime 전체 누적 15회로 해석하지 않는다. A1/A6의 수십 회 이하 실행도 장기 안정성 시험이라고 부르기는 어렵다.

## 6. 우선 수정할 발견 사항

### R1. A5b 실행 완료 주장에 대응하는 근거가 없다 — 우선도 높음

`docs/EVIDENCE_v0.9_E14_stage1.md` §4.1과 §9는 A5b를 Native Conv2D에서 확인했다고 서술한다. 그러나 해당 문서 §3 표와 Native 원시 로그·summary에 있는 것은 **A5a**다.

- A5a: 원본 계약 + 손상 VMFB → 해시 불일치로 gate에서 거부.
- A5b: 손상 VMFB의 해시를 가진 계약 → binding 통과 후 IREE 로더가 오류를 처리해야 함.

두 경로는 다르다. 저장된 cFS summary에서도 `runtime_load_failed`는 모든 사례에서 null이다. 검토한 결과 디렉터리에서 A5b 실행 성공 근거는 찾지 못했다.

**권고:** A5b를 “미검증/증거 미보관”으로 정정하고 Native 및 cFS에서 별도로 실행한다. 임의 offset 4096의 bit flip은 가중치만 바꿀 수도 있으므로, 로더가 반드시 거부해야 하는 구조 손상 입력을 명시적으로 구성한다. 기존 A5a 성공을 A5b 성공으로 대체하지 않는다.

### R2. 파서가 할당을 놓쳐도 UNKNOWN으로 전환되지 않을 수 있다 — 우선도 높음

`static_mem_bound.py:parse_alloc_ir()`는 allocation을 한 줄 정규식으로 인식한다. 실제 Conv2D의 저장된 IR에 줄바꿈만 추가하는 파서 단위 진단을 했다.

```text
기존: inputs=[256], outputs=[8], transient_slabs=[1088], unresolved=[]
변경: inputs=[256], outputs=[],  transient_slabs=[],     unresolved=[]
두 경우 모두 entry_found=True
```

`make_contract.py`의 `all_static = entry_found and not unresolved` 판정에서는 누락을 검출하지 못한다. 미지원 표현을 “해석 불가”가 아니라 “해당 할당 없음”으로 취급하는 위험이다.

이 진단은 **텍스트 파서의 취약성을 재현**한 것이다. 변경된 텍스트를 MLIR 도구로 다시 파싱하거나 전체 compile→gate 경로의 과소계상을 재실행한 것은 아니다. 현재 보관된 원본 14개 계약이 잘못됐다는 결론도 아니다.

**권고:** 지원 operation과 크기 표현을 명시하고 전체 자원 사용 연산의 해석 여부를 검사한다. 정규 MLIR/IREE pass로 옮길 이유가 이제 추상적인 유지보수 장점보다 구체적인 **누락 검출**에 있다. pass 구현 자체와 soundness 증명은 별개다.

### R3. JSON의 조건 기록과 실제 허용 조건이 일치하지 않는다 — 우선도 높음

`make_contract.py`는 ABI 불일치, target triple 불일치, 분석한 ELF 불일치 일부를 `notes`에 남기지만 모두 계약 생성 실패로 처리하지는 않는다. `gen_contract_header.py`도 입력 전체를 엄격하게 검증하지 않는다.

헤더 생성기 직접 호출 경로에서 다음을 재현했다.

| 변경한 입력 | 생성 결과 |
|---|---|
| `bounded_bytes=-10` | 종료 0, `CONTRACT_BOUND_KNOWN 1`, `CONTRACT_BOUNDED_BYTES -10L` |
| `bound_method="UNSUPPORTED"` | 종료 0, `CONTRACT_BOUND_KNOWN 1` |
| 커널 스택 분석값 제거 | 종료 0, `CONTRACT_KERNEL_STACK_BYTES_KNOWN 0`, 스택 0 |

정상 스키마 검증을 반드시 거치는 신뢰된 파이프라인이라면 일부 잘못된 입력은 더 앞에서 차단될 수 있다. 그러나 헤더 생성기 직접 실행은 공개된 작업 경로이므로 그 의존성을 명시하거나 자체 검증해야 한다.

또한 Native/cFS 실행기는 단일 f32 입력·출력 경로를 구현하지만, 생성되는 `CONTRACT_NUM_INPUTS/OUTPUTS`를 gate에서 검증하지 않는다. compiler/runtime/target 필드 전체를 실행 전 검증한다고 표현해서도 안 된다.

**권고:** 허용 method 목록, 비음수 범위, 입력·출력 수와 dtype, ABI 일치, 필수 provenance 검증을 계약 수용 조건으로 정한다. HAL-only 허용과 커널 스택까지 검증된 허용은 서로 다른 상태로 표현한다.

### R4. 스택 회계는 구현됐지만 스택 admission gate는 아니다 — 우선도 높음

`AI_LEARNER_Init()`는 다음 값을 계산한다.

```c
int accounted = es_stack >= stack_needed;
```

그 뒤 로그·이벤트를 남기고 `CFE_SUCCESS`를 반환한다. `accounted=false`에서 초기화를 거부하는 분기가 없다. 이 확인은 IREE runtime·module·입력 버퍼·SB 파이프를 만든 뒤 수행된다.

게다가 262,144바이트 base stack은 이력상 설정한 예산이며, runtime부터 앱까지의 전체 호출 경로에 대한 증명된 최대 사용량은 아니다. `feat[CONTRACT_INPUT_ELEMS]` 등 앱의 입력 크기 의존 지역 배열도 존재한다.

**권고:** 현재는 “커널 스택 분석값을 설정 스택에 반영하고 메타데이터를 확인했다”고 쓰고, “전체 스택 안전을 검증했다”는 표현은 피한다. 스택 부족 거부를 주장하려면 미달 설정의 음성 실험과 실제 거부 분기를 추가한다.

### R5. one-invocation 검사는 유용하지만 완전한 결합 증명은 아니다 — 우선도 중상

현재 도구는 VMFB 내부 ELF와 dump ELF의 일치, 입력 basename과 dump 파일명의 관련성을 검사한다. `e14_matrix.py`가 한 번의 컴파일 호출로 산출물을 만드는 정상 경로도 구현돼 있다.

그러나 독립 실행 가능한 `make_contract.py`는 layout IR의 모든 메모리 계획이 해당 VMFB에서 나왔다는 사실을 완전히 검증하지 않는다. `single_invocation=true`는 주로 ELF 일치와 이름 검사에서 산출된다. layout IR의 해시를 계약에 적는 것만으로 VMFB와의 관계가 증명되지는 않는다.

**권고:** “대표적인 산출물 혼입을 탐지한다”로 표현을 좁힌다. 컴파일 wrapper가 생성한 manifest의 입력·명령·compiler·출력 해시를 extraction에서 검증하고, stale layout IR·동일 basename 다른 원본·ELF 분석 JSON 혼입을 각각 시험한다. 공급망 공격까지 다루려면 별도 신뢰 모델이 필요하며, 현재 연구에 반드시 추가할 필요는 없다.

### R6. 7/7 PASS를 생명주기 전체 검증으로 확대하면 안 된다 — 우선도 중상

저장된 7개 cFS 로그는 모두 `EXIT=124`이며, 종료 부분에는 timeout이 보낸 SIGINT와 cFS processor reset 경로가 나타난다. 이는 의도된 실험 종료이지 곧바로 크래시를 뜻하지 않는다. 하지만 A1·A6의 cleanup은 0회라서 정상 앱 종료·자원 회수 성공의 근거로도 쓸 수 없다.

재시작 A7은 1회 성공을 보여준다. 원래 generator의 계획은 재시작 2회 후 삭제였으며, 실제 실행 expect도 이보다 완화돼 있다. 예를 들어 A1의 generator 최소 완료 횟수는 15회인데 보관된 실행 expect는 3회다. 변경 자체는 가능하지만 계획 대비 축소를 명시해야 한다.

checker는 `run/stack` 로그가 없으면 `runtime_created=false`로 추정하고 `no_crash`는 특정 문자열 부재로 판단한다. 빈 로그에 `runtime_created=false`, `no_crash=true`, `no_failures=true`만 주면 통과하는 진단도 재현했다. 실제 7개 시나리오에는 추가 조건이 있어 빈 로그 전체가 통과한다는 뜻은 아니다.

**권고:** runtime 생성·해제에 직접 카운터를 넣고 lifetime별로 집계한다. 초기화 2회+cleanup 1회는 재시작 1회 관측으로 기술한다. 정상 STOP/DELETE 종료는 timeout 경로와 분리한다. OPERATIONAL 문자열 한 번 관측은 관측 구간 전체의 타 앱 무영향을 증명하지 않는다.

### R7. 교차 타깃 계약 비교와 교차 타깃 실행 검증을 구분해야 한다 — 우선도 중간

`comparison/cross_target.*.json`의 `native`는 null이며 `both_sound` 및 수치 출력 일치도 null이다. 이 파일들은 두 타깃의 계약 수치와 구조를 비교한 근거다. 확장한 모든 모델에 대해 양쪽 runtime 피크와 출력까지 확인한 근거로 직접 인용할 수 없다.

**권고:** x86-64와 AArch64의 동일 입력 Native 결과를 각각 연결하여 `both_sound`와 전체 출력 비교를 채운다. 현재는 “시험한 세 정적 모델의 계약값이 두 target 설정에서 동일했다”고 쓴다. 세 사례만으로 “모델 종류와 무관하게 불변”이라 일반화하지 않는다.

### R8. binding 이전 blob 할당은 계약 밖 자원 경계다 — 우선도 중간

cFS 코드는 파일 전체 크기를 읽어 `malloc(blob_len)`한 뒤 계약의 크기·해시와 비교한다. 예산 gate는 먼저 있지만 VMFB blob 자체는 그 부분 계약의 범위 밖이다. 따라서 모델 파일이 예상보다 커도 먼저 파일 크기만큼 할당을 시도한다.

**권고:** 계약의 `artifact.bytes`와 실제 파일 크기를 먼저 비교하고, 별도 로딩 예산·크기 상한을 확인한 뒤 버퍼를 할당한다. 이는 전체 프로세스 메모리 보장을 추가하는 것이 아니라 이미 분리한 로딩 영역을 일관되게 관리하는 보강이다.

## 7. 방금 작성한 의견서에 반영할 변경

기존 의견서의 “CPU 사례는 연구 대상을 정당화하고 MLIR은 필수조건은 아니다”라는 결론은 유지한다. 변경할 것은 구현 상태와 우선순위다.

| 기존 의견서의 항목 | 반영할 수정 |
|---|---|
| 최신 저장소를 재검토하지 않았다는 전제 | 본 검토 커밋 `33e1ebc`를 기준으로 코드·원자료 대조를 완료했다고 갱신. 전체 시스템 독립 재실행은 별도 구분 |
| cFS-in-AArch64를 향후 검증 환경처럼 설명 | 선택한 시나리오 7건의 guest 실행이 이미 존재한다고 수정 |
| 모델 세트 확대를 주된 다음 단계로 제안 | MLP·Conv2D·multibranch가 이미 존재함을 반영. 다음 확장은 임무 의미를 가진 workload로 제한 |
| 스택을 단순 제외 영역으로 언급 | 커널 스택 분석·설정 반영은 구현됨. 전체 task stack 상한·미달 거부는 미완료로 분리 |
| 텍스트 파서의 잠재적 취약성 | 줄바꿈에 의한 누락 진단 결과를 추가하고 fail-closed 보강의 구체 근거로 사용 |
| 모델 교체 실험을 모두 신규 제안 | stale 계약+교체 VMFB 거부는 이미 구현·관측. 다음은 모델+계약 정상 갱신 및 조건 불일치 검사 |
| 계약과 HAL peak 일치를 대표 성과로 사용 | Native Conv2D 1,352≤3,528과 cFS 3,528=3,528을 함께 적어 구성별 tightness 구분 |
| 다중 AI 앱·대안 비교로 곧바로 확장 | 우선 A5b 증거 정정, verifier·checker 강화, 미완료 생명주기 시험을 수행 |

### 기존 의견서 §5를 대체할 수 있는 문단

> 기준 커밋 33e1ebc에서 연구는 AArch64 Linux QEMU 게스트의 cFS 앱 실행까지 진전했다. MLP·Conv2D·multibranch와 교체·동적 변형을 포함한 14개 아티팩트의 계약·해시가 보관돼 있으며, cFS 원시 로그는 정상 실행, 모델 불일치, 파일 부재, 동적 shape 거부, 반복 추론 및 한 차례 앱 재시작을 뒷받침한다. 다만 실행한 7건의 PASS는 원래 계획한 모든 시나리오의 완료를 뜻하지 않는다. A5b의 runtime 로드 실패 주장은 대응 원자료가 확인되지 않으며, 스택 확인은 설정값 비교·보고 단계다. 계약 생성기의 미지원 값 처리와 IR 누락 검출을 강화하는 것이 다음 연구의 우선순위다.

### MLIR 타당성 문단에 추가할 의견

> v0.9에서는 HAL 버퍼 계획과 ISA별 커널 스택이 서로 다른 분석 계층에 있다는 점이 실제 코드로 드러났다. 이는 다단계 IR과 최종 ELF를 함께 사용하는 연구 설계를 뒷받침한다. 동시에 텍스트 파서의 누락 진단은 구조적 MLIR pass와 명시적인 미지원 상태가 필요한 이유를 제공한다. 이러한 결과는 MLIR의 독점적 필수성을 증명하지 않으며, 동일 경계의 대안 대비 자동화·검증 가능성의 이점을 별도로 평가해야 한다.

## 8. 권장 후속 순서

1. **증거 정정:** A5b 미검증, A7 1회 재시작, timeout 종료, cross-target null 필드를 문서와 실험 원장에 일치시킨다.
2. **계약 verifier 보강:** method·크기·dtype·ABI·provenance·스택 unknown을 명시적으로 판정한다. 현재 지원 범위는 단일 f32 입력·출력으로 좁혀 시작해도 된다.
3. **파서 및 도구 음성 시험:** 줄바꿈·미지원 op·stale layout·잘못된 ELF 분석·누락 메타데이터가 잘못된 ADMIT으로 이어지지 않는지 확인한다.
4. **남은 cFS 시나리오 완료:** 예산 B-1/B/B+1, A5b, 스택 미달, 재시작 2회+삭제를 실제 guest에서 수행한다. 불필요한 장기 타이밍 측정은 하지 않는다.
5. **정규 MLIR/IREE pass 및 대안 비교:** 지원 범위와 판정 기준이 고정된 뒤 구현·비교한다. 비교 항목은 과소 추정, 과도한 거부, 적용 범위, 재생성 비용, 변경 추적성이다.

다중 앱 admission은 그 이후가 적절하다. 현재 단일 앱의 예산 비교에는 전역 예약이 없으므로 동시 admission은 새로운 동시성·자원 소유 문제를 추가한다. 현 단계에서 연구 범위를 넓히는 것보다 기존 계약의 거부 조건을 닫는 편이 기여를 더 명확하게 만든다.

## 9. 최종 평가

| 항목 | 평가 |
|---|---|
| 우주 CPU AI를 대상으로 한 응용 타당성 | 유지 — 외부 비행 사례와 연결 가능 |
| 실제 구현의 성숙도 | 이전 의견서보다 상향 — AArch64 cFS guest 실행 근거 확보 |
| 재현 자료의 충실도 | 양호 — 원시 로그·계약·바이너리·정정 이력 존재 |
| 검증 주장과 자료의 일치 | 보강 필요 — A5b, 종료, cross-target 실행 범위 |
| 계약 추출기의 일반적 신뢰성 | 아직 부족 — 텍스트 누락 및 조건 검증 진단에서 취약점 확인 |
| MLIR의 고유 연구 기여 | 발전 가능 — 구조적 분석과 계약 검증 방법이 핵심 |

**현재는 의미 있는 연구용 통합 프로토타입이다. 논문의 설득력을 더 높이려면 실험 건수보다 “어떤 증거가 없을 때 반드시 거부하는가”를 먼저 완성해야 한다.**

## 10. 코드·근거 링크

모든 링크는 검토 커밋에 고정했다.

- [커밋 및 변경점](https://github.com/wookjaeya/onAIR-MLIR/commit/33e1ebc50de30e110f1947e60def308b35b4ed1d)
- [실험 원장](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/EXPERIMENT_LOG.md)
- [v0.9 근거 문서](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/docs/EVIDENCE_v0.9_E14_stage1.md)
- [정적 버퍼 파서](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/harness/static_mem_bound.py)
- [계약 생성기](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/harness/make_contract.py)
- [C 헤더 생성기](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/harness/gen_contract_header.py)
- [cFS AI_LEARNER](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/native/cfs_app/fsw/src/ai_learner.c)
- [cFS 시나리오 판정 도구](https://github.com/wookjaeya/onAIR-MLIR/blob/33e1ebc50de30e110f1947e60def308b35b4ed1d/harness/e14_cfs_scenarios.py)
- [cFS 실행 요약·원시 로그](https://github.com/wookjaeya/onAIR-MLIR/tree/33e1ebc50de30e110f1947e60def308b35b4ed1d/results/e14_aarch64_qemu/cfs)
- [Native 실행 요약·원시 로그](https://github.com/wookjaeya/onAIR-MLIR/tree/33e1ebc50de30e110f1947e60def308b35b4ed1d/results/e14_aarch64_qemu/native)
- [교차 타깃 비교](https://github.com/wookjaeya/onAIR-MLIR/tree/33e1ebc50de30e110f1947e60def308b35b4ed1d/results/e14_aarch64_qemu/comparison)

이 문서는 검토 의견과 기존 MD 반영안을 제공한다. 저장소 코드·원본 실험 이력·기존 의견서 본문은 변경하지 않았다.
