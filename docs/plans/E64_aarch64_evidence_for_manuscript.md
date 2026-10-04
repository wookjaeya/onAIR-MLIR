# E64 계획 — 원고가 기대던 범위 밖 근거를 평가 타깃(AArch64) 근거로 교체

**사전 고정 문서다. 측정(편집 프로브 실행·재컴파일·게스트 계산) 전에 커밋한다.**
근거가 된 검토: 원고 v25 사실 검증과 전체 메타리뷰(2026-09-24). 검증에서 원고 문장 셋의 근거가 x86-64 타깃
산출물이라는 것이 드러났고, 연구 책임자 지시상 x86-64는 이 논문의 타깃도 검증 수단도 아니다. 또 한 문장의 보조
기준값은 지상 개발 호스트에서 계산됐다. 이 실험은 그 네 자리를 **AArch64 타깃 산출물과 AArch64 게스트 계산**으로
다시 세우고, 메타리뷰가 새로 요구한 두 사실(DeepAE 이상 점수 영향, 게스트 환경 기록)을 같은 게스트에서 남긴다.

## 0. 착수 전 조사 (실험 아님 — 보관 원자료 판독)

| 원고 위치 | 원고가 기대던 근거 | 문제 |
|---|---|---|
| §III 분석 영역 문단: 전제 위반 편집 시험 | `results/e51_claim_preconditions/stage1_preconditions.json` — `harness/e51_precondition_trace.py`의 `fixture(target="x86_64", model="mlp16k")` | x86-64 합성 모델. 게다가 "미인식 자원 op" 셀(`stream.resource.frobnicate`)은 파싱이 안 되는 op라 거부가 **전용 키가 아니라 두 추출기 불일치**로 났다 |
| 같은 문단: "26개 표현 미분류 0, 14개 명세 재생성" | 저장소 전체 layout IR 26개(그중 15개가 x86-64) + `regression_check`의 E14 합성 14개(x86-64 7개 포함) | 범위 밖 산출물 포함 |
| §III 컴파일러 통계 비교 | 스크래치패드의 x86-64 컴파일(저장소 밖) | x86-64 타깃이고 보관되지 않음. 2026-09-24에 AArch64로 따로 재컴파일해 네 모델 C·T+O 일치를 확인했으나 그 컴파일은 계약과 **다른 호출**이다 |
| §V.G 층별 분석: 순차 단정도 30원소·배정도 19원소 | `results/e60_deepae_layers_aarch64/layers.json` — `e60 … compare`가 **호스트**에서 NumPy로 계산 | 게스트 출력과 비교하는 산술이지만, 원고가 그 계산값을 보고한다 |

또한: 원고 표 4에 게스트 vCPU·메모리·소프트웨어 버전이 없고 저장소에도 게스트 버전 기록이 없다(LiteRT 2.2.0, IREE
Python 3.11.0은 게스트 휠의 사실이나 원자료에 없음). DeepAE 불만족의 결정 수준 영향(이상 점수)은 계산된 적이 없다.

## 1. 질문과 셀

### A. 전제 위반 편집 — 평가 모델(ResNet) AArch64 layout 표현

보관 `results/e36b_aarch64_models/b2_resnet/b2_resnet.layout_ir.txt`를 외과적으로 편집하고(재컴파일 없음, 작업 규율 7)
production `make_contract.py` → `gen_contract_header.py` 서브프로세스를 그대로 돈다. 편집은 엔트리 마지막 print의
`util.return` **앞**에 넣는다(E51의 교훈). 셀마다 두 추출기가 각자 무엇을 봤는지 기록한다(거부는 귀속될 때만 근거다).

| 셀 | 편집 | 예측 |
|---|---|---|
| A0 양성 대조 | 없음 | 계약 발행, `bounded_bytes` 618,856, 헤더 `CONTRACT_BOUND_KNOWN 1` |
| A1 두 계열 안의 미인식 op | `stream.resource.size`(파싱 가능) | 계약은 **발행**되고 `bound_method = NONE`, 헤더 `BOUND_KNOWN 0` (비행 앱 Init이 `UNKNOWN_BOUND`로 거부) |
| A2 두 계열 밖의 자원 운반 op | `util.optimization_barrier`(자원 피연산자) | 계약 **미발행** — walker의 `unclassified_resource_ops`(전용 키) |
| A3 남은 사전 스케줄 비동기 할당 | `stream.async.alloca` | 계약 **미발행** — walker `pre_scheduling_ops`, 두 추출기 불일치 |
| A4 상수로 풀리지 않는 크기 | `arith.addi`로 만든 크기의 `stream.resource.alloca` | 계약 발행·`NONE`·헤더 `BOUND_KNOWN 0` |
| A5 파싱 불가 op | `stream.resource.frobnicate`(E51과 같은 줄) | 계약 **미발행** — 원인을 그대로 기록한다(파싱 실패 후 이전 print 사용 → 두 추출기 불일치로 예측) |
| A6 다른 수명 범주 | `<staging>` 수명의 `stream.resource.alloca` | 계약 **미발행** — 정규식 파서는 external·transient만 보고 walker는 센다 → 불일치 |

제어 흐름 구조(호출·루프·분기)는 D105가 같은 ResNet AArch64 표현에서 이미 셀을 남겼으므로 다시 돌리지 않고 인용한다
(`results/d105_control_flow_boundary/after.json`).

### B. AArch64 보관 표현 전수와 평가 명세 재생성

