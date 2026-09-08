# CLAUDE.md — 프로젝트 컨텍스트 (Claude Code용)

이 파일은 Claude Code가 세션 시작 시 자동으로 읽는 컨텍스트 파일이다. 여기 없는 세부사항은
`PROGRESS.md`(현재 상태 한 장 요약) → `EXPERIMENT_LOG.md`(전체 실험 레지스트리) →
`docs/EVIDENCE_v0.*.md`(버전별 상세 근거) 순으로 내려가며 읽는다.

## 프로젝트 한 줄 요약

NASA cFS/OnAIR 위에서 MLIR/IREE로 AOT 컴파일한 AI 추론 아티팩트를 배치할 때, 컴파일러의
할당 스케줄에서 도출한 **정적 메모리 계약**으로 배치 전 admission(허용/거부) 판정을 수행하는
연구. 현재 버전: **v0.13**(git tag는 환경 제약으로 보류 — 커밋 이력·CHANGELOG로 확인).
중심 주장은 **정오표 반영 개정판**을 그대로 쓴다 — 지어내지 말 것(`docs/EVIDENCE_v0.9_E14_stage1.md`
§11.8이 정본, 아래는 그 요약):

> 정적 메모리 계약(per-call 버퍼 + 모듈 상주 상수)은 MLP·Conv2D·multi-branch 세 가지 할당
> 구조에서 x86-64와 AArch64(Cortex-A53, QEMU 시스템 에뮬레이션) 모두 동일한 값으로 산출됐고,
> 시험한 실행 구성에서 각 타깃의 HAL 관측 피크 이하였다(tightness는 구성에 따라 다름 — conv2d
> native 1,352 ≤ 3,528 vs cFS 3,528 = 3,528). 같은 계약을 AArch64 게스트 안의 cFS
> `AI_LEARNER` 앱 초기화 admission에 연결해, 선택된 7개 시나리오(정상 허용·모델 교체 거부·
> 모델 파일 부재·반복 추론 무결성·동적 형상(UNKNOWN_BOUND) 거부·앱 재시작 1회)를 실행
> 검증했다(원래 계획한 전체 시나리오의 완주는 아니며, 정상 종료 시의 자원 회수는 미검증).
> AArch64 코드생성이 도입하는 고정 태스크 스택 잔차는 모델의 지역 버퍼 유무에 따라 16 B(MLP·
> multi-branch)에서 191 B(Conv2D, 동적 재정렬 패딩 포함)까지 달랐으며, HAL 계약이 아닌 태스크
> 스택 예산으로 별도 회계해 시작 스크립트에 반영하고 런타임이 그 설정값의 충분성을 스스로
> 확인해 보고하도록 구현했다(초기화를 거부하는 gate는 아님). 동일 경계의 대안 비교는 여전히
> 후속 대상이다.

**절대 하지 말 것**: H1(AOT가 더 빠르다)이나 H2(계약 기반 lowering 선택이 유리하다)를 다시
주가설로 세우지 말 것 — 둘 다 실험으로 기각/격하됐다(`EXPERIMENT_LOG.md`의 가설 판정 이력 참조).

**v0.9에서 완료된 것**: E14 Stage 1(qemu-system-aarch64 전체 시스템 + cFS-in-guest)을 Claude
Code에서 완료했다 — MLP 외 Conv2D·multi-branch·동적형상 모델 추가, cFS 게스트 안에서 A1·A3·
A4·A6·A7·A8 시나리오 7/7 PASS(단, 계획 대비 대폭 축소 — 아래 v0.9.1 참조), 계약 도구 자체의
검증 결함(D9·D10, `docs/EVIDENCE_v0.9_E14_stage1.md` §0.4) 발견·수정. 상세는
`docs/EVIDENCE_v0.9_E14_stage1.md` 참조.

**v0.9.1에서 정정된 것 (외부 검토 2건 반영, `docs/EVIDENCE_v0.9_E14_stage1.md` §11)**: A5b가
"native에서 확인됨"이라는 서술은 **실행 근거가 없어 철회**(native·cFS 어디에도 A5b 미실행,
`runtime_load_failed`는 7/7 `null`). 7/7 PASS는 계획(31개 시나리오) 대비 대폭 축소된 7개 결과이며
전부 timeout(`EXIT=124`)으로 종료돼 **정상 종료 시의 자원 회수는 미검증**. 스택 회계
(`kernel_stack_accounted`)는 admission gate가 아니라 텔레메트리이며 구조상 항상 참에 가까운
항등식(빌드가 써넣은 값을 앱이 그대로 되읽어 비교). conv2d의 HAL peak는 native 1,352 vs cFS
3,528로 tightness가 구성마다 다름 — "HAL peak = contract" 일반화 금지. cross-target 비교
(`comparison/*.json`)는 계약 수치 비교일 뿐 실행 대조가 아님(`native`/`both_sound` 전부 null).
계약 도구 체인이 **fail-open**임도 확인(D11–D15) — 파서가 미인식 할당을 조용히 무시하고,
헤더 생성기는 음수 `bounded_bytes`를 `BOUND_KNOWN=1`로 통과시켜 C 게이트가 무조건 ADMIT함.
14개 계약 자체의 값은 vmfb 실물과 재대조해 14/14 일치 확인(도구 결함이 기존 값을 반증하지는 않음).

