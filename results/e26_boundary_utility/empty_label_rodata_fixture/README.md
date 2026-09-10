# 빈 백틱 라벨 rodata — 실물 근거 (E26b / D48)

`iree-dump-module`이 embedded `.rodata` 세그먼트의 내용을 **백틱 사이에** 렌더링하는데,
내용이 인쇄 가능해 보이면 그렇게 한다. 그래서 **첫 바이트가 NUL인 진짜 상수 블록**은
빈 백틱 쌍(`` `` ``)으로 출력된다.

```
  .rodata[  0] embedded     2816 bytes ``          <- 진짜 f32 상수 2,816 B
  .rodata[  1] embedded       13 bytes `hal.device.id`
  .rodata[  2] embedded        6 bytes `local*`
  ...
  .rodata[  5] external     5040 bytes (offset 112 / 70h to 1420h)
```

`static_mem_bound.py`의 옛 판별식은 `"`" not in rest`(백틱이 있으면 데이터가 아님)라서
**2,816 B를 관측 상수 총합에서 버렸다.** 그러면 계약이 서명한 `module_resident_constant_bytes`
(2,816)와 관측이 모순되고, N1/D28의 상수 게이트가 — **자기가 들은 정보 기준으로는 옳게** —
모델을 거부한다. 그 거부를 뚫으려면 `--allow-unconfirmed-constants`가 필요한데, 그러면
계약이 `verification_grade: overridden`이 되고 E24b/D39의 헤더 게이트가 다시 거부한다.

**정직한 f32 모델이 배치 가능한 헤더를 만들 수 없었다** — 유형 (B) 과잉 거부다.

## 판별식 (E26b에서 수정)

라벨의 **길이**로 가른다: IREE는 문자열 세그먼트의 내용을 전부 출력하므로 진짜 문자열이면
`len(label) == nbytes`다. 저장소의 모든 보관 산출물 + 조사용 모델의 백틱 rodata 줄
**137개 중 136개가 이 성질을 만족**하고, 유일한 예외가 바로 위의 오분류된 데이터 세그먼트다.

모호하면 **데이터로 분류**한다 — 이 방향이 보수적이다. 상수를 과다 계상하면 크로스체크가
거부해서 **눈에 보이고**, 과소 계상하면 틀린 값을 조용히 통과시킨다.

## 파일

| 파일 | 무엇 |
|---|---|
| `empty_label_rodata.vmfb` | 이 현상을 보이는 실물 vmfb (15,562 B) |
| `empty_label_rodata.dump_module.txt` | 그 `iree-dump-module` 출력 (원본 증거) |

이 모델은 조사 과정에서 만들어진 f32 모델이며(9×64×2 위상), 계약은
`bounded=3116 per_call=300 constants=2816`이다. **정확도나 임무 대표성과는 무관하고**,
여기서 쓰는 목적은 오직 이 파서 조건의 재현이다.

## 한계

- 이 fixture는 `iree-dump-module`(IREE 3.11.0rc20260316) 출력 형식에 의존한다. 다른 버전이
  라벨을 다르게 렌더링하면 판별식을 다시 확인해야 한다 — 시험이 그 지점을 고정한다.
- MLIR 소스는 보존하지 않았다(조사용 임시 모델). 재현에 필요한 것은 vmfb와 그 덤프뿐이다.
