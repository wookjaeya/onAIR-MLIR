# AArch64 게스트 부팅 이력 (E25)

지침 §7의 실패 분류에서 **1번(빌드·배선·QEMU 환경 실패)**에 해당하는 사건만 기록한다.
의미 동치(§7-5·6)와 구분하기 위한 것이며, 계약·binding·수치 결과와 무관하다.

## 시도 1 — emergency mode (2026-09-09 ~07:00Z)

- `SMP=1 MEM=1024 bash scripts/71_boot_guest_aarch64.sh`
- 부팅 ~130초 지점까지 정상 진행(루트 `/dev/vda1` ext4 re-mount r/w 성공) 후:

```
[ TIME ] Timed out waiting for device dev-disk-by\x2dlabel-BOOT.device
[DEPEND] Dependency failed for boot.mount - /boot.
[DEPEND] Dependency failed for local-fs.target - Local File Systems.
[DEPEND] Dependency failed for boot-efi.mount - /boot/efi.
[ TIME ] Timed out waiting for device dev-disk-by\x2dlabel-UEFI.device
You are in emergency mode.
```

- 원인: `/boot`(label BOOT)와 `/boot/efi`(label UEFI) 장치가 나타나지 않아
  `local-fs.target` 의존성이 실패. **루트 파일시스템은 정상 마운트**됐고 실험에 `/boot`는
  필요하지 않다.
- 조치: `scripts/73_console.sh`의 양방향 시리얼 소켓으로 Ctrl-D(continue bootup) 전송.
  부팅이 재개되어 cloud-init까지 진행됐으나 **406초 지점에서 3분 이상 진전 없음**
  (sshd 미기동, cloud-init 미완료). 원시 로그: `boot_attempt1_serial.log`.
- 판정: 환경 실패. 재부팅으로 재시도한다.

이 저장소의 기존 기록(`docs/EVIDENCE_v0.9_E14_stage1.md` §9, `EVIDENCE_v0.12_E17.md`)도
이 게스트의 부팅 안정성을 일반화하지 않는다 — v0.9에서 무로그 크래시, v0.12에서 ~170초
정상 완료, 이번에 emergency mode. 표본이 작고 결과가 일정하지 않다.

---

## 시도 2 — sshd 도달 (~07:19–07:25Z), **시리얼 로그 미보존**

- 드라이버 로그: `boot_attempt2_driver.log` (pid 867, `guest up after ~370 s`).
- **원시 시리얼 로그가 남아 있지 않다.** `scripts/71_boot_guest_aarch64.sh:24`가 매 부팅마다
  `: > serial.log`로 잘라내므로, 시도 3의 부팅이 시도 2의 콘솔 기록을 덮어썼다.
- 따라서 **이 시도에서 emergency mode가 있었는지는 보존된 산출물로 확인할 수 없다.**
  `docs/EVIDENCE_v0.22_E25.md` §7은 "부팅이 두 번 emergency mode로 실패했다"고 서술하는데,
  그중 두 번째는 그 세션의 실시간 관찰에만 근거하며 이 저장소의 산출물로는 재현·검증되지 않는다.
  (철회가 아니라 **증거 등급의 명시**다. 시도 1은 아래 §대조표대로 산출물로 확인된다.)
- 확인 가능한 것: 이 부팅은 sshd까지 도달했다(시도 1은 도달하지 못했다).

## 디스크·부팅 설정 수정 (시도 2와 3 사이)

호스트에서 게스트 이미지를 열어 원인을 확인하고 고쳤다.

1. `qemu-img convert`로 qcow2 → raw, `losetup -o 1074790400`으로 루트 파티션을 loop 마운트.
2. `blkid`로 확인한 결과 **`BOOT`·`UEFI` label을 가진 파티션은 정상 존재**했다 —
   부재가 아니라 **게스트 커널의 장치 인식 지연**이 원인이다.
3. `/etc/fstab`의 `/boot`·`/boot/efi` 두 항목에 **`nofail`** 추가 →
   장치가 늦어도 `local-fs.target` 의존성이 실패하지 않는다. 실험에 `/boot`는 필요 없다.
4. `/etc/cloud/cloud-init.disabled` 생성 → 시도 1이 정체했던 지점 제거.
   **먼저** ssh 공개키가 호스트 키와 일치하고 sshd host key가 이미 디스크에 있음을 확인한 뒤
   비활성화했다(그러지 않으면 ssh 접속 수단 자체를 잃는다).
5. 백업: `~/onair-mlir-bench/ext/guest/aarch64-linux.qcow2.bak`.

**이 수정은 저장소 밖(게스트 이미지)에 있다.** 컨테이너가 새로 만들어지면
`scripts/70`+`71`로 게스트를 다시 만든 뒤 위 4단계를 **다시 적용해야 한다.**

## 시도 3 — 정상 부팅 (07:35–07:39Z), E25 AArch64 측정에 사용

- 드라이버 로그: `boot_attempt3_driver.log` (pid 1639, `guest up after ~205 s`).
- 원시 시리얼 로그: `boot_attempt3_serial.log`.
- 이 게스트에서 E25의 cFS AArch64 실행(`out_cfs_aarch64.bin`, `out_cfs_aarch64_run2.bin`)을 얻었다.

## 보존된 산출물 대조표 (수치로 확인 가능한 것만)

| | 시도 1 | 시도 3 |
|---|---|---|
| 원시 시리얼 로그 | `boot_attempt1_serial.log` (46,097 B) | `boot_attempt3_serial.log` (53,450 B) |
| 커널 배너(`Linux version`) | 1 | 1 |
| `You are in emergency mode` | **1** | **0** |
| `cloud-init` 언급 줄 | **33** | **0** (비활성화됨) |
| `Timed out waiting for device …by-label/{BOOT,UEFI}` | 있음 (치명적) | 있음 (**`nofail`로 비치명적**) |
| sshd 도달 | 아니오 | 예 (~205 s) |

장치 타임아웃 자체는 시도 3에서도 여전히 발생한다 — 고친 것은 **그것이 부팅을 멈추지 않게** 한
것이지 타임아웃의 원인이 아니다.

## 보존 결함 D46 (v0.22.1에서 수정)

이 디렉터리의 `*.log`는 **저장소에 커밋되지 않고 있었다.** `.gitignore:7`의 포괄 규칙 `*.log`에
대해 `results/e14_aarch64_qemu/**/*.log`만 예외로 두었기 때문이다. 그런데
`docs/EVIDENCE_v0.22_E25.md` §7은 *"상세와 원시 시리얼 로그: `results/e25_equivalence/aarch64_env/`"*
라고 서술한다 — 문서가 가리키는 근거가 클론에는 없었다.

E22가 F9에서 찾은 것과 **같은 계열**이다(회귀 시험이 요구하는 `dump/`가 `.gitignore`로 빠져
있었음). v0.22.1에서 `!results/e25_equivalence/**/*.log`(그리고 앞으로를 위해
`!results/e26_boundary_utility/**/*.log`)를 추가하고 위 로그들을 커밋했다.
