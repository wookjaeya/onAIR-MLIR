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
