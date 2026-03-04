# nxp/imxrt1060-evk

Bare-metal cross-compilation environment for the NXP i.MX RT1060 — Cortex-M7 at 600 MHz
with 2 MB on-chip SRAM and FlexSPI XIP support. Powers millions of Teensy 4.x units and
SparkFun MicroMod boards.

## Supported boards

| Board | SoC | Core |
| --- | --- | --- |
| MIMXRT1060-EVKB | i.MX RT1060 | Cortex-M7 @ 600 MHz |
| SparkFun MicroMod | i.MX RT1060 | Cortex-M7 @ 600 MHz |
| Teensy 4.0 | i.MX RT1062 | Cortex-M7 @ 600 MHz |
| Teensy 4.1 | i.MX RT1062 | Cortex-M7 @ 600 MHz |

## What's installed

- **arm-none-eabi** toolchain (ARM GNU, from catalog)
- CMake toolchain file at `/opt/nxp/cmake/imxrt1060.cmake` (M7 CPU flags pre-set)
- udev rules for J-Link, MCU-Link, and LPC-Link2 debug probes
- Build tools: `cmake`, `ninja`, `make`

## Toolchain details

| Field | Value |
| --- | --- |
| Prefix | `arm-none-eabi-` |
| CPU flags | `-mcpu=cortex-m7 -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb` |
| FPU | FPv5-D16 (double-precision) |
| Installed to | `/opt/nxp/imxrt1060/toolchain` |

## Quick start

```bash
# Direct compile
arm-none-eabi-gcc -mcpu=cortex-m7 -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o app.elf main.c

# CMake project (CPU flags applied automatically via toolchain file)
cmake -DCMAKE_TOOLCHAIN_FILE=/opt/nxp/cmake/imxrt1060.cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build
```

## Debug probe udev rules

Pre-configured for:

- **J-Link** (SEGGER, VID `1366`) — used on MIMXRT1060-EVKB
- **MCU-Link** (NXP, VID `1fc9` PID `0143`) — newer EVK revisions
- **LPC-Link2** (NXP, VID `1fc9` PID `0090`) — legacy

## Environment variables

| Variable | Value |
| --- | --- |
| `CROSS_COMPILE` | `arm-none-eabi-` |
| `PATH` | includes `/opt/nxp/imxrt1060/toolchain/bin` |