**v0.10에서 완료된 것 (E15, `docs/EVIDENCE_v0.10_E15.md`)**: v0.9.1이 정정으로 남긴 D12·D13·D14를
실제로 fail-closed로 수정 — 파서의 줄바꿈 누락·미인식 op 무시, 헤더 생성기의 음수/미지원
`bound_method`·스택 미상 수용·다중입력/비f32 수용, one-invocation의 layout IR 미결합(D14, dispatch
심볼을 dump-dir과 대조)을 각각 직접 재현 후 거부로 전환. 신규 `harness/contract_negative_tests.py`
음성 20건+단위 5건+회귀 26건 = **51/51 PASS**. 보관된 v0.9 14개 계약·헤더를 이 도구로 재생성해
**diff 0**(회귀 없음) 확인. **범위 밖(명시)**: C 게이트 자체(스택 거부 분기, blob 크기 선검사, 입출력
런타임 gate)는 x86-64/cFS 환경 재구축이 필요해 미착수 — v0.11에서 이어감.

**v0.11에서 완료된 것 (E16, `docs/EVIDENCE_v0.11_E16.md`)**: 이 세션에서 x86-64 환경(cFS
native_std, IREE C 런타임)을 재구축해 D15·R8을 실제 cFS 기동으로 검증·수정 — `ai_learner.c`의
스택 확인을 `Init()` 최선두(자원 획득 전)로 옮기고 `accounted=false`에서 실제 거부하는 분기 신설
(이전엔 텔레메트리뿐), blob `malloc` 전 파일 크기를 계약과 선검사(다르면 해시 계산 없이 즉시 거부),
두 실행기에 인터페이스(단일 f32 in/out) defense-in-depth 추가. 실제 `core-cpu1`으로 정상/스택거부/
크기불일치/NOT_ADMITTED 4개 시나리오를 기동해 EVS 이벤트·JSON 필드로 확인. 부수 발견: `scripts/50_wire_cfs_ai_learner.sh`
가 `WIRING.md`의 stack=base+kernel 규칙을 어기고 262144로 하드코딩하던 버그(신규 gate가 즉시 드러냄,
수정함). **범위 밖(명시)**: AArch64 게스트 재구축·재현(A2 전 모델·A5b·재시작 2회+DELETE·정상 종료
cleanup)은 여전히 미착수.

**v0.12에서 완료된 것 (E17, `docs/EVIDENCE_v0.12_E17.md`)**: AArch64 크로스 툴체인·IREE 런타임·
qemu-system-aarch64 게스트를 이 세션에서 재구축(정상 부팅). **A5b를 native x86-64·cFS x86-64·cFS
AArch64 게스트 세 레벨 전부에서 최초로 실제 실행**(D11 실제 해소) — `.vmfb`(ZIP)의 `module.fb`
FlatBuffer 자신의 root-uoffset을 구조적으로 손상시켜(임의 bit flip 아님) binding MATCH 조건을
만든 뒤, 전 레벨에서 admission ADMIT→binding MATCH→`runtime_load_failed`(IREE 검증기가 안전 거부)
→cleanup 1회→cFS OPERATIONAL 유지, 크래시 0을 확인. mlp16k·multibranch A2 경계값(native 6/6+cFS
mlp16k 3/3) 확인. A7을 재시작 2회+DELETE로 확장해 x86-64·AArch64 양쪽에서 완주(이중 해제 없음,
ES 명령 기반 정상 종료 경로로 v0.9 §11.2의 "정상 종료 자원회수 미검증"도 해소). E16의 신규 게이트를
AArch64에서도 교차 확인.

**v0.13에서 완료된 것 (E18, `docs/EVIDENCE_v0.13_E18.md`)**: 우선순위 3번(정규 MLIR pass)의 1단계 —
`harness/mlir_alloc_walk.py`가 `static_mem_bound.py::parse_alloc_ir`의 크기 추출을 정규식이 아니라
실제 `iree.compiler.ir` API로 재구현. `--mlir-print-ir-after`의 함수별 조각남 문제(v0.12 조사가
찾음)를 `util.global.load`/`store` 선언 합성 전처리로 해결하고, 그 이후는 전부
`Operation.walk()`·`Value.owner` define-use 체인·`arith.constant` 속성 직접 읽기로 크기를 얻는다.
보관된 v0.9의 14개 `layout_ir`(재컴파일 없음)에서 기존 정규식 파서와 값이 전부 일치, 화이트리스트를
실제로 좁혀서 미인식 op fail-closed도 재확인. `harness/contract_negative_tests.py` 51/51 → **66/66**.
**범위 밖(명시)**: `make_contract.py` 파이프라인 통합, `stream.resource.pack` 실사용 시험, 다른
IREE 버전 재확인.

