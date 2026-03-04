# Generic Rust Embedded Dev Environment

Rust embedded development environment with cross-compilation support for ARM Cortex-M
and RISC-V 32-bit MCUs, plus the [probe-rs](https://probe.rs) unified flashing and
debugging toolkit.

## What's installed

| Component | Location | Version |
| --- | --- | --- |
| Rust (stable) | `/usr/local/cargo/bin/` | stable via rustup |
| rustup | `/usr/local/bin/rustup` | latest |
| probe-rs | `/usr/local/cargo/bin/probe-rs` | 0.24.0 |
| flip-link | `/usr/local/cargo/bin/flip-link` | 0.1.9 |
| cargo-binutils | `/usr/local/cargo/bin/cargo-*` | 0.3.6 |
| udev rules | `/etc/udev/rules.d/99-probe-rs.rules` | — |

## Installed cross-compilation targets

| Target | Architecture | Example MCUs |
| --- | --- | --- |
| `thumbv6m-none-eabi` | Cortex-M0/M0+ | RP2040, STM32F0, nRF51 |
| `thumbv7m-none-eabi` | Cortex-M3 | STM32F1/F2, LPC1768 |
| `thumbv7em-none-eabi` | Cortex-M4 (no FPU) | STM32F3, nRF52 |
| `thumbv7em-none-eabihf` | Cortex-M4F | STM32F4/F7, nRF52840 |
| `thumbv8m.main-none-eabi` | Cortex-M33 (no FPU) | STM32L5, nRF9160 |
| `thumbv8m.main-none-eabihf` | Cortex-M33F | STM32U5, LPC55S69 |
| `riscv32imac-unknown-none-elf` | RISC-V 32 (IMAC) | CH32V, GD32VF103 |
| `riscv32imc-unknown-none-elf` | RISC-V 32 (IMC) | ESP32-C3/C6 |

## Quick start

```bash
source /etc/profile.d/40-rust.sh

# Generate a new embedded project (Cortex-M4F)
cargo generate --git https://github.com/rust-embedded/cortex-m-quickstart \
  --name my-app

cd my-app

# Build for STM32F4 (Cortex-M4F with FPU)
cargo build --target thumbv7em-none-eabihf

# Flash and run via probe-rs
probe-rs run --chip STM32F411RETx \
  target/thumbv7em-none-eabihf/debug/my-app
```

## Embassy (async embedded Rust)

```bash
# Clone an Embassy example for STM32
git clone https://github.com/embassy-rs/embassy
cd embassy/examples/stm32f4

cargo build --target thumbv7em-none-eabihf
```

## Supported debug probes (udev rules pre-installed)

| Probe | Supported MCU families |
| --- | --- |
| CMSIS-DAP v1/v2 (DAPLink) | All Cortex-M |
| ST-LINK/V2, V2-1, V3 | STM32, STM8 |
| J-Link | All Cortex-M, RISC-V |
| WCH-Link | CH32V series |
| Raspberry Pi Debug Probe | RP2040, any SWD |

## flip-link (stack overflow protection)

[flip-link](https://github.com/knurling-rs/flip-link) moves the call stack below
the `.bss`/`.data` sections so a stack overflow immediately triggers a hard fault
rather than silently corrupting data:

```toml
# .cargo/config.toml
[target.thumbv7em-none-eabihf]
linker = "flip-link"
```
