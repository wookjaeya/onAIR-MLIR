# E14 Stage 1 — qemu-system-aarch64 Linux 게스트 + cFS 통합 (Claude Code에서 이어서)

이 문서는 `docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md`(외부 제안, 원문 보존)의
§7·§10·§11·§12·§17을 실행하기 위한 계획이다. **Stage 0**(교차 컴파일 + 구조 분석 +
`qemu-aarch64` user-mode 빠른 확인)은 이 세션에서 완료했다(`docs/EVIDENCE_v0.8_E14_aarch64.md`).
Stage 1(시스템 전체 에뮬레이션 + cFS-in-guest)은 다음 이유로 이 세션에서 미루고
Claude Code로 이관한다.

## 왜 이 세션에서 안 했는가 (솔직한 사유)

1. **게스트 디스크 이미지가 필요**: `qemu-system-aarch64`는 부팅 가능한 AArch64 Linux
   이미지(수백 MB~수 GB, 예: Ubuntu/Debian cloud image)가 있어야 한다. 이 세션(claude.ai
   공유 VM)은 세션 종료 시 파일시스템이 초기화되므로, 큰 이미지를 받아도 다음 세션에서
   사라진다 — Claude Code의 영속 파일시스템에서 하는 것이 맞다.
2. **부팅·자동화 반복**: 게스트 안에서 cFS를 빌드/실행하려면 SSH 포트포워딩(`hostfwd`) 또는
   시리얼 콘솔 스크립팅으로 여러 번 왕복해야 한다. 이런 반복 상호작용은 대화형 도구 호출보다
   터미널 세션이 유지되는 환경(Claude Code)에서 훨씬 빠르다 — `CLAUDE.md`에서 이미 지적한
   "Claude Code가 나은 이유"와 정확히 같은 이유다.
3. **시간**: 이미지 다운로드 + 최초 부팅 + cFS 크로스/네이티브 빌드는 단일 대화 턴 예산을
   넘어설 가능성이 크다.

## Stage 0에서 이미 확인된 것 (Stage 1의 전제)

Stage 1을 시작하기 전에 알아야 할 사실 — 다시 검증할 필요 없음:

| 항목 | 결과 |
|---|---|
| AArch64 vmfb 컴파일 | 성공, 단일 호출 (`scripts/62_compile_and_check_aarch64.sh`) |
| bounded_bytes (x86-64 vs AArch64) | **동일** (786,476) — `iree-stream-layout-slices`가 타깃 코드생성 이전이라 메모리 계획 자체는 ISA 무관 |
| Native 실행 (qemu-user, 참고용) | HAL 피크=bounded 일치, 정상 상태 per-call=65,544 일치, 경계값 B-1/B/B+1 정확, 모델 교체 거부, out0=4.432073(x86-64와 수치 일치) |
| AArch64 코드생성 구조 | LLVM alloca 0, malloc 0, ELF call 0. **단, 두 dispatch 함수 모두 16바이트 AAPCS64 표준 프롤로그(`stp x29,x30`) 사용** — x86-64(SysV leaf, 프레임 없음)에는 없던 것. 추가 지역변수 스필은 없음(`sub sp` 없음) |
| 벡터 ISA 차이 | AArch64 NEON(v.4s, 4-wide, fmla 14개) vs x86-64 host(AVX-512, 16-wide, fma 34개) |
| 동적 형상 | AArch64에서도 `all_sizes_static=false` → UNKNOWN_BOUND, 정책상 거부 |

**AArch64 16바이트 스택 프레임의 처리**: 제안서 §9.2의 4분류 중 **(2) 태스크 스택 예산**으로
분류한다(HAL per-call/상수 계약이 커버하는 힙·중간버퍼 영역이 아니라 OS 태스크 스택 위에 있는
값이므로). 크기가 극히 작아(호출당 16 B, 순차 실행이라 누적 없음) 실질적 위험은 낮지만,
Stage 1의 cFS 앱에서는 **명시적으로 태스크 스택 크기 설정(startup script의 스택 필드)에
여유로 반영**할 것 — 계약 밖 미회계로 방치하지 말 것(제안서 §14 필수 합격 기준 8).

## Stage 1 실행 순서 (Claude Code에서)

