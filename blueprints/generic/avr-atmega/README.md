# Generic AVR ATmega Dev Environment

Board-agnostic AVR 8-bit bare-metal toolchain for ATmega and ATtiny microcontrollers.
Covers the full AVR family: Arduino Uno/Mega/Leonardo, custom ATmega boards, and standalone ATtiny designs.

## What's installed

| Component | amd64 host | arm64 host |
| --- | --- | --- |
| AVR GCC toolchain | `/opt/avr/avr-gcc/` (prebuilt 14.x) | `/usr/bin/` (apt, older) |
| avr-libc | system apt | system apt |
| avrdude | system apt | system apt |
| udev rules | `/etc/udev/rules.d/99-avr.rules` | `/etc/udev/rules.d/99-avr.rules` |

### Host platform notes

- **`linux/amd64`**: installs the [modm-io/avr-gcc](https://github.com/modm-io/avr-gcc)
  prebuilt release (GCC 14.x) from the Alloy catalog.
- **`linux/arm64`**: installs `gcc-avr` from Ubuntu apt. The version is older but uses
  the same `avr-gcc` prefix and is fully compatible for standard AVR targets.

## Compiling

```bash
# ATmega328P (Arduino Uno, 16 MHz)
avr-gcc -mmcu=atmega328p -DF_CPU=16000000UL -Os -o blink.elf blink.c
avr-objcopy -O ihex blink.elf blink.hex

# ATmega2560 (Arduino Mega)
avr-gcc -mmcu=atmega2560 -DF_CPU=16000000UL -Os -o blink.elf blink.c

# ATtiny85 (8-pin DIP)
avr-gcc -mmcu=attiny85 -DF_CPU=8000000UL -Os -o blink.elf blink.c
```

## Flashing with avrdude

```bash
# USBasp programmer → ATmega328P
avrdude -p m328p -c usbasp -U flash:w:blink.hex

# Arduino bootloader (USB-serial)
avrdude -p m328p -c arduino -P /dev/ttyUSB0 -b 115200 -U flash:w:blink.hex

# Atmel ICE → ATmega2560
avrdude -p m2560 -c atmelice -U flash:w:blink.hex
```

## Supported targets

| MCU | `-mmcu` flag | Common board |
| --- | --- | --- |
| ATmega328P | `atmega328p` | Arduino Uno, Nano |
| ATmega2560 | `atmega2560` | Arduino Mega |
| ATmega32U4 | `atmega32u4` | Arduino Leonardo, Pro Micro |
| ATtiny85 | `attiny85` | Digispark, custom |
| ATmega4809 | `atmega4809` | Arduino Every, Nano Every |

## Toolchain source

- **amd64**: [modm-io/avr-gcc](https://github.com/modm-io/avr-gcc) prebuilt
  (catalog entry: `toolchain.avr-gnu.avr-gcc@stable`).
- **arm64**: `gcc-avr` Ubuntu package.
