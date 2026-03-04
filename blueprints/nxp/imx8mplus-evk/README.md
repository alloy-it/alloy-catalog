# NXP i.MX 8M Plus EVK

Yocto-based development environment for NXP i.MX 8M Plus (e.g. FRDM-iMX8MPLUS, i.MX 8M Plus EVK).

## What this blueprint provides

- System packages and Google `repo` tool for NXP BSP
- NXP imx-manifest Yocto layer set (repo init + sync) in `BUILD_DIR`
- aarch64 cross-compiler from catalog for building applications

## Usage

After provisioning:

1. `cd /opt/yocto/imx8mplus`
2. Source the NXP setup: `source setup-env.sh`
3. Build an image: `MACHINE=imx8mpevk bitbake imx-image-full` (or your target)

For application cross-compilation, use `CROSS_COMPILE=aarch64-none-linux-gnu-` and the toolchain in `/opt/imx8mplus/toolchain/bin`.

## Variables

| Variable              | Default                                   | Description                 |
| --------------------- | ----------------------------------------- | --------------------------- |
| `BUILD_DIR`           | `/opt/yocto/imx8mplus`                    | Yocto workspace (repo root) |
| `IMX_MANIFEST_BRANCH` | `imx-linux-kirkstone`                     | NXP manifest branch         |
| `IMX_MANIFEST_FILE`   | `imx-5.15.71-2.2.0.xml`                   | Manifest file name          |
| `IMX_MANIFEST_URL`    | `https://github.com/nxp-imx/imx-manifest` | NXP manifest repo           |
