# Nordic nRF54 Development Environment Blueprint

This blueprint sets up a complete development environment for Nordic Semiconductor nRF54 series (nRF54H20, nRF54L15) on Linux hosts (amd64 and arm64). The nRF54 family is based on Arm Cortex-M33 and is supported by the nRF Connect SDK.

## What's Included

- **ARM GNU Embedded Toolchain** (arm-none-eabi) – from catalog
- **Zephyr SDK** – host tools and toolchains, from catalog
- **nRF Connect SDK** – Nordic's SDK based on Zephyr RTOS (West manifest)
- **Nordic Command Line Tools** – nrfjprog, mergehex, nrfutil – from catalog
- **West** – Zephyr's meta-tool for project management
- **Go** – from catalog
- **CMake & Ninja** – build system tools

## Directory Structure

```text
nrf54/
├── manifest.yml         # Entry point with variables and catalog refs
├── 00-system-base.yml   # Base packages and udev rules
├── 10-arm-zephyr.yml # ARM toolchain, Zephyr SDK, Go (from catalog)
├── 20-nrf-sdk.yml      # nRF Connect SDK and Nordic CLI tools
└── 99-cleanup.yml      # Final cleanup and verification
```

## Installed Paths

| Component              | Path                          |
| ---------------------- | ----------------------------- |
| ARM Embedded Toolchain | `/opt/arm-none-eabi`          |
| Zephyr SDK             | `/opt/zephyr-sdk`             |
| nRF Connect SDK        | `/opt/nordic/ncs/v2.9.0`      |
| Nordic CLI Tools       | `/opt/nrf-command-line-tools` |
| CMake Toolchain Files  | `/opt/nordic/cmake/`          |

## Environment Variables

After provisioning:

```bash
# ARM Toolchain
export GNUARMEMB_TOOLCHAIN_PATH=/opt/arm-none-eabi
export PATH=$PATH:/opt/arm-none-eabi/bin

# Zephyr SDK
export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk

# nRF Connect SDK / Zephyr
export ZEPHYR_BASE=/opt/nordic/ncs/v2.9.0/zephyr

# Nordic Tools
export PATH=$PATH:/opt/nrf-command-line-tools/bin

# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
```

## Usage Examples

### Build for nRF54H20 DK

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf54h20dk_nrf54h20 nrf/samples/hello_world
```

### Build for nRF54L15 DK

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf54l15dk_nrf54l15 nrf/samples/hello_world
```

### Flash and monitor

```bash
west flash
picocom /dev/ttyACM0 -b 115200
```

## Supported Boards

- **nRF54H20 DK** – `nrf54h20dk_nrf54h20`
- **nRF54L15 DK** – `nrf54l15dk_nrf54l15`
- Custom nRF54 boards – add board files under NCS.

## Catalog References

This blueprint uses the catalog for toolchain and SDK versions. Resolve generates `alloy.lock.yml` with pinned URLs and SHA256 for the host platform. Re-run `alloy-cicd resolve` when adding or changing catalog refs.

## Documentation

- [nRF Connect SDK](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/)
- [nRF54 Series](https://www.nordicsemi.com/Products/nRF54)
- [Zephyr Project](https://docs.zephyrproject.org/)
