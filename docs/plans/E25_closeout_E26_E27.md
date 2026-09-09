# 계획: E25 주장 범위 정정 → E25b(판정 도구 일치) → E26(계약 경계 유용성) → E27(MLIR 고유 기여)

> 작성: 2026-09-09, 기준 커밋 `44c27ac` (E25 완결, PR #1, CI green)
> 입력: 일곱 번째 외부 검토 `docs/reviews/REVIEW_v0_22_E25.md` (원문 보존)
> 성격: **계획서다. 이 문서를 만든 세션은 아무것도 실행하지 않았다.** 아래의 "확인된 사실" 표는
> 저장소를 **읽기만** 해서 검토의 주장을 대조한 결과이고, 그 이후는 후속 세션이 수행할 작업 순서다.
> 범위: **연구·실험 구현 흐름만.** 보안·threat model·서명·공급망 항목은 이 계획에 없고, 후속 세션도
> 등록하지 않는다(`docs/ASSUMPTIONS_AND_SCOPE.md`, 검토 §7).

---

## 0. 한 줄 요약

검토는 E25를 "실질적 연구 진전"으로 인정하면서 **주장 범위 4곳의 과대 서술**과 **판정 도구 1곳의
계획 불일치**를 지적했고, 저장소 대조 결과 **전부 사실**이다(§1). 필요한 것은 짧은 정정(Phase A),
이미 정해둔 비교 조건의 구현(Phase B), 그리고 **사전 고정 기준을 먼저 커밋한 뒤** E26 측정(Phase C),
E27 개요(Phase D)다. 방어 조건 추가는 없다.

---

## 1. 검토 주장 대조 — 저장소 읽기로 확인된 사실

| # | 검토의 지적 | 대조 결과 | 근거(파일:행) |
|---|---|---|---|
| 1 | "256/256 원소"는 집계 오기. 경로당 128, 네 경로 512 | **사실** | `build/comparison_all.json`: 4경로 × (telemetry 64 + normalized 64) = 512. 오기 4곳: `docs/EVIDENCE_v0.22_E25.md:23`, `CHANGELOG.md:8`, `CLAUDE.md:268`, `EXPERIMENT_LOG.md:11` |
| 2 | "두 ISA가 같은 누산 순서를 만들었다"는 출력만으로 단정 불가 | **사실(과잉 추론)** | `docs/EVIDENCE_v0.22_E25.md:118` "두 ISA의 코드생성이 같은 누산 순서를 만들어 비트까지 같았다", `CHANGELOG.md:16` 동일 문장. 누산 순서는 관측하지 않았다(ELF 대조 없음) |
| 3 | E25가 E14의 `both_sound: null` 갭을 해소했다는 서술은 오귀속 | **사실** | `harness/cross_target_compare.py:201` — `both_sound`는 각 타깃 실행 summary의 `peak_within_bounded`(메모리) 종합값. E25는 메모리 계측을 산출하지 않았다(cFS E25 로그의 stage는 `stack/admission/binding/e25_equivalence`뿐, `mem` 없음). 오귀속 4곳: `EVIDENCE_v0.22:142-146(§6.4)`, `EVIDENCE_v0.22:171`(§8 "E14의 미확인 cross-target 출력 비교 보완"은 정확하나 §6.4 제목이 "갭 해소"), `CHANGELOG.md:28`, `CLAUDE.md:273`, `EXPERIMENT_LOG.md:11` |
| 4 | "OnAIR-IREE"는 IREE Python 바인딩 실행이지 OnAIR 플러그인·SB 흐름이 아님 | **사실** | `plugins/compiled_learner/compiled_learner_plugin.py:118-138`은 여전히 `weights.npz`를 읽어 `self._fn(self._x, *self._weights)`로 호출. E25의 `out_ireepy.npy`는 baked vmfb를 `iree.runtime`으로 직접 호출한 것. cFS E25 모드는 SB 수신·feature 변환을 거치지 않음(`ai_learner.c:326-372`). 명칭 사용처: `EVIDENCE_v0.22:18`, `CLAUDE.md:267,353`, `EXPERIMENT_LOG.md:11`, `results/e25_equivalence/README.md:10,20` |
| 5 | README 등 문서가 E25 완료 현황과 어긋남 | **사실** | `results/e25_equivalence/README.md:1` "(진행 중)", `:13` "cFS AArch64 게스트 ⏳ 미실행", `:20` "세 경로" — 실제로는 네 경로 완료. 최상위 `README.md:7` "현재 버전: v0.21"(E25 링크 없음). `aarch64_env/BOOT_LOG.md`는 시도 1만 기록(시도 2 emergency, 시도 3 성공·디스크 수정은 EVIDENCE §7에만 있고 원시 로그 `boot_attempt3_serial.log`는 있음, 시도 2 로그는 `/tmp/e25/boot2.log`에만 존재) |
| 6 | `e25_compare.py`가 모든 IREE 쌍에 비트 동일을 요구 — 다른 모델의 cross-ISA 결과가 tolerance 이내·비트 상이일 때 거짓 FAIL | **사실** | `harness/e25_compare.py:91-100` — 쌍마다 vmfb 구분 없이 `if not same: report["pass"] = False`. 계획 `docs/plans/E25_same_model_equivalence.md` §3.2·§3.3-5는 cross-ISA 쌍을 tolerance로 판정하도록 **이미** 정해 두었다. 이번 데이터는 강한 조건도 만족해 PASS는 유효 |
| 7 | E26 측정 전 E25 모드를 꺼야 함(초기화 중 64회 추론이 peak를 오염) | **사실, 양쪽 C 경로 모두** | cFS: `ai_learner.c:326-372` E25 블록이 `rss_kb_init1` 직후·RunLoop 이전에 실행되고 HAL 통계는 `:437,:447`(추론 5회마다)에서만 조회 → E25 모드가 켜지면 첫 `mem` 레코드가 이미 64회 추론 뒤. native: `native_learner.c:220-274` E25 블록이 `st_warm`(`:290`)·최종 통계(`:312`)보다 앞 |
| 8 | 계약값 ISA 동일(786476/65580/720896)은 이 구성의 관측이지 일반 증명이 아님 | **사실** | E14 4모델도 `identical_bounded_bytes: true`이나 4개 모델·1개 컴파일러 버전이다 |

**검토가 요구하지 않았지만 대조 중 확인된 것(E26 설계에 직접 쓰임)**: E14의 conv2d "native 1,352"는
**qemu-user(aarch64)에서 같은 aarch64 vmfb**를 실행한 값이다(`results/e14_aarch64_qemu/native/summary.json`
`execution`). 즉 게스트 cFS의 3,528과의 차이는 vmfb 차이가 아니라 **실행 경로(정적 링크 native_learner
vs cFS `.so`)·계측 시점의 차이**다. mlp16k(786,476)·multibranch(38,216)는 두 경로에서 같다 — conv2d만
다르다.

---

## 2. 공통 규율 (후속 세션이 지킬 것)

1. **실험 1건 = 커밋 1건**, 메시지에 ID·핵심 수치. 버전: Phase A+B = **v0.22.1**(정정 + E25b),
   Phase C = **v0.23/E26**, Phase D = **v0.24/E27**.
2. **EVIDENCE 본문은 고쳐쓰지 않는다** — `docs/EVIDENCE_v0.22_E25.md`에는 **§11 정오표**를 덧붙인다.
   살아있는 문서(`CLAUDE.md`, `CHANGELOG.md`, `EXPERIMENT_LOG.md`, `README.md`, `results/*/README.md`)는
   직접 고친다. 판정은 철회가 아니라 정정으로 남긴다(`EXPERIMENT_LOG.md` 세 표).
3. **사전 고정 기준을 결과보다 먼저 커밋한다**(E26 §C-2, E27 §D). 결과를 본 뒤 기준을 바꾸지 않는다.
4. **CI 수치는 CI가 잰 값만 적는다**(D34). 컨테이너 수치와 조건을 병기한다.
5. **재컴파일 금지**: E14·E25의 vmfb·계약·헤더는 보관본을 그대로 쓴다(one-invocation, 작업 규율 7).
   E26에서 새 컴파일이 필요한 경우(E26c 다른 IREE 버전)는 **별도 디렉터리에 새 invocation 전체**를 보관한다.
6. **타이밍 값은 인용하지 않는다**(작업 규율 4). HAL 통계·해시·계약 수치는 결정론적이므로 인용 가능.
   게스트 RSS는 §9(E14)대로 증거가 아니며 "표시용"으로만 병기한다.
7. **보안·threat-model·서명·공급망·"수동 위조" 항목은 등록하지 않는다.** 방어 조건은 실제 재현된
   결함이 나올 때만, 그것도 실험 1건으로 처리한다.
8. **데이터 이력**: 기존 결과 파일(`comparison_all.json`, E14 summary 등)을 덮어쓰지 않는다. 새 도구가
   만든 결과는 **새 파일명**으로 옆에 둔다.
9. 게스트 VM·빌드 트리는 컨테이너 밖 산출물이라 세션이 바뀌면 사라질 수 있다(§6 환경 인수인계).

---

## 3. Phase A — E25 주장 범위 정정 (docs-only, 커밋 1, v0.22.1)

**커밋 메시지 예**: `정정(v0.22.1): E25 주장 범위 — 512 원소·both_sound 분리·IREE Python 바인딩 명칭·README 동기화·BOOT_LOG 완결`

### A-1. `docs/EVIDENCE_v0.22_E25.md` — **§11 정오표 신설**(본문 무수정)

| 항목 | 원문 위치 | 정정 내용 |
|---|---|---|
| (a) 원소 수 | `:23` | "네 경로 × 2 regime = 256/256" → **경로당 128(64 입력 × 2 출력), 네 경로 합계 512/512**. PASS 판정 불변 |
| (b) 누산 순서 | `:118` | "두 ISA의 코드생성이 같은 누산 순서를 만들어 비트까지 같았다" → **관측된 것은 출력의 비트 동일뿐**이다. 누산 순서가 같다는 것은 출력만으로 결론 내릴 수 없는 설명 가설이며, 확인하려면 두 ELF의 dispatch 코드 대조(E27 후보)가 필요하다 |
| (c) `both_sound` | `:142-146(§6.4)` | §6.4 제목·본문 정정: E25가 채운 것은 **`out0_agreement`(출력 대조)의 자리를 canonical 모델에 한해** 채운 것이다. `both_sound`는 `cross_target_compare.py:201`이 정의하듯 두 타깃 실행의 `peak_within_bounded` 종합값(메모리)이며, E25는 메모리 계측을 산출하지 않았으므로 **여전히 null이고 E26 대상**이다. E14 4모델의 출력 대조도 canonical 모델 결과로 대체되지 않는다 |
| (d) 경로 명칭 | `:18`, §8 | "OnAIR-IREE" → **"IREE Python 바인딩(pip `iree-base-runtime`) 직접 호출"**. OnAIR `CompiledLearner` 플러그인(`weights.npz` 인수 경로)과 OnAIR 프레임워크 데이터 흐름, cFS SB 수신·feature 변환은 E25에 포함되지 않는다. E25가 입증한 것은 **"canonical 모델의 계산 결과 동치 + cFS 앱 내부 추론 경로(계약·binding 통과 후 파일 입력) 통합"**이다 |
| (e) 완료 범위 문장 | §0, §8 | 검토 §3의 문장을 정본으로 채택: *"고정한 canonical 모델과 64개 입력에 대해 IREE Python, native C, cFS x86-64 및 cFS AArch64의 계산 결과가 사전 허용 오차 내에서 reference와 일치했다. 네 IREE 실행 경로 사이에서는 비트 동일도 관측됐다."* 적용 범위: 해당 모델·입력 집합·컴파일러 버전·타깃 설정 |
| (f) 계약값 ISA 동일 | §6.2 | "계약은 ISA 독립" 제목에 **"이 구성에서"**를 붙인다(일반 증명 아님, 검토 §4.2) |

### A-2. 살아있는 문서 직접 정정

| 파일 | 행 | 변경 |
|---|---|---|
| `CLAUDE.md` | `:267` | "OnAIR-IREE" → "IREE Python 바인딩" |
| `CLAUDE.md` | `:268` | "256/256" → "512/512(경로당 128)" |
| `CLAUDE.md` | `:273` | "E14가 남긴 cross-target `both_sound: null` 갭도 해소" → "E14 `out0_agreement`의 자리를 canonical 모델에 한해 출력 대조로 채움. **`both_sound`(메모리 soundness)는 E25 범위 밖, E26 대상**" |
| `CLAUDE.md` | `:270-271` | "누산 순서" 서술이 있으면 (b)와 같이 완화(현재 이 단락엔 없음 — 확인만) |
| `CLAUDE.md` | R-1 블록 `:342-357` | 상태를 "**완결(E25, v0.22)**"로 표시하고, 잔여를 명시: (i) `CompiledLearner` 플러그인의 baked-vmfb 전환·SB 흐름 end-to-end는 **범위 밖(후속)** — 검토 §4.1은 "현재 목표를 위해 확대 불필요"로 판단, (ii) `harness/corrupt_vmfb.py`로 AArch64 게스트 A5b raw log 재생성(R-1 할 일 (5))은 **미수행** — E26 게스트 세션에서 A5b_canonical 1건으로 처리(§C-4) |
| `CLAUDE.md` | 버전 줄 `:11` | v0.22 → **v0.22.1** ; v0.22 단락 끝에 "v0.22.1 정정" 한 단락 추가(검토 요지 + 정정 5건 + E25b) |
| `CLAUDE.md` | 저장소 지도 | `docs/reviews/REVIEW_v0_22_E25.md`, `docs/plans/E25_closeout_E26_E27.md`, `docs/EVIDENCE_v0.22_E25.md`(§11 정오표 표시) 추가 |
| `CHANGELOG.md` | 상단 | **`## [v0.22.1] — 정정: E25 주장 범위 (외부 검토 v0.22) + E25b`** 신설. "정정:" 접두어로 (a)~(f) 요약. 기존 `[v0.22]` 본문(`:8`, `:16`, `:28`)은 **그대로 두고** 그 위 `[v0.22.1]`에서 정정한다(CHANGELOG는 이력이므로 원문 유지) |
| `EXPERIMENT_LOG.md` | `:11` E25 행 | 레지스트리 행은 현재 상태를 말하므로 직접 정정: 256→512, "OnAIR-IREE"→"IREE Python 바인딩", "`both_sound: null` 갭 해소" 문구 삭제 후 "`out0_agreement` 자리를 canonical에 한해 채움; `both_sound`는 E26" |
| `EXPERIMENT_LOG.md` | 반증된 주장 이력 | 행 추가: `"E25가 E14의 both_sound: null 갭을 해소했다"` \| EVIDENCE_v0.22 §6.4·CHANGELOG·CLAUDE.md \| 외부 검토(REVIEW_v0_22_E25 §4.2): `both_sound`는 `peak_within_bounded` 종합값(`cross_target_compare.py:201`), 출력 대조로 채울 수 없음 \| v0.22.1 |
| `EXPERIMENT_LOG.md` | 방법론 결함 이력 | **D45** 추가: *서로 다른 관측(출력 동치 vs 메모리 soundness)을 같은 지표(`both_sound`)에 귀속* — "계산값과 관측값이 일치했다"가 "다른 종류의 관측까지 닫혔다"로 번지는 형태(CLAUDE.md "가장 중요한 교훈"의 변종). 원인: E25 마무리 시 `cross_target_compare.py`의 정의를 다시 읽지 않고 E14 §11.4의 "실행 대조 아님"이라는 요약만 기억해 채웠다. 조치: 정오표 + E26에서 `--native-summaries`로 실제 채움. 256/256·누산 순서는 표현 오류라 D 번호 없이 정오표 (a)(b)로만 처리 |
| `README.md` | `:7` | "현재 버전: v0.21" → **v0.22.1**, 최신 근거를 `docs/EVIDENCE_v0.22_E25.md`(**§11 정오표 필수 확인**)로, E24c는 "이전 근거"로 밀기 |
| `results/e25_equivalence/README.md` | 전체 | "(진행 중)" 제거. 표에 cFS AArch64 게스트 ✅(`out_cfs_aarch64.bin`, run2), 판정 절을 `comparison_all.json` 기준 네 경로·6쌍·512/512로, "OnAIR-IREE 엔진" → "IREE Python 바인딩", 재현 절에 AArch64 줄 추가(EVIDENCE §9와 동일) |
| `results/e25_equivalence/aarch64_env/BOOT_LOG.md` | 말미 | **시도 2**(emergency mode 재발, 시각, 조치 결정), **디스크 수정**(qcow2→raw 변환, `losetup -o 1074790400`로 루트 loop 마운트, blkid로 label 존재 확인, fstab 두 항목 `nofail`, `/etc/cloud/cloud-init.disabled`, ssh 키·host key 존재 확인 후 적용, 백업 `aarch64-linux.qcow2.bak`), **시도 3**(emergency 0건, SSH 배너 지연은 1 vCPU 부하) 추가. 원시 로그: `/tmp/e25/boot2.log`가 시도 2의 시리얼 로그인지 **내용을 열어 확인한 뒤** `boot_attempt2_serial.log`로 복사(아니면 "시도 2 시리얼 로그 미보존"으로 기록). 이 디스크 수정은 저장소 밖(게스트 이미지)에 있으므로 컨테이너 재생성 시 다시 해야 한다는 주의 문구 |
| `docs/reviews/REVIEW_v0_22_E25.md` | 신규 | 검토 원문 그대로(이 계획 커밋에 이미 포함) |

`PROGRESS.md`는 v0.4 이후 `REPORT_v0.4.md` 포인터로 유지돼 왔다(마지막 수정 커밋 `811ea84`) — 관례대로 손대지 않는다.

### A-3. 검증

- `grep -rn "256/256\|both_sound.*해소\|OnAIR-IREE" --include=*.md . | grep -v docs/reviews` 가 **정오표·CHANGELOG 원문 인용 외에 0건**.
- `python3 harness/contract_negative_tests.py` 무변화(191/191 이 컨테이너, 코드 변경 없음이므로 생략 가능).

---

## 4. Phase B — E25b: `e25_compare.py`를 계획 §3.2와 일치 (코드 + 회귀, 커밋 2, v0.22.1)

**커밋 메시지 예**: `E25b: e25_compare.py 쌍별 판정 규칙(동일 vmfb=비트 동일 / cross-vmfb=사전 tolerance) + 회귀 7건 + 보관 출력 재판정 PASS 불변`

검토 §5 표현 그대로: **기준 완화가 아니라 이미 정한 비교 조건의 구현**이다. 현재 코드는 계획보다
강한 조건이므로 이번 데이터의 PASS는 유효하고, 고친 뒤에도 같은 데이터에서 같은 판정이 나와야 한다.

### B-1. 설계

```
python3 harness/e25_compare.py --model-dir M --reference ref.npy \
  --path ireepy=out_ireepy.npy   --vmfb ireepy=<64-hex>  \
  --path nativec=out_nativec.bin --vmfb nativec=<64-hex> \
  --path cfs_x86=out_cfs.bin     --vmfb cfs_x86=<64-hex> \
  --path cfs_aarch64=out_cfs_aarch64.bin --vmfb cfs_aarch64=<64-hex> \
  --out comparison_all.pairrule.json
```

- `--vmfb NAME=SHA256`(64 hex 전체, 계약의 `artifact.sha256`) — **모든 `--path`에 필수**. 하나라도 없으면
  분류 불능 → **rc≠0, 출력 파일 미기록**(어느 규칙을 조용히 고르는 것은 fail-open이거나 과잉 거부이므로).
- 쌍 규칙: 같은 sha → `bit-identical` **필수**(현행 유지, 계획 §3.2 "핵심 주장"). 다른 sha →
  원소별 `abs<=1e-4 OR rel<=1e-5` **AND 두 경로 argmax 전 행 일치**; `bit_identical`은 **관측값으로 기록만**.
- reference 대비·argmax 게이트는 현행 그대로.
- 보고서: `criteria.pair_rules = {"same_vmfb":"bit-identical","cross_vmfb":"abs<=1e-4 OR rel<=1e-5 per element, argmax equal"}`,
  쌍마다 `{rule, vmfb_same, bit_identical, passed, elements, abs_max, rel_max, argmax_agree}`.
- 상수(`ABS_TOL`, `REL_TOL`)와 docstring의 "실행 전 고정" 서술 유지. 타임스탬프 없음(결정적 출력).

### B-2. 재판정(데이터 이력 보존)

- 보관 출력으로 새 도구를 실행해 `results/e25_equivalence/build/comparison_all.pairrule.json`을 **새 파일로**
  둔다. `comparison_all.json`은 그대로.
- 확인: `pass=True`, `vs_reference`의 `passed/elements`·`would_pass_*`가 원본과 동일, 6쌍 `bit_identical=True`,
  `cfs_aarch64` 관련 3쌍은 `rule=cross_vmfb`(관측 bit_identical True), 나머지 3쌍 `rule=same_vmfb`.
- vmfb sha 출처: `build/model_canonical.contract.json`(x86, `0e250c2f…`)·`aarch64/*.contract.json`(`4e5b2972…`).

### B-3. 회귀 시험 — `harness/contract_negative_tests.py`에 `e25_compare_rule_cases()` 추가

`numpy` 부재 시 `Result.skip`(stdlib-only CI 레그가 크래시 없이 SKIP). `main()`의 등록 목록에 추가.

| # | 입력 | 기대 |
|---|---|---|
| 1 | 보관 E25 출력 + 올바른 vmfb 매핑 | rc 0, PASS, 원본 `comparison_all.json`과 `passed/elements`·6쌍 bit_identical 동일 |
| 2 | `cfs_aarch64` 한 원소를 `np.nextafter`로 1 ulp 이동(다른 vmfb 선언) | **PASS**, 해당 3쌍 `rule=cross_vmfb`, `bit_identical=False`. **revert-and-confirm-fail**: 수정 전 코드에서는 FAIL이었음을 시험 자체가 기록(과잉 거부 재현) |
| 3 | 같은 1 ulp 이동을 **같은 vmfb**로 선언 | FAIL(비트 동일 요구 유지) |
| 4 | cross-vmfb 한 원소 ×(1+1e-3) | FAIL(tolerance 초과) |
| 5 | reference 행 `[1.0, 1.0+1e-7]`, 경로 `[1.0+1e-7, 1.0]` | FAIL(abs는 통과하지만 argmax 불일치) |
| 6 | 한 경로에 `--vmfb` 누락 | rc≠0, 출력 파일 없음 |
| 7 | 같은 입력 2회 실행 | JSON 바이트 동일(결정성) |

기대 수치: 이 컨테이너 191/191 → **198/198**(numpy 있음). CI 세 레그 수치는 **CI가 잰 뒤에** 적는다
(`stdlib-only`·`without-iree` 레그는 numpy 유무에 따라 SKIP이 늘 수 있다 — 추정 금지).

### B-4. 문서

- `docs/EVIDENCE_v0.22_E25.md` §11 정오표에 (g) E25b 항목 1단락(도구 불일치 사실 + 수정 + 재판정 불변).
- `EXPERIMENT_LOG.md` E25b 행(결정론적, 산출물, "보관 출력 재판정 PASS 불변, 과잉 거부 1건 재현·수정"),
  `CHANGELOG.md [v0.22.1]`에 E25b 항목, `CLAUDE.md` 저장소 지도 `e25_compare.py` 설명 갱신.

---

## 5. Phase C — E26: 부분 메모리 계약 경계의 유용성 (v0.23)

검토 §6의 세 질문을 그대로 채택한다. **측정 전에 기준을 커밋한다.**

### C-1. 연구 질문과 사전 고정 기준

| 질문 | 지표 | 사전 고정 판정 |
|---|---|---|
| Q1 상한의 타당성 | 셀(모델×경로)마다 `hal_peak_steady ≤ bounded_bytes` | 하나라도 초과 → 그 셀 **FAIL**, 결함 원장 등록. 사후 완화 없음 |
| Q2 상한의 보수성 | `slack = bounded − hal_peak_steady`; `Δ = hal_peak_steady − static_per_call_bytes`를 `module_resident_constant_bytes`와 대조해 분류: **C**(Δ≈constants, 상수가 HAL에 잡힘) / **Z**(Δ≈0, 상수가 HAL 밖) / **O**(그 외) | 판정 없음(보고). 단 **conv2d의 qemu-user Z vs 게스트 C 불일치는 통제 시험(C-5)으로 원인을 밝히거나 "미확정"으로 명시** — 그럴듯한 설명을 실측 없이 원인으로 적지 않는다(D2·D3 교훈) |
| Q3 판정의 유용성 | (i) 예산 `B ∈ {bounded−1, bounded, bounded+1}` sweep에서 verdict와 실측 peak: **ADMIT인데 `peak > budget`인 셀 = unsafe admit = FAIL**; (ii) 과보수 거부대역 폭 = `slack`(peak ≤ budget < bounded 구간); (iii) **계약 커버리지** = `bounded / (앱 전체 메모리 증가분)` — 부분 계약이 앱 메모리의 어느 비율을 지배하는지 | (i)는 0건이어야 PASS. (ii)(iii)는 보고. (iii)의 분모는 RSS이므로 **x86-64 host 값만 근거**로 쓰고 게스트 값은 표시용(작업 규율 4·E14 §9) |
| 귀속 분리 | 버킷: ① 계약 영역(HAL: per_call + constants) ② IREE 런타임 컨텍스트(instance/device/session) ③ 모듈 로드 ④ 래퍼/앱(입력 버퍼·feat 배열·파이프) ⑤ OSAL/cFS 기저(앱 Init 이전 프로세스 RSS) | 보고. ②③④⑤는 계약 밖이며 "고정 오버헤드 버킷"으로 다룰 수 있는지(모델 간 분산이 작은지)를 **x86-64 3회 반복의 범위**로 판단 |

시간 축은 다루지 않는다(R-5). 다중 앱은 다루지 않는다(R-4).

### C-2. 측정 매트릭스

- **모델 3**: canonical(=mlp16k 계약값, E25 산출물), conv2d, multibranch — 전부 **보관 vmfb·계약·헤더**
  (`results/e14_aarch64_qemu/{x86_64,aarch64}/`, `results/e25_equivalence/{build,aarch64}/`). `dynamic`은
  UNKNOWN_BOUND라 제외(A8은 이미 확인됨).
- **경로 4**: native x86-64 host / native AArch64 qemu-user / cFS x86-64(`core-cpu1`) / cFS AArch64 게스트.
- **구간 3**: `after_load`(모듈 로드·입력 버퍼 할당 직후, 추론 0회) / `after_first_call` / `steady`
  (native 400회, cFS ≥30회 — E14 A6 기준).
- **반복**: HAL 통계는 결정론적이므로 1회 + 결정성 확인용 1회(동일해야 함). RSS는 x86-64에서 3회.
- **예산 sweep**(Q3-i): 3모델 × {native x86-64, cFS x86-64, cFS AArch64} × {B−1, B, B+1}. E14/E17이 한 것
  (conv2d native, mlp16k cFS)은 재실행하지 않고 인용, 나머지 셀만 채운다.

### C-3. 필수 선행 — E25 모드 위생과 계측 지점 (코드, 실험 아님, 커밋 1건)

검토 §6 "측정 전 필수 사항". 최소 계측 추가이며 게이트·판정 로직은 건드리지 않는다.

1. **E25 모드 부재를 로그로 증명**: `ai_learner.c` E25 블록에서 파일이 **없을 때** 한 줄
   `{"stage":"e25_mode","active":false}`를 남긴다(있을 때는 기존 `e25_equivalence` 레코드). 하네스
   `e14_cfs_scenarios.py:check_expect`에 `e25_mode_active: false` expect 키를 추가하고 **E26 모든 cFS
   시나리오의 expect에 넣는다**. 실행 전 `cf/e25_inputs.bin` 부재를 스크립트가 `test ! -e`로 확인.
   native는 `argv[4]`를 주지 않으면 되지만 요약 JSON에 `"e25_mode":false`를 함께 찍는다.
2. **cFS `mem_init` 레코드**: Init에서 입력 버퍼 할당 직후·E25 블록 **이전**에
   `{"stage":"mem_init","hal_peak":…,"hal_allocated":…,"process_rss_kb":…}`; 그리고 session 생성 직후
   RSS 프로브 `rss_kb_after_session`(버킷 ② 분리용) 추가해 `init_ok` 이벤트/JSON에 포함.
3. **첫 호출 peak**: 코드 변경 없이 `AI_LEARNER_REPORT_EVERY=1`로 빌드(`scripts/51`의 `REPORT_EVERY`,
   `scripts/50`은 같은 knob 노출 필요 — 없으면 추가)해 `completed=1`의 `mem` 레코드를 얻는다.
4. **native `hal_after_load`·`hal_after_first_call`**: `native_learner.c`에 모듈 로드 직후와 첫 호출 직후
   `iree_hal_allocator_query_statistics` 두 지점 추가, 최종 JSON에 병기(`st_warm` 유지).
5. 시험: `contract_negative_tests.py`에 expect 키 처리 단위 시험 2건(`e25_mode_active` 누락/true → 실패,
   false → 통과). C 빌드는 시험 범위 밖(툴체인 필요) — 컨테이너에서 두 경로 빌드·기동으로 확인.

### C-4. 실행 순서와 커밋

1. `E26 계획: 사전 고정 기준` — `docs/plans/E26_boundary_utility.md`(§C-1·C-2 그대로, 결과 없음) **먼저 커밋**.
2. `E26: 계측 지점(mem_init/after_first_call/after_session) + E25 모드 부재 기록·expect` (§C-3).
3. `E26: x86-64 native + cFS 측정` — `results/e26_boundary_utility/x86_64/{native,cfs}/<model>/…`
   원시 로그 + `summary.json`; `harness/e26_collect.py`(로그→표, 결정적)와 `manifest.json`
   (모든 vmfb·계약·헤더 sha256을 E14/E25 보관본에 연결).
4. `E26: AArch64 qemu-user + 게스트 측정` — 같은 레이아웃 `aarch64/`. 게스트 세션 안에서
   **A5b_canonical 1건**(`harness/corrupt_vmfb.py flatbuffer_root_uoffset`, R-1 잔여 (5))도 함께 실행해
   raw log 보존. 부팅 실패는 `results/e26_boundary_utility/aarch64_env/BOOT_LOG.md`에 환경 실패로 분리.
5. `E26: conv2d Δ 불일치 통제 시험` (§C-5).
6. `E26: cross_target_compare --native-summaries로 both_sound 실제 채움` — 3모델 새 comparison JSON을
   `results/e26_boundary_utility/comparison/`에(E14 파일 불변).
7. `E26: EVIDENCE_v0.23_E26 + 원장` — §C-6.

### C-5. conv2d Δ 불일치 통제 시험 (가설은 셋, 각각 **한 변수만** 바꿔 실측)

관측: 같은 aarch64 vmfb에서 qemu-user native peak 1,352(=per_call, 분류 Z) vs 게스트 cFS 3,528
(=per_call+constants, 분류 C). mlp16k·multibranch는 두 경로 모두 C.

| 가설 | 통제 변수 | 기각/채택 관측 |
|---|---|---|
| H-a 계측 시점 | native의 통계 조회 지점(현재 최종 조회는 `:312`, 절대 peak) — `after_load`·`after_first_call` 추가 지점(§C-3-4)에서 conv2d peak가 3,528로 나오면 "시점" 아님이 확정 | 세 지점 모두 1,352면 H-a 기각 |
| H-b 상수 저장 경로 | 두 경로 모두 `malloc+fread`(`native_learner.c:175`, `ai_learner.c:281-282`)이지만 정적 링크 바이너리와 `.so`에서 blob 정렬·IREE의 import 가능 여부가 다를 수 있음. native에서 blob을 64 B 정렬(`aligned_alloc`)/비정렬로 각각 로드해 peak 변화 확인; 반대로 cFS 앱에서 같은 실험 | 정렬만으로 1,352↔3,528이 뒤집히면 H-b 채택 |
| H-c 런타임 빌드 차이 | native(`build-rt-aarch64`, `-static`)와 cFS `.so`가 링크한 런타임 라이브러리 목록·플래그 비교(`scripts/61` vs `scripts/51`); 같은 라이브러리로 native를 `.so` 형태로 빌드하거나 cFS 링크 목록을 native에 적용 | 링크 구성 교체로 값이 따라오면 H-c 채택 |

셋 다 기각되면 **"원인 미확정"**으로 적고 후속 등록한다. 어느 경우든 Q1(soundness)은 두 값 모두
≤ 3,528이므로 영향 없음 — 이 시험은 Q2(보수성 서술의 정확성)를 위한 것이다.

### C-6. 산출물

- `docs/plans/E26_boundary_utility.md`(기준, 결과 전 커밋), `harness/e26_collect.py`,
  `results/e26_boundary_utility/`(원시 로그·summary·manifest·comparison), 코드 계측 2파일.
- `docs/EVIDENCE_v0.23_E26.md`: §0 판정(Q1 셀별 PASS/FAIL, Q3-i unsafe admit 건수), §1 매트릭스와
  보관 아티팩트 연결, §2 Q2 표(slack·Δ 분류), §3 귀속 표(버킷 ①~⑤, x86 3회 범위), §4 conv2d 통제
  시험, §5 `both_sound` 실제 값, §6 환경 실패 분리, §7 주장 가능/불가(전체 OBC 수용성 아님, 수학적
  증명 아님 — "관측에서 초과 없음"과 구분), §8 재현.
- `EXPERIMENT_LOG.md` E26 행, `CHANGELOG.md [v0.23]`, `CLAUDE.md` v0.23 단락 + R-2 상태, `README.md` 버전.

### C-7. E26 확장(선택, 별도 ID — 핵심 E26 완료 후에만)

- **E26b 임무형 경량 모델 1개**(R-2 (4)): 9-feature 텔레메트리 창에 대한 1D conv + dense 이상탐지기
  (`gen_model_*.py` 관례대로 baked, 결정적 seed). 새 할당 구조가 생기므로 계약 생성부터 Q1~Q3 전부 반복.
  검토 §6은 기존 3모델 재사용을 우선하므로 **E26 핵심에 포함하지 않는다.**
- **E26c 다른 IREE 버전**(R-2 (5)): 먼저 `pip download iree-base-compiler==<다른 릴리스>`가 프록시를
  통과하는지 확인. 되면 별도 venv에서 3모델을 **새 invocation으로** 컴파일해 (i) 계약 생성 성공/명시적
  거부(E19 하드 실패 지점 발동 여부), (ii) 수치 변화, (iii) 같은 런타임 커밋과의 vmfb 호환 여부를
  기록. 안 되면 "환경 차단"으로 기록하고 넘어간다.
- ISA 독립/종속 영역 표(R-2 (6)): 새 측정 없이 E14·E25 계약에서 필드별로 정리(bounded/per_call/
  constants = 4모델 동일, kernel stack·ELF 크기·vmfb 바이트 = 종속) — E26 EVIDENCE §2에 표 하나.

---

## 6. Phase D — E27 개요: MLIR 단계 정보의 고유 기여 (v0.24, E26 뒤)

검토 §7: 정규 pass 구현 여부가 아니라 **분석 가능 범위·정확성·보수성·수작업 요구량의 차이**가 핵심.
상세 계획은 E26 결과를 입력으로 E26 뒤에 `docs/plans/E27_mlir_contribution.md`로 쓴다. 지금 고정하는 것:

- **비교 대상 3**: (A) 현행 MLIR post-processing(layout IR + 구조적 크로스체크), (B) LLVM IR/ELF만
  (같은 invocation의 `llvm_ir`·`elf` 덤프 — **재컴파일 없이 보관본으로 가능**), (C) 런타임 계측만
  (HAL 통계, 입력 필요).
- **지표(사전 고정)**: 커버리지(계약 필드 중 도출 가능한 것: per_call transient slab / constants /
  kernel stack / interface shape·dtype), 정확도(HAL 관측 대비), 보수성, 수작업 단계 수·LOC,
  컴파일러 버전 취약성(E26c 데이터), 감사 가능성(아티팩트 결속 가능 여부).
- **예상되는 구조적 결과(가설, 측정으로 확인)**: (B)는 rodata에서 constants와 스택 프레임은 얻지만
  per-call transient slab 크기는 dispatch ELF에 없다(할당은 VM 바이트코드·stream dialect 수준) →
  커버리지 갭; (C)는 입력 의존·실행 필요라 배치 전 판정 불가. 이 갭이 "왜 MLIR 수준인가"의 근거가
  되는지 **실제로 (B)를 구현해** 확인한다.
- 강화안(진짜 PassManager pass)은 E27 결과가 최소안으로 충분하지 않을 때만 착수.
- 부수 후보: E25 정오표 (b)의 누산 순서 질문을 두 ISA dispatch ELF 대조로 실제 확인.

---

## 7. 환경 인수인계 (이 계획을 쓴 시점의 상태 — 다음 세션에서 반드시 재확인)

| 자원 | 상태(2026-09-09) | 없으면 |
|---|---|---|
| `iree-compile` 3.11.0rc20260316 @ `e4a3b04` | 있음 | `scripts/30` |
| IREE C 런타임 x86-64 `~/onair-mlir-bench/ext/iree-src/build-rt` | 있음 | `scripts/40` |
| IREE C 런타임 AArch64 `…/build-rt-aarch64` | 있음 | `scripts/60`+`61` |
| cFS x86-64 `~/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1/core-cpu1` | 있음(현재 헤더는 저장소 기본 `contract_gen.h`, vmfb는 마지막 배선 상태 — **E26 전 모델별 재배선 필요**) | `scripts/00`(mqueue 512 매 세션)+`10`+`50` |
| cFS AArch64 크로스 트리 `~/onair-mlir-bench/ext/cfs-aarch64-exe/{canonical_e25,mlp16k_v11,mlp16k_a5b_aarch64}` | 있음 | `scripts/51` |
| AArch64 게스트 `~/onair-mlir-bench/ext/guest/` (fstab `nofail`·cloud-init 비활성 적용본, 백업 `.bak`) | **부팅 중(pid 1639, SMP=1 MEM=1024)** | `scripts/70`+`71`, 그리고 **BOOT_LOG의 디스크 수정을 다시 적용** |
| OnAIR 클론 `~/onair-mlir-bench/ext/OnAIR` | 있음 | `scripts/20` |
| 스크래치 `/tmp/e25/`(deploy_and_run.sh·rerun.sh·boot2/3.log·cross_build.log) | 있음 | Phase A에서 필요한 로그를 `results/`로 옮긴 뒤엔 불필요 |

컨테이너는 세션마다 새로 시작될 수 있다. **위 표의 "없으면" 열이 곧 재구축 순서**다.

---

## 8. 하지 말 것 (이 계획의 경계)

- 보안·threat model·서명·키·공급망·"수동 위조" 시나리오 등록 — 없음.
- 새 fail-closed 가드 — 실제 재현된 결함이 나올 때만, 실험 1건으로.
- E14·E25 vmfb 재컴파일 — 금지(one-invocation). E26c만 새 invocation을 **통째로** 보관.
- tolerance·기준의 사후 변경 — 금지. 미달이면 실패로 기록하고 원인 분석.
- EVIDENCE 본문 수정 — 정오표 절 추가만.
- CI 수치 추정 — CI 실측 후 기입.
- OnAIR `CompiledLearner` baked 전환·SB end-to-end — 검토 §4.1대로 **범위 밖으로 명시**하고 착수하지 않음
  (R-1 잔여로 기록만).
- R-4(다중 앱)·R-5(시간 축)·R-6(RTEMS) 착수 — E26·E27 뒤.
