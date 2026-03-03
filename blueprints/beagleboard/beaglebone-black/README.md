# BeagleBone Black

Cross-compilation environment for BeagleBone Black (TI AM335x, ARM Cortex-A8, armhf).

## What this blueprint provides

- Build tools (git, cmake, ninja, device-tree-compiler, u-boot-tools)
- Go SDK (from catalog) for host builds
- ARM 32-bit toolchain (arm-none-linux-gnueabihf) and CMake toolchain file

## Usage

After provisioning, cross-compile with:

- `CROSS_COMPILE=arm-none-linux-gnueabihf-` and the toolchain on PATH, or
- `cmake -DCMAKE_TOOLCHAIN_FILE=/opt/cross-beaglebone/cmake/beaglebone-black.cmake ...`

For a full BSP or rootfs, use TI Processor SDK or Buildroot/Yocto in a separate workflow; this blueprint focuses on application cross-compilation.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TOOLCHAIN_DEST` | `/opt/cross-beaglebone/arm-linux-gnueabihf` | ARM toolchain install path |
| `TOOLCHAIN_FILES_DIR` | `/opt/cross-beaglebone/cmake` | CMake toolchain file directory |
