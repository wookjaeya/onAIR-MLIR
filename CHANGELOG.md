# CHANGELOG

형식: [버전] 날짜 — 변경. 가설 판정 변경은 반드시 "판정:" 접두어, 이전 주장 철회는 "정정:" 접두어로 기록.

## [v0.28] — E26f: E26-ext 완결, 상수 지배형 실물 모델

계획서가 채택한 마지막 ext 모델(**MLPerf Tiny Deep AutoEncoder**, ToyADMOS 계열)을 실행했다.
이 모델이 포트폴리오에 있는 이유는 **상수:per-call 비가 극단**이라는 것이었고, 실측 비는
**171.3 : 1**이다(B2 ResNet 1.00:1, canonical 11:1). Q1(위반 0)·Q2(반증 0)·Q3(`B−1`→DENY,
`B`·`B+1`→ADMIT) 전부 성립. 계약 `bounded` 1,069,632 = `per_call` 6,208 +
`constants` 1,063,424, 오버라이드 0개 — 계획서 §1.1이 조사에서 인용해 둔 값과 **정확히 같다**
(다른 세션의 독립 재현). **ext는 판정을 산출하지 않으므로 v0.25의 판정은 그대로다.**

반입은 이 세션에서 직접 수행했다(조사 산출물을 그대로 쓰지 않았다): `tflite2onnx` →
ONNX `graph.name = "infer"` → `iree-import-onnx --opset-version 17` → `iree-opt` torch→linalg →
**한 번의 `iree-compile`**. 잔여 torch op 0, entry `@infer(tensor<1x640xf32>) -> tensor<1x640xf32>`.

**배포 의존성의 최대 사례**: 같은 vmfb가 pip `iree.runtime`에서 **6,208**(`mapped`,
tightness **172.30×**), 소스 빌드 C 런타임에서 **1,069,632**(`allocated`, 1.00×). 차이는 정확히
상수량이다. E26-core의 tightness 상한 45.50×를 **172.30×로 넓힌다** — "런타임 계측으로 얻은
상한을 다른 배포에 그대로 쓰면 얼마나 틀릴 수 있는가"의 이 저장소 최대 실측치다.

**B2(1:1)와 B3(171:1)는 할당 구조가 정반대인데 결론이 같다** — tightness는 상수 비중을 그대로
따라가고, 분기 가설은 어느 쪽에서도 반증되지 않았으며, 예산 경계 동작은 동일하다.

**주장하지 않음**: 정확도·AUC(ToyADMOS 평가셋 접근 불가), 이 모델의 cFS 배포(미실행),
172.30×의 일반화(이 모델·이 두 배포의 관측이며 분기 결정 요인은 E26에서 미확정으로 남긴 그대로).

이 컨테이너 실측 **260/260 → 267/267**, 보관 14개 계약 diff 0.

**CI 실측**(커밋 `f7be746`, run 73): `full` **266/266 + 1 SKIP**(PyYAML 미설치) · `without-iree` **159/159 + 15 SKIP** · `stdlib-only` **159/159 + 15 SKIP**. 컨테이너와 `full`의 차이 1건은 PyYAML 유무다(D34).

## [v0.27] — E26e: E26-ext, 실물 MLPerf Tiny CNN에서의 계약 경계

**E26-core의 결론이 합성 모델 밖에서 재현된다.** MLPerf Tiny ResNet(CIFAR-10, 원본
`pretrainedResnet.tflite` 318,144 B, 16 dispatch)에서 Q1(위반 0)·Q2(반증 0)·Q3(`B−1`→DENY,
`B`·`B+1`→ADMIT)이 전부 성립했다. 계약: `bounded` 618,856 = `per_call` 309,416 +
`constants` 309,440, 오버라이드 0개. **E26-ext는 판정을 산출하지 않으므로 v0.25의 판정은
그대로다**(`docs/plans/E26_boundary_utility.md` §0.1).

**핵심 관측**: 같은 vmfb가 배포에 따라 `try_map`의 **두 분기를 모두** 탔다 —
pip `iree.runtime` peak **309,416**(`mapped`, tightness 2.00×) vs 소스 빌드 C 런타임
**618,856**(`allocated`, 1.00×). 차이는 **정확히 상수량 309,440 B**다. E26의 "정적 계약은
배포에 독립, 런타임 계측은 그 배포에만 유효" 결론이 실물 CNN에서 재확인된다.

**부수 실측 (1) — `iree-compile`은 이 구성에서 바이트 재현적이지 않다.** ResNet을 같은 파일·
같은 플래그로 3회 컴파일해 **3개의 서로 다른 vmfb 해시**를 얻었고(`--mlir-disable-threading`을
주면 2회 동일), 2-dispatch 소형 모델도 덤프·프린트 플래그를 포함하면 회마다 달라졌다.
그럼에도 **계약이 서명하는 수치는 전부 동일**했다 — 새 호출의 계약은 fixture 계약과
`bounded`·`per_call`·`constants`·`transient`·`io`·`dispatches`가 모두 일치하고 `artifact.bytes`/
`sha256`만 다르다. 흔들리는 것은 **아티팩트 동일성**이지 **경계 수치**가 아니다. 실무적 귀결:
**측정에 쓴 vmfb는 보존해야 한다 — 레시피만으로는 되돌아오지 않는다**(작업 규율 7의 두 번째 이유).

**부수 실측 (2) — D50, 스스로 잡은 측정 결함.** 첫 pip 측정이 peak 309,576을 내 저장소
분류기가 **`refutes_hypothesis`**로 판정했다(B0 37셀에서 0건이던 값). 원인은 모델이 아니라
측정이었다 — 반환된 출력 버퍼 4개를 붙들고 있어 해제되지 않았다(`309,416 + 4×40`). 호출마다
결과를 놓아주면 피크는 정확히 `per_call`이고 `allocated == freed`다. **HAL 통계는 관측자가
무엇을 붙들고 있는지에 반응한다** — E26의 "HAL 통계는 프로세스 전역"과 같은 계열의 두 번째 얼굴이다.

**주장하지 않음**: 정확도(CIFAR-10 평가셋 호스트 차단), 이 모델의 cFS 배포(미실행),
B3 Deep AutoEncoder(fixture 없음 — 남은 ext 항목).

이 컨테이너 실측 **252/252 → 260/260**, 보관 14개 계약 diff 0.

## [v0.26.1] — 정정: E26 계획 §5-3의 A5b_canonical 누락 (E26d)

정정: **사전 고정 계획서가 지정한 단계 하나가 실행되지도, 미실행으로 기록되지도 않았다.**
`docs/plans/E26_boundary_utility.md` §5 3단계는 게스트 세션에서 **A5b_canonical 1건**을 함께
실행하라고 지정했으나 `docs/EVIDENCE_v0.25_E26.md`는 그것을 보고하지 않았다. E26의 판정
(Q1·Q3 PASS, Q2 정량화)은 **바뀌지 않는다** — A5b는 메모리 경계 질문이 아니라 손상 아티팩트
거부 경로의 질문이고 §2의 판정 기준 어디에도 들어가지 않는다. 그러나 이 저장소는 v0.9.1에서
A5b를 두고 이미 한 번 정정했으므로(실행하지 않은 시험을 "확인했다"고 서술) 같은 유형을
조용히 넘기지 않는다.

**E26d에서 실제로 실행했다**(게스트가 살아 있어 재구축 없이). `flatbuffer_root_uoffset`로
손상(크기 동일 732,760 B), 계약을 **손상된 파일의 실제 해시로 재생성**해 해시 게이트가 잡을 수
없는 조건을 만든 뒤 게스트 `core-cpu1` 기동: admission **ADMIT** → binding **MATCH** →
`runtime_load_failed`(IREE 자신의 FlatBuffer 검증기, E17과 같은 오류 문자열) → cleanup 1회 →
`CFE_ES_ExitApp`. 이후에도 cFS는 남은 앱을 계속 로드했고 크래시·abort 0건,
`check_expect` 불일치 0건이다.

