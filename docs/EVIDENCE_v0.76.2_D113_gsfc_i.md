# EVIDENCE v0.76.2 — D113 기록 확장: GSFC 인용을 개정판 I로 통합

**근거**: v43 원고 독립 메타리뷰(2026-10-04) R2. 검토자가 공식 PDF로 개정판 I를 대조했다. **새 실행 0, 평가 수치·판정 불변.**

## 1. 무엇이 바뀌었나

- 지금까지 원고는 GSFC 설계 규칙을 두 개정판으로 나눠 인용했다.
  - 개정판 I: RAM 마진 두 값(PDR 50%, Ship/Flight 30%), 마진 정의, *"경성 한계가 아니다"*. v30 원고 검토자가 확인했다(v0.73.2).
  - 개정판 H만: 서론의 Rule 3.07 서술(마진을 표에 대해 유지하고 핵심 결정 검토에 제시하며, 사용량을 단계별로 추정·분석·측정한다)과
    II.A의 *"대용량 저장소는 RAM 행에서 제외된다"*. 저자가 원문을 확인했다(v27).
- v43 검토자가 같은 공식 PDF(Rule 3.07·Table 3.07-1과 RAM 설명, 인쇄면 54–56쪽)로 다음을 확인했다.
  - 개정판 I의 Rule 3.07과 Table 3.07-1이 서론이 인용하는 마진 서술을 담는다. 개정판 I PDF의 Rule 3.07 개정 상태 표기는 H다(그 규칙은 H 이후 바뀌지 않았다).
  - RAM 설명은 대용량 메모리를 따로 추적하되, 처리기 카드에서 RAM·비휘발성 메모리와 구분되지 않는 공간을 공유하면 함께 추적한다는 예외를 둔다.
- 그래서 원고 v44는 GSFC를 **전부 개정판 I로** 인용한다.
  - II.A의 대용량 저장소 서술은 그 예외로 한정한다(*"tracks apart from its RAM row unless it shares processor-card memory not distinguished from RAM or nonvolatile memory"*).
  - *"부족분은 규칙 소유자와 협의한다"*는 H에서만 확인됐으므로 원고에서 뺐다.

## 2. 기록

`results/manuscript_evidence_records/records.json`(생성기 `harness/manuscript_evidence_records.py`):

- `review_confirmations.gsfc_std_1000i`
  - `confirmations`: v30 검토(2026-09-28)와 v43 검토(2026-10-04)가 각각 무엇을 확인했는지.
  - `manuscript_uses`: 서론의 Rule 3.07 서술과 II.A의 대용량 메모리 서술을 더했다.
  - `not_confirmed_here`: 부족분 협의 문구는 H에서만 확인됐고 원고 v44가 인용하지 않는다.
  - `manuscript_status`: 원고 v44부터 GSFC 인용은 전부 개정판 I.
  - 바이트·해시는 여전히 없다(검토자가 이 환경 밖에서 읽었다). 문서 주소도 싣지 않는다(검토문의 주소는 다시 임시 업로드 경로였다, v0.73.3).
- `author_confirmations.gsfc_std_1000h`: `manuscript_status`를 더했다(원고 v44는 H를 인용하지 않는다). 저자 확인 기록 자체는 그대로 둔다.
- E54 등급(`transcribed_from_directive_primary_blocked`)은 **고치지 않는다**. 그 등급은 이 환경이 받은 것을 말한다.

`CLAUDE.md` 가드레일의 *"Rule 3.07의 단계별 방법과 RAM 행의 대용량 저장소 제외는 여전히 H에서만 인용한다"*도 갱신했다(D65: 정정이 산문에만 남지 않게).

## 3. 가드

- `d113/14`: 기록이 두 검토를 순서대로 싣고, v43 검토가 Rule 3.07과 대용량 메모리 예외를 덮으며, H에서만 확인된 문구를 이름으로 적고, H 기록이 원고 v44에서 인용되지 않음을 적고, `CLAUDE.md`에 옛 가드레일 문장이 없다.
- **되돌림 실측**:
  - `CLAUDE.md`에 옛 문장을 되돌리면 `d113/14`가 FAIL한다.
  - 기록의 `not_confirmed_here`를 옛 값으로 되돌리면 `d113/1`(재유도 불일치)과 `d113/14`가 FAIL한다.
  - 원복하면 전부 PASS다.
- 이 컨테이너 **1034/1034 + 2 SKIP → 1035/1035 + 2 SKIP**.

## 4. 주장하지 않음

- 이 저장소가 개정판 I 원문을 취득·보관했다(호스트는 여전히 000이다).
- 같은 내용을 이 환경에서 독립 대조했다. 확인 주체는 검토자이고 기록은 그 사실을 적을 뿐이다.
