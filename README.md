# onair-mlir-bench

NASA cFS/OnAIR AI 플러그인을 MLIR/IREE로 컴파일하고, 컴파일러의 할당 스케줄에서 도출한
정적 메모리 계약으로 배치 전 admission 판정을 수행하는 연구용 저장소.

**시작점**: [`CLAUDE.md`](./CLAUDE.md) — 프로젝트 컨텍스트, 작업 규율, 환경 구축, 현재 상태.
**현재 버전**: v0.21 (`git tag` 대신 커밋 이력·`CHANGELOG.md`로 확인 — 태그 푸시는 이 실행 환경의 정책 제약으로 보류 중, `EXPERIMENT_LOG.md` 참조). 최신 근거: [`docs/EVIDENCE_v0.21_E24c.md`](./docs/EVIDENCE_v0.21_E24c.md)(외부 검토 v0.20 F1–F5 — 확인된 4건 수정, **F1은 리뷰 권고가 삭제 경로를 위조 경로로 바꿔 악화시킴을 실측해 미채택**. F4의 실물 근거를 `results/e24c_manyconst31/`에 보존). 이전 근거: [`docs/EVIDENCE_v0.20_E24b.md`](./docs/EVIDENCE_v0.20_E24b.md) — **§12 정오표 필수 확인**("unsigned 비교" 원인 서술 철회)(외부 검토 v0.19-재정리본 R1–R5 — 음수 스택이 cFS 스택 게이트를 **모든 스택 크기에서 참인 항등식**으로 만들던 경로(리뷰 분류보다 심각도 상향), 계약 자기모순 2종, subset-sum tri-state, **적용된 override의 계약 기록·헤더 게이트**. **리뷰 처방 1건은 실측 과잉 거부로 미채택**). 이전 근거: [`docs/EVIDENCE_v0.19_E24.md`](./docs/EVIDENCE_v0.19_E24.md)(외부 검토 v0.18-후속 N1–N6·S5 — 검증 불가·모순 상태가 배치 가능 헤더로 새던 경로 4건 차단, E23이 출하한 과잉 거부 회귀 1건 수정. **리뷰 제안 3건은 실측 과잉 거부로 범위 축소**), [`docs/EVIDENCE_v0.18_E23.md`](./docs/EVIDENCE_v0.18_E23.md)(외부 검토 잔여 4건 F4/F8/F10/F11 + CI가 잡은 신규 크래시 D25 — A5a·A5b 손상 방식 코드화, OnAIR 계약-아티팩트 바인딩 게이트 — **§9 정오표 필수 확인**), [`docs/EVIDENCE_v0.17_E22.md`](./docs/EVIDENCE_v0.17_E22.md)(외부 검토 F9: fresh clone 재현성 — **§6 정오표 필수 확인**), [`docs/EVIDENCE_v0.16_E21.md`](./docs/EVIDENCE_v0.16_E21.md)(외부 검토 fail-open 결함 6건 실제 재현·수정), [`docs/EVIDENCE_v0.15_E20.md`](./docs/EVIDENCE_v0.15_E20.md)(E19 구조적 크로스체크 적대적 리뷰 + 과잉 거부 결함 2건 실제 재현·수정), [`docs/EVIDENCE_v0.14_E19.md`](./docs/EVIDENCE_v0.14_E19.md)(구조적 추출기를 make_contract.py에 필수 크로스체크로 결선 — 2단계. "정규 MLIR pass"가 아니라 **MLIR API 기반 구조적 post-processing verifier**다, 명칭 정정 `docs/EVIDENCE_v0.13_E18.md` §7 — **§8·§9 정오표 필수 확인**), [`docs/EVIDENCE_v0.13_E18.md`](./docs/EVIDENCE_v0.13_E18.md)(구조적(비정규식) 할당 추출기 = MLIR API 기반 post-processing verifier, 1단계 — **§7 정오표(명칭 정정) 필수 확인**), [`docs/EVIDENCE_v0.12_E17.md`](./docs/EVIDENCE_v0.12_E17.md)(AArch64 게스트 재현: A5b 최초 실행), [`docs/EVIDENCE_v0.11_E16.md`](./docs/EVIDENCE_v0.11_E16.md)(C 게이트 보강), [`docs/EVIDENCE_v0.10_E15.md`](./docs/EVIDENCE_v0.10_E15.md)(계약 도구 fail-closed 전환), [`docs/EVIDENCE_v0.9_E14_stage1.md`](./docs/EVIDENCE_v0.9_E14_stage1.md) — **§11 정오표(외부 검토 2건 반영) 필수 확인**.
**전체 실험 이력**: [`EXPERIMENT_LOG.md`](./EXPERIMENT_LOG.md).