```bash
# 1. 호스트 도구 (이미 Stage 0에서 설치했다면 스킵)
bash scripts/60_setup_aarch64_cross.sh

# 2. 게스트 이미지 준비 (제안서 SS7.1) — 예시, 실제 경로로 교체
#    권장: Ubuntu Server 24.04 aarch64 cloud image (또는 Debian 12 generic-arm64)
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img -O aarch64-linux.qcow2
qemu-img resize aarch64-linux.qcow2 +8G
# cloud-init로 root 계정·SSH 키 주입 (cloud-localds 등 사용) — 최초 1회

# 3. UEFI 펌웨어 확보 (배포판 패키지 qemu-efi-aarch64 등)
apt-get install -y qemu-efi-aarch64
QEMU_AARCH64_EFI=/usr/share/AAVMF/AAVMF_CODE.fd  # 경로는 배포판에 따라 다름

# 4. 부팅 (제안서 SS7.1 그대로, SSH 포트 2222로 포워딩)
qemu-system-aarch64 -machine virt,gic-version=3 -cpu cortex-a53 -smp 1 -m 1024 \
  -bios "$QEMU_AARCH64_EFI" -drive if=virtio,file=aarch64-linux.qcow2,format=qcow2 \
  -device virtio-net-device,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -nographic &

# 5. 게스트 확인 (제안서 SS7.2)
ssh -p 2222 root@localhost 'uname -a; uname -m; getconf LONG_BIT'
# 기대: aarch64, LP64

# 6. 게스트 안에서 cFS 빌드 (최초 구축은 네이티브 빌드 권장 — 제안서 SS7.2)
#    scripts/10_build_cfs.sh, scripts/50_wire_cfs_ai_learner.sh를 게스트 안에서 실행
#    (AI_LEARNER의 CMakeLists.txt가 참조하는 IREE_SRC 경로를 게스트 내 경로로 조정할 것 —
#     scripts/61_build_iree_runtime_aarch64.sh로 만든 aarch64 런타임을 게스트로 복사하거나
#     게스트 안에서 네이티브로 다시 빌드해도 됨. 최초엔 후자가 디버깅이 쉬움 — 제안서 SS7.2.)

# 7. 시나리오 A1-A7 실행 (제안서 SS11.2 표 그대로)
#    A1 정상, A2 budget=B-1 거부, A3 모델 교체 거부, A4 파일 부재, A5 손상 vmfb,
#    A6 반복 추론 카운터 일치, A7 재시작 시 이중 해제 없음
```

## 모델 세트 확장 (제안서 §12)

Stage 0은 MLP 1종만 다뤘다. Stage 1에서 반드시 추가할 것 — **단일 MLP로 교차 ISA
일반성을 주장하지 않는다**는 제안서 원칙을 지킨다:

| 모델 | 상태 | 비고 |
|---|---|---|
| MLP (h=16384, 베이킹) | Stage 0 완료 | `e14/aarch64/` |
| 동적 형상 | Stage 0 완료 | UNKNOWN_BOUND 확인 |
| **소형 Conv2D** | 미착수 | tiling·workspace 구조 확인 — `harness/`에 생성기 없음, 새로 작성 필요 |
| **Residual/multi-branch** | 부분 참고 가능 | `harness/structural_cases.py`의 `B_lifetime_reuse`(비중첩 수명)·`D_fusion`이 근접 사례; 제안서가 요구하는 "분기 후 합류" 구조는 아니므로 신규 작성 권장 |

## 산출물 배치 규칙

제안서 §15 디렉터리 구조를 따른다. 이미 있는 `e14/aarch64/`를 그 구조의 `aarch64/` 하위로
재배치하거나, `results/e14_aarch64_qemu/`를 새로 만들고 Stage 0 산출물을 복사해도 된다 —
어느 쪽이든 `EXPERIMENT_LOG.md`에 실제 경로를 기록할 것.

## 합격/실패 기준

제안서 §14를 그대로 채택한다. 특히 8번("커널의 계약 밖 메모리가 없거나 별도 예산으로
명시됨")은 Stage 0에서 발견한 16바이트 스택 프레임 때문에 **자동 통과가 아니다** — 위
"Stage 0에서 이미 확인된 것" 절의 처리 방침(태스크 스택 예산에 명시적으로 반영)을 Stage 1의
cFS 앱 빌드에 실제로 적용하고, 적용했다는 근거를 남길 것.

## 결과 해석 원칙 (제안서 §19, 그대로 적용)

QEMU(user-mode든 system-mode든) 실행시간·RSS·jitter는 **연구 근거로 쓰지 않는다.**
Stage 0의 `qemu-aarch64` 측정값(median 1807 µs 등)도 이미 이 규칙으로 배제했다 —
Stage 1에서도 동일하게 모든 시간·RSS 수치 옆에 "QEMU 결과, 증거 아님"을 명시할 것.