## 작업 규율 (반드시 지킬 것)

이 저장소는 **엄격한 이력 관리**로 운영되어 왔다. Claude Code에서도 동일하게 유지한다.

1. **실험 1건 = git 커밋 1건.** 커밋 메시지에 실험 ID(E14, E15…)와 핵심 수치를 넣는다.
   예: `E14: ...` 형식. 버전 매듭마다 `git tag -a v0.8 -m "..."`.
2. **모든 실험은 `EXPERIMENT_LOG.md`에 등록.** ID·날짜·플랫폼 등급·산출물·결과 요약·판정 문서·커밋 해시.
3. **판정 변경은 철회하지 않고 덧붙인다.** 이전 결론이 틀렸으면 "정정" 항목으로 남기고 사유를 적는다.
   `EXPERIMENT_LOG.md` 하단의 "가설 판정 이력"·"반증된 주장 이력"·"방법론 결함 이력" 표가 그 기록이다.
4. **증거 등급을 항상 명시한다.** 이 컨테이너의 실측 결과, `harness/platform_check.py`가
   `FUNCTIONAL_ONLY`를 반환하면(1 vCPU 등 공유 환경) **절대 지연값은 인용하지 않는다.**
   동일 호스트 연속 측정의 구현 간 비율만, 그것도 platform_check가 보고하는 잡음 비를
   초과할 때만 방향성 신호로 쓴다. **결정론적 값(해시, HAL 통계, 바이너리 크기, IR 구조 분석)은
   이 규칙이 적용되지 않는다** — 그대로 인용 가능.
5. **버전마다 `docs/EVIDENCE_v0.N_<실험명>.md`를 새로 만든다.** 기존 EVIDENCE 파일을 고쳐쓰지
   않는다(단, 발견된 오류의 "정오표" 절 추가는 허용).
6. **`CHANGELOG.md`, `PROGRESS.md`를 매 버전 갱신한다.**
7. **컴파일러 산출물(vmfb 등)을 재컴파일할 때는 주의**: 같은 MLIR·같은 플래그라도 **입력 파일명이
   다르면 vmfb 바이트가 달라진다**(심볼명에 파일명이 들어감). 계약·IR 덤프·배치 아티팩트는
   반드시 **한 번의 `iree-compile` 호출**에서 생성한다(`EVIDENCE_v0.7_E13.md` §1.3).

## 현재 상태 (v0.7 시점)

| 가설/주장 | 판정 |
|---|---|
| H1 (AOT가 Python/NumPy보다 빠르고 예측 가능) | **성능 우위 미관측**. 최적 compiled가 NumPy/BLAS 대비 2.2–4.1× 느림 (베이킹 가중치, h=16384 기준) |
| H2 (계약 기반 lowering 선택이 고정 설정보다 유리) | **선택의 이점 미입증**. 초기엔 강한 근거(ρ=+0.18 순위 붕괴)로 보였으나 **가중치 per-call 복사 결함(D1)의 인공물**로 판명, 철회 |
| **H3 (실행 전 memory admission 판정)** | **메모리 축, 시험 조건 내 성립.** 정적 상한이 HAL 런타임 피크와 60/60(+구조 사례 4/4, +cFS 통합 등) 일치. 이 연구의 유일하게 살아남은 핵심 결과 |
| MLIR 필연성 (TFLite Micro 등 대안 대비) | **미검증.** 다음 순서 항목 |

가장 중요한 교훈: **이 프로젝트는 두 번의 외부 검토에서 각각 실제 계산 결함을 지적받았다**
(D2: 상수 오귀속, D3: 정렬 패딩으로 인한 slice-sum 과소추정, D5–D7: 계측 경계 오류).
"계산값과 관측값이 일치했다"는 항상 "같은 할당 계획의 두 관측이 서로 모순되지 않는다"는
뜻일 뿐, 계획 자체가 맞다는 증명이 아니다. **새 실험을 설계할 때마다 이 함정을 의심할 것.**

## 지금 바로 이어서 할 일 (Claude Code, 우선순위 1)

v0.9.1 정정(외부 검토 2건, `docs/EVIDENCE_v0.9_E14_stage1.md` §11)에서 두 검토가 합의한 순서를
그대로 우선순위로 쓴다 — **모델·시나리오 수를 늘리는 것보다 "어떤 정보가 없거나 잘못됐을 때 절대
ADMIT하지 않는가"를 먼저 닫는다.** 항목 1은 v0.10(E15), 항목 2는 v0.11(E16, x86-64) +
v0.12(E17, AArch64 게스트)로 완료됐다.

