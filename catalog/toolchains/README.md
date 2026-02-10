# Toolchains

Cross-compilers and bare-metal toolchains in the catalog.

## Embedded toolchains

| Vendor     | Tool                     | Ref                                              | Notes |
|-----------|---------------------------|--------------------------------------------------|-------|
| riscv-gnu | riscv64-unknown-linux-gnu | `toolchain.riscv-gnu.riscv64-unknown-linux-gnu` | RISC-V Linux (glibc). Source: [riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain). |
| riscv-gnu | riscv32-unknown-elf       | `toolchain.riscv-gnu.riscv32-unknown-elf`        | RISC-V bare-metal. Source: riscv-collab. |
| avr-gnu   | avr-gcc                   | `toolchain.avr-gnu.avr-gcc`                     | AVR 8-bit. Source: [modm-io/avr-gcc](https://github.com/modm-io/avr-gcc). **SHA256**: If download verification fails, compute with `curl -sL <url> -o /tmp/f && sha256sum /tmp/f` and update the version YAML. |
| ti        | msp430-elf-gcc            | `toolchain.ti.msp430-elf-gcc`                   | TI MSP430. Source: [TI MSP430-GCC-OPENSOURCE](https://www.ti.com/tool/MSP430-GCC-OPENSOURCE). **SHA256**: TI provides MD5; compute SHA256 with `curl -sL <url> -o /tmp/f && sha256sum /tmp/f` and update the version YAML. |
| espressif | xtensa-esp-elf            | `toolchain.espressif.xtensa-esp-elf`            | Xtensa ESP32/ESP-IDF. Source: [espressif/crosstool-NG](https://github.com/espressif/crosstool-NG). |
