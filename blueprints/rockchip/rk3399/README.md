# Rockchip RK3399 Dev Environment

Cross-compilation toolchain for the Rockchip RK3399 SoC (dual Cortex-A72 + quad
Cortex-A55, aarch64). Use this to build Linux applications, kernel modules, and
bootloaders for RK3399-based boards.

## What's installed

| Component             | Location                           |
| --------------------- | ---------------------------------- |
| aarch64 GNU toolchain | `/opt/rockchip/rk3399/toolchain/`  |
| CMake toolchain file  | `/opt/rockchip/cmake/rk3399.cmake` |

## Cross-compiling with CMake

```bash
cmake \
  -DCMAKE_TOOLCHAIN_FILE=/opt/rockchip/cmake/rk3399.cmake \
  -B build
cmake --build build
```

## Cross-compiling directly

```bash
source /etc/profile.d/21-rockchip-rk3399-toolchain.sh
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## Supported boards

| Board                | Notes                          |
| -------------------- | ------------------------------ |
| Pine64 ROCKPro64     | Popular open-source RK3399 SBC |
| Pinebook Pro         | ARM laptop                     |
| Khadas Edge / Edge-V | Compact RK3399 module          |
| NanoPC-T4            | FriendlyELEC RK3399 SBC        |
| Firefly RK3399       | Development board              |
| Rock Pi 4            | Radxa community board          |

## BSP / Yocto builds

For full image builds (kernel + rootfs + bootloader), layer the
`generic/yocto-image-builder` blueprint on top and add your board's BSP layer
(e.g. `meta-rockchip`).

## Toolchain source

Prebuilt from [ARM GNU Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain)
(catalog entry: `toolchain.arm-gnu.aarch64-none-linux-gnu@stable`).