**손상 아티팩트는 저장소에 넣지 않았다** — 손상이 결정적이므로 시험이 in-tree 원본에서
재생성해 게스트가 실제로 적재한 해시와 대조한다. 주장이 저장소 내용만으로 재현되면서
732 KB를 늘리지 않는다.

이 컨테이너 실측 **244/244 → 252/252**, 보관 14개 계약 diff 0.

## [v0.26] — E26c: 다중 출력 모델 과잉 거부 (D49)

벤치마크 지침(B0–B4) 도입 조사가 `docs/plans/E26_boundary_utility.md` §6에 남겨 둔 잔여 결함
후보 **C-1**을 직접 재현해 수정했다(**D49**). 이후 별도로 돌린 반박 검증의 "실제 CNN 규모를
감당하는가" 축도 독립적으로 같은 결론에 도달했으나, 어느 보고도 액면 그대로 받지 않고 스톡
2출력 모델을 한 번의 `iree-compile`로 컴파일해 직접 확인했다(E24c/F4의 교훈).

증상: IREE는 결과가 둘 이상이면 **하나의 external 슬랩에 패킹**한 뒤 `stream.resource.subview`로
쪼갠다. 그 op이 두 추출기(`static_mem_bound.py`의 정규식, `mlir_alloc_walk.py`의 구조적)
화이트리스트 어디에도 없어 D13의 fail-closed 규칙이 `unresolved`로 밀어 넣었고, `bound_method`가
`UNKNOWN_BOUND`가 됐다. **파서는 유일한 실제 할당(128 B)을 이미 건전하게, 그것도 보수적으로
(128 ≥ 32 + 16) 계상하고 있었다** — 거부는 순전히 화이트리스트 누락이었다. 유형 (B) 과잉 거부다.

수정: 두 화이트리스트에 추가하되, 이미 있던 비할당 항목(`tensor.export`·`resource.dealloca`)과
달리 **검사를 붙였다** — 세 index 피연산자가 전부 상수로 풀리고 `offset + result_size <=
source_size`일 때만 통과하고, 아니면 `unresolved`다. 구조적 추출기의 피연산자 순서
`[source, source_size, offset, result_size]`는 실제 op에 MLIR API를 걸어 읽은 것이다.

**revert-and-confirm-fail을 두 단계로** 했다: 화이트리스트만 되돌리면 **7건 FAIL**(과잉 거부가
실재했다), 검사 코드만 빼면 **4건 FAIL**(검사가 없으면 거짓말하는 subview 두 종류가 그대로
통과한다 — 유형 (B)를 고치면서 유형 (A)를 심는 경우).

실물 근거(D43 규칙): `harness/gen_model_multiout.py` + `results/e26c_multiout/`(한 번의 컴파일
호출, 128 KB). 계약은 **오버라이드 0개**로 생성되고 `constants_confirmation_state: confirmed`,
구조적 크로스체크 일치. `iree.runtime` local-sync 실측 HAL 피크 **704 B = bounded 704 B**
(tightness 1.00×), 출력 2개 확인.

**남는 제약(명시)**: `gen_contract_header.py`는 이 계약을 받고도 헤더를 쓰지 않는다 — 두 C
실행기가 실제로 단일 f32 in/out을 가정하기 때문이다. 이는 과잉 거부가 아니라 정확한 진술이며,
E26c가 연 것은 **계약 생성 경로**이고 다중 출력의 C/cFS 배치는 여전히 열려 있지 않다.

이 컨테이너 실측 **229/229 → 244/244**, 보관 14개 계약 diff 0.

정정: `docs/plans/E26_boundary_utility.md` §1.4의 `iree-import-tflite` 차단 서술에서 **"TF 2.21에서"를
철회한다.** 실측은 TF **2.19.1·2.20.0·2.21.0 셋 다** `ExperimentalTFLiteToTosaBytecode`를
export하지 않는다 — 다운그레이드로 우회할 수 없고, 막는 축도 IREE 버전 불일치가 아니라
TensorFlow↔TOSA↔IREE다(같은 세션 반박 검증 8건: UPHELD 1, QUALIFIED 7, 반전 0).

## [v0.22.1] — 정정: E25 주장 범위 (외부 검토 v0.22) + E25b 판정 도구

일곱 번째 외부 검토(`docs/reviews/REVIEW_v0_22_E25.md`, 기준 커밋 `44c27ac`)는 E25를 "실질적
연구 진전"으로 인정하면서 **주장 범위 4곳과 판정 도구 1곳**을 지적했다. 저장소를 직접 대조한
결과 **전부 사실**이었다. **E25의 PASS 판정과 수치는 바뀌지 않는다** — 바뀌는 것은 그 수치가
무엇을 말하는지의 범위다. 아래 [v0.22] 항목의 원문은 이력이므로 그대로 두고 여기서 정정한다.

정정: **"256/256 원소"는 집계 오기**다. 경로당 128(입력 64 × 출력 2), 네 경로 합계 **512/512**.
argmax는 경로당 64/64(합계 256/256)이며 그 수와 섞였다.

정정: **"두 ISA의 코드생성이 같은 누산 순서를 만들었다"는 철회한다.** 이 실험이 관측한 것은
출력 바이트의 동일성뿐이고, 누산 순서는 어디에서도 측정하지 않았다(두 타깃의 dispatch ELF를
대조한 적이 없다). 정정된 서술은 *"서로 다른 vmfb인데도 출력이 비트 동일했다. 그 원인은
확인하지 않았다"*이다. 원인 확인은 E27 후보다.

정정: **E25가 E14의 `both_sound: null`을 해소했다는 서술을 철회한다(D45).**
`harness/cross_target_compare.py:201`의 `both_sound`는 각 타깃 실행 요약의 `peak_within_bounded`,
즉 **메모리 관측**을 종합한 값인데 E25는 메모리를 전혀 계측하지 않았다(cFS E25 로그의 stage는
`stack`/`admission`/`binding`/`e25_equivalence` 넷뿐, `mem` 레코드 없음). E25가 채운 것은 같은
지표의 **다른 칸**인 `out0_agreement`이며 그것도 **canonical 모델 한 개 한정**이다. E14 4모델의
메모리 soundness 공백은 **그대로 남아 있고 E26의 대상**이다.

정정: **"OnAIR-IREE"는 OnAIR 실행이 아니다.** `iree.runtime` Python 바인딩 직접 호출이며,
OnAIR 플러그인은 여전히 외부 `weights.npz`를 읽는 경로이고(`compiled_learner_plugin.py:118-138`),
cFS E25 모드는 Software Bus 수신과 feature 변환을 거치지 않는다(`ai_learner.c:326-372`).
E25의 입증 범위는 **"canonical 모델의 계산 결과 동치 + cFS 앱 내부 추론 경로 통합"**이다.

정정: 계약값이 두 ISA에서 같다는 것은 **이 구성(4~5개 모델·1개 컴파일러 버전)의 관측**이며
일반적 ISA 독립성의 증명이 아니다.

**E25b — 판정 도구를 사전 고정 기준에 맞춤(과잉 거부 1건 실제 재현·수정)**:
`harness/e25_compare.py`는 **모든** IREE 경로 쌍에 비트 동일을 요구하고 있었다. 그러나 계획
`docs/plans/E25_same_model_equivalence.md` §3.2·§3.3-5는 실행 **전에** "같은 vmfb는 비트 동일,
cross-ISA는 tolerance"로 정해 두었다. 즉 도구가 계획보다 강한 조건을 걸어, 정직한 cross-ISA
결과를 FAIL로 만드는 **유형 (B) 결함(과잉 거부)** 경로였다. 한 원소만 1 ulp 다른 입력
(`abs_max=1.192e-07`, `rel_max=6.255e-08` — 모든 원소가 abs·rel 기준을 **각각 단독으로** 16/16
만족)으로 직접 재현했고, 옛 도구는 `VERDICT: FAIL rc=1`이었다.
수정: 쌍 규칙을 아티팩트 sha256으로 선택하고(`--vmfb NAME=SHA256`을 모든 `--path`에 필수화,
누락 시 거부·미기록), cross-vmfb 쌍은 tolerance + argmax 일치로 판정하되 `bit_identical`은
관측값으로 계속 기록한다. **기준 완화가 아니라 이미 정한 비교 조건의 구현**이다.

