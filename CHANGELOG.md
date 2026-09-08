# CHANGELOG

형식: [버전] 날짜 — 변경. 가설 판정 변경은 반드시 "판정:" 접두어, 이전 주장 철회는 "정정:" 접두어로 기록.

## [v0.9.1] 2026-09-08
- 외부 검토 2건(`docs/reviews/REVIEW_v0_9_CODE_AND_MD_AMENDMENTS.md`,
  `docs/reviews/OPINION_v0_9_SPACE_CPU_AI_INTEGRATED.md`, 기준 커밋 `33e1ebc`)을 코드·원자료와 직접
  대조해 반영. `docs/EVIDENCE_v0.9_E14_stage1.md` §11(정오표) 신설, 기존 §0–§10은 고쳐쓰지 않음.
- 정정: A5b(계약 해시가 손상 파일을 가리키는 경우, `runtime_load_failed` 경로)를 "native에서
  확인했다"는 §4.1·§9 서술을 **철회**. native·cFS 어느 레벨에서도 A5b는 실행되지 않았다
  (`runtime_load_failed` 7/7 `null`). §3 표에는 A5a 행만 있어 문서 자체가 자기모순이었다(D11).
- 정정: "7/7 PASS"의 범위를 명시. 계획(31개 시나리오) 대비 7개만 실행, expect 조건이 축소됐고
  (`min_completed` 15→3 등, `hal_peak_le_bounded` 독립 대조 삭제), 7개 전부 `EXIT=124`(timeout SIGINT)
  로 종료돼 **정상 종료 시의 자원 회수는 미검증**(정상 시나리오 cleanup 0회).
- 정정: 스택 회계(`kernel_stack_accounted`)가 admission gate가 아니라 텔레메트리임을 명시(D15).
  `accounted=false`에서도 초기화를 거부하는 분기가 없고, 빌드가 startup에 써넣은 `base+kernel`을
  앱이 그대로 되읽어 비교하므로 구조상 항상 참에 가까운 항등식이다. 합격기준 #8의 표현을
  "task stack 설정에 반영·확인"으로 축소.
- 정정: conv2d의 HAL peak가 native(1,352 B)와 cFS(3,528 B=bounded)에서 다름을 명시 — "HAL peak =
  contract" 일반화 금지. cross-target 비교(`comparison/*.json`)는 계약 수치 비교일 뿐 실행 대조가
  아님(`native`/`both_sound` 전부 null)도 명시.
- 정정: one-invocation 검증(D10)이 layout IR을 검사에 결합하지 않음을 확인(D14) — "대표적 산출물
  혼입 탐지"로 표현 축소.
- 결함 원장 추가: D11(A5b 무근거 서술) · D12(`static_mem_bound.py` 단독 경로의 `entry_found` 누락) ·
  D13(계약 도구 체인의 fail-open — 파서 미인식 할당 무시, 헤더 생성기의 음수 bound·미지원 method 통과) ·
  D14(one-invocation의 layout IR 미결합) · D15(스택 회계 항등식 구조).
- 중심 문장 개정판(§11.8)으로 CLAUDE.md 갱신, "지금 바로 이어서 할 일"을 두 외부 검토가 합의한
  우선순위(fail-closed verifier(E15) → 남은 cFS 음성·생명주기 시험 → 정규 MLIR pass → 대안 비교 →
  임무 유사 workload·다중 앱)로 교체.
- 보관된 14개 계약의 `artifact.bytes`/`sha256`을 vmfb 실물과 독립 재계산 — **14/14 일치**(도구 결함이
  기존 계약 값 자체를 반증하지 않음을 확인).
- 다음 실험(E15, 계약 도구 fail-closed 전환 + 음성 시험)은 `docs/EVIDENCE_v0.10_E15.md`에서 별도 등록.

## [v0.9] 2026-09-08
- E14 Stage 1(Claude Code 이관분): qemu-system-aarch64 Linux 게스트 + cFS-in-guest + Conv2D/multi-branch/
  동적형상 모델. `docs/EVIDENCE_v0.9_E14_stage1.md`.
- 판정: H3 일반성 범위 재확대 — **모델 종류 불변**(MLP·Conv2D·multi-branch 3종, per-call/상수/bounded
  x86-64=AArch64 완전 동일) + **cFS admission의 타깃 독립성 검증**(AArch64 게스트 cFS `AI_LEARNER` 앱,
  정상/모델교체거부/파일부재/반복무결성/UNKNOWN_BOUND거부/재시작 7/7 시나리오 PASS).
