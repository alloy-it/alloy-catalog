# Zephyr SDK

Development environment for the [Zephyr SDK](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html) GNU bundle.

## What this blueprint provides

- Zephyr SDK GNU bundle (host tools + selectable cross-toolchains)
- `setup.sh` registration of CMake toolchain packages (`-c`) and host tools (`-h`)
- `ZEPHYR_SDK_INSTALL_DIR` and `ZEPHYR_TOOLCHAIN_VARIANT=zephyr` for automatic SDK discovery
- Python pinned to the version required by the selected SDK (3.10 or 3.12) with an isolated venv at `/opt/zephyr/venv`
- OpenOCD udev rules on native Linux (skipped in Docker/WSL2)

This blueprint installs the SDK only. It does not clone Zephyr or install west. For a full board-agnostic Zephyr workspace, use `generic/zephyr`.

## SDK versions and dependencies

The catalog publishes multiple SDK versions (`sdk.zephyr.zephyr-sdk`). Each version targets a Zephyr release line and requires specific host dependencies:

| Catalog ref | SDK | Zephyr | Python | CMake min | West min | Bundle |
| ----------- | --- | ------ | ------ | --------- | -------- | ------ |
| `@1.0.1` / `@stable` | 1.0.1 | 4.4+ / main | **3.12** | 3.28.0 | 0.14.0 | `_gnu` |
| `@1.0.0` | 1.0.0 | 4.4.x | **3.12** | 3.28.0 | 0.14.0 | `_gnu` |
| `@0.17.4` | 0.17.4 | 4.2.x / 4.3.x | **3.10** | 3.20.5 | 0.14.0 | legacy |
| `@0.16.9` / `@lts` | 0.16.9 | 3.7 LTS | **3.10** | 3.20.5 | 0.14.0 | legacy |
| `@0.17.0` | 0.17.0 | (deprecated) | 3.10 | 3.20.5 | 0.14.0 | legacy |

See the [SDK compatibility wiki](https://github.com/zephyrproject-rtos/sdk-ng/wiki/Zephyr-Version-Compatibility) for the full matrix.

### Switching SDK version

1. Set the catalog ref in `manifest.yml`:

   ```yaml
   toolchains:
     - ref: "sdk.zephyr.zephyr-sdk@0.17.4"
       alias: ZEPHYR_SDK
   ```

2. Merge the matching variable profile from `profiles/` into `manifest.yml` `variables:` (or copy to `variables.yml`). Example profiles:

   - `profiles/sdk-1.0.1.yml` — default, Python 3.12
   - `profiles/sdk-0.17.4.yml` — Python 3.10 for Zephyr 4.2/4.3
   - `profiles/sdk-0.16.9.yml` — Python 3.10 for Zephyr 3.7 LTS

`ZEPHYR_SDK_VERSION` must match the catalog ref version (used for `setup.sh` paths).

## Usage

After provisioning, point your Zephyr build at the SDK:

```bash
export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
source /etc/profile.d/05-zephyr-python.sh
```

With an existing Zephyr tree or vendor SDK:

```bash
west build -b <board> <app_path>
```

## Variables

| Variable                   | Default (SDK 1.0.1)  | Description                                         |
| -------------------------- | -------------------- | --------------------------------------------------- |
| `ZEPHYR_SDK_INSTALL_DIR`   | `/opt/zephyr-sdk`    | Parent directory containing `zephyr-sdk-<version>/` |
| `ZEPHYR_SDK_VERSION`       | `1.0.1`              | Must match catalog ref (see profiles/)              |
| `ZEPHYR_SDK_TOOLCHAINS`    | `arm-zephyr-eabi`    | Toolchain IDs passed to `setup.sh -t`               |
| `PYTHON_MINOR`             | `3.12`               | Required Python series (`3.10` or `3.12`)           |
| `ZEPHYR_PYTHON_VENV`       | `/opt/zephyr/venv`   | Isolated venv for west / workspace pip deps         |
| `PYTHON_APT_VERSION_jammy` | (see profile)        | Exact `python3.x` apt pin on Ubuntu 22.04           |
| `PYTHON_APT_VERSION_noble` | (see profile)        | Exact `python3.x` apt pin on Ubuntu 24.04           |

To install additional architectures, set `ZEPHYR_SDK_TOOLCHAINS` to a space-separated list (for example `arm-zephyr-eabi riscv64-zephyr-elf`).

## References

- [Zephyr SDK installation](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)
- [Zephyr SDK releases](https://github.com/zephyrproject-rtos/sdk-ng/releases)
- [Zephyr SDK version compatibility](https://github.com/zephyrproject-rtos/sdk-ng/wiki/Zephyr-Version-Compatibility)
