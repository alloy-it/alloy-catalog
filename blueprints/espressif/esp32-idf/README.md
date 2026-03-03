# Espressif ESP32 ESP-IDF

Development environment for the ESP32 family (ESP32, ESP32-S3, ESP32-C3, ESP32-C6, etc.) using the official [ESP-IDF](https://docs.espressif.com/projects/esp-idf/) framework.

## What this blueprint provides

- ESP-IDF cloned at a pinned version (default v5.4.1) with install script run for esp32, esp32s3, esp32c3
- udev rules for SiLabs CP210x and Espressif USB devices
- IDF_PATH and export script in profile

## Usage

After provisioning, source the export script and build:

```bash
. /opt/esp-idf/export.sh
cd /opt/esp-idf/examples/get-started/hello_world
idf.py set-target esp32
idf.py build
idf.py -p /dev/ttyUSB0 flash monitor
```

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `IDF_DEST` | `/opt/esp-idf` | ESP-IDF install path |
| `IDF_VERSION` | `v5.4.1` | Git tag or branch |
| `IDF_URL` | `https://github.com/espressif/esp-idf.git` | ESP-IDF repo URL |
