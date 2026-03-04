# Nordic nRF52

Development environment for Nordic nRF52 series (nRF52832, nRF52840, etc.) with nRF Connect SDK and Zephyr RTOS.

## What this blueprint provides

- ARM GNU Embedded toolchain and Zephyr SDK
- nRF Connect SDK (NCS) via West
- Nordic nRF Command Line Tools (nrfjprog, etc.)
- CMake toolchain files for nRF52840 DK and nRF52 DK (nRF52832)

## Usage

After provisioning:

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf52840dk_nrf52840 nrf/samples/hello_world
# or
west build -b nrf52dk_nrf52832 nrf/samples/hello_world
```

Use CMake with `-DCMAKE_TOOLCHAIN_FILE=/opt/nordic/cmake/nrf52840.cmake` (or `nrf52832.cmake`) for Zephyr builds.
