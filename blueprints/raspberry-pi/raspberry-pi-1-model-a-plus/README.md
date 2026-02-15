# Raspberry Pi 1 Model A+ Development Environment Blueprint

This blueprint sets up a complete cross-compilation development environment for Raspberry Pi 1 Model A+ on Linux hosts (amd64 and arm64).

## What's Included

- **Go 1.24.4** - Latest Go toolchain
- **Sysroot** - Raspberry Pi system libraries
- **ARM 32-bit Toolchain** - GCC 13.3 for Raspberry Pi OS 32-bit (armhf)
- **QEMU** - ARM emulation for testing binaries
- **CMake Toolchain Files** - Ready-to-use toolchain files for CMake projects

## Directory Structure

```text
raspberry-pi/
├── manifest.yml        # Main entry point with variables
├── 00-system-base.yml  # Base packages and QEMU setup
├── 10-host-tools.yml   # Go and host build tools
├── 20-toolchain.yml    # ARM cross-compilers
└── 99-cleanup.yml      # Final cleanup
```

## Installed Paths

| Component              | Path                                  |
| ---------------------- | ------------------------------------- |
| Go                     | `/usr/local/go`                       |
| 32-bit ARM Toolchain   | `/opt/cross-pi/arm-linux-gnueabihf`   |
| CMake Toolchain Files  | `/opt/cross-pi/cmake/`                |
| Sysroot                | `/opt/cross-pi/sysroot`               |

## Environment Variables

After provisioning, the following environment variables are available:

```bash
# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

# 32-bit cross-compiler
export CROSS_COMPILE_32=arm-none-linux-gnueabihf-
```

## Usage Examples

### Cross-compile a C program for 32-bit Raspberry Pi

```bash
arm-none-linux-gnueabihf-gcc -o myapp myapp.c
```

### Use with CMake (32-bit)

```bash
cmake -DCMAKE_TOOLCHAIN_FILE=/opt/cross-pi/cmake/raspi-32bit.cmake ..
make
```

## Supported Host Architectures

This blueprint supports both:

- **amd64** - Intel/AMD 64-bit hosts (x86_64)
- **arm64** - ARM 64-bit hosts (Apple Silicon, ARM servers)

The correct toolchain binaries are automatically selected based on the host architecture using the `per_arch` mechanism.
