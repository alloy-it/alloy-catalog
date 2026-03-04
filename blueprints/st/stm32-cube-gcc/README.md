# ST STM32 Cube + GCC

Generic STM32 development environment with ARM GCC and OpenOCD (ST-Link). Suitable for bare-metal or STM32Cube-based projects without Zephyr.

## What this blueprint provides

- ARM GNU Embedded toolchain (arm-none-eabi)
- OpenOCD for flashing and debugging via ST-Link
- udev rules for ST-Link (0483:3748, etc.)

## Usage

After provisioning, build your firmware with `arm-none-eabi-gcc` or CMake and flash with OpenOCD:

```bash
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program firmware.elf verify reset exit"
```

For STM32CubeMX/STM32CubeProgrammer CLI, download from ST and add to the blueprint or install manually.

## Variables

| Variable             | Default              | Description        |
| -------------------- | -------------------- | ------------------ |
| `ARM_TOOLCHAIN_DEST` | `/opt/arm-none-eabi` | ARM toolchain path |
