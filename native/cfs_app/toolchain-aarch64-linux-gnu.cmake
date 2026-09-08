# CMake toolchain file: cross-compile the whole cFS bundle (cFE + OSAL + PSP + every
# app in targets.cmake, including AI_LEARNER) for the E14 Stage 1 AArch64 guest
# (qemu-system-aarch64 -M virt -cpu cortex-a53, Ubuntu 24.04 arm64, glibc 2.39).
#
# Modeled on the bundle's Linux-on-ARM cross example
# (sample_defs/toolchain-arm-cortexa8_neon-linux-gnueabi.cmake) and the rpi variant
# (toolchain-arm-rpi-linux.cmake), but for the Debian/Ubuntu-packaged cross toolchain
# (gcc-13-aarch64-linux-gnu): the tools are on PATH under the "aarch64-linux-gnu-" prefix
# and the target libraries/headers live in the multiarch tree /usr/aarch64-linux-gnu
# (aarch64-linux-gnu-gcc -print-sysroot is "/", so no --sysroot flag is needed). That
# tree ships glibc 2.39 -- the SAME glibc as the guest -- so dynamic linking against it
# is valid for deployment in the guest (readelf -d must show only glibc NEEDED entries).
#
# cFE selects this file by name: SIMULATION=aarch64-linux-gnu -> "toolchain-${SIMULATION}.cmake"
# looked up first in ${MISSION_DEFS}/ (cfe/cmake/mission_build.cmake, process_arch()).
# scripts/51_build_cfs_aarch64.sh copies it into <cFS>/sample_defs/ and <cFS>/aarch64_defs/.

# Basic cross system configuration
set(CMAKE_SYSTEM_NAME       Linux)
set(CMAKE_SYSTEM_VERSION    1)
set(CMAKE_SYSTEM_PROCESSOR  aarch64)

set(TARGETPREFIX            "aarch64-linux-gnu-")

# Compiler and binutils (resolved on PATH; scripts/60_setup_aarch64_cross.sh installs them)
set(CMAKE_C_COMPILER        "${TARGETPREFIX}gcc")
set(CMAKE_CXX_COMPILER      "${TARGETPREFIX}g++")
set(CMAKE_ASM_COMPILER      "${TARGETPREFIX}gcc")
set(CMAKE_AR                "${TARGETPREFIX}ar")
set(CMAKE_RANLIB            "${TARGETPREFIX}ranlib")
set(CMAKE_NM                "${TARGETPREFIX}nm")
set(CMAKE_STRIP             "${TARGETPREFIX}strip")
set(CMAKE_OBJDUMP           "${TARGETPREFIX}objdump")
set(CMAKE_OBJCOPY           "${TARGETPREFIX}objcopy")

# Where the target environment is: the multiarch tree of the packaged cross toolchain.
set(CMAKE_FIND_ROOT_PATH    "/usr/aarch64-linux-gnu")

# search for programs (host tools such as elf2cfetbl helpers) in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM   NEVER)

# for libraries and headers only in the target directories (never pick host x86-64 libs)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY   ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE   ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE   ONLY)

# Target CPU: -mcpu=cortex-a53 (docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md SS5).
# The deployed IREE artifact is compiled for cortex-a53 (contract target.cpu, e14/aarch64),
# and the guest is booted with -cpu cortex-a53. Building cFE/OSAL/PSP and the apps with the
# same -mcpu keeps the whole deployed system on the CPU the experiment names: the compiler
# tunes for the in-order A53 pipeline and emits nothing beyond the ARMv8-A base ISA it has
# (no LSE/8.1+ instructions that a real A53 would SIGILL on), so the AI_LEARNER .so and the
# core executable make the same ISA assumption as the kernel code the contract was checked on.
# *_FLAGS_INIT only seeds CMAKE_C_FLAGS on the first configure of the arch build tree, which
# is exactly when cFE passes this file (process_arch adds -DCMAKE_TOOLCHAIN_FILE only when
# no CMakeCache.txt exists yet).
set(CPUTUNEFLAGS            "-mcpu=cortex-a53")
set(CMAKE_C_FLAGS_INIT      "${CPUTUNEFLAGS}")
set(CMAKE_CXX_FLAGS_INIT    "${CPUTUNEFLAGS}")
set(CMAKE_ASM_FLAGS_INIT    "${CPUTUNEFLAGS}")

# these settings are specific to cFE/OSAL and determine which abstraction layers are
# built when using this toolchain. "pc-linux" is the generic POSIX/Linux PSP (the bundle's
# arm and riscv64 Linux samples use it too -- it is not x86-specific).
set(CFE_SYSTEM_PSPNAME      "pc-linux")
set(OSAL_SYSTEM_OSTYPE      "posix")