```bash
pip install -r requirements.txt    # iree-base-compiler/runtime, jsonschema (버전 고정)
python3 harness/contract_negative_tests.py  # 계약 도구 fail-closed 회귀·음성·구조적 추출기 일치·크로스체크 배선·과잉거부·fail-open·불변식·override 기록 회귀 시험 (이 컨테이너 191/191)
bash scripts/99_bootstrap_all.sh   # 전체 환경 구축(cFS·IREE C 런타임 등, 위 시험엔 불필요)
python3 harness/platform_check.py  # 이 머신의 타이밍 증거 등급 확인
```

**fresh clone 재현성(외부 검토 F9 — E22/E23에서 실제 확인·해결, N6 — E24에서 명칭 정정)**:
`git clone`으로 새로 받은 이 저장소에서 위 `pip install -r requirements.txt` 후
`contract_negative_tests.py`를 실행하면 크래시나 오탐 FAIL 없이 정상 종료한다. v0.21(E24c)의
이 컨테이너 실측은 **191/191**이고, **CI 실측**(커밋 `50f16d0`, 세 레그 전부 success)은
`full` **190/190 + 1 SKIP**, `without-iree` **103/103 + 11 SKIP**, `stdlib-only`
**103/103 + 11 SKIP**이다. 차이 1건은 PyYAML 유무이며(그 SKIP은 워크플로우 YAML 파싱 검사),
**CI가 측정하기 전의 값을 추정해 적지 않는 것이 이 저장소의 규칙이다**(그렇게 적었다가 D34로
정정한 이력이 있다). 레그별 조건 설명은 아래 v0.20 기록이 그대로 유효하다 — **CI가 측정하기 전의 값을 추정해 적지 않는 것이 이 저장소의
규칙이다**(그렇게 적었다가 D34로 정정한 이력이 있다). 아래는 v0.19 시점의 CI 실측 기록이며
레그별 조건 설명은 그대로 유효하다: **142/142 + 1 SKIP**(CI 실측. 이 저장소 개발 컨테이너처럼
PyYAML이 별도로 깔려 있으면 143/143 — PyYAML은 `requirements.txt`에 없고, 그 1건은 워크플로우
YAML 파싱 검사다). 의존성을 줄인 두 조건도 크래시나 오탐 FAIL
없이 정상 종료한다 — `jsonschema`만 설치(iree-base-compiler 미설치: 모듈도 콘솔 스크립트도
`iree.runtime`도 없음)과 **아무것도 설치하지 않은** 진짜 무의존성 조건 둘 다 **58/58 + 9 SKIP**
(CI 실측. 이 커밋에서 두 조건이 같은 값인 것도 사실이다 — IREE 도구가 없으면 `jsonschema`를 쓰는
경로가 이미 전부 SKIP되므로 두 레그가 같은 것을 측정한다. E23이 기록한 48/48+6은 그 시점 값이며,
E24가 IREE를 요구하지 않는 시험을 여럿 추가해 올라갔다)(이 저장소에서 pip 없는 venv로
실측). E24 전에는 후자를 어떤 CI 레그도 시험하지 않았고(당시 "without-deps" 레그가 실제로는
`jsonschema`를 설치했다 — 그래서 "진짜 무의존성"이라는 이 문서의 표현이 부정확했다),
`jsonschema`만 없는 조건에서는 시험이 **15건의 거짓 FAIL**을 냈다(E24에서 수정).
세 경로 모두 `.github/workflows/contract-negative-tests.yml`(`full`/`without-iree`/`stdlib-only`)이
CI에서 매 푸시마다 확인하며,
**그 CI가 첫 실행에서 실제로 결함(D25)을 하나 잡았다** — 로컬의 import 차단 시뮬레이션은
Python 모듈만 숨기고 콘솔 스크립트를 남기므로 재현할 수 없던 조건이었다
([`docs/EVIDENCE_v0.18_E23.md`](./docs/EVIDENCE_v0.18_E23.md) §5).