- 보관 E25 출력 재판정: 판정 `pass: true` 불변, `vs_reference`·`argmax` 원본과 **완전 동일**,
  규칙 배정 `same_vmfb` 3 / `cross_vmfb` 3, 6쌍 모두 `bit_identical: true`(cross 3쌍은 요구되지
  않았으나 관측됨). 결과는 **새 파일** `comparison_all.pairrule.json`에 쓰고 원본은 보존했다.
- 커밋 전 자체 검토에서 fail-open 하나를 더 닫았다: `--vmfb` 값을 형식 검증 없이 문자열 비교만
  하면, 같은 아티팩트를 쓰는 두 경로의 sha를 잘못 적었을 때(빈 값·잘린 값) 두 값이 달라
  **더 약한 cross_vmfb 규칙이 조용히 적용**된다(D28·D29·D30과 같은 모양). 64자리 16진수가
  아니면 거부하도록 했다.
- 회귀 **12건** 신설(`e25_compare_rule_cases()`): same_vmfb 1 ulp는 **여전히 FAIL**(핵심 주장 유지),
  cross_vmfb 1 ulp는 통과, tolerance 초과·argmax 불일치는 FAIL, `--vmfb` 누락·형식 불량 4종은 거부,
  결정성. 이 컨테이너 실측 `--skip-regression` **160/160**, 전체 **203/203**(191→199→203).
  (CI 실측은 E26a·E26b가 시험을 더한 뒤의 최종 상태로 [v0.25]에 기록했다.)
- README·`results/e25_equivalence/README.md`를 E25 완료 현황과 동기화하고,
  `aarch64_env/BOOT_LOG.md`에 부팅 시도 2·3과 디스크 수정을 보완 기록했다.

정정: **D46 — EVIDENCE §7이 가리키는 원시 게스트 로그가 저장소에 없었다.** `.gitignore:7`의
포괄 규칙 `*.log`에 대한 예외가 `results/e14_aarch64_qemu/**/*.log`에만 있어 E25의 시리얼·드라이버
로그가 전부 제외되고 있었다(E22의 F9와 같은 계열). `!results/e25_equivalence/**/*.log`를 추가하고
로그 5개를 커밋했다. 함께 확인된 것: **시도 2의 시리얼 로그는 복구 불가**다 —
`scripts/71_boot_guest_aarch64.sh:24`의 `: > serial.log`가 매 부팅마다 잘라내 시도 3이 덮어썼다.
따라서 §7의 "emergency mode 2회" 중 **두 번째는 보존 산출물로 검증되지 않는다**(철회가 아니라
증거 등급의 명시 — 산출물로 확인되는 것은 시도 1의 emergency 1회와 시도 3의 정상 부팅 0회다).

## [v0.25] — E26: 부분 메모리 계약 경계의 유용성 (Q1·Q3 PASS, Q2 정량화)

판정: **Q1 PASS**(관측 21개 실행 셀 전부 `hal_peak ≤ bounded_bytes`, 위반 0),
**Q3 PASS**(unsafe admit 0, `B−1`→DENY·`B`/`B+1`→ADMIT이 native·cFS 모두 성립),
**Q2 측정 완료**(tightness 1.00×~45.50×). 사전 고정 기준은 측정 전에 커밋됐다(`c8e8980`).

**tightness는 컴파일러가 emit한 분기의 함수이고, 그 분기는 런타임 배포가 정한다.**
layout IR에서 기전을 직접 확인했다 — IREE는 상수를 `stream.resource.try_map` +
`scf.if(%did_map)`로 감싸며, 성공 분기는 HAL 할당이 0이고 실패 분기는 상수만큼 할당한다.
보관 모델 12개 전부 같은 구조다. 따라서 `bounded = per_call + constants`는 **두 분기의
최댓값**이고, soundness는 구조적으로 두 분기 모두에서 성립한다.

같은 아티팩트로 네 가지 런타임 배포를 실측했다:

| 배포 | conv2d | mlp16k | multibranch |
|---|---|---|---|
| pip `iree.runtime` (x86-64) | 1,352 매핑 | 65,580 매핑 | 840 매핑 |
| 소스 빌드 C 런타임 native (x86-64) | 3,528 할당 | 786,476 할당 | 38,216 할당 |
| 같은 런타임의 cFS 앱 (x86-64) | 3,528 할당 | 786,476 할당 | 38,216 할당 |
| 소스 빌드 C 런타임 qemu-user (AArch64) | 1,352 매핑 | 786,476 할당 | 840 매핑 |

**같은 vmfb의 HAL 관측 peak가 배포에 따라 최대 45.5배 달라진다.** 그러므로 런타임 계측으로
얻은 상한은 그 배포에만 유효하고, **정적 계약은 배포에 독립**이다 — 이것이 "부분 계약이 배치
판단에 유용한가"에 대한 이 실험의 답이며, 유용성의 근거는 tightness가 아니라 배포 독립성이다.

분기 결정 요인은 네 가지를 실측으로 배제했다: 실행마다 무작위 아님(5/5 결정적), 런타임 빌드
구성 차이 아님(CMake 캐시 동일), 모델 내재적 아님(E14는 **같은 aarch64 vmfb**로 multibranch
38,216, 이번엔 840), embedded/external 저장 형태만으로 설명 안 됨(external인 multibranch가
AArch64에서 매핑됨). **어느 배포 요소가 `try_map` 성공을 가르는지는 미확정으로 남긴다.**

- **E14의 `both_sound: null` 공백을 실제로 닫았다** — 3모델 전부 `both_sound: true`,
  `out0_agreement.agree: true`. v0.22.1에서 D45로 철회했던 항목을 이번엔 두 타깃의 실제 실행
  요약으로 채웠다.
- 측정 위생: 모든 cFS 셀이 `{"stage":"e25_mode","active":false}`로 동치 모드 꺼짐을 **증언**했다
  (`e25_mode_unproven: []`). HAL 통계가 프로세스 전역이라 한 프로세스에서 두 모델을 재면
  오염됨을 실측 재현했고(840 대신 65,580), 모든 셀을 모델당 별도 프로세스로 측정했다.
- 신규 도구 `harness/e26_collect.py` — 사전 고정 기준을 그대로 적용해 판정한다. 작성 중
  자체 결함 하나를 발견해 고쳤다: 두 실행기가 예산 필드명을 다르게 쓴다(`budget_bytes` vs
  `budget`). 한쪽만 읽으면 절반의 셀에서 Q3가 **평가 불가인데 "ok"로 보였다** — 평가 불가는
  이제 `UNGRADED`로 드러난다.
- 지연값은 인용하지 않았다(작업 규율 4). RSS는 버킷 보고용이며 판정에 쓰지 않는다.
- 회귀 시험 **CI 실측**(커밋 `3afdf80`): `full` **228/228 + 1 SKIP**(PyYAML 미설치) · `without-iree` **126/126 + 13 SKIP** · `stdlib-only` **126/126 + 13 SKIP**. 이 컨테이너와 `full`의 차이 1건은 PyYAML 유무다(D34 — 추정하지 않고 두 수치를 조건과 함께 병기).

**범위**: E26-core(B0 3모델)의 판정이다. B2·B3(MLPerf Tiny)의 실행 측정과 AArch64 게스트
cFS 셀은 E26-ext로 남아 있다.

## [v0.24] — E26b: 빈 백틱 라벨 상수 세그먼트 과잉 거부 (D48)

정정: **D48 — 정직한 f32 모델이 배치 가능한 헤더를 만들 수 없었다**(유형 B, 과잉 거부).
E26a(D47)와 원인·위치가 다르고, 둘 다 "실제 워크로드를 넣자마자 드러났다"는 점만 같다.

