# Generic Zephyr RTOS

Board-agnostic Zephyr RTOS development environment with Zephyr SDK and west.

## What this blueprint provides

- Zephyr SDK (toolchains and CMake integration) with ARM target installed
- west (Zephyr meta-tool) for workspace and build management

## Usage

After provisioning, create a workspace and build for any Zephyr-supported board:

```bash
west init my-zephyr-app
cd my-zephyr-app
west update
west build -b <board> samples/hello_world
```

Or use an existing Zephyr manifest repo. This blueprint does not clone Zephyr itself; use west to init/update your desired manifest (e.g. upstream zephyr, vendor SDK).

## Variables

| Variable          | Default           | Description             |
| ----------------- | ----------------- | ----------------------- |
| `ZEPHYR_SDK_DEST` | `/opt/zephyr-sdk` | Zephyr SDK install path |
