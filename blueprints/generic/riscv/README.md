# Generic RISC-V Dev Environment

Board-agnostic cross-compilation toolchain for 64-bit RISC-V Linux targets.
Use this for any RISC-V SBC or SoC running a Linux-based operating system.

## What's installed

| Component             | amd64 host                                 | arm64 host                       |
| --------------------- | ------------------------------------------ | -------------------------------- |
| riscv64 GNU toolchain | `/opt/riscv/riscv64-linux-gnu/` (prebuilt) | `/usr/bin/` (apt)                |
| Compiler prefix       | `riscv64-unknown-linux-gnu-`               | `riscv64-linux-gnu-`             |
| CMake toolchain file  | `/opt/riscv/cmake/riscv64.cmake`           | `/opt/riscv/cmake/riscv64.cmake` |

### Host platform notes

- **`linux/amd64`**: installs the riscv-collab prebuilt toolchain from the Alloy catalog
  (`toolchain.riscv-gnu.riscv64-unknown-linux-gnu@stable`).
- **`linux/arm64`**: installs `gcc-riscv64-linux-gnu` from Ubuntu apt (no upstream prebuilt
  is available for arm64-hosted riscv64 cross-compilers). The compiler prefix differs
  (`riscv64-linux-gnu-` instead of `riscv64-unknown-linux-gnu-`); the CMake file handles
  this automatically.

## Cross-compiling with CMake

The CMake toolchain file works on both host architectures — it automatically references
the correct compiler path and prefix for the host.

```bash
cmake \
  -DCMAKE_TOOLCHAIN_FILE=/opt/riscv/cmake/riscv64.cmake \
  -B build
cmake --build build
```

## Cross-compiling directly

On **amd64**:

```bash
source /etc/profile.d/21-riscv-toolchain.sh
riscv64-unknown-linux-gnu-gcc -o hello hello.c
```

On **arm64**:

```bash
source /etc/profile.d/21-riscv-toolchain.sh
riscv64-linux-gnu-gcc -o hello hello.c
```

Or use `$CROSS_COMPILE` (set by the profile script on both hosts):

```bash
source /etc/profile.d/21-riscv-toolchain.sh
${CROSS_COMPILE}gcc -o hello hello.c
```

## Supported boards

Any board running a 64-bit RISC-V Linux OS, including:

| Board                   | SoC          | Notes                |
| ----------------------- | ------------ | -------------------- |
| SiFive HiFive Unmatched | U740         | Desktop-class RISC-V |
| StarFive VisionFive 2   | JH7110       | Popular SBC          |
| Milk-V Pioneer          | SG2042       | 64-core server       |
| Milk-V Mars             | JH7110       | Compact SBC          |
| Nezha D1                | Allwinner D1 | Entry-level RISC-V   |
| LicheePi 4A             | TH1520       | High-performance SBC |

## Bare-metal / RTOS targets

This blueprint targets Linux userspace applications. For bare-metal firmware or RTOS
(e.g., FreeRTOS on RISC-V microcontrollers like ESP32-C3/C6), you need the ELF toolchain
variant (`riscv32-unknown-elf` or `riscv64-unknown-elf`) — a separate blueprint.

## Toolchain source

- **amd64**: prebuilt binaries from
  [riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
  releases (catalog entry: `toolchain.riscv-gnu.riscv64-unknown-linux-gnu@stable`).
- **arm64**: `gcc-riscv64-linux-gnu` Ubuntu package (Debian multiarch cross-compiler).
