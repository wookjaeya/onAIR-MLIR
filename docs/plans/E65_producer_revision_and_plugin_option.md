# E65 계획 — 생산 컴파일러 리비전 불일치 시 상한 보류(M1), OnAIR 조건부 옵션의 구성 오류화(M2), 경미 사항의 실행 근거

**사전 고정 문서다. 구현·셀 실행·재실행 이전에 커밋한다.** 근거는 22차 원고 메타리뷰
(`JAIS_onair_mlir_v26_metareview_only.md`, 2026-09-28, 연구 책임자 전달)의 필수 2건(M1·M2)과 경미 1–3이다.
모든 셀은 **AArch64 게스트**에서 돌고, 개발 호스트에서는 지상 측 분석(명세 생성)만 한다.

## 0. 착수 전 조사 (실험 아님 — 보관 원자료 판독)

- **아티팩트가 말하는 생산 정보**: vmfb의 `module.fb`(FlatBuffer `BytecodeModuleDef`)에 `bytecode_version`
  필드가 있다(`runtime/src/iree/schemas/bytecode_module_def.fbs`). 보관 AArch64 vmfb 8개를 직접 파싱했다 —
  E59 이전 리비전(3.10.0rc20260107) 4개는 **16.0**, 평가 리비전(3.11.0rc20260316 @ e4a3b04) 4개는 **17.0**.
  모듈 `attrs`는 비어 있고 임베디드 ELF의 `.comment`는 `IREE` 한 줄뿐이라 **컴파일러 리비전 문자열은 아티팩트에 없다**.
  평가 런타임은 `IREE_VM_BYTECODE_VERSION_MAJOR 17`/`MINOR 0`(`vm/bytecode/utils/isa.h:26,32`)과 다른 major를
  `verifier.c:174`에서 거부한다(소스 판독 — Q2가 관측으로 바꾼다). 지상 측에서는 이미 관측이 있다 — E59 이전 리비전 문서 4개의
  `provenance.notes`가 호스트 `iree-dump-module`(같은 3.11 런타임)의 `verifier.c:180 … bytecode version mismatch`를 싣는다.
  게스트의 C 런타임에서 그 거부를 본 셀은 없다.
- **E59 이전 리비전 문서 4개**: `validity.compiler`는 분석 호스트의 3.11 리비전이고, 불일치는 `provenance.notes`의
  자유 텍스트뿐이다(`results/e59_info_levels_aarch64/drift_310/*/…contract.json`). `verification_grade: verified`로
  발행됐고 헤더 생성기는 `BOUND_KNOWN 1`을 낸다.
- **OnAIR 플러그인**: `allow_conditional_map`을 설정에서 받아 `admission_policy.decide`에 넘긴다
  (`plugins/compiled_learner/compiled_learner_plugin.py:113,355`). 매핑 확인을 하지 않으므로 켜면 확인 없이 `B_m`으로
  승인할 수 있다 — 지금까지 모든 셀에서 `false`였다(절차적 제한).
- **런타임 리비전**: PyPI `iree-base-runtime 3.11.0` aarch64 휠(cp312-abi3, sha256 `7b428beb…`)의
  `iree/_runtime_libs/version.py`가 `VERSION = "3.11.0rc20260316"`, `REVISIONS = {"IREE": "e4a3b04…"}`를 싣는다 —
  컴파일러와 같은 리비전이다. 게스트에 설치된 사본은 Q6가 게스트에서 읽는다.
- **다중 slab·다중 출력**: 보관 AArch64 표현 11개 전부 transient slab ≤ 1, 출력 할당 1개다(E40의 관측과 같다).
  `--iree-stream-resource-max-allocation-size`는 상수를 쪼개지 transient를 쪼개지 않는다(ResNet 16 KiB·64 KiB 시험 컴파일,
  transient 297,088 B 한 개 그대로).

## 1. 질문

- **Q1 (M1, 분석기)**: 분석기가 아티팩트의 `bytecode_version`을 읽어 문서의 기계 판독 필드
  `validity.producer_check`에 기록하고, $K$를 점검한 리비전(3.11.0rc20260316 @ e4a3b04, bytecode 17.0)과 다르면
  **상한을 보류한 문서**(`bound_method = NONE`, 수치는 `diagnostic_figures_when_bound_withheld`에만)를 발행하는가.
  이전 리비전 4개 → 4/4 보류, 헤더 `BOUND_KNOWN 0`. 평가 리비전 4개 → 4/4 `match`, 세 수치 불변, 헤더 바이트 동일.
