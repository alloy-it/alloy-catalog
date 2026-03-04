# Rockchip RK3588 Dev Environment

Cross-compilation toolchain for the Rockchip RK3588 SoC (Cortex-A76 + Cortex-A55, aarch64).

Used in: Orange Pi 5, Rock 5B, Radxa CM5, and other RK3588-based boards.

## What's installed

| Component             | Location                           |
| --------------------- | ---------------------------------- |
| aarch64 GNU toolchain | `/opt/rockchip/aarch64-linux-gnu/` |
| CMake toolchain file  | `/opt/rockchip/cmake/rk3588.cmake` |

## Cross-compiling with CMake

```bash
cmake \
  -DCMAKE_TOOLCHAIN_FILE=/opt/rockchip/cmake/rk3588.cmake \
  -B build
cmake --build build
```

## Cross-compiling directly

```bash
source /etc/profile.d/21-rockchip-toolchain.sh
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## Building a full Linux image

For BSP/distro builds, combine this blueprint with `generic/yocto-image-builder` and the
[meta-rockchip](https://github.com/JeffyCN/meta-rockchip) Yocto layer, or use Buildroot with
the `rockchip_rk3588_defconfig` target.

## Supported boards

- Orange Pi 5 / 5B / 5 Plus
- Rock 5B / 5A (Radxa)
- Radxa CM5
- Firefly ITX-3588J
- Any board using the RK3588 or RK3588S SoC
