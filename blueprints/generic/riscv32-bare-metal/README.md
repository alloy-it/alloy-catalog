# Generic RISC-V 32-bit Bare-Metal Dev Environment

Board-agnostic cross-compilation toolchain for 32-bit RISC-V bare-metal targets
(`riscv32-unknown-elf`). Use this for any RISC-V 32-bit MCU running firmware directly
on the hardware (no OS).

> **Host platform:** Supported on `linux/amd64` only. No prebuilt `riscv32-unknown-elf`
> toolchain is available for `linux/arm64` hosts from upstream or Ubuntu apt.

## What's installed

| Component | Location |
| --- | --- |
| riscv32 GNU toolchain | `/opt/riscv/riscv32-elf/` |
| CMake toolchain file | `/opt/riscv/cmake/riscv32-elf.cmake` |

## Cross-compiling with CMake

```bash
cmake \
  -DCMAKE_TOOLCHAIN_FILE=/opt/riscv/cmake/riscv32-elf.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -B build
cmake --build build
```

## Cross-compiling directly

```bash
source /etc/profile.d/22-riscv32-toolchain.sh
riscv32-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -o firmware.elf main.c
riscv32-unknown-elf-objcopy -O binary firmware.elf firmware.bin
```

## Supported targets

| Target | Arch | Notes |
| --- | --- | --- |
| WCH CH32V203 | rv32imac | Popular cheap RISC-V MCU |
| WCH CH32V305/307 | rv32imafc | Higher-performance CH32V |
| SiFive FE310 | rv32imac | Original HiFive1 MCU |
| GigaDevice GD32VF103 | rv32imac | Popular RISC-V Cortex clone |
| ESP32-C3 | rv32imc | Espressif Wi-Fi SoC |
| ESP32-C6 | rv32imac | Espressif Wi-Fi/BLE SoC |

## Bare-metal vs Linux

This blueprint targets bare-metal firmware (no OS). For RISC-V Linux applications
targeting boards like SiFive HiFive Unmatched or StarFive VisionFive 2, use the
`generic/riscv` blueprint instead (provides `riscv64-unknown-linux-gnu`).

## Toolchain source

Prebuilt from [riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
releases (catalog entry: `toolchain.riscv-gnu.riscv32-unknown-elf@stable`).
