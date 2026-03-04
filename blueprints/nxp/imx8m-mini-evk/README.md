# nxp/imx8m-mini-evk

Yocto-based development environment for the NXP i.MX 8M Mini — quad Cortex-A53 at 1.6 GHz,
optimized for cost-sensitive multimedia applications.

## Supported boards

| Board | SoC | Arch |
| --- | --- | --- |
| MIMX8MMEVK | i.MX 8M Mini | 4× Cortex-A53 |
| Variscite DART-MX8M-MINI | i.MX 8M Mini | 4× Cortex-A53 |
| Boundary Nitrogen8M Mini | i.MX 8M Mini | 4× Cortex-A53 |
| Compulab UCM-iMX8M-Mini | i.MX 8M Mini | 4× Cortex-A53 |

## What's installed

- **NXP Yocto BSP** via `repo` + `imx-manifest` (Kirkstone LTS, kernel 5.15)
- **aarch64-none-linux-gnu** toolchain (ARM GNU, from catalog)
- Yocto workspace at `/opt/yocto/imx8mmini`
- Build tools: `cmake`, `ninja`, `gawk`, `chrpath`, `repo`

## BSP details

| Field | Value |
| --- | --- |
| Yocto branch | `imx-linux-kirkstone` |
| Manifest file | `imx-5.15.71-2.2.0.xml` |
| Kernel version | 5.15.71 |
| MACHINE | `imx8mmevk` |

## Quick start

```bash
# Initialize and build Yocto image
cd /opt/yocto/imx8mmini
source setup-env.sh
MACHINE=imx8mmevk bitbake imx-image-full

# Cross-compile an application
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## Environment variables

| Variable | Value |
| --- | --- |
| `CROSS_COMPILE` | `aarch64-none-linux-gnu-` |
| `PATH` | includes `/opt/nxp/imx8mmini/toolchain/bin` |