- `iree-dump-module`은 embedded `.rodata`의 내용이 인쇄 가능해 보이면 백틱 사이에 렌더링한다.
  **첫 바이트가 NUL인 진짜 상수 블록은 빈 백틱 쌍으로 출력된다.**
  `static_mem_bound.py:229`의 판별식이 `"`" not in rest`(백틱이 있으면 데이터가 아님)라서
  2,816 B 상수 블록을 관측 총합에서 버렸다.
- 연쇄: 관측이 계약값과 모순 → N1/D28 상수 게이트가 (받은 정보 기준으로는 옳게) 거부 →
  `--allow-unconfirmed-constants`로 뚫으면 `verification_grade: overridden` →
  E24b/D39 헤더 게이트가 다시 거부. 실제로 그 모델의 계약은 이 오버라이드로만 존재했다.
- 수정: 라벨의 **존재**가 아니라 **길이**로 가른다 — IREE는 문자열 내용을 전부 출력하므로
  진짜 문자열이면 `len(label) == nbytes`. 저장소 전 산출물의 백틱 rodata 줄 **137개 중 136개**가
  이 성질을 만족하고 유일한 예외가 오분류되던 그 세그먼트다. 모호하면 **데이터로** 분류한다
  (과다 계상은 크로스체크가 거부해 눈에 보이고, 과소 계상은 조용히 통과하므로).
- 시험 8건 신설. revert 시 깨끗이 1건 FAIL — 첫 작성본은 `AttributeError`로 **스위트 전체를
  죽였고**(D24/D32가 두 번 고친 바로 그 부류), 시험 자신이 `getattr`로 전제를 확인하도록 고쳤다.
  **결함을 재현하려고 되돌리는 순간이 정확히 그 조건이 발생하는 때다.**
- 이 컨테이너 실측 **229/229**(221→229), 보관 14개 계약 diff 0. (CI 실측은 [v0.25]에 기록.)
- 실물 근거: `results/e26_boundary_utility/empty_label_rodata_fixture/`(vmfb + 원본 덤프).

## [v0.23] — E26a: 계약 도구가 실제 공개 CNN을 수용하도록 (D47)

벤치마크 구성 지침(`docs/reviews/BENCHMARK_PLAN_REFERENCE_BASED.md`)이 요구한 "합성 모델 대신
출처가 추적되는 실제 워크로드"를 따르자마자 **첫 실물 모델에서 도구가 막혔다.**

정정: **D47 — 정직한 공개 CNN이 배치 가능한 헤더를 만들지 못하고 거부되고 있었다**(유형 B,
과잉 거부). `elf_stack_frame.py`의 분류 문구는 처음부터 *"resolve targets before classifying"*
이라고 적혀 있었지만 **그 해석 단계가 구현된 적이 없어**, 호출 명령이 하나라도 있으면 무조건
bucket (3)/(4)였고 `gen_contract_header.py`(E21/D22)가 그것을 "신뢰 불가"로 읽어 거부했다.

- 재현: MLPerf Tiny ResNet(CIFAR-10, `mlcommons/tiny` @ `4addd0f`, Apache-2.0)의 softmax
  dispatch가 컴파일러 생성 부동소수 헬퍼를 80번 호출한다. 그 80개의 타깃은 **2개뿐이고 둘 다
  이 ELF의 `.text`(0x2e50–0x54fc) 안**이며, `.plt`도 미정의 심볼도 없고, 두 헬퍼는 **프레임
  0 B의 leaf**다. 실제 추가 스택은 반환 주소 8 B다 — "정적 상한 없음"은 사실이 아니었다.
- **이 결함은 합성 모델셋으로 재현 불가능했다**: E14 보관 14개와 E25 canonical이 전부
  `total_call_insns = 0`이다(손으로 쓴 linalg는 자기완결적 dispatch로 lowering된다).
  지침이 말하는 외적 타당성 문제의 구체적 실례다.
- 수정: 호출 그래프 해석을 넣되 **한 방향으로만** 작동한다. 간접 호출·범위 밖 타깃·꼬리 호출·
  콜리의 동적 alloca·콜리 안 간접 분기·재귀·해석 결과 부재는 전부 **거부 유지**. 콜리 범위는
  CFG를 실제로 순회해 찾는다(첫 구현의 "첫 ret까지 자르기"는 바로 이 ResNet 헬퍼에서 거짓
  거부를 냈다 — 그 헬퍼가 자기 첫 ret을 건너뛰는 전방 분기를 갖는다).
- 부수 정정: `make_contract.py`의 `kernel_external_call_insns`가 이름과 달리 **내부 호출까지
  포함한 총 호출 수**로 채워지고 있었다. 이제 해석되지 않은 호출 수를 담으며, 옛 분석 파일에는
  총 호출 수로 폴백한다(보수적 방향). 계약에는 판정만 넣어 **보관 14개 계약은 바이트 불변**.
- 결과: 그 모델이 **오버라이드 0개**로 계약(`bounded=618856` `per_call=309416`
  `constants=309440`)과 헤더(`KERNEL_STACK_BYTES_KNOWN 1`, `439L`)까지 완주한다.
- 시험 12건 신설, revert 시 11건 실패 확인. 이 컨테이너 실측 **221/221**(209→221),
  **14/14 계약 diff 0**. (CI 실측은 [v0.25]에 최종 상태로 기록했다.)
- 실물 근거 보존: `results/e26_boundary_utility/mlperf_tiny_resnet_fixture/`
  (D43이 확립한 관례 — "실제 모델이 X한다"는 주장은 그 모델이 트리에 있어야 한다).

**주장하지 않음**: 이 모델의 정확도(CIFAR-10 평가셋 호스트가 이 환경에서 차단됨, 직접 확인),
모든 CNN의 통과, HAL 관측 peak와의 관계(E26 대상), 양자화 모델(범위 밖).

## [v0.22.2] — E26 준비: 계측 분리 (측정 아님)

외부 검토 §6("E26 측정 전 필수 사항")이 요구한 계측 분리를 구현하고 **실제 실행으로 확인**했다.
게이트·판정 로직은 건드리지 않았고, E26의 판정·수치는 사전 고정 기준을 커밋한 뒤에 만든다.

문제: `/cf/e25_inputs.bin`이 있으면 cFS 앱이 **초기화 중 64회 추론**을 먼저 돌리므로 run 루프의
첫 `mem` 레코드가 이미 오염된다. native 경로도 E25 블록이 통계 조회보다 앞에 있어 같다.
게다가 지금까지 HAL 통계는 run 루프에서만 나와서 **"모듈 적재 + 입력 버퍼만으로 얼마가 드는가"가
아예 관측되지 않았다.**

- cFS `ai_learner.c`: `{"stage":"e25_mode","active":<bool>}`를 **항상** 기록(측정 실행이 동치 모드
  꺼짐을 *증명*할 수 있어야 한다), 추론 0회 시점의 `{"stage":"mem_init",...}` 스냅샷,
  세션 생성 직후 `rss_kb_after_session`(IREE 런타임 컨텍스트를 모듈 로드와 분리 귀속).
- native `native_learner.c`: `phase_hal.{after_init,after_first_call,steady_baseline}`와
  `e25_mode_active`.
- `harness/e14_cfs_scenarios.py`: expect 키 `e25_mode_active`·`mem_init_present` 신설.
  **레코드 부재는 `false`가 아니다** — 그 레코드를 내지 않는 옛 앱은 침묵으로 통과하지 못하고
  실패한다(D29의 교훈을 그대로 적용).
- 회귀 6건(`e26_instrumentation_expect_cases()`). 이 컨테이너 `--skip-regression` **166/166**.

실측(x86-64, canonical_e25): 계약의 두 구성요소가 **실행 단계별로 분리 관측**됐다 —
초기화 직후 peak **720,932**(= constants 720,896 + 입력 버퍼 36 B = 9 float × 4),
최초 추론 직후 **786,476**(= `bounded_bytes`), 정상 실행도 786,476. native와 cFS가 같은 값이다.
cFS RSS 분해는 런타임 컨텍스트 +304 KB, 모듈 로드 +864 KB(RSS는 결정론적이지 않으므로 E26에서
반복 측정의 범위로만 다룬다 — 작업 규율 4). 실행 기록:
`results/e26_boundary_utility/instrumentation_check/`.