- 정정(D9): v0.7 §4.3(x86-64 "스택 프레임 없음")과 v0.8 §3(AArch64 16B)은 서로 다른 정의를 각 ISA에
  적용한 결과였다. 통일된 정의(callee-save+지역=frame_bytes, +복귀주소=invocation_stack_bytes)로 재분석하면
  x86-64도 같은 16B 프레임 레코드를 가진다(복귀주소 위치만 콜스택 vs 링크레지스터로 다름).
- 정정(D10): 계약 생성기(`harness/make_contract.py`)의 one-invocation 검증이 하드코딩 `true`였다 — 실제로는
  검증을 안 해서 서로 다른 컴파일 호출의 산출물을 섞어도 통과시켰다. 두 독립 신호(임베디드 ELF sha256 매칭
  + dump-dir 파일명의 입력 basename 포함 여부)로 실제 검증 추가, 불일치 재현 케이스로 거부 확인.
- AArch64 태스크 스택 잔차를 모델별로 확정: MLP·multi-branch 16 B(호출 0, 지역변수 없음), Conv2D 191 B
  (동적 스택 재정렬 패딩 63 B 포함 — `elf_stack_frame.py`가 이 관용구를 인식하도록 신규 지원). cFS 시작
  스크립트 스택 크기(`AI_LEARNER_STACK_BASE_BYTES` + `CONTRACT_KERNEL_STACK_BYTES`)에 실제로 반영하고,
  앱이 자신의 실제 태스크 스택 크기를 `CFE_ES_GetAppInfo`로 읽어 회계 충분성을 자체 보고
  (`kernel_stack_accounted`)하도록 구현·검증.
- 신규 도구: `harness/make_contract.py`(one-invocation 산출물에서만 계약 생성), `harness/elf_stack_frame.py`
  (IREE embedded-ELF 정적 분석, x86-64/AArch64 공통 정의), `harness/e14_matrix.py`(모델×타깃 컴파일·추출
  파이프라인), `harness/cross_target_compare.py`, `harness/gen_model_conv2d.py`/`gen_model_multibranch.py`,
  `harness/e14_cfs_scenarios.py`/`e14_make_scenarios.py`, `harness/cfs_cmd.py`(cFE CI_LAB UDP 명령 전송),
  `scripts/51_build_cfs_aarch64.sh`(cFS AArch64 크로스빌드), `scripts/70-73_*.sh`(게스트 준비·부팅·콘솔).
- `native/native_learner.c`·`native/cfs_app/fsw/src/ai_learner.c`를 계약 헤더만으로 모델 독립적으로
  동작하도록 일반화(입출력 형상·엔트리·드라이버·커널 스택을 매크로화), UNKNOWN_BOUND 거부(exit 6)와
  안전한 런타임 로드 실패 경로(exit 7, `runtime_load_failed`) 추가.
- 제안서 §14 합격기준 9개 중 8개 완전 PASS, 1개(경계값 B-1/B/B+1)는 conv2d에서만 cFS 레벨 재검증하고
  나머지 모델은 native 레벨(동일 게이트 코드) 확인으로 갈음 — 부분 PASS로 명시.
- 한계: 다중 AI 앱 동시 admission 미착수, RTEMS 단계 미착수, QEMU 시스템 에뮬레이션이 이 컨테이너
  환경에서 원인 불명 크래시를 2회 겪음(게스트 콘솔 stderr 캡처 개선 후 재발 없음, 하지만 완전한
  안정성을 주장하지 않음).

## [v0.8] 2026-09-08
- 외부 제안(`docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`) 반영, E14 등록.
- Stage 0(이 세션): AArch64/Cortex-A53 교차 컴파일(단일 호출 규칙 준수), 정적 상한 계산,
  LLVM IR/ELF 구조 분석, `qemu-aarch64` user-mode로 Native 실행(참고용, 시간값 비증거).
- 결과: bounded_bytes가 x86-64와 AArch64에서 **동일**(786,476) — 메모리 계획 패스가
  타깃 코드생성보다 앞서기 때문(구조적 이유 확인). HAL 피크·정상상태 per-call·경계값
  B-1/B/B+1·모델교체거부·동적형상거부 전부 x86-64와 일치. out0 수치까지 일치.
- 발견: AArch64 코드생성이 x86-64에 없던 **16B AAPCS64 스택 프레임**을 커널 함수마다
  도입(호출 0개인데도 발생). (2)태스크 스택 예산으로 분류, Stage 1에서 명시적 반영 필요.
- Stage 1(qemu-system-aarch64 Linux 게스트, cFS-in-guest, Conv2D/multi-branch 모델,
  QEMU RTEMS)은 게스트 이미지·영속 저장·반복 자동화가 필요해 Claude Code로 이관
  (`docs/plans/E14_stage1_qemu_system_cfs.md`).
