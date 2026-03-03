# Generic Buildroot Image Builder

Board-agnostic development environment for building custom embedded Linux images with [Buildroot](https://buildroot.org/).

## What this blueprint provides

- System packages required for Buildroot (git, make, gcc, unzip, bc, etc.)
- A clone of the Buildroot repository at a pinned version (default `2024.02.3`) in `BUILDROOT_DEST` (default `/opt/buildroot`)

## Usage

After provisioning:

1. `cd /opt/buildroot` (or your `BUILDROOT_DEST`)
2. Configure: `make menuconfig` (or copy a defconfig: `make <board>_defconfig`)
3. Build: `make`

To use a custom BR2_EXTERNAL tree or defconfig, extend the blueprint with a `buildroot_config` task that sets `source` and/or `file` accordingly.

## Variables

| Variable            | Default          | Description                                          |
| ------------------- | ---------------- | ---------------------------------------------------- |
| `BUILDROOT_DEST`    | `/opt/buildroot` | Where Buildroot is cloned                            |
| `BUILDROOT_VERSION` | `2024.02.3`      | Buildroot tag or branch (e.g. `2024.02.3`, `master`) |
