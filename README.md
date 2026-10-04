# onair-mlir-bench

NASA cFS/OnAIR AI 플러그인을 MLIR/IREE로 컴파일하고, 컴파일러의 할당 스케줄에서 도출한
정적 메모리 계약으로 배치 전 admission 판정을 수행하는 연구용 저장소.

**시작점**: [`CLAUDE.md`](./CLAUDE.md) — 프로젝트 컨텍스트, 작업 규율, 환경 구축, 현재 상태.
**현재 버전**: v0.50 (`git tag` 대신 커밋 이력·[`CHANGELOG.md`](./CHANGELOG.md)로 확인 — **원격 저장소에는 태그가 하나도 없다**: `git ls-remote --tags origin`이 빈 결과이고, 이 실행 환경에서 태그 푸시는 403으로 거부된다. `v0.50`을 붙이려면 로컬 클론에서 `git tag -a v0.42 <main의 병합 커밋> && git push origin v0.42`를 직접 실행해야 한다).

**연구의 최종 주장과 7개 구분**(예산 / 계약 범위 / 무조건·조건부 정책 / 실행 타깃 / OnAIR / MLIR 기여):
[`EVIDENCE_v0.41_E37.md`](./docs/EVIDENCE_v0.41_E37.md) §2. 짧게 말하면 — **부분 메모리 계약을 컴파일
산출물에서 뽑아 앱에 부여한 예산과 비교해 실행 전에 허용 여부를 정하는 방법**이고, 세 공개 실물 모델
(OPS-SAT SmartCam · MLPerf Tiny ResNet · Deep AutoEncoder)에서 AArch64 QEMU 게스트 cFS로 확인했다.
**네 번째 실물 모델**(OPS-SAT WGAN denoiser)은 v0.46/E46에서 반입했고 **x86-64 의미 동치와 계약까지**다
— AArch64·cFS·OnAIR에서 돌리지 않았으므로 위 세 모델과 같은 줄에 세우지 않는다.
**범위 한정(v0.45/D74)**: 실입력으로 바꾸면 ResNet·SmartCam은 사전 고정 기준을 여전히 만족하지만
**Deep AutoEncoder는 만족하지 않는다**(34창 21,760원소 중 94 실패, 한 샘플에 몰려 있다).
**v0.50/E48에서 그 실입력을 AArch64 native·cFS에서도 밟았고 판정이 셋 다 x86-64와 같다** —
DeepAE는 **두 ISA가 정확히 같은 한 샘플**에서 실패하고 argmax도 같다(실패 원소 수만 46 vs 94).
쓸 수 있는 것은 *"그 FAIL은 x86 전용 현상이 아니다"*까지이고, 제3의 기준값이 없으므로 **어느 쪽이
옳은지는 단정하지 않는다**.
**범위 한정(v0.49/D78)**: 조건부 계층의 *"1.94배 작은 예산"*은 **HAL 디바이스 할당 회계 범위의
진술**이고 프로세스 RAM 절감이 아니다 — 상수는 모듈 이미지 안에서 두 분기 모두 상주한다.
**현재 비교한 모델·도구·정책 조건에서는 MLIR 기반 경로와 아티팩트 전용 경로의 수치·판정 차이가
관측되지 않았다** — 아티팩트만 보는 기준선과 판정이 24/24 일치했다(E35). 구현하지 않은 정규 pass의
효과를 부정하는 근거로는 쓰지 않는다. 주장하는 것은 수치적 우위가 아니라 **MLIR 기반 계약 추출·연계 방법**이다.

**세 모델의 증거를 원본→계약→입력→cFS 판정→출력→HAL peak까지 한 표로**:
[`results/evidence_linkage/linkage.md`](./results/evidence_linkage/linkage.md)(생성기 산출물, 직접 편집 금지).
최종 코드로 보관 원자료를 다시 판정한 결과는 [`reproduce_check.json`](./results/evidence_linkage/reproduce_check.json).

**세 연구 질문의 답** (각 문서의 "주장하지 않음" 절이 범위를 못박고 있으므로 함께 읽을 것):

| 축 | 답 | 근거 |
|---|---|---|
| **R-1** OnAIR↔cFS 의미 동치 | canonical 모델·고정 64입력에서 다섯 경로가 사전 정의 허용 오차 내 일치, 네 IREE 경로는 6쌍 전부 비트 동일. 범위는 *계산 결과 동치 + cFS 내부 추론 경로 통합*까지 | [`EVIDENCE_v0.22_E25.md`](./docs/EVIDENCE_v0.22_E25.md) — **§11 정오표·§12 필수 확인** |
| **R-2** 계약 경계의 유용성 | 유용성의 근거는 tightness가 아니라 **배포 독립성**. 같은 vmfb의 HAL 관측 피크가 배포에 따라 최대 **172.3×** 달라지는 반면 정적 계약은 변하지 않는다 | [`v0.25_E26`](./docs/EVIDENCE_v0.25_E26.md)(**§9 정오표**) · [`v0.27_E26e`](./docs/EVIDENCE_v0.27_E26e.md) · [`v0.28_E26f`](./docs/EVIDENCE_v0.28_E26f.md) |
| **R-3** MLIR의 고유 기여 | **더 정확한 수치가 아니라 독립적인 두 번째 정보원.** 정상 조건 8/8에서 아티팩트만 보는 분석기가 계약값과 정확히 일치했고, 차이는 컴파일러 버전 드리프트에서만 났다 | [`EVIDENCE_v0.29_E27.md`](./docs/EVIDENCE_v0.29_E27.md) |

