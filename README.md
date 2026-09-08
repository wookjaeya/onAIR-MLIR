# onair-mlir-bench

NASA cFS/OnAIR AI 플러그인을 MLIR/IREE로 컴파일하고, 컴파일러의 할당 스케줄에서 도출한
정적 메모리 계약으로 배치 전 admission 판정을 수행하는 연구용 저장소.

**시작점**: [`CLAUDE.md`](./CLAUDE.md) — 프로젝트 컨텍스트, 작업 규율, 환경 구축, 현재 상태.
**현재 버전**: v0.13 (`git tag` 대신 커밋 이력·`CHANGELOG.md`로 확인 — 태그 푸시는 이 실행 환경의 정책 제약으로 보류 중, `EXPERIMENT_LOG.md` 참조). 최신 근거: [`docs/EVIDENCE_v0.13_E18.md`](./docs/EVIDENCE_v0.13_E18.md)(정규 MLIR pass 1단계: 구조적 할당 추출기). 이전 근거: [`docs/EVIDENCE_v0.12_E17.md`](./docs/EVIDENCE_v0.12_E17.md)(AArch64 게스트 재현: A5b 최초 실행), [`docs/EVIDENCE_v0.11_E16.md`](./docs/EVIDENCE_v0.11_E16.md)(C 게이트 보강), [`docs/EVIDENCE_v0.10_E15.md`](./docs/EVIDENCE_v0.10_E15.md)(계약 도구 fail-closed 전환), [`docs/EVIDENCE_v0.9_E14_stage1.md`](./docs/EVIDENCE_v0.9_E14_stage1.md) — **§11 정오표(외부 검토 2건 반영) 필수 확인**.
**전체 실험 이력**: [`EXPERIMENT_LOG.md`](./EXPERIMENT_LOG.md).

```bash
bash scripts/99_bootstrap_all.sh   # 전체 환경 구축 (최초 1회)
python3 harness/platform_check.py  # 이 머신의 타이밍 증거 등급 확인
python3 harness/contract_negative_tests.py  # 계약 도구 fail-closed 회귀·음성·구조적 추출기 일치 시험, 66/66 (환경 구축 불필요)
```