- B1: `results/` 아래 보관 layout IR 중 **AArch64 타깃**(IR 안의 `hal.executable.target`이 AArch64)인 것을 전부 모아
  구조적 walker의 `unclassified_resource_ops` 개수를 센다. 편집·주입 사본과 이전 컴파일러 리비전(E59 drift)은 따로 표시한다.
- B2: **평가 명세 네 개**(ResNet·DeepAE·SmartCam·WGAN AArch64)를 보관된 같은 호출의 산출물(MLIR·vmfb·layout IR·dump·ELF
  분석)에서 현재 분석기로 다시 생성해 세 수치·`bound_method`를 대조하고, 헤더를 다시 생성해 보관 헤더와 **바이트 대조**한다.
  예측: 세 수치 불변. 헤더는 바이트 동일로 예측하되, 다르면 다른 줄을 그대로 기록한다(E40 이후 필드 추가 등).

### C. 컴파일러 통계를 명세와 **같은 호출**에서

네 모델과 동적 형상 모델(E14 `dynamic`)을 AArch64(cortex-a53)로, E59의 명령(`--iree-hal-target-backends=llvm-cpu`,
layout print, executable dump, `--mlir-elide-elementsattrs-if-larger=16`)에
`--iree-scheduling-dump-statistics-format=json --iree-scheduling-dump-statistics-file=…`만 더해 **한 번의 호출**로
vmfb·layout IR·dump·통계를 함께 만든다. 같은 산출물에서 `make_contract.py`로 명세를 만든다.

- 예측(C1): 네 모델에서 통계 `constant-size` = 그 호출 명세의 C, `transient-memory-size` = T + O. 명세의 세 수치는 보관 명세와 같다.
- 예측(C2): 동적 모델은 JSON·CSV 두 기계 판독 형식 모두 transient 0이고 해석 불가를 표시하지 않는다. 사람이 읽는
  형식(`pretty`)은 한정어를 남긴다. 형식마다 별도 호출이다(통계 형식은 호출당 하나). 그 명세는 발행되고 상한이 없다(`NONE`).

### D. AArch64 게스트 계산

같은 게스트를 한 번 부팅해 다음을 게스트 안에서 계산한다(호스트는 파일 복사만 한다).

- D1: E60 창(`normal_id_04_00000043_hist_librosa_w98`, 입력 sha256 `024c8300…`)의 **순차 단정도**와 **배정도** 참조를
  게스트에서 계산하고, E60이 게스트에서 얻은 층별 IREE 출력(`guest/guest_outputs.json`)과 E25 규칙으로 대조한다.
  함수는 `harness/e52_deepae_layers.py`의 `sequential_f32_forward`·`reference_forward`·`violations`를 **그대로** 쓴다
  (두 번째 구현을 만들지 않는다 — E44). 상수는 호스트가 배치 MLIR에서 추출해 넘긴다(데이터 추출이지 계산이 아니다).
  예측: 층 9의 위반이 순차 단정도 30·배정도 19로 E60과 같고, 순차 단정도와 비트 동일한 층은 0/10.
  어긋나면 게스트 값을 원고에 쓴다.
- D2: DeepAE 34창의 **이상 점수**(입력과 재구성 출력의 평균 제곱 오차, 창마다 하나)를 두 경로 출력 — IREE(E48 cFS 출력)와
  LiteRT(E61 게스트 기준값) — 에서 게스트가 계산해, 점수 차이·순위 일치·정상/이상 라벨 기준 AUC 두 값을 기록한다.
  입력은 E48 fixture manifest의 샘플별 sha256과 대조한 뒤에만 쓴다. 예측은 두지 않는다(기술 통계).
- D3: 게스트 환경 기록 — `uname -a`, `/etc/os-release`, `nproc`, `MemTotal`, Python·`ai_edge_litert`·`iree-base-runtime`·`numpy`
  버전, 이번 부팅의 SMP·MEM, 호스트 `qemu-system-aarch64 --version`, 게스트 이미지 sha256. **이것은 이번 부팅의 기록이다** —
  이전 실험 셀들의 부팅 설정은 각 실험 기록에서 따로 읽는다.

## 2. 판정 기준 (측정 전 고정)

- **A PASS**: A0가 헤더 `BOUND_KNOWN 1`, 편집 셀 A1–A6 **어느 것도** `BOUND_KNOWN 1` 헤더를 만들지 않는다. 각 셀의 거부 원인이
  기록된다(귀속). 예측과 다른 **경로**로 거부되면 PASS를 유지하되 그 경로를 원고에 쓴다.
  **FAIL**(fail-open 발견): 편집 셀이 `BOUND_KNOWN 1` 헤더를 만든다 — 결함 원장에 올린다.
- **B PASS**: AArch64 보관 표현 미분류 0, 평가 명세 네 개의 세 수치 불변. 헤더 바이트 차이는 판정이 아니라 기록이다.
- **C PASS**: 네 모델 모두 C1 두 등식이 같은 호출 안에서 성립. 어긋나면 그 값을 기록하고 원고 문장을 고친다.
- **D**: D1은 E60 값과 같으면 "게스트에서 재계산해 같았다", 다르면 게스트 값으로 교체. D2·D3은 기록.

## 3. 주장하지 않는 것

- 편집 표현은 컴파일러가 만들 수 있는 IR의 표본이 아니다 — 분석기의 분류 규칙이 **그 입력에서** 무엇을 하는지다.
- D3은 이전 셀들의 게스트 설정을 소급해 증명하지 않는다.
- D2의 AUC는 34창(성능 측정 부분집합)에서의 값이고 모델 정확도가 아니다(E45 §5).
- 통계 덤프의 전 형식·전 모델 일반화, 다른 컴파일러 리비전.