- 계약 스키마에 `target.cpu`, `target.executable_format` 필드 추가.
- 신규 스크립트: `60_setup_aarch64_cross.sh`, `61_build_iree_runtime_aarch64.sh`,
  `62_compile_and_check_aarch64.sh`.
- 문서: `docs/EVIDENCE_v0.8_E14_aarch64.md`, `docs/plans/E14_stage1_qemu_system_cfs.md`.

## [v0.7] 2026-09-08
- 외부 검토(`REVIEW_v0_6_E13_RESEARCH_DIRECTION.md`) §9 순서대로 반영.
- 계약–아티팩트 결합: `artifact.sha256/bytes` + `validity`; `harness/gen_contract_header.py`로 헤더 생성; gate가 IREE에 넘길 바이트를 해시 비교 (D6).
- E11b: peak↔bounded 비교(D5 수정), 정상 상태 per-call 65,544 B(D7 수정), 단계별 카운터.
- E11c/E12c: 같은 ABI 모델 교체 → 런타임 생성 전 거부 (standalone exit 5 / cFS 기동 거부).
- E12d: 모델 파일 부재 → cleanup, cFS OPERATIONAL. `AI_LEARNER_Cleanup()` 모든 실패 지점·종료에 적용.
- E13: 단일 컴파일 호출 덤프. 커널 LLVM IR alloca 0·외부 호출 0, ELF call 0·스택 프레임 0. host AVX-512 FMA(34) vs generic 스칼라(mulss 9) — E4/E5/E6b 원인 규명.
- 규칙: 계약·덤프·배치 아티팩트는 **한 컴파일 호출**에서 생성 (파일명만 달라도 vmfb 해시가 바뀜).
- 표현 수정(검토 §7): RSS 관측값, Python 제거 단일 귀속 불가, init delta 프로세스 전체, 지연 설명은 후보, 타 앱 무영향 미검증, gate 위치는 IREE 초기화 이전.
- 문서: `docs/EVIDENCE_v0.7_E13.md`.

## [v0.6] 2026-09-08
- IREE 런타임 소스 빌드(컴파일러 동일 커밋 e4a3b04, 최소 구성, PIC).
- E11: Native C 변형. 런타임 생성 전 admission; HAL 피크 786,476 = bounded_bytes(상수가 allocator를 통과하는 구성); RSS 4.3 MB(Python 41.5 MB); median 32.2 µs.
- E12: cFS 앱 `AI_LEARNER`. 초기화 시 계약 vs 앱 예산 admission; ADMIT → ES HK 텔레메트리로 추론(피크=bounded 유지); NOT_ADMITTED → 앱 기동 거부, cFS·타 앱 무영향.
- 판정: H3 메모리 축 → cFS 앱 배치 형태에서도 시험 조건 내 성립. 경계 (b) 런타임 구성 2종에서 견고. "Python 제거" 후속 가설 측정 완료(같은 경로에서 교환 관계 서술 가능).
- 결함 D4(하네스 해제 순서) 등록.
- 문서: `docs/EVIDENCE_v0.6_E11.md`, `native/cfs_app/WIRING.md`.

## [v0.5] 2026-09-08
- 외부 검토(`REPORT_v0_4_REVIEW.md`) 반영.
- 정정(결함 D3): 상한 계산법 "slice 합" → "post-layout transient alloca 크기". E9 정렬 간극·수명 재사용 사례에서 slice 합이 과소(48<128, 84<128)임을 실증. MLP 60/60 재검증.
- E9: 할당 구조 4사례 (A 정렬, B 수명 재사용, C 대형 체인, D fusion) 4/4 sound·tight.
- 상수 독립 검증: `iree-dump-module` rodata 세그먼트 부분합으로 30/30 확인 (IR 값 재사용 아님).
- 판정 의미: ACCEPT/REJECT/UNBOUNDED → ADMIT / NOT_ADMITTED(보증 불가≠불가능) / UNKNOWN_BOUND(분석 미확보≠상한 부재). pessimistic → conservative_denial.
- E10: 경계값 U−1/U/U+1 18/18 정확.
- E7b: 258 판정, misprediction 0, config-invariant.
- 판정: H3 시험 조건 내 성립, 근거 강화. 중심 문장을 "OnAIR IREE 아티팩트의 부분 메모리 계약·판정기 구현·검증"으로 한정. 런타임 컨텍스트 → 미분류 잔차. TFLM 서술 미검증으로 통일.
- 문서: `docs/EVIDENCE_v0.5_E9.md`.