1. ~~fail-closed 계약 verifier~~ — **완료(v0.10/E15)**.
2. ~~C 게이트 보강 + 남은 cFS 음성·생명주기 시험~~ — **완료(v0.11/E16 x86-64 + v0.12/E17 AArch64
   게스트, `docs/EVIDENCE_v0.11_E16.md`·`docs/EVIDENCE_v0.12_E17.md`)**. A5b(구조 손상 기반, 3레벨
   전부 실행), mlp16k·multibranch A2 경계값, 재시작 2회+DELETE(정상 종료 cleanup도 함께 확인),
   스택 실거부·blob 크기 선검사의 AArch64 교차 확인까지 전부 완료. 남은 잔여: multibranch cFS 레벨
   A2, dynamic 모델의 게스트 재현(우선순위 낮음, EVIDENCE_v0.12 §6).
3. **정규 MLIR/IREE pass** — 텍스트 정규식 파서(E15로 fail-closed는 됐으나 여전히 정규식 기반)를
   compiler 내부 Operation·Type·SSA 정보로 대체. 평가지표: 알려진 allocation 누락 없음, 미지원
   표현 무시 안 함, compiler 버전 변경 시 명시적 실패, 기존 파서와 정상 모델에서 동일 값, 적대적
   변형에서 과소 추정 방지(EVIDENCE_v0.10 §5가 남긴 한계).
   **1단계 완료(v0.13/E18, `docs/EVIDENCE_v0.13_E18.md`)**: `harness/mlir_alloc_walk.py`가
   `parse_alloc_ir`의 크기 추출을 실제 `iree.compiler.ir` API로 재구현 — 유일한 텍스트 처리는
   `util.global.load`/`store` 줄에서 선언을 합성하는 좁은 전처리뿐이고(아래 착수 전 조사가 찾아낸
   조각남 문제의 해법), 그 이후는 전부 `op.name`·define-use 체인 추적이다. 14개 보관 아티팩트
   전부 정규식 파서와 값 일치, 화이트리스트 축소로 미인식 op fail-closed 재확인,
   `contract_negative_tests.py` 66/66. **남은 것**: `make_contract.py` 파이프라인 통합(이번엔
   독립 검증 도구로만 존재), `stream.resource.pack` 실사용 시험(현재 모델 중 아무것도 안 씀),
   다른 IREE 버전에서의 재확인.
   **착수 전 조사(v0.12, 실험 아님, 참고용으로 유지)**: `python3 -c "import
   iree.compiler.ir"`로 MLIR Python 바인딩이 실제로 사용 가능함을 확인했다(정규식 대신 실제
   Operation/Type API로 순회 가능). 그러나 `--mlir-print-ir-after=iree-stream-layout-slices`가
   만드는 layout IR은 **함수별로 조각나 있다**(entry 함수 print가 `util.global.load
   @__hoisted_tensor_...`처럼 다른 청크의 `util.initializer`가 정의하는 전역을 참조하는데, 그
   전역의 **선언 자체**는 어느 청크에도 없다 — 선언은 이 패스가 바꾸지 않아 재출력되지 않음).
   `ir.Module.parse()`로 entry 함수 청크만 단독 파싱하면 항상 "undefined global" 검증 오류로
   실패한다(`--mlir-disable-threading`를 추가해도 청크 수·구조는 동일 — 이건 프린트 *순서*의
   결정성 문제였지 조각남의 원인이 아니었다, 재확인함).
   **주의**: 재컴파일해서 얻은 IR로 검증하면 one-invocation 규칙(§작업 규율 7)을 위반하므로,
   기존 vmfb와 짝지어 쓰려면 반드시 같은 컴파일 호출의 산출물이어야 한다(v0.13은 재컴파일 없이
   v0.9의 보관 `layout_ir`만 사용해 이 규칙을 지켰다).