실물 워크로드 도입이 드러낸 과잉 거부 3건: [`v0.23_E26a`](./docs/EVIDENCE_v0.23_E26a.md)(호출 해석 부재) · [`v0.24_E26b`](./docs/EVIDENCE_v0.24_E26b.md)(빈 백틱 라벨 상수) · [`v0.26_E26c`](./docs/EVIDENCE_v0.26_E26c.md)(다중 출력 subview).

외부 검토 반영 이력(v0.14–v0.21, E19–E24c)은 [`CHANGELOG.md`](./CHANGELOG.md)와 [`EXPERIMENT_LOG.md`](./EXPERIMENT_LOG.md)가 정본이다. 정오표가 붙은 문서: [`v0.21_E24c`](./docs/EVIDENCE_v0.21_E24c.md) · [`v0.20_E24b`](./docs/EVIDENCE_v0.20_E24b.md)(**§12**) · [`v0.19_E24`](./docs/EVIDENCE_v0.19_E24.md)(**§10**) · [`v0.18_E23`](./docs/EVIDENCE_v0.18_E23.md)(**§9**) · [`v0.17_E22`](./docs/EVIDENCE_v0.17_E22.md)(**§6**) · [`v0.14_E19`](./docs/EVIDENCE_v0.14_E19.md)(**§8·§9**) · [`v0.13_E18`](./docs/EVIDENCE_v0.13_E18.md)(**§7 명칭 정정**) · [`v0.9_E14_stage1`](./docs/EVIDENCE_v0.9_E14_stage1.md)(**§11**).
**전체 실험 이력**: [`EXPERIMENT_LOG.md`](./EXPERIMENT_LOG.md).

```bash
pip install -r requirements.txt    # iree-base-compiler/runtime, jsonschema (버전 고정)
python3 harness/contract_negative_tests.py  # 계약 도구 fail-closed 회귀·음성·구조적 추출기 일치·크로스체크 배선·과잉거부·fail-open·불변식·override 기록 회귀 시험 (이 컨테이너 276/276, CI full 275/275+1 SKIP)
bash scripts/99_bootstrap_all.sh   # 전체 환경 구축(cFS·IREE C 런타임 등, 위 시험엔 불필요)
python3 harness/platform_check.py  # 이 머신의 타이밍 증거 등급 확인
```

**fresh clone 재현성(외부 검토 F9 — E22/E23에서 실제 확인·해결, N6 — E24에서 명칭 정정)**:
`git clone`으로 새로 받은 이 저장소에서 위 `pip install -r requirements.txt` 후
`contract_negative_tests.py`를 실행하면 크래시나 오탐 FAIL 없이 정상 종료한다.

| 조건 | v0.29 실측 |
|---|---|
| 이 개발 컨테이너 | **276/276** |
| CI `full`(`requirements.txt`) | **275/275 + 1 SKIP** |
| CI `without-iree`(`jsonschema`만) | **168/168 + 15 SKIP** |
| CI `stdlib-only`(아무것도 설치 안 함) | **168/168 + 15 SKIP** |

(커밋 `7fb1d4d`, 워크플로 run 76, 세 레그 전부 success.) 컨테이너와 `full`의 차이 1건은
PyYAML 유무이며, 그 SKIP은 워크플로우 YAML 파싱 검사다 — PyYAML은 `requirements.txt`에 없다.
축소 두 레그의 SKIP은 전부 **정직한 SKIP**이다(도구 부재를 이유와 함께 표시한다).

**CI가 측정하기 전의 값을 추정해 적지 않는 것이 이 저장소의 규칙이다**(그렇게 적었다가 D34로
정정한 이력이 있다). 두 축소 레그가 같은 값인 것도 사실이다 — IREE 도구가 없으면 `jsonschema`를
쓰는 경로가 이미 전부 SKIP되므로 두 레그가 같은 것을 측정한다. E24 전에는 후자를 어떤 CI 레그도
시험하지 않았고(당시 "without-deps" 레그가 실제로는 `jsonschema`를 설치했다 — 그래서 "진짜
무의존성"이라는 이 문서의 옛 표현이 부정확했다), `jsonschema`만 없는 조건에서는 시험이
**15건의 거짓 FAIL**을 냈다(E24에서 수정). 버전별 옛 수치는 `CHANGELOG.md`가 조건과 함께 보존한다.

세 경로 모두 `.github/workflows/contract-negative-tests.yml`(`full`/`without-iree`/`stdlib-only`)이
CI에서 매 푸시마다 확인하며,
**그 CI가 첫 실행에서 실제로 결함(D25)을 하나 잡았다** — 로컬의 import 차단 시뮬레이션은
Python 모듈만 숨기고 콘솔 스크립트를 남기므로 재현할 수 없던 조건이었다
([`docs/EVIDENCE_v0.18_E23.md`](./docs/EVIDENCE_v0.18_E23.md) §5).