- **Q2 (M1, 게스트)**: 이전 리비전 ResNet 아티팩트로 비행 응용을 두 번 빌드한다.
  (a) 새 문서(상한 보류)의 헤더 → Init에서 `UNKNOWN_BOUND`, 런타임 생성 전 종료, cFS 운영 유지.
  (b) E59가 발행했던 보관 문서(상한 있음, 수정 전 분석기)의 헤더, 예산 `B_u` → `ADMIT`·`MATCH` 뒤 **모듈 적재에서
  런타임이 거부**(오류 문자열에 bytecode 버전 불일치), 추론 0, cFS 운영 유지 — 원고의 *"소스에서 읽음, 적재 시도 없음"*을
  관측으로 바꾼다.
- **Q3 (M2)**: 플러그인이 `allow_conditional_map: true`를 **구성 오류**로 거부하는가(공식 OnAIR 로더, 게스트).
  비활성·`runtime_created: false`·admission 미평가. 대조: 같은 배포에서 옵션만 `false` → 승인·추론(과잉 거부 0).
- **Q4 (경미 1)**: 평가 네 명세를 현재 분석기로 보관 컴파일러 산출물에서 재발행하면 네 문서가 모두 출력 해제·정렬
  전제(`analysis_domain`)와 `producer_check: match`를 싣고, 세 수치 불변·헤더 바이트 동일인가.
- **Q5 (경미 2)**: (a) 보관 AArch64 ResNet 표현을 재컴파일 없이 편집해 transient slab 2개, 출력 할당 2개를 만든 두 셀에서
  분석기가 각각 $T$·$O$를 합으로 내고 두 추출기가 일치하는가. (b) 합성 두 출력 모델(`gen_model_multiout.py`)을 평가 타깃용으로
  한 번의 호출로 컴파일한 명세가 출력 두 개를 한 슬랩과 봉쇄된 subview 둘로 읽는가(C 배치는 단일 출력만이라 분석기 수준).
- **Q6 (경미 3)**: 게스트에 설치된 IREE 파이썬 런타임의 버전 기록이 컴파일러와 같은 리비전(e4a3b04)인가.

## 2. 판정 기준 (측정 전 고정)

- **Q1 PASS**: 이전 리비전 4/4 `state = mismatch`·`bound_method = NONE`·헤더 `BOUND_KNOWN 0`; 평가 리비전 4/4 `match`,
  `bounded_bytes`·`static_per_call_bytes`·`module_resident_constant_bytes` 보관값과 동일, 헤더 바이트 동일. 보관 14개(E14)
  회귀 diff 0(새 블록은 subtree로 제외). **반증**: 평가 리비전 문서가 보류되면(과잉 거부) FAIL.
- **Q2 PASS**: (a) `admission = UNKNOWN_BOUND`, `mem_init` 부재, 추론 0, 운영 유지. (b) `admission = ADMIT`,
  `binding = MATCH`, 런타임 적재 실패 레코드와 그 오류 문자열에 `16`과 `17`이 함께 나타남, 추론 0, 운영 유지.
  게스트 `.so` sha256이 빌드 기록과 일치(불일치 셀은 INVALID).
- **Q3 PASS**: 옵션 `true` 셀 `active = false`, `runtime_created = false`, `admission = null`, 사유에 구성 오류 명시;
  대조 셀 `active = true`, 추론 ≥ 1. 기존 배포 설정(명시적 `false`)은 단위 시험으로 통과 확인.
- **Q4 PASS**: 4/4 `analysis_domain.required_premises.output_lifetime` 존재, `producer_check.state = match`, 세 수치 불변,
  헤더 바이트 동일.
- **Q5 PASS**: (a) 두 셀 모두 발행, $T$ = 두 slab 합, $O$ = 두 할당 합, 추출기 일치, 편집하지 않은 대조는 원래 수치.
  (b) 발행, $O$ = 패킹 슬랩 크기, subview 2개 봉쇄 통과, 오버라이드 0.
- **Q6**: 관측값을 그대로 적는다(판정 아님).

## 3. 주장하지 않는 것

- bytecode 버전 검사는 **같은 bytecode 버전을 내는 다른 컴파일러 리비전을 구별하지 못한다**. 쓸 수 있는 것은
  *"아티팩트가 선언한 bytecode 버전이 점검한 리비전의 것과 다르면 상한을 보류한다"*까지다.
- 이전 리비전에 대해 $K$를 점검하지 않았다. Q2(b)는 런타임이 그 모듈을 적재하지 않음을 보일 뿐이다.
- 다중 slab·다중 출력의 **실행** 피크(Q5는 분석기 수준).
- 지연·정확도.
