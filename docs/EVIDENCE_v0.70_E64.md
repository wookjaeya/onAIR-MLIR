# EVIDENCE v0.70 — E64: 원고가 기대던 범위 밖 근거를 평가 타깃(AArch64) 근거로 교체

- 사전 고정 계획: `docs/plans/E64_aarch64_evidence_for_manuscript.md` (커밋 `6578481`, **측정 이전**)
- 하네스: `harness/e64_aarch64_evidence.py` · 원자료: `results/e64_aarch64_evidence/`
- 가드: `harness/contract_negative_tests.py::e64_aarch64_evidence_cases` (`e64/1`–`/7`)
- 계기: 원고 v25의 사실 검증과 전체 메타리뷰(2026-09-24). 원고 문장 셋의 근거가 x86-64 타깃 산출물이었고,
  한 문장의 보조 기준값은 지상 개발 호스트가 계산했다. 연구 책임자 지시상 x86-64는 이 논문의 타깃도 검증 수단도 아니다.

## 1. 판정

| 부 | 질문 | 판정 | 핵심 |
|---|---|---|---|
| A | 전제를 하나씩 깬 AArch64 ResNet 표현이 배치 가능한 헤더를 만드는가 | **PASS** | 양성 대조 618,856·`BOUND_KNOWN 1`, 편집 6셀 중 `BOUND_KNOWN 1` **0** |
| B | AArch64 보관 표현 미분류 수 / 평가 명세 재생성 | **PASS** | 11개 표현 미분류 **0**, 평가 명세 4개 세 수치 불변·헤더 **바이트 동일** |
| C | 컴파일러 통계가 **같은 호출**의 명세와 일치하는가 | **PASS** | 상수=C, transient=T+O 4/4, 동적 모델 JSON·CSV 모두 0 |
| D | 보조 기준값을 게스트에서 / 이상 점수 / 환경 기록 | 기록 | 30·19·비트 동일 0/10 = 호스트 계산과 동일, 순위 동일 561쌍 중 역전 0 |

## 2. A — 전제 위반 편집(보관 `results/e36b_aarch64_models/b2_resnet/b2_resnet.layout_ir.txt`, 재컴파일 없음)

편집은 엔트리 마지막 print의 `util.return` 앞에 넣었다(E51 `mutate` 재사용). production `make_contract.py` →
`gen_contract_header.py`(위치 인자 둘, D106) 경로를 그대로 돌렸다. 셀마다 두 추출기의 출력을 따로 기록했다.

| 셀 | 편집 | 결과 | 귀속(기록에서) |
|---|---|---|---|
| A0 | 없음 | 명세 발행 618,856, 헤더 `BOUND_KNOWN 1` | 두 추출기 일치, walker chunk 0 |
| A1 | `stream.resource.size`(두 계열 안의 미인식 op) | 명세 발행·`NONE`·헤더 `BOUND_KNOWN 0` | 두 추출기 모두 `unrecognized_op:stream.resource.size` |
| A2 | `util.optimization_barrier`(두 계열 밖의 자원 운반 op) | **명세 없음** | walker `unclassified_resource_ops`(전용 키) |
| A3 | `stream.async.alloca` | **명세 없음** | walker `pre_scheduling_ops` → 두 추출기 불일치(`unresolved(presence)`) |
| A4 | `arith.addi`로 만든 크기의 `alloca` | 명세 발행·`NONE`·헤더 `BOUND_KNOWN 0` | walker `non_constant_def:arith.addi` |
| A5 | `stream.resource.frobnicate`(파싱 불가) | **명세 없음** | walker가 파싱 가능한 **이전 print(chunk 1)**를 읽음 → 두 추출기 불일치 |
| A6 | `<staging>` 수명의 `alloca` | **명세 없음** | 정규식 파서는 external·transient만 보고 walker는 센다 → 불일치 |

**예측과 모두 일치했다.** 헤더 `BOUND_KNOWN 0`인 명세는 비행 앱이 Init에서 `UNKNOWN_BOUND`로 거부한다(E14 A8의
게스트 관측, D106). 이 결과가 원고의 분류 서술을 **바로잡는다**: 두 이름 계열(`stream.resource`·`stream.tensor`)
안의 미인식 op는 전용 키로 가지 않고 `unresolved`가 되어 **상한 없는 명세**가 나온다. 전용 키로 생성을 멈추는 것은
두 계열 **밖**의 자원 운반 op다. 파싱 불가 op는 walker가 이전 print로 물러나 두 추출기가 어긋나서 멈춘다 —
E51의 "미인식 op" 셀이 x86-64 mlp16k에서 보인 것과 같은 경로이고, 이번엔 평가 모델의 AArch64 표현이다.
제어 흐름 구조(호출·루프·분기)는 같은 표현에서 D105가 남긴 셀을 인용한다.

## 3. B — AArch64 보관 표현과 평가 명세

**표현의 대상은 파일 내용으로 판별할 수 없다.** layout 표현은 코드 생성 전 단계라 대상 표기가 없고, 실제로
AArch64 컴파일 산출물 11개 중 **8개가 x86-64 컴파일 산출물과 바이트 동일**하다. 그래서 대상은 그 파일을 만든
**호출의 디렉터리**로 정했다(`AARCH64_COMPILE_DIRS`, 하네스에 명시). 저장소 추적 layout 표현 30개 = AArch64 15
(평가 리비전 11 + E59 이전 리비전 4) + x86-64 15.

