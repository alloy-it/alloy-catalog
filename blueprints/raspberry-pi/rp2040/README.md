# Raspberry Pi RP2040 (Pico)

Development environment for Raspberry Pi RP2040 (Pico, Pico W) using the official [Pico SDK](https://github.com/raspberrypi/pico-sdk).

## What this blueprint provides

- ARM GNU Embedded toolchain (arm-none-eabi)
- Pico SDK clone with submodules (tinyusb, etc.)
- PICO_SDK_PATH set in environment

## Usage

After provisioning:

```bash
export PICO_SDK_PATH=/opt/pico-sdk
cd /opt/pico-sdk/examples/hello_world
mkdir build && cd build
cmake ..
make
```

Flash with picotool or drag-and-drop UF2 onto the device.

## Variables

| Variable             | Default              | Description          |
| -------------------- | -------------------- | -------------------- |
| `ARM_TOOLCHAIN_DEST` | `/opt/arm-none-eabi` | ARM toolchain path   |
| `PICO_SDK_DEST`      | `/opt/pico-sdk`      | Pico SDK path        |
| `PICO_SDK_VERSION`   | `1.6.0`              | Git tag for pico-sdk |