## [v0.22] — E25: OnAIR↔cFS 동일 모델·의미 동치 (PASS)

판정: 다섯 실행 경로가 같은 canonical 모델을 실행하고 네 IREE 경로의 출력이 **전부 비트
동일**하다. reference 대비 256/256 원소, argmax 64/64. AArch64 반복 실행도 비트 동일(결정적).

이전까지 OnAIR fixture(`mlp_9x65536x2`, hidden 65536, 외부 `weights.npz` 2.88 MB)와 cFS
배포(`mlp16k`, hidden 16384, baked)는 **서로 다른 모델**이었고 같은 것은 인터페이스뿐이었다.
`harness/gen_model_canonical.py`가 한 seed에서 baked MLIR과 npz를 함께 생성해 배포 경로 셋이
같은 vmfb를 공유하게 했고, npz는 reference 계산에만 쓰여 **배포 경로에서 사라졌다**.

**계획이 예상하지 않은 결과**: AArch64는 다른 vmfb(`4e5b2972` vs `0e250c2f`)이므로 tolerance
비교 대상으로 분류돼 있었는데 실제로는 비트까지 같았다. 두 ISA의 코드생성이 같은 누산 순서를
만든 결과다. **일반화하지 않는다** — 활성화 없는 matmul 2회 모델에서 이 컴파일러 버전·두 타깃
설정에 대해 관측된 것이고, 다른 할당·연산 구조에서도 성립한다는 근거는 없다. 그런 경우를 위해
계획의 tolerance 기준은 그대로 유지한다.

**사전 고정 기준의 가치가 실측으로 증명됐다**: telemetry regime(출력 ~1.3e9)은 절대 기준
단독이면 1/64, normalized regime(~12)은 상대 기준 단독이면 59/64 통과다. 어느 한쪽만
요구했어도 정직한 결과가 FAIL이 됐다. `e25_compare.py`가 `would_pass_abs_only`/
`would_pass_rel_only`를 함께 기록해 사후 합리화가 아님을 감사 가능하게 한다.

- 계약 값은 두 ISA에서 동일(786476/65580/720896/16), vmfb 바이트만 다르며 두 산출물이 같은
  canonical source·weight에서 나왔음을 `invocation.json`이 연결한다.
- E14의 cross-target 비교가 남긴 `both_sound`/`out0_agreement` `null`을 실제 출력 대조로 채웠다.
- 환경 실패(게스트 emergency mode 2회 → fstab `nofail` + cloud-init 비활성화로 해소)는
  EVIDENCE §7에 의미 동치와 **분리해** 기록했다.

## [v0.21] — E24c: 다섯 번째 외부 검토(F1–F5) — 확인된 4건 수정, 1건은 근거 있는 미채택

판정: 5건 전부 재현하고 4건을 수정했다(D41–D44). `contract_negative_tests.py` 170/170 →
**191/191**(이 컨테이너 실측). **CI 실측**(커밋 `50f16d0`): `full` 190/190+1 SKIP ·
`without-iree` 103/103+11 SKIP · `stdlib-only` 103/103+11 SKIP.

정정: **F5 — 이 저장소가 D35의 원인을 "unsigned 비교"라고 쓴 것은 틀렸다.**
`ai_learner.c`의 `es_stack`과 `stack_needed`는 둘 다 signed `long`이고 `info.StackSize`는
명시적으로 `(long)`으로 캐스트된다. 올바른 인과는 `stack_needed`가 음수(-37856)가 되어
비음수인 어떤 스택도 비교를 만족한다는 것이다. **인과가 반대로 틀렸다** — 실제 unsigned
비교였다면 오히려 거부됐을 것이다(재컴파일 확인). 그런데 그 서술에 "실제 C 식으로
컴파일해 확인"이라는 표시가 붙어 있었다. 판정(항등식·claim blocker)과 코드 수정은 유지되며,
`es_stack = -1`(GetAppInfo 실패)에서도 참이라는 사실이 추가로 확인됐다. 7곳 정정
(`docs/EVIDENCE_v0.20_E24b.md`는 §12 정오표).

**F1은 수정하지 않았다.** 리뷰 권고(provenance 필수화)를 적용하면 삭제 경로(VERIFIED=0)가
손으로 쓴 `{"single_invocation": true}` 한 블록으로 통과하는 **위조 경로(VERIFIED=1)**로
바뀌어 상태가 나빠짐을 실측했다. 삭제 경로가 만든 헤더는 이미 문서화된
`--allow-override-contract` 헤더와 **바이트 동일**이라 새 fail-open도 아니다. 이것은 코드가
아니라 threat model 결정 문제이며 `CLAUDE.md` 우선순위 0번이 이미 대기 항목으로 두고 있다.

- **D41(F2)**: D36의 합 항등식이 `is_int`를 건너뛰기 조건으로 써서 `null` 구성요소가 검사를
  무력화하고, 비음수 검사 부재로 `-1` 구성요소가 항등식을 공허하게 만족시켰다.
  리뷰 서술("둘 다 정수일 때만 실행")은 두 변종 중 하나만 설명한다.
- **D42(F3)**: 예산 초과 `None`이 기본 거부되지 않았다. **리뷰 처방은 정직한 >256 MiB
  모델을 거부**해 미채택 — 결정 절차를 예산 검사보다 앞에 두고 둘 다 실패할 때만 `None`
  (무작위 3,000건 brute force 교차검증 0 불일치). `constants_confirmation_state` 5-상태 신설.
- **D43(F4)**: D38을 정당화한 사례의 실물 산출물이 없었다. `harness/gen_model_manyconst.py`와
  `results/e24c_manyconst31/`(한 번의 컴파일 호출, 440 KB)로 보존하고, **실물 입력으로
  현재 True / 옛 절단 False를 실증**했다. 수치도 정정(31은 모델의 상수 개수, 세그먼트는 33개).

## [v0.20] — E24b: 네 번째 외부 검토(연구 목표 재정리본)의 반례 5건 + 우선순위 재편

판정: 검토 §5.2의 반례 5건(R1–R5)을 전부 실제로 재현하고 수정했다(D35–D39). 부수로 발견한
D40(문서화된 스모크 경로 2개 파손, 그중 1건은 E24의 N3 게이트가 만든 유형 (B) 회귀)도 수정.
`contract_negative_tests.py` 143/143 → **170/170**(이 컨테이너 실측). **CI 실측**(커밋 `5debfd5`):
`full` 169/169+1 SKIP · `without-iree` 85/85+9 SKIP · `stdlib-only` 85/85+9 SKIP — 차이 1건은
PyYAML 유무이며 D34의 교훈에 따라 두 값을 조건과 함께 병기한다(`docs/EVIDENCE_v0.20_E24b.md` §9.1).
보관 14개 헤더는 `CONTRACT_PROVENANCE_VERIFIED` 한 줄만 추가되고 다른 바이트 변화 0.

정정: **심각도 재분류가 두 번 있었고 방향이 서로 반대다.** R1(음수 스택)은 검토가 "매우 낮음:
수동 변조 필요"로 분류했으나, 계약을 손대지 않고 `--elf-analysis` 입력만 바꾸면 정상
`make_contract.py` 경로로 도달하는 **claim blocker**였다(cFS 스택 게이트의 `stack_needed`가
음수가 되어 signed 비교가 모든 스택 크기에서 참인 항등식이 된다 — 정정 E24c/F5). 반대로 R4(상수 세그먼트 절단)는 검토가 제안한
문자 그대로의 수정이 **정직한 31세그먼트 모델을 통째로 거부**하는 것으로 실측돼 채택하지
않았다 — 열거기를 진짜 tri-state로 고쳐 해결했다. E20(D16·D17)·E24(N1·N3)에 이어 양방향
결함 정의(fail-open과 과잉 거부 모두 결함)가 다시 결정적이었다.

