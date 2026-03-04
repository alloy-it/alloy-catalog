# ST STM32MP157-DK2

Yocto-based development environment for ST STM32MP157-DK2 (Cortex-A7 + Cortex-M4).

## What this blueprint provides

- System packages and kas for Yocto/OpenEmbedded
- Minimal Yocto layer set (poky-based) in `BUILD_DIR`
- ARM 32-bit toolchain (arm-none-linux-gnueabihf) for Cortex-A7 application builds

## OpenSTLinux BSP

For the full ST BSP (OpenSTLinux), add the official layer [meta-st-stm32mp](https://github.com/STMicroelectronics/meta-st-stm32mp) to your kas config or bblayers.conf, or use an ST-provided distribution manifest.

## Usage

After provisioning:

1. `cd /opt/yocto/stm32mp157-dk2` and build with bitbake, or
2. Use a kas config that includes `meta-st-stm32mp` and target `stm32mp1` machines.

Cross-compile applications with `CROSS_COMPILE=arm-none-linux-gnueabihf-` and the toolchain in `/opt/stm32mp157/toolchain/bin`.

## Variables

| Variable          | Default                              | Description                                    |
| ----------------- | ------------------------------------ | ---------------------------------------------- |
| `BUILD_DIR`       | `/opt/yocto/stm32mp157-dk2`          | Yocto build directory                          |
| `KAS_CONFIG_URL`  | `https://github.com/kas-project/kas` | Kas config repo (minimal); override for ST BSP |
| `KAS_CONFIG_FILE` | `kas.yml`                            | Kas config file name                           |
