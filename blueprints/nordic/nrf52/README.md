# Nordic nRF52

Development environment for Nordic nRF52 series (nRF52832, nRF52840, etc.) with nRF Connect SDK and Zephyr RTOS.

## What this blueprint provides

- ARM GNU Embedded toolchain and Zephyr SDK
- nRF Connect SDK (NCS) via West
- Nordic nRF Command Line Tools (nrfjprog, etc.)
- CMake toolchain files for nRF52840 DK and nRF52 DK (nRF52832)

## Provisioning variables

### DEV_USERNAME (auto-detected)

This blueprint runs SDK initialization tasks as a non-root user and sets ownership of installed directories to that user. The provisioner detects the right username automatically from the sudo context — **no action required** for standard use.

|Source|When used|
|---|---|
|`$SUDO_USER`|Running `sudo alloy-provisioner …` (normal case)|
|`$USER`|Running without sudo on a non-root shell|
|Explicit override|Set `DEV_USERNAME` in a `.env` file (see `.env.example`)|

You only need to override it when provisioning for a different user or running in CI where both `SUDO_USER` and `USER` are `root`.

---

## Usage

After provisioning:

```bash
cd /opt/nordic/ncs/v2.9.0
west build -b nrf52840dk_nrf52840 nrf/samples/hello_world
# or
west build -b nrf52dk_nrf52832 nrf/samples/hello_world
```

Use CMake with `-DCMAKE_TOOLCHAIN_FILE=/opt/nordic/cmake/nrf52840.cmake` (or `nrf52832.cmake`) for Zephyr builds.