- R5(override trust): `waive()`가 거부 지점이 아니라 **플래그 접근**을 감싼다 — 기계적 패치는
  결합형 게이트 2곳을 놓치고, 그러면 override가 적용됐는데 `verification_grade="verified"`라고
  주장하는 신규 fail-open이 된다. 드리프트를 1곳만 주입하면 **행위 시험 5건은 전부 PASS이고
  소스 수준 가드만 FAIL**함을 실측으로 확인했다.
- `provenance.overrides_applied`/`verification_grade` 신설(스키마 **선택** 필드 — 필수화하면
  보관 14개 계약이 전부 무효), `gen_contract_header.py`가 override 계약을 기본 거부
  (`--allow-override-contract`가 opt-out), `CONTRACT_PROVENANCE_VERIFIED` 매크로 신설.
- `CLAUDE.md` 우선순위를 검토 §5·§7의 연구 목표 축(C1–C4 / E25–E27)으로 재편. 중심 주장
  문장(`docs/EVIDENCE_v0.9_E14_stage1.md` §11.8)은 변경 없음.

## [v0.19] — E24: fail-closed 계약 불변식 닫기 (외부 검토 v0.18-후속 N1–N6, S5)

판정: 리뷰가 지적한 "검증 불가·모순 상태에서도 `CONTRACT_BOUND_KNOWN=1` 헤더가 생성되는 경로"
4건을 실제 재현 후 닫았다(D28–D30). E23이 함께 출하한 과잉 거부 회귀 1건(D31)과 하네스가
`jsonschema` 부재를 15건의 거짓 FAIL로 보고하던 문제(D32)도 수정. `contract_negative_tests.py`
125/125 → **142/142 + 1 SKIP**(CI 실측; PyYAML이 있는 환경은 143/143), 보관 14개 계약 diff 0 · 14개 헤더 바이트 동일.

정정: 리뷰의 N1–N6은 7건 전부 재현됐으나(반박 0건) 심각도는 달랐다(N1 P0→P1, N3 P0→P1,
N4 P1→P2). 그리고 **리뷰가 제안한 수정 3건은 실측 결과 과잉 거부를 유발**해 범위를 좁혔다 —
N1의 문자 그대로의 수정은 `dynamic` 계약 2개(A8 음성 시나리오의 입력)를, N3의 strict 변종은
이 저장소 스키마가 선언하는 정본 형태를 거부한다. `docs/EVIDENCE_v0.18_E23.md`에 §9 정오표
(OnAIR 게이트가 서명하는 것은 배포 바이트의 일부 / "진짜 무의존성 체크아웃"은 부정확했음),
`docs/EVIDENCE_v0.14_E19.md`에 §9 정오표(명칭 — 수치·판정 변경 없음) 추가. README·CLAUDE.md의
살아있는 서술에서 "정규 MLIR pass" 표현을 직접 정정(진짜 pass는 여전히 미착수 목표).

## [v0.18] 2026-09-08
- E23: 외부 검토(v0.15) 잔여 4건 처리(`docs/EVIDENCE_v0.18_E23.md`) — F4(표현 정정),
  F8(A5a·A5b 손상 방식 코드화), F10(OnAIR 바인딩 갭), F11(범위 명시).
- **판정(D26)**: A5b 시나리오가 EVIDENCE_v0.12 §2.1의 구조 손상이 아니라 A5a와 동일한 임의
  bit flip을 쓰고 있었음 — 두 방식을 구분하는 필드조차 없어 저장소 코드로는 E17의 A5b를
  재현할 수 없었다. `harness/corrupt_vmfb.py` 신설(ZIP64/STORED 외과적 패치 + CRC 갱신),
  `corrupt_method` 필수화(누락·미인식은 거부). 보관 vmfb 8/8에서 컨테이너 유효·타 엔트리
  불변·크기 동일·결정적 확인, `iree.runtime`으로 실제 로드해 E17과 같은 오류 문자열로
  거부됨을 확인(A5b의 네 번째 레벨).
- **판정(D27)**: OnAIR `CompiledLearner`가 계약이 지목한 vmfb를 sha256·크기 검사 없이
  로드하고 있었음(C 경로는 두 검사를 자원 획득 전에 수행). `artifact_binding.py` 신설,
  `verify_artifact_hash=True` 기본, 계약에 해당 필드가 없으면 검사 생략이 아니라 거부.
- **정정(D25)**: `iree-dump-module` 부재 시 uncaught `FileNotFoundError`로 전체 크래시.
  **E22가 만든 CI의 without-deps 레그가 첫 실행에서 실제로 잡았다** — E22의
  `sys.meta_path` import 차단은 모듈만 숨기고 콘솔 스크립트를 남기므로 원리적으로 재현
  불가능했던 조건. `OSError` 포착 + `(None,None)` 반환으로 "관측 못 함"과 "관측했고 없음"을
  구분, 상수 독립 확인 불가는 `null` + 기본 거부, 하네스는 `iree_tools_available()`로 SKIP.
