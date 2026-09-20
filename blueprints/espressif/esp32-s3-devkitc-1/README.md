# Espressif ESP32-S3-DevKitC-1

Development environment for the [ESP32-S3-DevKitC-1](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32s3/esp32-s3-devkitc-1/index.html) (ESP32-S3-WROOM-1 / WROOM-1U / WROOM-2 variants) using [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/v5.4.1/esp32s3/).

## What this blueprint provides

- ESP-IDF v5.4.1 in `/opt/esp-idf`
- Only the ESP32-S3 tools, pulled from the Alloy catalog for the host arch (`linux/amd64` or `linux/arm64`) and installed in `/opt/espressif`: `xtensa-esp32s3-elf-gcc`, RISC-V + FSM ULP toolchains, `openocd-esp32`, GDB and the ROM ELFs
- Python venv built by `idf_tools.py install-python-env` (no tool downloads from `install.sh`)
- `IDF_TARGET=esp32s3` by default, and `idf.py` on `PATH` in every login shell
- udev rules for both USB-C ports, and the dev user added to `dialout`/`plugdev`

## Host OS requirements

Debian/Ubuntu (uses `apt`). ESP-IDF v5.4.1 needs Python ≥ 3.8 and CMake ≥ 3.16; provisioning checks this up front. Tested targets: Ubuntu 22.04 (Alloy VM default: Python 3.10, CMake 3.22) and Ubuntu 24.04 (Python 3.12, CMake 3.28). No PPAs or pinned apt versions needed.

## The two USB ports

| Port on board | Chip                                          | Linux device   | Use for                                                            |
| ------------- | --------------------------------------------- | -------------- | ------------------------------------------------------------------ |
| **UART**      | CP2102N (`10c4:ea60`)                         | `/dev/ttyUSB0` | Flashing + console; works even if the firmware disables native USB |
| **USB**       | ESP32-S3 native USB-Serial/JTAG (`303a:1001`) | `/dev/ttyACM0` | Flashing, console **and** JTAG debugging with no external probe    |

Forward whichever port you use into the VM (see USB passthrough in Alloy Host).

## Usage

```bash
cp -r $IDF_PATH/examples/get-started/blink ~/blink && cd ~/blink
idf.py build
idf.py -p /dev/ttyUSB0 flash monitor      # UART port
```

On-chip debugging over the **USB** port:

```bash
idf.py openocd          # terminal 1 (uses board/esp32s3-builtin.cfg)
idf.py gdb              # terminal 2
```

The on-board RGB LED is a WS2812 on GPIO48 (GPIO38 on board v1.1). Set the pin with `idf.py menuconfig` → Example Configuration.

## Variables

| Variable         | Default                                    | Description                                    |
| ---------------- | ------------------------------------------ | ---------------------------------------------- |
| `IDF_VERSION`    | `v5.4.1`                                   | ESP-IDF git tag                                |
| `IDF_URL`        | `https://github.com/espressif/esp-idf.git` | ESP-IDF repo                                   |
| `IDF_DEST`       | `/opt/esp-idf`                             | ESP-IDF checkout                               |
| `IDF_TOOLS_PATH` | `/opt/espressif`                           | Toolchains + Python env                        |
| `IDF_TARGET`     | `esp32s3`                                  | Chip passed to `install.sh` and default target |

## Upgrading ESP-IDF

ESP-IDF only accepts the exact tool versions in its `tools/tools.json`. When you bump `IDF_VERSION`, add the matching versions to the catalog and update both the `toolchains:` refs and the `*_VER` directory names in `manifest.yml`.

## Changelog

| Version | Change |
|---|---|
| 1.0.1 | Clone ESP-IDF with shallow submodules, sequential fetch and retries. Fixes the `could not read Username for 'https://github.com'` abort during submodule checkout. |
| 1.0.0 | Initial blueprint. |