- B1: 평가 리비전 AArch64 표현 **11개**(E14 합성 7 · SmartCam · ResNet · DeepAE · WGAN) — 미분류 **0**, walker 예외 0.
- B2: 평가 명세 4개를 보관된 같은 호출의 산출물에서 현재 분석기로 재생성 — 세 수치·`bound_method` **4/4 불변**, 헤더
  **4/4 바이트 동일**. 문서 leaf 차이는 ResNet·DeepAE의 `provenance.dump_dir_files` 하나뿐인데, 보관 dump가 생성 후
  축소됐기 때문이다(목록 57→52, 24→19; E47이 기록한 `.gitignore` 축소). 수치와 무관하다.

## 4. C — 같은 호출에서 컴파일러 통계

E59와 같은 AArch64 명령에 `--iree-scheduling-dump-statistics-format/-file`만 더해 모델당 **한 번의 호출**로
vmfb·layout·dump·통계를 만들고 그 산출물에서 명세를 만들었다(`iree-compile 3.11.0rc20260316 @ e4a3b04`, 산출 ELF
`embedded-elf-arm_64`).

| 모델 | 통계 상수 | C | 통계 transient | T + O |
|---|---:|---:|---:|---:|
| ResNet | 309,440 | 309,440 | 297,128 | 297,088 + 40 |
| DeepAE | 1,063,424 | 1,063,424 | 3,648 | 1,088 + 2,560 |
| SmartCam | 8,840,704 | 8,840,704 | 8,779,980 | 8,779,968 + 12 |
| WGAN | 4,283,648 | 4,283,648 | 130,780,672 | 130,178,560 + 602,112 |

동적 모델: JSON transient 0 · CSV transient 0(기계 판독 두 형식) · 사람이 읽는 형식은
`Submissions: 1, using cumulative minimum 0 B` — 명세는 발행되고 `bound_method NONE`, 해석 불가 피연산자 3개.
명세의 세 수치는 보관 명세와 같다. vmfb·dump는 보관하지 않았다(바이트 재현 불가 — E26e; 수치는 재현).
통계 파일과 명세는 `results/e64_aarch64_evidence/compiler_statistics/`에 있다.

## 5. D — AArch64 게스트 계산 (`SMP=1 MEM=1024`, Ubuntu 24.04.4, Python 3.12.3, numpy 2.3.5)

호스트는 파일을 복사만 했다. 번들 파일은 게스트에서 sha256을 다시 대조한 뒤에 썼다.

- **D1** E60 창(`normal_id_04_00000043_hist_librosa_w98`, 입력 sha256 `024c8300…`): 게스트가 계산한 순차 단정도·배정도
  참조와 E60 게스트 층 출력의 E25 규칙 위반 — 층 0–8 **0**, 마지막 층 **30**(순차 단정도)·**19**(배정도), 순차 단정도와
  비트 동일한 층 **0/10**. **E60이 호스트에서 계산한 값과 전부 같다.** 함수는 `e52_deepae_layers.py`를 그대로 썼다.
- **D2** DeepAE 34창 이상 점수(입력과 재구성 출력의 평균 제곱 오차): IREE(E48 cFS 출력)와 LiteRT(E61 게스트 기준값)
  두 경로의 **순위가 동일**하고 561쌍 중 역전 **0**, 최대 상대 점수 차 **1.02×10⁻⁵**, 최대 절대 차 1.1×10⁻⁴(점수 중앙값
  10.6). 입력 34창은 fixture manifest의 샘플별 sha256과 **34/34 일치**한 뒤에 썼다. 기록한 AUC(두 경로 동일)는 **정확도
  주장이 아니며 원고에 쓰지 않는다** — 34창은 평가셋이 아니다(E45 §5).
- **D3** 게스트 환경(이번 부팅): `aarch64`, 1 vCPU, MemTotal 974,848 kB, Ubuntu 24.04.4 LTS, 커널 6.8.0-138, Python 3.12.3,
  `ai-edge-litert` 2.2.0(`~/e61/litelib`), `iree-base-runtime` 3.11.0·numpy 2.3.5(`~/e57/pylib`), 호스트 QEMU 8.2.2.
  **이전 셀들의 부팅 설정을 소급해 증명하지 않는다.**

## 6. 가드와 revert

`e64/1`–`/6`은 보관 원자료에서 **다시 유도**한다(`/3`은 통계 파일과 명세 파일을, `/5`는 저장된 점수를 읽는다 — 요약의
불리언이 아니라, D89). `/7`은 도구가 있으면 프로브를 **라이브로 다시 돌려** 셀별 경로를 대조한다(D77). 통계 파일의 상수를
1 B 바꾸면 `/3`이, 점수 두 개를 맞바꾸면 `/5`가 실제로 FAIL했다(확인 후 복원).

## 7. 주장하지 않는 것

- 편집 표현은 컴파일러가 만드는 IR의 표본이 아니다 — 분석기의 분류 규칙이 **그 입력에서** 무엇을 하는지다.
- D3은 이번 부팅의 기록이다. 이전 실험 셀의 vCPU·메모리는 각 실험 기록에서 따로 읽어야 한다.
- 이상 점수 결과는 두 구현의 **결정량 동치**이지 이상 탐지 성능이 아니다.
- 통계 덤프의 모든 형식·모든 모델·다른 컴파일러 리비전으로의 일반화.