4. **동일 경계의 대안 비교** — TFLite Micro(정적 아레나) 등과 같은 메모리 경계에서 비교해
   "왜 MLIR/IREE 경로여야 하는가"에 답한다. 전제(TFLM이 컴파일 시 아레나 크기를 제공하는가)부터
   1차 문서로 확인할 것. 지표: 과소 추정 발생률, tightness/과도한 거부, 분석 가능 범위, 재생성
   자동화, stale contract 탐지, 분석·통합 비용.
   **전제 확인 결과(이 세션, 1차 문서 대조 — 실험 아님, TFLM 빌드/측정 없음)**:
   [`tensorflow/tflite-micro` `micro_interpreter.h`](https://github.com/tensorflow/tflite-micro/blob/main/tensorflow/lite/micro/micro_interpreter.h)의
   `arena_used_bytes()` 주석 원문: *"Returns the actual used arena in bytes. This method gives
   the optimal arena size. It's only available after `AllocateTensors` has been called."* —
   즉 **`Invoke()`(실제 추론 실행) 없이 `AllocateTensors()`(그래프+shape 기반 메모리 계획 단계)만
   호출한 뒤에도 유효한 값**이라는 점에서, 우리 `bounded_bytes`(post-layout 슬랩 크기, 추론 미실행)
   와 **같은 부류의 값**(실행이 아니라 계획 단계에서 나옴)이다 — "TFLM은 런타임 계측만 준다"는
   첫 대략적 확인은 부정확했다(정정). 다만 [`docs/memory_management.md`](https://github.com/tensorflow/tflite-micro/blob/main/tensorflow/lite/micro/docs/memory_management.md)
   는 이 값을 **"For debugging only"**로만 표기하고, 우리가 `bounded_bytes`에 대해 확보한 것과
   같은 종류의 **건전성 근거(60/60 실측 일치, 경계값 시험 등)를 TFLM 쪽 문서는 제시하지 않는다** —
   "이 값이 모든 유효 입력에 대해 상한임을 증명한다"는 주장은 TFLM 공식 문서 어디에도 없다. 따라서
   비교를 시작할 수 있는 전제(컴파일/준비 단계에서 나오는 계획 기반 수치가 존재한다)는 **참**이지만,
   그 수치의 건전성은 TFLM 쪽에서 **직접 확인해야 하는 새로운 질문**이다(우리 쪽 `bounded_bytes`도
   처음엔 그렇게 시작해서 D2·D3 등 결함을 거쳐 검증됐다는 점을 상기할 것 — 같은 함정을 TFLM 비교에도
   적용해야 한다). 실제 비교 실험은 TFLM 빌드 도구체인(이 컨테이너에 없음, 별도 환경 구축 필요)이
   있어야 착수 가능 — 다음 세션 항목.
5. **임무 유사 workload + 다중 AI 앱 동시 admission** — 단일 앱 계약 수용 규칙(1–3)이 끝난 뒤 착수.
   다중 앱은 전역 예산의 예약·해제·경합 설계가 새로 필요하다(현재는 전역 예약 없음).
6. 시간 축 계약 — `platform_check.py`가 PASS를 반환하는 전용 하드웨어(코어 격리, SCHED_FIFO)가
   있어야 착수 가능. 이 컨테이너에서는 원리적으로 불가능하다.
7. RTEMS 단계(제안서 §17) — Linux AArch64 단계가 통과했으므로 이제 착수 가능하나 우선순위는 낮음.

**환경 참고**: 이 컨테이너는 세션마다 새로 시작되며 `~/onair-mlir-bench`(cFS 빌드, IREE C 런타임,
AArch64 게스트 이미지)가 비어 있을 수 있다. 항목 1은 `iree-compile`(동일 커밋 필요)과
`results/e14_aarch64_qemu/`의 보관 산출물만으로 재구축 없이 완료했다(`harness/contract_negative_tests.py`
로 재검증 가능). 항목 2는 x86-64(`scripts/10`+`40`+`50`, v0.11)와 AArch64 게스트
(`scripts/60`+`61`+`70`+`71`+`51`, v0.12) 둘 다 이 세션들에서 재구축해 완료했다 — AArch64 게스트
부팅은 이번엔 ~170초로 정상 완료됐고 크래시가 재발하지 않았지만(§9 한계 유지, 안정성을 일반화하지
않음), 표본은 여전히 작다. 게스트 아티팩트(`~/onair-mlir-bench/ext/cfs-aarch64-exe/`,
`~/onair-mlir-bench/ext/guest/`)는 `results/`에 보관하지 않았다 — 재현하려면 위 스크립트를 다시
실행해야 한다.

## 저장소 지도

```
CLAUDE.md                 ← 지금 이 파일
PROGRESS.md                v0.3.1 시점 한 장 요약 (v0.4 이후는 REPORT_v0.4.md, 이후는 EVIDENCE_v0.7 참조)
REPORT_v0.4.md              v0.4 총괄 + v0.5 정정 부록
EXPERIMENT_LOG.md           ★ 실험 레지스트리 + 가설 판정 이력 + 반증 원장 + 결함 원장 (가장 먼저 읽을 파일)
CHANGELOG.md                 버전별 변경 (판정:/정정: 접두어)
docs/
  reviews/                    ★ 원본 연구노트 + 외부 검토 4건 (전부 인용됨, 원문 보존)
    research_note_v0.1.md       최초 연구노트 (엄격 검토 대상이 됐던 원본)
    direction_v0.3_judgment.md  실험 결과 기반 방향 판단
    PROGRESS_v0_3_REVIEW.md      v0.3 외부 검토 (D2 발견)
    REPORT_v0_4_REVIEW.md         v0.4 외부 검토 (D3 발견, E13 제안)
    REVIEW_v0_6_E13_RESEARCH_DIRECTION.md  v0.6 외부 검토 (D5-D7 발견, 계약 결합 요구)
  STATUS.md, MVP_RESULT.md   초기 환경 구축, 첫 go/no-go
  EVIDENCE_v0.1.md            E0-E4: OnAIR 통합, 모델 크기 스윕, lowering 설정 효과
  EVIDENCE_v0.2_E5.md         E5: lowering 특성화 (일부 v0.3에서 철회됨 — D1 결함)
  EVIDENCE_v0.3_E6.md         E6/E6b/E6c: 정적 메모리 상한, 가중치 베이킹 정정
  EVIDENCE_v0.4_E7.md         E7/E8: admission checker, 동적 형상 거부
  EVIDENCE_v0.5_E9.md         E9/E10: 할당 구조 4사례 (D3 결함 발견·수정), 경계값
  EVIDENCE_v0.6_E11.md        E11/E12: Native C 변형, cFS 앱 통합 (최초)
  EVIDENCE_v0.7_E13.md        계약-아티팩트 결합, 계측 정정, E13 LLVM/ELF 코드 대응
  EVIDENCE_v0.8_E14_aarch64.md 교차 ISA(x86-64/AArch64) 계약 건전성, Stage 0
  EVIDENCE_v0.9_E14_stage1.md  qemu-system-aarch64 게스트 + cFS-in-guest + 모델셋 확장, Stage 1
                               (§11 정오표: 외부 검토 2건 반영, A5b 미실행·7/7 범위·스택 gate 아님 등)
  EVIDENCE_v0.10_E15.md        계약 도구 fail-closed 전환 + 음성 시험(51/51 PASS), D12-D14 수정
  EVIDENCE_v0.11_E16.md        C 게이트 보강(스택 실거부·blob 크기 선검사), x86-64 native_std 실기동 검증, D15 수정
  EVIDENCE_v0.12_E17.md        AArch64 게스트 재현: A5b 최초 실행(3레벨), A2 경계값, 재시작 2회+DELETE, D11 실제 해소
  EVIDENCE_v0.13_E18.md       ★ 최신. 정규 MLIR pass 1단계: 구조적(비정규식) 할당 추출기, iree.compiler.ir API
  plans/E14_stage1_qemu_system_cfs.md  E14 Stage 1 원 계획 (완료됨, v0.9 참조)
scripts/
  00_env.sh                   의존성 설치 + POSIX mqueue 한계 상향 (컨테이너 필수)
  10_build_cfs.sh              cFS 클론·빌드 (native_std)
  11_run_cfs.sh                 cFS 기동
  20_setup_onair.sh              OnAIR 설치 + 예제 실행
  30_setup_iree.sh                IREE 컴파일러/런타임 (pip, Python 바인딩)
  40_setup_iree_source_runtime.sh  ★ IREE 런타임 소스 빌드 (x86-64, native_learner/cfs_app가 링크할 것)
  50_wire_cfs_ai_learner.sh        AI_LEARNER 앱을 cFS native_std에 배선·빌드 (x86-64)
  51_build_cfs_aarch64.sh          ★ AI_LEARNER 포함 cFS를 AArch64로 크로스빌드 (native_std와 별도 트리)
  60_setup_aarch64_cross.sh          AArch64 크로스 툴체인 + qemu-user (시스템 에뮬레이션 아님)
  61_build_iree_runtime_aarch64.sh   IREE 런타임 AArch64 크로스 빌드
  62_compile_and_check_aarch64.sh    E14 Stage 0 재현 (컴파일→구조분석→qemu-user 확인)
  70_setup_qemu_system_aarch64.sh    ★ AArch64 게스트 이미지·cloud-init·mqueue 준비
  71_boot_guest_aarch64.sh           ★ 게스트 부팅/재부팅 (stderr 캡처, setsid+nohup)
  72_guest_ssh.sh                     게스트 ssh/scp/stop 헬퍼
  73_console.sh                       게스트 양방향 시리얼 콘솔 (emergency-mode 등 ssh 안 될 때)
  99_bootstrap_all.sh              ★ 전체 순서 실행 (x86-64 기준; aarch64는 60-62, 70-73 별도 실행)
harness/                    실험 스크립트
  static_mem_bound.py, admission_check.py, platform_check.py 등  E0-E13 기반 도구
  make_contract.py            ★ SAME iree-compile 호출 산출물에서만 계약 JSON 생성 (one-invocation 검증,
                               fail-closed: layout IR↔dump-dir 결합·ABI/triple/ELF 불일치 hard fail, E15)
  elf_stack_frame.py          ★ IREE embedded-ELF 정적 분석 (x86-64/AArch64 공통 정의, EVIDENCE_v0.9 §5 근거)
  gen_contract_header.py      계약 JSON → C 헤더 (contract_gen.h; fail-closed 검증 E15)
  contract_negative_tests.py  ★ 계약 도구 음성·단위·회귀·구조적 추출기 일치 시험, 66/66 PASS(E15+E18)
  mlir_alloc_walk.py          ★ E18: 구조적(비정규식) 할당 추출기 — iree.compiler.ir API, 14/14 정규식 파서와 일치
  e14_matrix.py                모델×타깃 컴파일·계약추출 파이프라인 (compile/extract 단계)
  cross_target_compare.py      타깃 간 계약/ELF 비교표
  gen_model_conv2d.py, gen_model_multibranch.py  Stage 1 모델 생성기 (베이킹 가중치)
  e14_cfs_scenarios.py, e14_make_scenarios.py     게스트 cFS 시나리오 실행기/생성기
  cfs_cmd.py                    cFE CI_LAB UDP 명령 전송 (A7 재시작/삭제 시나리오용)
contracts/                  계약 스키마 + 채워진 예시 (v0.4 memory_boundary 결정, v0.7 artifact binding)
models/                     기본 MLIR 모델
plugins/                    OnAIR AIPlugin 구현체 (compiled_learner=IREE, python_learner=NumPy 베이스라인)
native/                     Python 없는 C 경로: native_learner.c, cfs_app/ (cFS 앱 소스) — 둘 다 계약
                             헤더만으로 모델 독립적(v0.9); cfs_app/toolchain-aarch64-linux-gnu.cmake
e13/                        LLVM IR·ELF 덤프 (x86-64 host/generic 설정 비교)
e14/                        교차 ISA 검증 (aarch64/ = Stage 0 산출물)
results/e14_aarch64_qemu/   ★ E14 Stage 1 전체 산출물: environment/, models/, {aarch64,x86_64}/(계약·ELF·
                             헤더·objdump·llvm_ir·vmfb), native/(qemu-user 결과), cfs/(게스트 시나리오
                             결과), comparison/(교차 타깃 비교)
results_*.json               각 실험의 원자료 (git 추적됨 — 재실행 없이 분석 재현 가능)
```

## 환경 구축 (최초 1회, 순서대로)

```bash
bash scripts/99_bootstrap_all.sh
```

내부적으로 하는 일 (개별 실행도 가능):
1. `00_env.sh` — apt 패키지, **`/proc/sys/fs/mqueue/msg_max`를 512로 상향** (기본 10에서는
   cFE SB 파이프 생성이 `errno=22`로 실패해 cFS가 기동하지 못한다. 컨테이너 재시작마다 리셋되므로
   매 세션 다시 실행 필요할 수 있음).
2. `10_build_cfs.sh` — nasa/cFS 클론(`--recurse-submodules`), `make native_std.prep && make native_std.install`.
   **함정**: `cfe/cmake/Makefile.sample`을 번들 루트에 덮어쓰지 말 것 — `Target "hs" not found`로 실패한다.
   번들 자체의 `Makefile`/`sample_defs`를 그대로 쓴다.
3. `20_setup_onair.sh` — nasa/OnAIR 클론, pip 의존성, CSV/Kalman 예제로 스모크 테스트.
4. `30_setup_iree.sh` — `pip install iree-base-compiler iree-base-runtime` (컴파일러 + Python 런타임 바인딩).
5. `40_setup_iree_source_runtime.sh` — **IREE C 런타임을 소스에서 빌드**. `iree-compile --version`이
   보고하는 커밋과 **정확히 같은 커밋**을 체크아웃해야 한다(vmfb 포맷·HAL ABI 정합).
   최소 구성(local-sync 드라이버, embedded ELF loader, 스레딩 없음, ukernel 없음) + PIC
   (cFS 앱이 `.so`이므로). 이 저장소 기준 커밋: `e4a3b0405d7d23554da26403658d0e8c3c5ecf25`
   (IREE 3.11.0rc20260316). **버전이 달라지면 이 커밋 해시를 갱신할 것.**
6. `50_wire_cfs_ai_learner.sh` — `native/cfs_app/`을 cFS의 `apps/ai_learner/`로 복사하고
   `targets.cmake`·`generate_startup.cmake`를 패치, 재빌드.

**검증(smoke test)**:
```bash
python3 harness/platform_check.py                          # 이 머신의 증거 등급 확인
cd native && bash build.sh && ./native_learner model_16384_baked.vmfb 1048576 100
cd $HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && ./core-cpu1   # AI_LEARNER 로그 확인
```

## 알려진 환경 함정 모음 (반복하지 말 것)

| 증상 | 원인 | 해결 |
|---|---|---|
| `qemu-system-aarch64`가 로그 없이 죽음 | `-daemonize`는 fork로 부모와 분리돼 stderr가 유실됨 | `71_boot_guest_aarch64.sh`처럼 `setsid nohup … 2> qemu_stderr.log` 사용 |
| 게스트가 emergency mode에서 멈췄는데 원인을 못 봄 | `-serial file:`은 출력 전용이라 입력을 못 보냄 | `-chardev socket,...,server=on,wait=off` + `73_console.sh`(양방향 유닉스 소켓 콘솔) |
| cFS 시나리오 자동화 스크립트가 원격 로그 파일을 못 찾음(scp 실패) | 원격 쉘에서 `cd {remote_root}` 이후에도 상대경로 변수가 `remote_root` 접두어를 다시 붙여 `remote_root/remote_root/...`로 이중화 | `cd` 이후 쓰는 경로는 항상 그 시점의 작업 디렉터리 기준 상대경로인지 확인 |
| cFS 크로스빌드가 "contract sha256 not found in ai_learner.so"로 실패 | UNKNOWN_BOUND 모델은 admission에서 즉시 거부돼 sha256 비교 코드가 도달 불가능 → 컴파일러가 그 문자열까지 제거(-O2) | `CONTRACT_BOUND_KNOWN=0`일 때는 이 검증을 건너뜀(정상 동작의 부작용이지 버그가 아님) |
| 계약 생성 도구가 "one-invocation" 위반(서로 다른 컴파일 산출물 혼합)을 못 잡음 | 검증 로직 없이 `provenance.single_invocation`을 하드코딩 `true`로 기록 | 임베디드 ELF sha256 매칭 + dump-dir 파일명의 입력 basename 포함 여부, 두 독립 신호로 실제 검증(D10) |
| cFS `prep`이 `Target "hs" not found`로 실패 | `cfe/cmake/Makefile.sample`을 번들에 덮어씀 | 번들 자체 Makefile 사용 |
| cFS 기동 시 EVS/ES 초기화 실패 | `/proc/sys/fs/mqueue/msg_max` 기본 10 | `echo 512 > /proc/sys/fs/mqueue/msg_max` |
| cFS 앱 컴파일 에러 (`-Werror=pedantic`, `static_assert` 등) | cFS가 앱에 `-std=c99 -pedantic -Werror` 강제, IREE 헤더는 C11/GNU 확장 필요 | 해당 앱 CMakeLists에 `-std=gnu11 -Wno-pedantic -Wno-error` 추가 |
| `CFE_ES_HK_TLM_MID` undeclared | 헤더 누락 | `#include "cfe_es_msgids.h"` |
| `/cf/model.vmfb` fopen 실패 | `/cf`는 OSAL 가상 경로 | `OS_TranslatePath()`로 실경로 변환 후 fopen |
| IREE 링크 시 `undefined reference to flatcc_verify_error_string` 등 | flatcc/printf 서드파티 라이브러리 누락 | `libflatcc_parsing.a libflatcc_runtime.a libprintf_printf.a`도 링크 |
| IREE 런타임 종료 시 segfault (`iree_vm_bytecode_module_lookup_function`) | 모듈 blob을 세션 해제 **전에** `free()` (D4) | blob은 세션이 zero-copy 참조 — 세션 해제 **후**에 free |
| cmake `check_c_source_compiles` unknown command | 이 IREE 커밋의 ukernel CMakeLists가 include 누락 | `40_setup_iree_source_runtime.sh`가 자동 패치함 |
| CMake `target_link_libraries` plain/keyword 혼용 에러 | cFS의 `add_cfe_app`이 plain 시그니처 사용 | 앱 CMakeLists도 plain 시그니처로 통일 |
| 재컴파일한 vmfb의 해시가 이전과 다름 | **입력 MLIR 파일명이 vmfb 심볼명에 들어감** | 계약·덤프·배치 아티팩트는 한 번의 컴파일 호출에서 생성 |

## 이 컨테이너(claude.ai)에서 검증됐던 사실과의 관계

이 프로젝트는 원래 claude.ai의 공유 VM(1 vCPU)에서 시작했다. `harness/platform_check.py`가
그 환경을 `FUNCTIONAL_ONLY`로 판정했다 — 즉 **기능 검증은 가능하지만 타이밍 증거는 못 만든다.**
Claude Code 환경(로컬 머신/전용 컨테이너)으로 옮긴 이유가 바로 이것이면, 이관 후 가장 먼저 할 일은:
```bash
python3 harness/platform_check.py
```
이 `PASS`를 반환하는지 확인하는 것이다. **PASS라면** 이 프로젝트가 지금까지 미룬 두 가지
(시간 축 계약, H1/H2의 잔여 가능성 — `EVIDENCE_v0.5_E9.md` §3의 "대형 구간 유리한 신호" 등)를
비로소 시험할 수 있다. 이는 새 우선순위이므로 착수 전 `EXPERIMENT_LOG.md`에 왜 우선순위가
바뀌었는지 한 줄 남길 것.
