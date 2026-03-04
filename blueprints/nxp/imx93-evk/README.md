# nxp/imx93-evk

Yocto-based development environment for the NXP i.MX 93 — dual Cortex-A55 + Cortex-M33,
NXP's current-generation SoC targeting industrial and IoT edge applications (2023).

## Supported boards

| Board | SoC | Arch |
| --- | --- | --- |
| MCIMX93EVK | i.MX 93 | 2× Cortex-A55 + M33 |
| MCIMX93EVKB (11×11) | i.MX 93 | 2× Cortex-A55 + M33 |
| Variscite DART-MX93 | i.MX 93 | 2× Cortex-A55 + M33 |
| Toradex Verdin iMX93 | i.MX 93 | 2× Cortex-A55 + M33 |

## What's installed

- **NXP Yocto BSP** via `repo` + `imx-manifest` (Scarthgap, kernel 6.6)
- **aarch64-none-linux-gnu** toolchain (ARM GNU, from catalog)
- Yocto workspace at `/opt/yocto/imx93`
- Build tools: `cmake`, `ninja`, `gawk`, `chrpath`, `repo`

## BSP details

| Field | Value |
| --- | --- |
| Yocto branch | `imx-linux-scarthgap` |
| Manifest file | `imx-6.6.23-2.0.0.xml` |
| Kernel version | 6.6.23 |
| MACHINE | `imx93evk` |

## Quick start

```bash
# Initialize and build Yocto image
cd /opt/yocto/imx93
source setup-env.sh
MACHINE=imx93evk bitbake imx-image-full

# Cross-compile an application
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## Environment variables

| Variable | Value |
| --- | --- |
| `CROSS_COMPILE` | `aarch64-none-linux-gnu-` |
| `PATH` | includes `/opt/nxp/imx93/toolchain/bin` |
