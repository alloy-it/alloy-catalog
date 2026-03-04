# TI AM62x Starter Kit Dev Environment

Yocto/kas build environment and cross-compilation toolchain for the Texas Instruments
AM62x Starter Kit (SK-AM62). Targets the Cortex-A53 application processor running TI's
arago Linux distribution.

## What's installed

| Component               | Location                   |
| ----------------------- | -------------------------- |
| Yocto build directory   | `/opt/yocto/am62x/`        |
| kas Yocto layer manager | `/usr/local/bin/kas`       |
| aarch64 GNU toolchain   | `/opt/ti/am62x/toolchain/` |

## Building a Linux image

```bash
cd /opt/yocto/am62x
kas build https://git.ti.com/cgit/arago-project/meta-arago/kas/ti-core-bundle.yml
```

To build a specific image target:

```bash
kas build <kas-config.yml> -- bitbake tisdk-default-image
```

## Cross-compiling directly

```bash
source /etc/profile.d/30-ti-am62x-toolchain.sh
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## Supported hardware

| Board      | SoC    | Notes                          |
| ---------- | ------ | ------------------------------ |
| SK-AM62    | AM6232 | 1 GHz Cortex-A53 (single-core) |
| SK-AM62B   | AM6254 | 1.4 GHz Cortex-A53 (quad-core) |
| BeaglePlay | AM6254 | Community board using AM62x    |

## TI SDK resources

- [AM62x SDK landing page](https://www.ti.com/tool/PROCESSOR-SDK-AM62X)
- [meta-arago (arago Yocto layer)](https://git.ti.com/cgit/arago-project/meta-arago)
- [AM62x Technical Reference Manual](https://www.ti.com/lit/ug/spruiv7a/spruiv7a.pdf)
