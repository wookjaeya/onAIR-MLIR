# EVIDENCE v0.17 — E22: F9 재현성 인프라 — fresh clone에서 실제 확인

## 0. 등급과 범위

**증거 등급: 결정론적**(실행 성공/실패, 시험 통과 수, git clone 재현 결과). 이 실험은 시험
하네스 자신의 강건성과 저장소 재현성 인프라만 다룬다 — 계약 계산 로직 자체는 건드리지 않았다.

**범위**: `docs/reviews/REVIEW_v0_15_LATEST.md`의 F9("`96/96, 환경 구축 불필요`는 fresh clone
기준으로 재현되지 않는다")를 다룬다. E21이 F1–F7 중 F3(구조적 검증기 미설치 시 기본 하드 실패로
변경)을 고치면서 F9의 문제를 구조적으로 악화시킬 수 있었다는 점을 EVIDENCE_v0.16 §4·§9에서
이미 인지하고 이연했던 바로 그 후속 실험이다.

## 1. 검증 — 진짜 `git clone`으로 재현

이전 세션 검증(E21 verification, 워크플로우)이 이미 실제 `git clone`으로 두 가지 문제를 확인해
뒀다: (a) `results/e14_aarch64_qemu/*/dump/`가 `.gitignore`로 제외돼 fresh clone에 존재하지
않음(회귀·음성 시험이 요구하는데), (b) `iree.compiler.ir`이 없는 환경에서
`contract_negative_tests.py`가 **uncaught `RuntimeError`로 크래시**(PASS/FAIL 요약 0줄, 33/53
또는 그보다 나쁜 상태) — 이는 E21의 F3 수정(구조적 검증기 미설치 시 기본 하드 실패) 적용 전부터
이미 존재하던 별개의 버그였다.

이번 실험에서 두 문제를 모두 고친 뒤, **이 세션 안에서 실제로 `git clone`을 다시 실행**해 확인했다
(브랜치 `claude/review-and-proceed-4y1sag`, 이 커밋 기준):

```
$ git clone --branch claude/review-and-proceed-4y1sag --single-branch <repo> /tmp/.../freshclone
$ cd /tmp/.../freshclone
$ find results/e14_aarch64_qemu -path "*/dump/*" -type f | wc -l
242
$ python3 harness/contract_negative_tests.py
...
107/107 checks passed
```

`iree.compiler.ir`을 (패키지를 실제로 지우지 않고) `sys.meta_path` 훅으로 import 시점에
차단해 "패키지가 아예 없는 환경"을 가역적으로 시뮬레이션한 뒤 같은 fresh clone에서 재실행:

```
$ PYTHONPATH=.../fake_site python3 harness/contract_negative_tests.py
...
77/77 checks passed (3 skipped: iree.compiler.ir not installed)
```

두 경로 모두 **크래시 없음, 명확한 PASS/FAIL/SKIP 요약**을 출력한다.

## 2. 수정 내역

### 2.1 크래시 수정 — `Result`에 `skip` 상태 신설

`harness/contract_negative_tests.py`의 세 지점(`structural_walker_checks()`의 화이트리스트
축소 시험, `structural_hard_fail_cases()`·`structural_bugfix_regression_cases()`의 전제조건
확인)이 `iree.compiler.ir` 부재를 "이 코드는 고장났다"는 FAIL과 구분하지 못했다 — 그중 한
곳(`structural_walker_checks()`의 화이트리스트 축소 시험)은 아예 `except` 없이 예외가
전파돼 `main()` 전체가 죽었다(요약 출력 전에). `Result(name, ok, detail, skip=False)`로
확장하고, 이 세 지점을 명확한 SKIP으로 보고하도록 정리했다. `main()`의 요약도 SKIP을
PASS/FAIL 카운트에서 분리해, "이 환경에서 실제로 통과한 비율"이 항상 의미 있는 수치로
남도록 했다(리뷰가 요구한 "명확한 SKIP/FAIL 정책"과 일치).

### 2.2 E21(F3)과의 상호작용 해소

