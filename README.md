# Alloy Catalog

The official toolchain descriptor catalog for [Alloy](https://alloy-it.io).

## What is this?

This repository contains **metadata-only** descriptors for toolchains, SDKs, and development tools. Each descriptor maps a tool identifier + version + host platform to an official download URL and SHA256 checksum.

**No binaries are hosted here.** Downloads always come from the vendor's official servers.

## Structure

The catalog uses a **namespaced two-level model**: one immutable file per version, plus one small index per tool.

```text
catalog/
  toolchains/                    # namespace
    arm-gnu/                     # vendor
      arm-none-linux-gnueabihf/  # tool
        index.yaml               # aliases + version list
        13.3.rel1.yaml           # immutable version descriptor
        11.3.rel1.yaml
      arm-none-eabi/
        index.yaml
        13.3.rel1.yaml
  sdks/
    zephyr/
      zephyr-sdk/
        index.yaml
        0.17.0.yaml
    golang/
      go/
        index.yaml
        1.24.4.yaml
    flutter/
      flutter/
        index.yaml
        3.24.5.yaml
  tools/
    libconfuse/
      libconfuse/
        index.yaml
        3.3.yaml
```

### Namespaces

| Directory      | ID Prefix    | Purpose                                        |
| -------------- | ------------ | ---------------------------------------------- |
| `toolchains/`  | `toolchain.` | Cross-compilers, linkers, debuggers            |
| `sdks/`        | `sdk.`       | Full SDK bundles (Zephyr, nRF Connect, etc.)   |
| `tools/`       | `tool.`      | Standalone dev tools (genimage, etc.)          |

### ID Format

Dot-separated: `<namespace>.<vendor>.<tool>`

The ID is derived from the filesystem path. For example:

| Path                                              | ID                                                 |
| ------------------------------------------------- | -------------------------------------------------- |
| `toolchains/arm-gnu/arm-none-linux-gnueabihf/`    | `toolchain.arm-gnu.arm-none-linux-gnueabihf`       |
| `sdks/zephyr/zephyr-sdk/`                         | `sdk.zephyr.zephyr-sdk`                            |
| `sdks/golang/go/`                                | `sdk.golang.go`                                    |
| `sdks/flutter/flutter/`                          | `sdk.flutter.flutter`                              |

## Version File (immutable, one per release)

Each version file is a self-contained, immutable descriptor for a single release:

```yaml
spec_version: 1
id: toolchain.arm-gnu.arm-none-linux-gnueabihf
version: "13.3.rel1"

name: "ARM GNU Toolchain for ARM Linux (gnueabihf, 32-bit hard-float)"
homepage: "https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain"
license: "GPL-3.0"

capabilities:
  - toolchain.gcc
  - target.arm-linux-gnueabihf

providers:
  - id: archive
    method: archive
    host_platforms:
      linux/amd64:
        url: "https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz"
        sha256: "95c011cfd84e30e8ca3e8aba01f4d1bbf0e332b15f3ccd79c1410625e4a0411b"
      linux/arm64:
        url: "https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-aarch64-arm-none-linux-gnueabihf.tar.xz"
        sha256: "b55ae325c0db0e5c90850d56e0d7c1f17a3e5c38c7a2cbcab1bcf4aa06e9f8f5"

install_hints:
  creates: "bin/arm-none-linux-gnueabihf-gcc"
  env_vars:
    CROSS_COMPILE: "arm-none-linux-gnueabihf-"

lifecycle:
  status: stable
  released_at: "2024-06-01"
```

### Version File Fields

| Field            | Required | Description                                      |
| ---------------- | -------- | ------------------------------------------------ |
| `spec_version`   | Yes      | Schema version, currently `1`                    |
| `id`             | Yes      | Dot-separated tool ID, must match directory path |
| `version`        | Yes      | Exact version string, must match filename        |
| `name`           | Yes      | Human-readable display name                      |
| `homepage`       | No       | Upstream project URL                             |
| `license`        | No       | SPDX license identifier                          |
| `capabilities`   | No       | Trait-based metadata for search and matching     |
| `providers`      | Yes      | List of delivery methods (see below)             |
| `install_hints`  | No       | Post-install metadata (`creates`, `env_vars`)    |
| `lifecycle`      | Yes      | Version lifecycle status (see below)             |

### Providers

Each version can be delivered via one or more providers:

| Field              | Required | Description                                          |
| ------------------ | -------- | ---------------------------------------------------- |
| `id`               | Yes      | Provider identifier (e.g., `archive`)                |
| `method`           | Yes      | Delivery method: `archive`, `oci`, or `apt`          |
| `host_platforms`   | Yes      | Map of `linux/amd64`, `linux/arm64` to asset details |

Each platform asset contains:

| Field        | Required | Description        |
| ------------ | -------- | ------------------ |
| `url`        | Yes      | Download URL       |
| `sha256`     | Yes      | SHA256 checksum    |
| `size_bytes` | No       | File size in bytes |

### Lifecycle

| Field          | Required | Description                                  |
| -------------- | -------- | -------------------------------------------- |
| `status`       | Yes      | One of: `stable`, `lts`, `deprecated`, `eol` |
| `released_at`  | No       | Release date (YYYY-MM-DD)                    |
| `replaced_by`  | No       | Version that supersedes this one             |
| `eol_date`     | No       | End-of-life date                             |

| Status       | Meaning                                                                      |
| ------------ | ---------------------------------------------------------------------------- |
| `stable`     | Current recommended version for general use                                  |
| `lts`        | Long-term support — receives security fixes but not new features             |
| `deprecated` | Still available but should be migrated away from; check `replaced_by`        |
| `eol`        | End of life — no longer supported, may be removed in future catalog versions |

## Per-Tool Index

Each tool directory contains an `index.yaml` that lists available versions and defines aliases:

```yaml
spec_version: 1
id: toolchain.arm-gnu.arm-none-linux-gnueabihf
type: index

aliases:
  latest: "13.3.rel1"
  stable: "13.3.rel1"
  lts: "11.3.rel1"

versions:
  - version: "13.3.rel1"
    file: "13.3.rel1.yaml"
    status: stable
  - version: "11.3.rel1"
    file: "11.3.rel1.yaml"
    status: deprecated
    replaced_by: "13.3.rel1"
```

Aliases allow blueprints to reference channels instead of pinning exact versions. The resolver expands `@stable` to the exact version from the index before resolution. Lockfiles always record the resolved ref, ensuring reproducible builds.

## Usage with Alloy

Reference a catalog entry in your blueprint's `manifest.yml`:

```yaml
toolchains:
  - ref: "toolchain.arm-gnu.arm-none-linux-gnueabihf@stable"
    alias: TOOLCHAIN_32BIT
  - ref: "sdk.golang.go@1.24.4"
    alias: GOLANG
```

Then run:

```bash
alloy-host resolve
```

This generates `alloy.lock.yml` with the exact URL and SHA256 for your host architecture:

```yaml
# AUTO-GENERATED by alloy resolve. Do not edit.
resolved_at: "2025-01-15T10:30:00Z"
host: linux/amd64
toolchains:
  toolchain.arm-gnu.arm-none-linux-gnueabihf@stable:
    url: "https://developer.arm.com/..."
    sha256: "95c011..."
  sdk.golang.go@1.24.4:
    url: "https://go.dev/dl/..."
    sha256: "abc123..."
```

## Enterprise Overlay

Enterprises can fork this catalog to maintain internal toolchain policies:

1. **Add internal tools** in vendor-specific directories:

   ```text
   catalog/tools/acme-internal/custom-sdk/
     index.yaml
     1.0.0.yaml
   ```

2. **Pin approved versions** by editing per-tool `index.yaml` aliases:

   ```yaml
   aliases:
     stable: "1.22.8"    # company-approved version
   ```

3. **Merge upstream** periodically — only index aliases may conflict (intentionally).

## Contributing

1. Fork this repository
2. To add a new tool:
   - Create a directory: `catalog/<namespace>/<vendor>/<tool>/`
   - Add `index.yaml` with the tool ID, aliases, and version list
   - Add a version file: `<version>.yaml`
3. To add a new version to an existing tool:
   - Add a new `<version>.yaml` file in the tool directory
   - Update `index.yaml` to list the new version and adjust aliases
4. Submit a pull request

CI will validate:

- YAML schema compliance
- ID in each file matches the directory path
- URL reachability
- SHA256 correctness
- All index entries reference existing version files
