# EVIDENCE v0.10 — E15: 계약 도구 fail-closed 전환 + 음성 시험

## 0. 등급과 범위

**증거 등급: 결정론적.** 이 실험은 파일 파싱·정적 분석·프로세스 종료 코드만 다룬다. 지연값·RSS는
관여하지 않으므로 `platform_check.py` 등급과 무관하다.

**환경 제약**: 이 컨테이너는 세션마다 새로 시작되며 `~/onair-mlir-bench`(cFS 빌드, IREE C 런타임,
AArch64 게스트 이미지)가 비어 있었다. 이 실험은 **환경 재구축 없이** 가능한 범위로 한정했다 —
`iree-compile`(v0.9와 동일 커밋 `e4a3b0405d7d23554da26403658d0e8c3c5ecf25`)와
`results/e14_aarch64_qemu/`에 보관된 v0.9 산출물(layout IR, ELF 분석, dump-dir, vmfb, 계약, 헤더)만
사용했다. **C 게이트(`native_learner.c`, `ai_learner.c`) 자체의 수정은 이번 범위 밖이다**
(EVIDENCE_v0.9 §11.9의 계획 Phase 3, cFS/x86-64 환경 재구축 필요).

## 1. 배경

외부 검토 2건(`docs/reviews/REVIEW_v0_9_CODE_AND_MD_AMENDMENTS.md`,
`docs/reviews/OPINION_v0_9_SPACE_CPU_AI_INTEGRATED.md`, 기준 커밋 `33e1ebc`)이 계약 생성 도구
체인(`static_mem_bound.py`, `make_contract.py`, `gen_contract_header.py`)이 **fail-open**임을
직접 재현으로 확인했다 — 미인식 자원 할당 연산이 조용히 무시되고, 음수 `bounded_bytes`가
`CONTRACT_BOUND_KNOWN=1`로 헤더에 실려 C 게이트를 무조건 통과시킬 수 있었다(`docs/EVIDENCE_v0.9_E14_stage1.md`
§11.9, 결함 원장 D12·D13·D14).

이 실험(E15)은 두 검토가 합의한 2순위 항목("fail-closed 계약 verifier")을 수행한다: 도구를
fail-closed로 전환하고, 음성 시험으로 "거부돼야 할 입력이 실제로 거부되는지" 확인하며, 보관된
v0.9의 14개 계약·헤더가 이 변경으로 값이 바뀌지 않음(회귀 없음)을 증명한다.

## 2. 변경 사항

### 2.1 `harness/static_mem_bound.py::parse_alloc_ir` — 파서 fail-open 수정 (D13 R2)

- **줄바꿈 취약성**: 기존 정규식(`stream\.tensor\.import[^\n]*...`, `stream\.resource\.alloca[^\n]*...`)이
  한 줄(`[^\n]*`)로 한정돼, MLIR 프린터가 긴 연산을 여러 줄로 나눠 출력하면 그 연산의 크기가 조용히
  누락됐다(직접 재현: conv2d layout IR에 줄바꿈만 삽입하면 `outputs`·`transient_slabs`가 사라지고도
  `unresolved`는 비어 있었다). 새 정규식은 "다음 SSA 정의(`%value = ...`)나 닫는 중괄호로 시작하는
  줄이 아닌 한" 개행을 허용하는 경계 있는 non-greedy 패턴(`_CONT`)으로 바뀌었다 — 한 연산 내부의
  줄바꿈은 건너뛰되 이웃 연산을 잘못 삼키지 않는다.
- **미인식 op 승격**: entry 함수 본문에서 발견되는 `stream.resource.*`/`stream.tensor.*` op 이름을
  화이트리스트(`resource.alloca`, `resource.pack`, `resource.dealloca`, `tensor.import`,
  `tensor.export` — 보관된 14개 layout IR 전수 조사로 확정된, entry body에 실제 등장하는 자원 관련
  op 전체)와 대조해, 화이트리스트 밖의 op가 하나라도 있으면 `unresolved`에 `unrecognized_op:...`로
  추가한다. 이전에는 이런 op가 그냥 무시됐다.

### 2.2 `harness/static_mem_bound.py::main` — `entry_found` 누락 수정 (D12)

독립 실행 경로의 `all_static = len(unresolved)==0`이 `entry_found`를 빠뜨려, entry 함수를 못 찾아
IR 전체를 파싱한 경우에도 `bound_method=static_from_stream_layout`을 출력할 수 있었다
(`make_contract.py`의 `all_static`은 이미 `entry_found`를 포함해 영향받지 않음). `p["entry_found"] and
not p["unresolved"]`로 수정.

### 2.3 `harness/make_contract.py` — one-invocation 결합 확장 + hard fail 승격 (D13 R3, D14 R5)

