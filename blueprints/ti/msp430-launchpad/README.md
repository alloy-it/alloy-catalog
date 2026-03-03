# TI MSP430 LaunchPad Dev Environment

Development environment for Texas Instruments MSP430 microcontrollers using the
open-source MSP430 GCC toolchain (formerly Mitto Systems). Targets any MSP430 LaunchPad
kit or custom MSP430-based board.

> **Host platform:** Supported on `linux/amd64` only. TI does not publish an arm64
> prebuilt for the MSP430 GCC toolchain, and Ubuntu apt does not carry it for arm64.

## What's installed

| Component | Location |
| --- | --- |
| MSP430 GCC toolchain | `/opt/ti/msp430-gcc/` |
| udev rules | `/etc/udev/rules.d/99-msp430.rules` |

## Compiling

```bash
source /etc/profile.d/31-msp430-toolchain.sh

# Compile
msp430-elf-gcc -mmcu=msp430g2553 -Os -o blink.elf blink.c

# Convert to Intel HEX for flashing
msp430-elf-objcopy -O ihex blink.elf blink.hex
```

## Supported LaunchPad kits

| Board | MCU | Notes |
| --- | --- | --- |
| MSP-EXP430G2ET | MSP430G2553 | Classic value line LaunchPad |
| MSP-EXP430F5529LP | MSP430F5529 | USB-capable LaunchPad |
| MSP-EXP430FR6989 | MSP430FR6989 | FRAM-based LaunchPad |
| MSP-EXP430FR2355 | MSP430FR2355 | Low-power FRAM LaunchPad |

## GCC target flags by MCU family

| Family | `-mmcu` flag | Notes |
| --- | --- | --- |
| Value Line (G2xxx) | `-mmcu=msp430g2553` | 16 MHz, 512 B SRAM |
| F5xx/F6xx | `-mmcu=msp430f5529` | USB, 25 MHz |
| FRxx (FRAM) | `-mmcu=msp430fr6989` | Non-volatile SRAM |

## Toolchain source

TI MSP430 GCC (open-source build by Mitto Systems):
[ti.com/tool/MSP430-GCC-OPENSOURCE](https://www.ti.com/tool/MSP430-GCC-OPENSOURCE)
(catalog entry: `toolchain.ti.msp430-elf-gcc@stable`).