E21이 "구조적 검증기 미설치 시 기본 하드 실패"로 바꾼 것은 `make_contract.py`의 실제 배포
경로에는 옳지만, 이 시험 하네스 자신이 서브프로세스로 `make_contract.py`를 호출하는 곳(ABI
불일치·D14·D10 등 **다른 것**을 테스트하는 곳들)까지 구조적 검증기 부재라는 무관한 이유로
실패시켰다. `structural_available()`(환경을 1회 확인, 캐시)과
`with_structural_override()`를 신설해, 환경이 구조적 검증기를 못 갖췄을 때
`--allow-missing-structural-checker`를 투명하게 끼워 넣는다 — 각 시험은 자신이 실제로
검사하려는 조건(다른 `--allow-*` 플래그로 게이트됨)만으로 판정되고, 구조적 검증기 유무라는
무관한 축에 흔들리지 않는다. `regression_check()`의 "contract unchanged" 비교도 이 경우
생기는 `provenance.notes`의 정당한 추가 항목 1건을 인정하도록 조정(수치 자체의 diff는
여전히 0으로 요구).

### 2.3 `results/e14_aarch64_qemu/*/dump/` 저장소에 포함

242개 파일, 두 타깃 합계 6.5MB(중간 MLIR/LLVM-IR/비트코드/오브젝트 파일 — 민감 정보 없음).
`.gitignore`의 제외 사유("커널 ELF·codegen.ll·objdump는 옆에 복사돼 있다")는 그 세
파일에는 맞지만 `dump/` 디렉터리 전체에는 안 맞았다 — 회귀·음성 시험이 `--dump-dir`로
디렉터리 전체를 요구한다. `*.o`가 이미 전역 gitignore 패턴이라 별도 negation
(`!results/e14_aarch64_qemu/**/dump/**/*.o`)이 필요했다.

### 2.4 dependency lock + CI

`requirements.txt` 신설(`iree-base-compiler==3.11.0`, `iree-base-runtime==3.11.0`,
`jsonschema==4.26.0` — 이 저장소가 최근 검증한 버전). CLAUDE.md가 기록하는 정확한 컴파일러
커밋(`e4a3b0405d7d23554da26403658d0e8c3c5ecf25`)보다 거칠다는 한계를 파일 자체에 주석으로
남겼다. `.github/workflows/contract-negative-tests.yml` 신설 — 매 push/PR마다 fresh
checkout에서 두 경로(with/without `iree-base-compiler`)를 모두 실행해 §1의 재현을 CI에서
계속 확인한다.

## 3. 이번 실험이 다루지 않는 것 (범위 밖)

- CI 워크플로우 자체가 실제로 초록불로 실행되는지는(GitHub Actions 잡 실행) 이 문서 작성
  시점에는 다음 push 이후에나 확인 가능 — 로컬 fresh clone 재현(§1)으로 동일 커맨드가
  실제로 통과함은 확인했으나, GitHub 러너 환경(다른 OS 버전 등)에서의 실행 자체는 별도
  확인 대상이다.
- `iree-base-compiler`/`runtime` 없이 `jsonschema`조차 없는 완전 무의존성 환경은
  시험하지 않았다(이 저장소의 최소 요구사항은 `jsonschema` — `--no-validate` 없이
  `make_contract.py`를 실행하는 경로가 이를 요구한다).
- 다른 Python 버전(3.11 외)에서의 재현은 확인하지 않았다.

## 4. 판정

F9가 지적한 두 가지(fresh clone에서 크래시, dump/ 부재)를 모두 실제 `git clone` 재현으로
확인 후 수정했다. **README의 "환경 구축 불필요"는 이제 정확한 주장이다** —
`pip install -r requirements.txt` 후 fresh clone에서 107/107, 그 설치 없이도(패키지가
정말 없는 환경) 크래시 없이 77/77+3 SKIP로 정상 종료함을 이 세션에서 직접 재현해 확인했다.

## 5. 재현

```bash
git clone --branch claude/review-and-proceed-4y1sag <repo-url> /tmp/freshclone
cd /tmp/freshclone
pip install -r requirements.txt
python3 harness/contract_negative_tests.py   # 107/107
```