- **layout IR을 dump-dir에 결합(D14)**: 기존 one-invocation 검사(D10)는 임베디드 ELF sha256 매칭과
  dump-dir 파일명의 mlir basename 포함 여부, 두 신호만 봤다 — **layout IR 자체는 검사에 전혀
  결합돼 있지 않았다.** bound를 만드는 모든 수치가 layout IR에서 나오는데도 그렇다. 새 검사는 layout
  IR이 참조하는 `stream.cmd.dispatch @NAME::...` 심볼 각각이 `--dump-dir`에 실제 파일로 존재하는지
  확인한다(예: `infer_dispatch_0` → `module_infer_dispatch_0.mlir`). 다른 컴파일의 layout IR(다른
  dispatch 수·이름)을 섞으면 이 대조가 실패한다.
- **ABI 불일치·target triple 불일치·ELF 분석 대상 불일치를 hard fail로 승격**: 기존에는 `notes`에만
  기록되고 계약이 그대로 작성됐다. 이제 기본값은 거부이며, `--allow-abi-mismatch` /
  `--allow-triple-mismatch` / `--allow-elf-analysis-mismatch`로만 명시적으로 우회할 수 있다.
- **스키마 검증을 파일 기록 전으로 이동**: 기존에는 계약을 먼저 디스크에 쓰고 나중에 검증해 exit 3이
  나도 잘못된 계약이 남았다. 이제 검증이 먼저이고, 실패하면 파일을 쓰지 않는다. `jsonschema`가
  설치되지 않은 경우도 (이전의 "조용히 건너뜀"이 아니라) `--no-validate`를 명시하지 않는 한 실패로
  처리한다.

### 2.4 `harness/gen_contract_header.py` — 헤더 생성기 검증 (D13 R3/R3b)

이전에는 `artifact.sha256`의 길이(64자)만 검사했다. 이제 다음을 모두 검사하며, 위반 시 헤더를 쓰지
않고 종료 코드 0이 아닌 값을 반환한다:

- `bound_method`가 계약 스키마의 enum(`static_from_stream_schedule`, `static_from_stream_layout`,
  `NONE`) 밖이면 거부.
- `bounded_bytes`가 정수가 아니거나 음수면 거부.
- bound-known 계약(admission이 ADMIT/NOT_ADMITTED로 판정될 계약)인데 커널 스택 필드
  (`kernel_task_stack_invocation_bytes`/`kernel_task_stack_bytes`)가 없으면 거부 — 이전에는
  조용히 `CONTRACT_KERNEL_STACK_BYTES_KNOWN=0`, `CONTRACT_KERNEL_STACK_BYTES=0L`로 헤더가 만들어졌고,
  이 매크로를 소비하는 코드가 저장소 어디에도 없어 사실상 "커널 스택 0 B"로 취급됐다. 새 플래그
  `--allow-unknown-stack`로만 명시적 우회 가능.
- bound-known 계약의 입출력이 `native_learner.c`/`ai_learner.c`가 하드코딩한 단일 f32 입력·단일 f32
  출력이 아니면 거부(입력·출력 개수, dtype 확인). C 코드 자체를 고치지 않고도, 그 C 코드가 이미
  전제하는 조건을 헤더 생성 시점에 강제한다.
- `artifact.sha256`이 64자이면서 실제로 16진수 문자로만 구성됐는지도 확인(이전에는 길이만 확인).

## 3. 음성 시험 (`harness/contract_negative_tests.py`, 신규)

전부 "거부돼야 한다"가 기대 결과인 20건 + 단위 시험 5건 + 회귀 26건(14개 계약·14개 헤더, 일부 모델은
계약만 카운트되는 항목 제외) = **총 51개 체크, 51/51 PASS**.

| 구분 | 케이스 | 결과 |
|---|---|---|
| 단위(파서) | 원본 conv2d layout IR 정상 파싱(회귀 기준선) | PASS |
| 단위 | 줄바꿈 삽입 2종(alloca 내부, 리소스 타입 앞) → 크기 보존, `unresolved` 여전히 빈 값 | PASS(정상 복구됨을 확인 — R2 버그 수정 검증) |
| 단위 | entry body에 미인식 op 삽입 → `unresolved`에 등록 | PASS |
| 단위 | entry 함수 이름을 못 찾게 변형 → `entry_found=False`, `all_static=False`(D12) | PASS |
| 헤더 | 정상 계약(변형 없음) → **수용**(음성 시험이 공허하지 않음을 보장하는 대조군) | PASS |
| 헤더 | `bounded_bytes=-10`, `=-1` | 거부 |
| 헤더 | `bound_method="UNSUPPORTED"`, `"none"`(소문자) | 거부 |
| 헤더 | bound-known 계약에서 스택 필드 제거 | 거부(단, `--allow-unknown-stack`로 명시적 수용 가능함을 별도 확인) |
| 헤더 | 다중 입력으로 변형, 비-f32 dtype으로 변형 | 거부 |
| 헤더 | `artifact.sha256` 비16진수, 길이 오류 | 거부 |
| make_contract | 정합하는 conv2d 아티팩트 일체 → **수용**(대조군) | PASS |
| make_contract | **D14**: conv2d의 layout IR + mlp16k의 dump-dir(dispatch 3개 vs 파일 2개분) | 거부 |
| make_contract | ABI declaration을 조작해 MLIR 소스 시그니처와 불일치시킴 | 거부 |
| make_contract | dump-dir의 `codegen.ll` target triple을 `x86_64`로 조작(aarch64 컴파일에 대해) | 거부 |
| make_contract | `--elf-analysis` JSON의 `elf_sha256`을 임베디드 ELF와 다른 값으로 조작 | 거부 |
| make_contract | dump-dir을 완전히 다른 모델(mlp16k) 것으로 교체(D10, 기존 검사의 회귀 확인) | 거부 |