- **정정**: `docs/EVIDENCE_v0.17_E22.md` §6 정오표 추가(§1의 "패키지가 아예 없는 환경을
  시뮬레이션" 서술은 "모듈만 없는 환경"으로 정정, §4 판정은 D25 수정 이후에 참).
- **정정**: `docs/EVIDENCE_v0.13_E18.md` §7 정오표 추가 — `Operation.walk()` 서술은 실제
  구현(자체 재귀 `_walk()`)과 다름, "정규 MLIR pass" 명칭은 "MLIR API 기반 구조적
  post-processing verifier"로 정정(수치·판정 불변).
- `contract_negative_tests.py` 107/107 → **125/125**(CI with-deps 레그 실측 포함). 진짜
  의존성 없는 체크아웃은 CI without-deps 레그 실측 **48/48 + 6 SKIP**(크래시 없음) — 로컬
  시뮬레이션 수치(50/50+5)와 다른 이유는 이 컨테이너엔 `iree.runtime`이 있어 A5b 런타임
  거부 시험이 실제로 실행되기 때문이며, 두 수치를 조건과 함께 병기한다. SKIP 요약도 사유를
  뭉뚱그리지 않고 실제 원인별로 나열하도록 수정. 14개 보관 계약 diff 0 유지.

## [v0.17] 2026-09-08
- E22: 외부 검토 F9 재현성 실제 확보(`docs/EVIDENCE_v0.17_E22.md`) — "96/96, 환경 구축
  불필요"가 fresh clone에서 재현되지 않던 문제를 실제 `git clone`으로 재현 후 해결.
- **정정(D24)**: `contract_negative_tests.py`가 `iree.compiler.ir` 부재 환경에서 uncaught
  `RuntimeError`로 전체 크래시(요약 0줄)하던 버그 발견·수정. `Result`에 `skip` 상태 신설,
  3개 지점을 명확한 SKIP으로 정리.
- E21의 F3(구조적 검증기 미설치 기본 하드실패)이 이 시험 하네스 자신의 서브프로세스 호출과
  상충하던 것을 `structural_available()`/`with_structural_override()`로 해소(각 시험이
  실제로 검사하려는 조건만으로 판정되도록).
- `results/e14_aarch64_qemu/*/dump/`(242개 파일, 6.5MB)를 `.gitignore` 제외에서 빼고 커밋 —
  회귀·음성 시험이 실제로 요구하는데 저장소에 없었음.
- `requirements.txt`(버전 고정), `.github/workflows/contract-negative-tests.yml`(fresh
  checkout CI, with/without iree.compiler.ir 두 경로) 신설.
- 이 세션 내 실제 `git clone`으로 재현 확인: iree-base-compiler 설치 시 **107/107**, 미설치
  시 크래시 없이 **77/77 + 3 SKIP**. README의 "환경 구축 불필요" 문구가 이제 정확한 주장이 됨.

## [v0.16] 2026-09-08
- E21: 외부 검토(v0.15 최신본, `docs/reviews/REVIEW_v0_15_LATEST.md`) fail-open 결함 6건 수정
  (`docs/EVIDENCE_v0.16_E21.md`) — 11개 finding(F1–F11)을 독립 에이전트 11개로 병렬 검증(9건
  confirmed, 1건 partially_confirmed=F3, 1건 not-a-defect=F11), 코드 fail-open 결함 6건(F1,
  F2, F3, F5, F6, F7)을 실제 재현 후 수정.
- **정정**: F2(ABI 반사 부재 미거부)·F3(구조적 검증기 미설치시 opportunistic)·F5(stream.resource.pack
  비상수 unresolved 누락)는 검증 과정에서 원 리뷰의 severity(주로 P0)가 과대평가였음이 확인됨.
  특히 F3은 "MANDATORY라 부르면서 은폐"라는 리뷰의 프레이밍이 과장으로 판정됨(이 정확한 예외가
  이미 5곳에 문서화·E19에서 시험됨) — 다만 표현과 동작의 정책적 불일치는 타당해 기본값은 변경.
- 수정: F1(빈 `--dump-dir`로 one-invocation 신호 전부 None → 통과)은 기본 하드 실패
  (`--allow-unverified-invocation`), F2(ABI 반사 부재)는 기본 하드 실패
  (`--allow-missing-abi-declaration`), F3(구조적 검증기 미설치)은 기본 하드 실패
  (`--allow-missing-structural-checker`), F5(`stream.resource.pack` 비상수 슬라이스)는
  형제 분기와 대칭인 unresolved 처리로 수정(IREE 상류 실제 문법으로 재현), F6(스택 분석이
  스스로 불신뢰로 분류해도 KNOWN=1)은 세 신호 중 하나라도 불신뢰면 강제 미확인 처리, F7(C 게이트가
  "single-f32"라 주장하나 dtype 미검사)은 `CONTRACT_DTYPES_ALL_F32` 매크로 신설 + C 양쪽 게이트
  반영.
- 전 6건 수정 전 코드로 되돌려 신규 시험이 실제로 실패함을 확인(revert-and-confirm-fail).
  `contract_negative_tests.py` 96/96 → **107/107**. 보관 14개 헤더는 신규 매크로 반영해 재생성
  (계약 수치 자체는 diff 0 유지). F4/F8/F9/F10/F11은 후속 실험(E22/E23)으로 이연.

## [v0.15] 2026-09-08
- E20: E19 구조적 크로스체크 적대적 코드 리뷰(`docs/EVIDENCE_v0.15_E20.md`) — 이 세션 내에서
  E19의 diff를 4개 독립 관점(정확성/시험 커버리지/단순화/강건성) 병렬 리뷰 + finding당 3인 반박
  검증으로 검토. 13건 중 11건 확인, 2건 반박.
- **정정: 과잉 거부(over-rejection) 결함 2건 발견·수정(D16, D17)** — 둘 다 실제 재현됨(추측 아님):
  (A) 크로스체크가 계약이 실제로 서명하는 `p`가 아니라 정규식 파서의 "파일 마지막 print=최다
  lowering" 낡은 가정에 의존하는 `whole`과 비교돼, 인쇄 순서가 바뀌면 정상 모델도 거부될 수
  있었음(conv2d 두 print 청크 순서만 교환해 재현). (B) constants(sum) 비교가 계약이 실제 채택하는
  `const_b`(패킹 크기)가 아니라 `dense_sum`과 비교돼, 정렬 패딩이 있는 모델은 영구적으로 오탐
  거부됐을 것(mlp16k 패킹 크기만 64B 편집해 재현). 둘 다 보관 layout IR의 surgical 텍스트 편집만
  으로(재컴파일 없음) 재현.
- 수정: 비교 기준을 `p`/`const_b`로 교체, 3곳에 중복 구현됐던 diff 로직을
  `mlir_alloc_walk.diff_against_regex` 공유 헬퍼로 통합(드리프트 위험 제거). 재현 시나리오를
  고정 회귀 시험으로 등록하고, 수정 전 코드로 되돌려 시험이 실제로 실패함을 확인
  (revert-and-confirm-fail). 시험 갭 4건(dispatches-only 양성, allow-override 예외분기,
  constants 진짜불일치, graceful-degradation 정식화) 추가. `contract_negative_tests.py`
  85/85 → **96/96**. 보관 14개 계약은 diff 0 유지.
- `docs/EVIDENCE_v0.14_E19.md`에 §8 정오표 추가(철회 아님 — 14/14 일치 자체는 여전히 참, padding=0
  코퍼스라 이 두 결함이 그 검증에서 드러나지 않았을 뿐임을 명시).

## [v0.14] 2026-09-08
- E19: 정규 MLIR pass 2단계(`docs/EVIDENCE_v0.14_E19.md`) — E18의 구조적 추출기
  (`harness/mlir_alloc_walk.py`)를 `harness/make_contract.py`에 **필수 크로스체크**로 결선.
  대체가 아니라 상호 검증: 정규식 파서와 구조적 추출기가 같은 layout IR을 각각 읽고, 다섯 항목
  (inputs/outputs/transient_slabs 원소별, constants 합계, entry_found, unresolved 존재)이
  불일치하거나 구조적 추출기가 파싱에 실패하면 계약을 **거부**(`--allow-structural-mismatch`로만
  우회, D13과 같은 hard_fail_errors/raise 경로). `iree.compiler.ir`가 설치되지 않은 환경에서는
  하드 실패가 아니라 스킵(기록만, E15 이전 기준선으로 안전하게 저하) — 확인됨(§4).
- 검증: 14개 보관 계약을 **실제 프로덕션 경로**(서브프로세스로 `make_contract.py` 재실행)로
  재생성해 수치 diff 0 + 신규 필드 `provenance.structural_walker` 14/14
  `available=True, agrees_with_regex_parser=True` 확인(E18은 구조적 추출기를 직접 호출했을 뿐
  `make_contract.py`를 거치지 않았음 — 이번이 처음으로 프로덕션 경로 자체를 검증). 하드 실패
  배선은 in-process monkeypatch로 불일치·파싱예외 두 조건 모두 실제 `SystemExit` 확인.
  `harness/contract_negative_tests.py` 66/66 → **85/85**.
- CLAUDE.md 우선순위 3번의 미해결 평가지표("컴파일러 버전 변경 시 명시적 실패")에 실제 강제
  지점을 마련(다른 IREE 버전으로의 실제 재확인은 여전히 범위 밖).

## [v0.13] 2026-09-08
- E18: 정규 MLIR pass 1단계(`docs/EVIDENCE_v0.13_E18.md`) — `harness/mlir_alloc_walk.py` 신설.
  `static_mem_bound.py::parse_alloc_ir`가 하던 일(entry 함수의 입출력·transient·module 상주 상수
  크기 추출)을 정규식이 아니라 IREE의 실제 MLIR Python API(`iree.compiler.ir`)로 재구현.
- 기술적 장벽 해소: `--mlir-print-ir-after`가 함수별로 조각내 출력하는 문제(entry 함수 청크가
  다른 청크의 `util.initializer`가 정의하는 전역을 참조해 단독으로는 파싱 불가) — `util.global.load`
  /`store` 줄에서만 이름·타입을 모아 선언을 합성하는 좁은 전처리로 해결. 이 한 단계만 텍스트
  처리이고, 그 이후 모든 크기 추출은 `Operation.walk()`의 진짜 `op.name`과 `Value.owner`를 통한
  define-use 체인 추적(→ `arith.constant`)으로 이뤄진다 — 인쇄된 텍스트의 `{%c8}`을 읽지 않는다.
- 검증: 보관된 v0.9의 14개 `layout_ir`(재컴파일 없음, one-invocation 규칙 유지) 전부에서 구조적
  추출기와 기존 정규식 파서의 값이 일치(inputs/outputs/transient 원소별, constants 합계,
  entry_found, unresolved 존재 여부). 미인식 op 음성 시험은 텍스트를 손으로 바꾸는 대신 **실제
  화이트리스트를 좁혀서**(D13의 진짜 시나리오에 더 가까움) 재확인. `harness/contract_negative_tests.py`
  가 51/51 → **66/66**으로 확장.
- 범위 밖(명시): `make_contract.py` 파이프라인으로의 통합, `stream.resource.pack` 실사용 시험(현재
  모델 어느 것도 안 씀), 다른 IREE 컴파일러 버전에서의 재확인.

## [v0.12] 2026-09-08
- E17: AArch64 게스트 재현(`docs/EVIDENCE_v0.12_E17.md`) — 이 세션에서 AArch64 크로스 툴체인·IREE
  런타임 크로스 빌드·qemu-system-aarch64 게스트를 처음부터 재구축(정상 부팅, 크래시 재발 없음).
- **A5b 최초 실행**(D11 실제 해소): `.vmfb`(ZIP 컨테이너)의 `module.fb` FlatBuffer 자신의
  root-table uoffset(첫 4바이트)을 구조적으로 손상시키고(임의 bit flip이 아님), 손상된 파일의
  sha256/bytes로 계약을 갱신해 binding이 MATCH되도록 구성 — native x86-64·cFS x86-64·**cFS
  AArch64 게스트** 세 레벨 전부에서 admission ADMIT → binding MATCH →
  `runtime_load_failed`(IREE FlatBuffer 검증기가 안전하게 거부) → `cleanup_calls:1` → cFS
  OPERATIONAL 유지를 확인. 크래시 지표 0. 이 연구가 v0.9에서 "실행 근거 없이 확인했다고 서술"한
  것으로 정정했던 항목을 실제 실행 증거로 채운다.
- mlp16k·multibranch의 A2 경계값(B−1/B/B+1)을 native(양쪽 모델)와 cFS(mlp16k)에서 확인(6+3건 전부
  정확) — conv2d는 v0.9에서 이미 확인됨. 세 정적 모델 모두 native 레벨 완료.
- A7을 재시작 2회+DELETE로 확장(v0.9는 재시작 1회에 그침): x86-64 native_std와 AArch64 게스트
  양쪽에서 `cfs_cmd.py`로 ES 명령 전송 → `init_count` 3, `cleanup_calls` 3, 이중 해제 없음, DELETE
  후에도 cFS core 생존 확인. ES 명령 기반 정상 종료 경로를 사용했으므로 v0.9 §11.2가 남긴 "정상
  종료 시 자원 회수 미검증" 문제도 함께 해소(SIGINT 강제 종료가 아닌 경로에서 cleanup이 매번 정확히
  1회 호출됨을 확인).
