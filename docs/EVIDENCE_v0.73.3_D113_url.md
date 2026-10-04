# EVIDENCE v0.73.3 — D113 기록 정리: GSFC-STD-1000I 항목의 주소 제거

**경위**: v0.73.2는 `results/manuscript_evidence_records/records.json`의 `review_confirmations.gsfc_std_1000i`에 `url` 필드를 두고, v30 원고 검토문이
적어 준 `standards.nasa.gov`의 `/system/files/tmp/…` 경로를 넣었다. 원고 v31의 참고문헌 항목도 처음에는 같은 주소를 썼다. 저자가 그 주소는 문서 주소가 아니라고
지적했다. **평가 수치·판정은 바뀌지 않는다.**

## 1. 무엇이 틀렸나

- 경로에 `tmp`가 들어 있는 **임시 업로드 경로**이고, 문서의 안정된 위치가 아니다(개정판 H 항목의 주소는 `/sites/default/files/standards/GSFC/H/0/…` 형태다).
- 이 환경은 그 주소를 한 번도 열지 못했다(재프로브 `curl` → `000`, WebFetch → `EGRESS_BLOCKED`). 즉 **이 저장소는 그 주소가 문서를 가리킨다는 근거를 가진 적이 없다.**
- 그런데도 기록은 그것을 문서의 `url`로 실었다 — 받은 문자열을 확인 없이 문서 속성으로 옮긴 것이다(D65 계열: 검토문에 있다는 것과 문서의 성질이라는 것은 다르다).

## 2. 고친 것

- `harness/manuscript_evidence_records.py`: `url: None`과 `url_note`(사유: 임시 업로드 경로였고 안정된 위치가 아니며, 표준은 번호·발행 기관·승인일로 식별된다).
- 재프로브는 `url: "same as above"` 대신 `host: "standards.nasa.gov"`. `000`은 호스트 단위 관측(프록시 allowlist 거부, E55/P0-1)이라 호스트만으로 뜻이 같다.
- 원고 v31의 참고문헌 항목에서도 URL을 뺐다(번호 GSFC-STD-1000I, NASA GSFC, 2025년 8월, "Supersedes GSFC-STD-1000H").

## 3. 고치지 않은 것 (의도)

같은 주소가 세 곳에 더 있다. 전부 **그때 무엇을 받았고 무엇을 재 봤는지의 원자료**라 규율 3·5대로 고쳐 쓰지 않는다.

| 파일 | 성격 |
|---|---|
| `docs/reviews/MANDATORY_FOLLOWUPS_v0.57_RECOMMENDATION.md` | 보존 원문 지시서(sha256 고정). 지시서가 준 주소 |
| `results/e55_mandatory_followups/p0_1_sources/nasa_probe_log.json` | E55/P0-1 프로브 원자료. 그 주소를 재 보고 `000`을 받았다는 기록 |
| `docs/EVIDENCE_v0.58_E55.md` | E55 당시 판정 문서. 지시서가 준 경로를 인용 |

## 4. 가드

| 가드 | 내용 | 되돌림 |
|---|---|---|
| `d113/7` | Rev I 기록의 `url`이 null이고 사유가 있으며, 재프로브에 주소가 없고, `records.json`에 `/system/files/tmp/`가 없다 | 옛 생성기·기록 복원 → FAIL |

## 5. 수치

- 이 컨테이너: **1012/1012 + 2 SKIP → 1013/1013 + 2 SKIP**(새 파일을 스테이징한 뒤 실행). 보관 14개 계약 diff 0.

## 6. 주장하지 않음

- 개정판 I의 **올바른 주소**를 안다고 쓰지 않는다. 이 환경은 그 호스트에 닿지 않는다.
- 이 정리가 검토자 확인의 내용(두 RAM 마진·마진 정의·경성 한계 아님)을 바꾸지 않는다.