## 4. 회귀 — 보관된 v0.9의 14개 계약·헤더 불변

`results/e14_aarch64_qemu/{aarch64,x86_64}/{contracts,headers}/`의 7개 모델(mlp16k, mlp16k_swap,
conv2d, conv2d_swap, multibranch, multibranch_swap, dynamic) × 2 타깃 = 14개를, **fail-closed로
바뀐 도구로 원본 산출물(layout IR·dump-dir·ELF 분석·vmfb)에서 재생성**해 비교했다.

- 계약 JSON: 비결정론적으로 문서화된 필드(`layout_ir_sha256` 등 6개, `EVIDENCE_v0.7_E13.md`에서 이미
  비재현성이 기록됨)를 제외한 **모든 필드가 14/14 바이트 단위로 일치**.
- 헤더(.h): **14/14 완전히 동일**(diff 0).
- 스키마 검증: 14/14 `valid`(이전에는 `--no-validate` 없이도 검증이 파일 기록 후에 실행됐으나, 이번엔
  기록 전에 실행되도록 순서를 바꾼 채로도 동일하게 통과).

즉 이번 fail-closed 전환은 **이미 유효한 정상 입력의 결과를 하나도 바꾸지 않았고**, 이전에는
조용히 통과하던 비정상 입력만 새로 거부한다.

## 5. 이번 실험이 다루지 않는 것 (범위 밖)

- **C 게이트 자체의 변경**: 스택 미달 거부 분기 추가, blob 할당 전 `artifact.bytes` 선검사,
  `CONTRACT_NUM_INPUTS/OUTPUTS`의 런타임 gate는 하지 않았다(EVIDENCE_v0.9 §11.9 Phase 3, x86-64 환경
  재구축 필요). 이번 실험의 다중 입력/dtype 거부는 **헤더 생성 시점**에서만 이뤄진다 — 이미
  생성된 헤더를 손으로 편집해 C 코드에 넘기는 경로까지 막지는 않는다.
- **정규 MLIR/IREE pass**: 여전히 텍스트 정규식 기반이다. 화이트리스트 승격(§2.1)은 "미인식 op를
  무시하지 않는다"는 속성만 보장하며, `stream.resource.alloca`/`pack` 내부의 크기 표현이 정규식이
  다루지 못하는 새로운 문법으로 바뀌면(예: 완전히 다른 인코딩) 여전히 놓칠 수 있다 — 4순위 항목(정규
  pass)의 필요성은 그대로 남는다.
- **AArch64 게스트 cFS 재현(A5b 등)**: 이번 실험과 무관, EVIDENCE_v0.9 §11.9 Phase 4.
- **layout IR의 암호학적 provenance**: §2.3의 dispatch-name 결합은 "같은 dispatch 이름을 우연히
  재사용하는 별개의 컴파일"까지는 잡지 못한다(EVIDENCE_v0.9 §11.7의 지적과 동일한 한계가 남음) —
  "대표적 산출물 혼입 탐지"이지 수학적 증명이 아니다.

## 6. 판정

fail-closed 전환 전, D12/D13/D14가 지적한 5가지 구체적 실패 모드(파서의 줄바꿈 누락, 파서의 미인식
op 무시, 헤더 생성기의 음수/미지원 bound_method 수용, 헤더 생성기의 스택 미상 수용, one-invocation
검사의 layout IR 미결합)를 각각 직접 재현해 거부로 전환했고, 그 과정에서 보관된 14개 계약·헤더의
값은 하나도 바뀌지 않았다(§4). "모델·시나리오 수를 늘리는 것보다 어떤 정보가 없거나 잘못됐을 때
절대 ADMIT하지 않는가를 먼저 닫는다"는 외부 검토 2건의 공통 권고(2순위)를 이 범위에서 완료했다고
본다 — 단, §5에 명시한 대로 C 게이트 자체와 정규 MLIR pass는 여전히 미착수다.

## 7. 재현

```bash
python3 harness/contract_negative_tests.py --root results/e14_aarch64_qemu
```

산출물: 표준출력에 51개 체크 각각의 PASS/FAIL과 상세, 마지막 줄에 `N/51 checks passed`.
