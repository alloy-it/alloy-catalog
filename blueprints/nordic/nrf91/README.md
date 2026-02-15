# Nordic nRF91 Development Environment Blueprint

This blueprint sets up a complete development environment for Nordic Semiconductor nRF91 series (nRF9160, nRF9161) cellular IoT SoCs on Linux hosts (amd64 and arm64).

## What's Included

- **ARM GNU Embedded Toolchain 13.3** - GCC for Cortex-M33 (arm-none-eabi)
- **Zephyr SDK 0.17.0** - Host tools and additional toolchains
- **nRF Connect SDK v2.9.0** - Nordic's SDK based on Zephyr RTOS
- **Nordic Command Line Tools** - nrfjprog, mergehex, nrfutil
- **West** - Zephyr's meta-tool for project management
- **Go 1.24.4** - Latest Go toolchain
- **CMake & Ninja** - Build system tools

## Directory Structure

```text
nrf91/
├── manifest.yml         # Main entry point with variables
├── 00-system-base.yml   # Base packages and udev rules
├── 10-arm-toolchain.yml # ARM toolchain and Zephyr SDK
├── 20-nrf-sdk.yml       # nRF Connect SDK and West
└── 99-cleanup.yml       # Final cleanup and verification
```

## Installed Paths

| Component                  | Path                              |
| -------------------------- | --------------------------------- |
| ARM Embedded Toolchain     | `/opt/arm-none-eabi`              |
| Zephyr SDK                 | `/opt/zephyr-sdk`                 |
| nRF Connect SDK            | `/opt/nordic/ncs/v2.9.0`          |
| Nordic CLI Tools           | `/opt/nrf-command-line-tools`     |
| CMake Toolchain Files      | `/opt/nordic/cmake/`              |
| Go                         | `/usr/local/go`                   |

## Environment Variables

After provisioning, the following environment variables are available:

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

### Build a sample application for nRF9160 DK

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf9160dk_nrf9160_ns nrf/samples/cellular/hello_world
```

### Build for nRF9161 DK

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf9161dk_nrf9161_ns nrf/samples/cellular/hello_world
```

### Flash to device

```bash
west flash
```

### Monitor serial output

```bash
picocom /dev/ttyACM0 -b 115200
```

### Create a new project

```bash
mkdir my-nrf91-project && cd my-nrf91-project
west init -m https://github.com/nrfconnect/sdk-nrf --mr v2.9.0
west update
```

## Supported Boards

This environment supports all nRF91 series boards:

- **nRF9160 DK** - `nrf9160dk_nrf9160_ns`
- **nRF9161 DK** - `nrf9161dk_nrf9161_ns`
- **Thingy:91** - `thingy91_nrf9160_ns`
- **Custom boards** - Define your own board files

## Supported Host Architectures

This blueprint supports both:

- **amd64** - Intel/AMD 64-bit hosts (x86_64)
- **arm64** - ARM 64-bit hosts (Apple Silicon, ARM servers)

The correct toolchain binaries are automatically selected based on the host architecture using the `per_arch` mechanism.

## Cellular Connectivity

The nRF91 series features an integrated LTE-M/NB-IoT modem. Sample applications include:

- `nrf/samples/cellular/hello_world` - Basic cellular connectivity
- `nrf/samples/cellular/modem_shell` - Interactive modem commands
- `nrf/samples/cellular/nrf_cloud_mqtt` - nRF Cloud connectivity
- `nrf/samples/cellular/lwm2m_client` - LwM2M client

## Documentation

- [nRF Connect SDK Documentation](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/)
- [nRF9160 Product Page](https://www.nordicsemi.com/Products/nRF9160)
- [Zephyr Project Documentation](https://docs.zephyrproject.org/)