## [v0.4] 2026-09-07
- 결정: 계약 메모리 경계 = 옵션 (b) per-call 정적 버퍼 + 모듈 상주 상수. 스키마에 `memory_boundary`, `bounded_bytes`, `bound_method: NONE` 추가.
- E7: 메모리 전용 admission checker (`harness/admission_check.py`). 240 판정, misprediction 0, 판정 config-invariant, observed==bounded 240/240.
- E8: 동적 배치 차원 모델 → UNBOUNDED 거절 확인 (정적 상한의 적용 경계).
- 판정: H3 → "메모리 축, 시험 조건 내 성립; 시간 축 미검증".
- 판정: H2 → 논문 주장에서 제외 권고 (E7 config-invariance).
- 문서: `docs/EVIDENCE_v0.4_E7.md`, `REPORT_v0.4.md`(총괄).

## [v0.3.1] 2026-09-07
- 외부 검토(`PROGRESS_v0_3_REVIEW.md`) 반영.
- E6c: 베이킹 모델 정적 상한을 IR 파싱으로 재검증, 30/30. 총 60/60 (v0.3의 "50/50"은 오기).
- 정정: 런타임 컨텍스트 ≈971 KB → ≈244 KB (베이킹 상수 720,896 B 분리, 결함 D2).
- 정정: 파서가 initializer 상수 임포트를 입력으로 오귀속 (D2) → 엔트리 함수 스코프 + 상수 별도 집계.
- 판정: H1 "기각" → "현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류".
- 판정: H2 "부분 지지" → "설정별 비용 차이 관측; 계약 기반 선택의 이점 미입증".
- 판정: H3 "메모리 축 전제 충족" → "정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요".
- 판정: E6 "sound & tight" → "동일 할당 계획에 대한 예측·관측 일치 (가정 명시)".
- 판정: "2.2× 대가 교환" → Native-cFS 후속 가설로 강등.
- 계약 예시: 스코프 노트·가정·상수/런타임 분리 귀속·정오표 추가.
- 잔여 작업 우선순위 변경: 상충 워크로드 탐색(A2)을 H2 유지 시에만; 기본 순서는 E6 범위 정리 → Native-cFS → 메모리 전용 admission checker → 일반성/TFLM.

## [v0.3] 2026-09-07
- E6 정적 메모리 상한 추출 (`harness/static_mem_bound.py`, `static_bound_sweep.py`). 30/30 sound, tightness 1.0, lowering 설정 불변.
- 정정: E1–E5의 컴파일 경로가 매 호출 가중치 전체를 임포트(결함 D1). E6b로 재측정.
- 정정: 컴파일 vs B0 격차 6.3–9.5× → 2.2–4.1×.
- 정정: E5 §4 "순위 붕괴 ρ=+0.18" 철회 (ρ=+0.81).
- 정정: E5 §3 "Pareto front 5개" 철회 (상충 미관측).
- 판정: H2 "확립" → "부분 지지".
- 판정: H3 메모리 축 전제 충족 (정적 상한).
- 판정: C1 `peak_memory` → `static_from_stream_schedule`.
- 계약 예시 갱신: 정적 프로그램 65,580 B + 런타임 컨텍스트 ~971 KB(측정) 분리.
- 문서: `docs/EVIDENCE_v0.3_E6.md`.

## [v0.2] 2026-09-07
- E5 lowering 특성화 추가 (`harness/characterize.py`, 10 설정 × h∈{256,4096,16384}).
- 판정: H2 "강화" → "확립". 근거를 tail 지표(noise 안쪽)에서 결정론적 지표(binary 2.25×, RSS 2.75×, Pareto 5, ρ=+0.18)로 교체.
- 판정: 방향판단 §7 "peak memory 우위" 반증 (B0 40 KB vs compiled 최소 1216 KB).
- 계약 공란 채움 (`contracts/contract.filled.example.json`): profile, peak_memory(measured), bound(measured_max).
- 문서: `docs/EVIDENCE_v0.2_E5.md`.
- 이력 관리 도입: git, `EXPERIMENT_LOG.md`, 본 파일.

## [v0.1] 2026-09-07
- E0–E4 수행. 환경 구축, OnAIR 통합, 크기 스윕, 마샬링 floor, 설정 효과.
- 판정: H1 주가설 → 부분 기각. H2 강화. H3 미검증.
- 문서: `docs/STATUS.md`, `docs/MVP_RESULT.md`, `docs/EVIDENCE_v0.1.md`.

## [v0.0] 2026-09-07
- 연구노트 v0.1 (외부 문서) 검토. Critical 3 / Major 10 / Minor 10.
