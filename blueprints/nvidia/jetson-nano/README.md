# NVIDIA Jetson Nano

Cross-compilation environment for NVIDIA Jetson Nano (L4T, aarch64).

## What this blueprint provides

- Build tools and aarch64 GNU toolchain for cross-compiling Linux applications
- CMake toolchain file for Jetson Nano (aarch64)

## JetPack / L4T

For full JetPack (CUDA, cuDNN, TensorRT, L4T) development, install the NVIDIA SDK on the Jetson device or use the JetPack SDK Manager. This blueprint provides the host-side cross-compiler and a clean environment; link against the sysroot from your JetPack installation when building CUDA/TensorRT apps.

## Usage

After provisioning:

- Cross-compile with `CROSS_COMPILE=aarch64-none-linux-gnu-` and the toolchain on PATH, or
- `cmake -DCMAKE_TOOLCHAIN_FILE=/opt/jetson-nano/cmake/jetson-nano.cmake ...`

## Variables

| Variable              | Default                      | Description                    |
| --------------------- | ---------------------------- | ------------------------------ |
| `TOOLCHAIN_DEST`      | `/opt/jetson-nano/toolchain` | aarch64 toolchain path         |
| `TOOLCHAIN_FILES_DIR` | `/opt/jetson-nano/cmake`     | CMake toolchain file directory |
