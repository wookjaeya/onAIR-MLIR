# EVIDENCE v0.73.2 — D113 기록 확장: GSFC-STD-1000I 검토자 확인과 artifact-only 판정 일치의 구성

**경위**: v30 원고 메타리뷰(2026-09-28, 저자가 전달)가 수정 의견 네 건을 냈다. 그중 두 건(의견 3·4)은 원고 문장이 기대는 사실이라,
원고(v31)를 고치면 **저장소 기록도 같이 맞춰야** 원고와 기록이 다시 어긋나지 않는다(D113과 같은 이유, D65 계열).
**평가 수치·판정은 바뀌지 않는다.**

## 1. GSFC-STD-1000I (의견 4)

### 1.1 무엇이 바뀌나

- v30 원고는 *"the cited revision has been superseded by one whose table was not examined"*라 적었고, D113 기록의 H 항목도
  *"revision I, whose table was not examined"*를 원고 사용처로 적었다.
- 메타리뷰는 **NASA 공식 GSFC-STD-1000I**(2025-08-19 승인, H 대체)를 확인했다고 적는다: Rule 3.07·Table 3.07-1(인쇄면 54–55쪽)의
  RAM margin은 PDR 50%·Ship/Flight 30%이고, 원고가 쓰는 두 값·마진 계산식·*표의 값이 일률적인 경성 한계가 아니라는 설명*이 유지된다.
- 원고 v31은 그 부분만 인용한다: *"revision I, which superseded it, retains both values, the margin definition and the statement that the
  values are not hard limits"* — 참고문헌에 GSFC-STD-1000I 항목을 추가했다.

### 1.2 기록

- **재프로브(2026-09-28)**: Rev I URL `curl` → `000`, WebFetch → `EGRESS_BLOCKED`. Rev H도 여전히 `000`. **바이트가 없다.**
- `harness/manuscript_evidence_records.py`에 `REVIEW_CONFIRMATIONS`를 신설했다. 저자 확인(`author_confirmations`)과 **따로** 둔다 —
  확인한 주체가 다르기 때문이다(저자가 아니라 검토자).
  - `bytes_in_repository: false`, `sha256: null`, 사유 기록(D113과 같은 원칙: 아무도 여기 바이트를 갖지 않은 문서의 해시는 지어낸 기록이다).
  - `not_confirmed_here`: 검토자가 확인한 것은 두 값·정의·경성 한계 아님이다. **Rule 3.07의 단계별 방법과 RAM 행의 대용량 저장소 제외는
    여전히 H에서만 인용된다**(원고도 그 두 곳은 H를 인용한다).
  - E54 등급은 **그대로** 둔다(`d113/3`).
- H 항목의 원고 사용처 문구를 갱신했다(*"not examined"* 제거, Rev I 기록을 가리킴).

## 2. artifact-only 판정 일치의 구성 (의견 3)

- 메타리뷰: VI.A의 *"24 budget cells"*와 V.C 표(7조건 × 4모델 = 28)가 같은 집합인지 알 수 없다.
- 원자료(`results/e59_info_levels_aarch64/part_a.json`): 24는 **네 모델 × 두 정책(`unconditional`·`conditional_map`) × 예산 세 개**
  (`band_above_B` = $B_u$, `band_between` = $P$, `band_below_P` = $P-1$)의 **정책 함수 평가**다. `fairness.models_run: 0`,
  `recompiled: 0` — **실행 셀이 아니다.** 표 7의 실행 셀과는 예산·정책 조합부터 다르다(표 7에는 $B_u-1$ 행이 있고 $P-1$은 조건부만 있다).
- 원고 v31은 개수 대신 구성을 적는다: *"Fed to one policy implementation under both policies at $B_u$, $P$ and $P-1$---policy evaluations,
  not executed cells---identical figures necessarily yield identical verdicts"*.
- 기록 `artifact_only_policy_evaluations`가 그 구성을 **매번 원자료와 네 문서의 수치에서 다시 유도**한다(각 모델의 세 예산이 그 모델의
  `bounded_bytes`·`per_call_bytes`·`per_call_bytes − 1`과 같은지까지).

## 3. 가드

| 가드 | 내용 | 되돌림 |
|---|---|---|
| `d113/5` | Rev I 검토 확인: 바이트 없음·해시 null·사유·`not_confirmed_here` 있음, H 항목에 *"not examined"* 없음 | Rev I에 가짜 해시 → FAIL · H에 *"not examined"* 복원 → FAIL |
| `d113/6` | artifact-only 일치 = 정책 평가 24건(4모델·2정책·$B_u$/$P$/$P-1$), 모델 실행 0, 불일치 0, 따름정리 주석 있음 | 평가 수 28로 변조 → FAIL |

세 되돌림 모두 `d113/1`(기록 = 재유도)도 함께 FAIL한다.

## 4. 수치

- 이 컨테이너: **1010/1010 + 2 SKIP → 1012/1012 + 2 SKIP**(새 파일을 스테이징한 뒤 실행). 두 SKIP은 네트워크가 필요한 E52 실입력 재실행이다.
- 보관 14개 계약 diff 0.

## 5. 주장하지 않음

- 이 저장소가 GSFC-STD-1000I를 **취득·보관·검증했다**고 쓰지 않는다. 기록은 검토자 확인의 기록이다.
- Rev I가 Rule 3.07의 단계별 방법이나 대용량 저장소 제외를 유지한다고 쓰지 않는다 — 확인되지 않았다.
- E59의 24건을 독립 측정이라 쓰지 않는다(D72).
