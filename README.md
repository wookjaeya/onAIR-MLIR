# onair-mlir-bench

NASA cFS/OnAIR AI 플러그인을 MLIR/IREE로 컴파일하고, 컴파일러의 할당 스케줄에서 도출한
정적 메모리 계약으로 배치 전 admission 판정을 수행하는 연구용 저장소.

**시작점**: [`CLAUDE.md`](./CLAUDE.md) — 프로젝트 컨텍스트, 작업 규율, 환경 구축, 현재 상태.
**현재 버전**: v0.7 (`git tag`로 확인). 최신 근거: [`docs/EVIDENCE_v0.7_E13.md`](./docs/EVIDENCE_v0.7_E13.md).
**전체 실험 이력**: [`EXPERIMENT_LOG.md`](./EXPERIMENT_LOG.md).

```bash
bash scripts/99_bootstrap_all.sh   # 전체 환경 구축 (최초 1회)
python3 harness/platform_check.py  # 이 머신의 타이밍 증거 등급 확인
```
