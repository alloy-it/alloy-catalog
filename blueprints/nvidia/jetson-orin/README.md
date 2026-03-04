# NVIDIA Jetson Orin Dev Environment

Cross-compilation toolchain for the NVIDIA Jetson Orin family (Cortex-A78AE, aarch64).

Covers: **Orin Nano**, **Orin NX**, and **AGX Orin** modules running JetPack 6.x (L4T 36.x).

## What's installed

| Component             | Location                                   |
| --------------------- | ------------------------------------------ |
| aarch64 GNU toolchain | `/opt/jetson-orin/toolchain/`              |
| CMake toolchain file  | `/opt/jetson-orin/cmake/jetson-orin.cmake` |

## Cross-compiling with CMake

```bash
cmake \
  -DCMAKE_TOOLCHAIN_FILE=/opt/jetson-orin/cmake/jetson-orin.cmake \
  -B build
cmake --build build
```

## Cross-compiling directly

```bash
source /etc/profile.d/21-jetson-orin-toolchain.sh
aarch64-none-linux-gnu-gcc -o hello hello.c
```

## JetPack / CUDA setup

This blueprint provides the CPU cross-compiler only. For GPU-accelerated workloads (CUDA, TensorRT, VPI):

1. Flash JetPack 6.x to your Jetson via NVIDIA SDK Manager
2. Install the CUDA cross-compilation packages from the JetPack repository
3. Point `CMAKE_SYSROOT` to the JetPack sysroot for linking against CUDA/TensorRT libraries

## Supported modules

| Module               | SoC                  | RAM   |
| -------------------- | -------------------- | ----- |
| Jetson AGX Orin 64GB | Orin (12-core A78AE) | 64 GB |
| Jetson AGX Orin 32GB | Orin                 | 32 GB |
| Jetson Orin NX 16GB  | Orin (8-core A78AE)  | 16 GB |
| Jetson Orin NX 8GB   | Orin                 | 8 GB  |
| Jetson Orin Nano 8GB | Orin (6-core A78AE)  | 8 GB  |
| Jetson Orin Nano 4GB | Orin                 | 4 GB  |
