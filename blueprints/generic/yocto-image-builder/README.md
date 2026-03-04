# Generic Yocto Image Builder

Board-agnostic development environment for building custom Linux images with Yocto Project / OpenEmbedded and [kas](https://kas.readthedocs.io).

## What this blueprint provides

- System packages required for Yocto builds (git, gawk, diffstat, python3, etc.)
- **kas** — configuration tool for reproducible Yocto layer checkouts
- A minimal layer set checked out under `BUILD_DIR` (default `/opt/yocto/build`) using the kas-project minimal `kas.yml`

## Usage

After provisioning:

1. `cd /opt/yocto/build` (or your `BUILD_DIR`)
2. Source the OE environment: `source oe-init-build-env`
3. Run bitbake: `bitbake core-image-minimal` (or your target)

To use your own layers, add a task that runs `yocto_manifest` with your kas config repo URL and file, or clone your layers into a separate directory and use kas from there.

## Variables

| Variable          | Default                              | Description                                |
| ----------------- | ------------------------------------ | ------------------------------------------ |
| `BUILD_DIR`       | `/opt/yocto/build`                   | Where the Yocto build directory is created |
| `KAS_CONFIG_URL`  | `https://github.com/kas-project/kas` | Kas config repository URL                  |
| `KAS_CONFIG_FILE` | `kas.yml`                            | Kas config file path within the repo       |
