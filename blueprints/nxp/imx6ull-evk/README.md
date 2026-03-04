# nxp/imx6ull-evk

Cross-compilation environment for the NXP i.MX 6ULL — single Cortex-A7 at 800 MHz, 32-bit
Linux, the dominant NXP SoC for industrial IoT and HMI applications.

## Supported boards

| Board | SoC | Arch |
| --- | --- | --- |
| MCIMX6ULL-EVK | i.MX 6ULL | Cortex-A7 |
| Olimex IMX6ULL-NANO | i.MX 6ULL | Cortex-A7 |
| SolidRun HummingBoard | i.MX 6ULL | Cortex-A7 |
| Variscite VAR-SOM-6ULL | i.MX 6ULL | Cortex-A7 |
| Custom PCB (widely used) | i.MX 6ULL | Cortex-A7 |

## What's installed

- **arm-none-linux-gnueabihf** toolchain (ARM GNU, from catalog)
- CMake toolchain file at `/opt/nxp/cmake/imx6ull.cmake`
- Build tools: `cmake`, `ninja`, `device-tree-compiler`, `u-boot-tools`

## Toolchain details

| Field | Value |
| --- | --- |
| Prefix | `arm-none-linux-gnueabihf-` |
| Arch | Cortex-A7, `-march=armv7-a` |
| Float | Hard float, `-mfpu=neon -mfloat-abi=hard` |
| Installed to | `/opt/nxp/imx6ull/toolchain` |

## Quick start

```bash
# Direct compile
arm-none-linux-gnueabihf-gcc -march=armv7-a -mfpu=neon -mfloat-abi=hard -o hello hello.c

# CMake project
cmake -DCMAKE_TOOLCHAIN_FILE=/opt/nxp/cmake/imx6ull.cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build
```

## Environment variables

| Variable | Value |
| --- | --- |
| `CROSS_COMPILE` | `arm-none-linux-gnueabihf-` |
| `PATH` | includes `/opt/nxp/imx6ull/toolchain/bin` |