- E16(v0.11)의 신규 게이트(스택 실거부·blob 크기 선검사)를 AArch64 게스트에서도 재확인 — x86-64와
  동일한 패턴(EVS 이벤트·JSON 필드 일치).
- 범위 밖(명시): multibranch cFS 레벨 A2, dynamic 모델의 게스트 재현, 정규 MLIR/IREE pass, 동일
  경계 대안 비교, 다중 앱 동시 admission, 시간 축 계약, RTEMS 단계는 여전히 미착수.

## [v0.11] 2026-09-08
- E16: C 게이트 보강(`docs/EVIDENCE_v0.11_E16.md`) — 환경(cFS native_std, IREE C 런타임 x86-64)을
  이 세션에서 재구축해 실제 `core-cpu1` + `AI_LEARNER`로 검증.
- D15 조치: `ai_learner.c`의 스택 확인을 `AI_LEARNER_Init()` 최선두로 이동하고, `accounted=false`
  에서 초기화를 실제로 거부하는 분기(`EID_STACK_REJECT`)를 신설. 이전엔 확인이 IREE 세션·입력버퍼·
  SB 파이프 생성 뒤에서 텔레메트리로만 기록됐다. 배포된 startup script의 스택 값만 인위적으로 줄여
  실제 cFS 기동에서 거부(admission/binding 단계 도달 안 함, EVS CRITICAL, cleanup_calls:1, cFS core는
  OPERATIONAL 유지)를 확인.
- R8 조치: `ai_learner.c`/`native_learner.c` 모두 `malloc` 전에 파일 크기를 `contract.artifact.bytes`와
  비교하도록 수정 — 크기가 다르면 해시 계산·할당 없이 즉시 `CONTRACT_ARTIFACT_MISMATCH`. 크기가 같은
  경우의 기존 해시 비교 경로는 변경 없음(모델 교체 시나리오로 양쪽 다 검증).
- 두 실행기에 인터페이스(단일 f32 입력·출력) defense-in-depth 게이트 추가(신규 종료 코드/이벤트) —
  E15의 `gen_contract_header.py` 검증을 우회한 손편집 헤더에 대한 마지막 방어선.
- 부수 발견·수정: `scripts/50_wire_cfs_ai_learner.sh`가 `WIRING.md`가 명시한 "stack = base + kernel"
  규칙을 따르지 않고 시작 스크립트 스택을 항상 262144로 하드코딩하던 버그. D15의 실제 거부 gate를
  x86-64에 적용하자마자 non-zero kernel stack을 가진 모델(예: mlp16k, kernel=16 B)에서 상시 거부로
  드러났다 — `scripts/51_build_cfs_aarch64.sh`와 동일한 계산으로 수정.
- 범위 밖(명시): AArch64 게스트 재구축·재현(A2 경계값 전 모델·A5b 구조 손상·재시작 2회+DELETE·정상
  종료 cleanup 확인)은 이번에도 하지 않음 — 다음 우선순위로 유지.

## [v0.10] 2026-09-08
- E15: 계약 도구 fail-closed 전환 + 음성 시험(`docs/EVIDENCE_v0.10_E15.md`). v0.9.1이 정정으로 남긴
  D12·D13·D14를 실제로 수정.
- `harness/static_mem_bound.py::parse_alloc_ir`: 정규식이 한 줄(`[^\n]*`)로 한정돼 있어 MLIR이 연산을
  여러 줄로 출력하면 크기를 조용히 누락하던 결함(직접 재현으로 확인)을 경계 있는 non-greedy 패턴으로
  수정. entry 함수 본문의 자원 op를 화이트리스트와 대조해 미인식 op를 `unresolved`로 승격(이전엔 무시).
  독립 실행 경로의 `all_static`에 `entry_found` 누락도 수정(D12).
- `harness/make_contract.py`: one-invocation 검사에 layout IR을 결합(D14) — layout IR이 참조하는
  dispatch 심볼이 `--dump-dir`에 실제 파일로 있는지 확인, 없으면 거부. ABI 불일치·target triple
  불일치·ELF 분석 대상 불일치를 note에서 hard fail로 승격(각각 `--allow-*` 플래그로만 우회 가능).
  스키마 검증을 파일 기록 전으로 이동, `jsonschema` 부재 시 이제 실패(이전엔 조용히 건너뜀).
- `harness/gen_contract_header.py`: `bound_method` 화이트리스트, `bounded_bytes` 비음수 검사,
  bound-known 계약의 커널 스택 필드 필수화(`--allow-unknown-stack`로만 우회), 입출력 개수·dtype이
  native/cFS C 런타임이 하드코딩한 단일 f32 입출력과 다르면 거부, sha256 hex 검증 강화.
- 신규 `harness/contract_negative_tests.py`: 위 변경들이 실제로 "거부돼야 할 입력을 거부하는지" 확인하는
  음성 시험(20건) + 단위 시험(5건) + 회귀 시험(26건) = **51/51 PASS**.
- 회귀 확인: 보관된 v0.9의 14개 계약(mlp16k·mlp16k_swap·conv2d·conv2d_swap·multibranch·
  multibranch_swap·dynamic × aarch64/x86_64)을 원본 layout IR·dump-dir·ELF 분석에서 fail-closed
  도구로 재생성 — **14/14 계약·14/14 헤더 값 완전 불변**(diff 0). 이번 전환이 기존 유효 입력의
  결과를 바꾸지 않았음을 증명.
- 범위 밖(명시): C 게이트 자체(스택 미달 거부 분기, blob 할당 전 크기 선검사, 입출력 개수 런타임
  gate)는 x86-64/cFS 환경 재구축이 필요해 이번 실험에 포함하지 않음(EVIDENCE_v0.10 §5, EVIDENCE_v0.9
  §11.9 Phase 3). 정규 MLIR/IREE pass, AArch64 게스트 재현(A5b 등)도 마찬가지로 범위 밖.

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
