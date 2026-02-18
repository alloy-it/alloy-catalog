# Alloy Catalog

The official toolchain descriptor catalog and blueprint repository for [Alloy](https://alloy-it.io).

This repository contains two things:

1. **Catalog** -- metadata-only descriptors for toolchains, SDKs, and development tools.
2. **Blueprints** -- declarative environment definitions that describe how to provision a development machine for a specific hardware target.

No binaries are hosted here. Downloads always come from the vendor's official servers.

## How it all fits together

```text
                          alloy-catalog (this repo)
                         ┌────────────────────────────┐
                         │  catalog/    blueprints/   │
                         └──────┬─────────────┬───────┘
                                │             │
                    ┌───────────┘             │
                    ▼                         ▼
              ┌────────────┐            ┌────────────┐
              │ alloy-host │            │ alloy-cicd │
              │  resolve   │            │  pipeline  │
              └─────┬──────┘            └─────┬──────┘
                    │                         │
                    ▼                         ▼
           alloy.lock.yml             Alloy ImageRegistry
           (pinned URLs)          (api.alloy-it.io)
                                         │
                                         ▼
                                  ┌─────────────────┐
                                  │alloy-provisioner│
                                  │  (in guest VM)  │
                                  └────────┬────────┘
                                           │
                                           ▼
                                   Provisioned Machine
```

1. A **blueprint author** writes a blueprint in `blueprints/<vendor>/<board>/` and opens a PR.
2. **CI validates** the blueprint on every PR (`alloy-cicd validate` + `alloy-cicd resolve --dry-run`).
3. On merge to `main`, **CI publishes** the blueprint as an Alloy Imageimage to `api.alloy-it.io/community/<vendor>/<board>:<version>`.
4. A developer runs `alloy-host init my-vm --blueprint <vendor>/<board> --registry api.alloy-it.io`.
5. `alloy-host up` starts the VM and invokes `alloy-provisioner` inside the guest.
6. The **provisioner pulls** the Alloy Imageblueprint matching the host OS and CPU architecture, then executes every task to set up the environment.

---

## Repository Structure

```text
alloy-catalog/
├── catalog/                          # Tool descriptors (metadata only)
│   ├── toolchains/                   # Cross-compilers, linkers, debuggers
│   │   ├── arm-gnu/
│   │   │   ├── arm-none-eabi/
│   │   │   │   ├── index.yaml
│   │   │   │   └── 13.3.rel1.yaml
│   │   │   └── arm-none-linux-gnueabihf/
│   │   ├── riscv-gnu/
│   │   ├── avr-gnu/
│   │   ├── espressif/
│   │   └── ti/
│   ├── sdks/                         # Full SDK bundles
│   │   ├── golang/go/
│   │   ├── flutter/flutter/
│   │   └── zephyr/zephyr-sdk/
│   └── tools/                        # Standalone dev tools
│       ├── nordic/nrf-command-line-tools/
│       ├── pengutronix/genimage/
│       └── libconfuse/libconfuse/
├── blueprints/                       # Environment definitions
│   ├── nordic/
│   │   └── nrf91/                    # Nordic nRF91 dev environment
│   └── raspberry-pi/
│       ├── raspberry-pi-5/           # Raspberry Pi 5 dev environment
│       ├── raspberry-pi-4-model-b/
│       └── ...
└── .github/workflows/
    ├── validate-blueprints.yml       # PR validation
    └── publish-blueprints.yml        # Publish on merge
```

---

## Part 1: The Catalog

The catalog is a collection of YAML descriptors that map a tool identifier + version + host platform to an official download URL and SHA256 checksum.

### Namespaces

| Directory     | ID Prefix    | Purpose                                      |
| ------------- | ------------ | -------------------------------------------- |
| `toolchains/` | `toolchain.` | Cross-compilers, linkers, debuggers          |
| `sdks/`       | `sdk.`       | Full SDK bundles (Zephyr, Flutter, Go, etc.) |
| `tools/`      | `tool.`      | Standalone dev tools (genimage, etc.)        |

### ID Format

IDs are dot-separated and derived from the filesystem path:

```text
<namespace>.<vendor>.<tool>
```

| Path                                           | ID                                           |
| ---------------------------------------------- | -------------------------------------------- |
| `toolchains/arm-gnu/arm-none-linux-gnueabihf/` | `toolchain.arm-gnu.arm-none-linux-gnueabihf` |
| `sdks/golang/go/`                              | `sdk.golang.go`                              |
| `sdks/flutter/flutter/`                        | `sdk.flutter.flutter`                        |
| `tools/pengutronix/genimage/`                  | `tool.pengutronix.genimage`                  |

### Per-Tool Index (`index.yaml`)

Each tool directory contains an `index.yaml` that lists available versions and defines aliases:

```yaml
spec_version: 1
id: sdk.golang.go
type: index

aliases:
  latest: "1.25.7"
  stable: "1.25.7"

versions:
  - version: "1.25.7"
    file: "1.25.7.yaml"
    status: stable
  - version: "1.24.4"
    file: "1.24.4.yaml"
    status: stable
```

Aliases let blueprints reference channels (`@stable`, `@latest`, `@lts`) instead of pinning exact versions. The resolver expands aliases to concrete versions before generating the lockfile.

### Version Descriptor (`<version>.yaml`)

Each version file is immutable and self-contained:

```yaml
spec_version: 1
id: sdk.golang.go
version: "1.24.4"

name: "Go Programming Language"
homepage: "https://go.dev"
license: "BSD-3-Clause"

capabilities:
  - sdk.golang
  - language.go
  - compiler.go

providers:
  - id: archive
    method: archive
    host_platforms:
      linux/amd64:
        url: "https://go.dev/dl/go1.24.4.linux-amd64.tar.gz"
        sha256: "77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"
      linux/arm64:
        url: "https://go.dev/dl/go1.24.4.linux-arm64.tar.gz"
        sha256: "d5501ee5aca0f258d5fe9bfaed401958445014495dc115f202d43d5210b45241"

install_hints:
  creates: "go/bin/go"
  env_vars:
    GOROOT: "/usr/local/go"
    PATH_ADD: "/usr/local/go/bin"

lifecycle:
  status: stable
  released_at: "2025-06-01"
```

#### Version File Fields

| Field           | Required | Description                                                 |
| --------------- | -------- | ----------------------------------------------------------- |
| `spec_version`  | Yes      | Schema version, currently `1`                               |
| `id`            | Yes      | Dot-separated tool ID, must match directory path            |
| `version`       | Yes      | Exact version string, must match filename                   |
| `name`          | Yes      | Human-readable display name                                 |
| `homepage`      | No       | Upstream project URL                                        |
| `license`       | No       | SPDX license identifier                                     |
| `capabilities`  | No       | Trait-based metadata for search and matching                |
| `providers`     | Yes      | List of delivery methods (see below)                        |
| `install_hints` | No       | Post-install metadata (`creates`, `env_vars`, `build_deps`) |
| `lifecycle`     | Yes      | Version lifecycle status                                    |

#### Providers

Each provider declares how the tool is delivered for each host platform:

| Field            | Required | Description                                             |
| ---------------- | -------- | ------------------------------------------------------- |
| `id`             | Yes      | Provider identifier (e.g., `archive`, `source`)         |
| `method`         | Yes      | Delivery method: `archive`, `source`, `alloy`, or `apt` |
| `host_platforms` | Yes      | Map of `os/arch` keys to download details               |

Each platform entry contains:

| Field        | Required | Description        |
| ------------ | -------- | ------------------ |
| `url`        | Yes      | Download URL       |
| `sha256`     | Yes      | SHA256 checksum    |
| `size_bytes` | No       | File size in bytes |

Supported host platforms: `linux/amd64`, `linux/arm64`, `darwin/amd64`, `darwin/arm64`. Each tool declares the platforms it supports in `host_platforms`; resolution picks the matching URL for the current host (e.g. darwin/arm64 on macOS Apple Silicon).

#### Lifecycle

| Status       | Meaning                                                              |
| ------------ | -------------------------------------------------------------------- |
| `stable`     | Current recommended version for general use                          |
| `lts`        | Long-term support -- receives security fixes but not new features    |
| `deprecated` | Still available but should be migrated away from (see `replaced_by`) |
| `eol`        | End of life -- no longer supported                                   |

### Adding a New Tool to the Catalog

1. Create a directory: `catalog/<namespace>/<vendor>/<tool>/`
2. Add a version file: `<version>.yaml`
3. Add `index.yaml` with the tool ID, aliases, and version list
4. Submit a PR

### Adding a New Version

1. Add a new `<version>.yaml` file in the tool directory
2. Update `index.yaml` to list the new version and adjust aliases as needed
3. Submit a PR

---

## Part 2: Blueprints

A blueprint is a declarative definition of a development environment for a specific hardware target. It describes what packages to install, what toolchains to download, and how to configure the machine.

### Blueprint Directory Layout

```text
blueprints/<vendor>/<board>/
├── manifest.yml          # Blueprint metadata, variables, and run order
├── variables.yml         # Optional: additional variables (merged into manifest)
├── 00-system-base.yml    # Task file: system packages
├── 10-host-tools.yml     # Task file: host development tools
├── 20-toolchain.yml      # Task file: cross-compilation toolchains
├── 30-sysroot.yml        # Task file: target sysroot
├── 99-cleanup.yml        # Task file: cleanup
└── alloy.lock.yml        # Auto-generated: pinned download URLs (do not edit)
```

The `<vendor>/<board>` path determines the Alloy Imageimage name when published:

| Blueprint Path                            | Alloy ImageImage                                              |
| ----------------------------------------- | ------------------------------------------------------------- |
| `blueprints/nordic/nrf91/`                | `api.alloy-it.io/community/nordic/nrf91:1.0.0`                |
| `blueprints/raspberry-pi/raspberry-pi-5/` | `api.alloy-it.io/community/raspberry-pi/raspberry-pi-5:1.0.0` |

### The Manifest (`manifest.yml`)

The manifest is the entry point for a blueprint. It defines metadata, variables, optional catalog references, and the execution order of task files.

```yaml
name: "Raspberry Pi 5 Dev Environment"
version: "1.0.1"
description: "Cross-compilation toolchains and dev tools for Raspberry Pi 5."

variables:
  GOLANG_VERSION: "1.24.4"
  GOLANG_URL_amd64: "https://go.dev/dl/go1.24.4.linux-amd64.tar.gz"
  GOLANG_SHA_amd64: "77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"
  GOLANG_URL_arm64: "https://go.dev/dl/go1.24.4.linux-arm64.tar.gz"
  GOLANG_SHA_arm64: "d5501ee5aca0f258d5fe9bfaed401958445014495dc115f202d43d5210b45241"
  TOOLCHAIN_DEST: "/opt/cross-pi/aarch64-linux-gnu"

# Optional: OS/arch targets for CI/CD (one image per target; default: [linux/amd64])
targets:
  - linux/amd64
  - linux/arm64

toolchains:
  - ref: "toolchain.arm-gnu.aarch64-none-linux-gnu@stable"
    alias: TOOLCHAIN_64BIT
  - ref: "sdk.golang.go@1.24.4"
    alias: GOLANG

run_order:
  - "00-system-base.yml"
  - "10-host-tools.yml"
  - "20-toolchain.yml"
  - "30-sysroot.yml"
  - "99-cleanup.yml"
```

#### Manifest Fields

| Field         | Required | Description                                                                                |
| ------------- | -------- | ------------------------------------------------------------------------------------------ |
| `name`        | Yes      | Human-readable blueprint name                                                              |
| `version`     | Yes      | Semantic version string                                                                    |
| `description` | No       | Brief description of the environment                                                       |
| `variables`   | No       | Key-value map of template variables                                                        |
| `targets`     | No       | OS/arch platforms for CI/CD (e.g. `linux/amd64`, `linux/arm64`). Default: `[linux/amd64]`. |
| `toolchains`  | No       | List of catalog refs to resolve via the lockfile                                           |
| `run_order`   | Yes      | Ordered list of task files to execute                                                      |

#### Variables

Variables are key-value strings available in task files via Go template syntax: `{{.Vars.VARIABLE_NAME}}`.

Variables are resolved in this order (highest priority first):

1. OS environment variables (allow runtime overrides)
2. Manifest `variables:` block
3. Injected toolchain variables from the lockfile (e.g., `TOOLCHAIN_64BIT_URL`, `TOOLCHAIN_64BIT_SHA`)

An optional `variables.yml` file can provide additional variables. Manifest variables take precedence over `variables.yml` entries.

#### Toolchain References

The `toolchains:` section references catalog entries. During resolution, each ref is expanded to a concrete URL and SHA256 for the host platform and written to `alloy.lock.yml`.

When an `alias` is provided, two variables are injected into the template context:

- `{ALIAS}_URL` -- the resolved download URL
- `{ALIAS}_SHA` -- the resolved SHA256 checksum

For example, with `alias: TOOLCHAIN_64BIT`, you can use `{{.Vars.TOOLCHAIN_64BIT_URL}}` and `{{.Vars.TOOLCHAIN_64BIT_SHA}}` in task files.

### Task Files

Task files are YAML arrays of steps executed in order. Each step declares a `name` and an `action`.

#### Available Actions

| Action               | Description                                            | Required Fields             |
| -------------------- | ------------------------------------------------------ | --------------------------- |
| `apt_install`        | Install system packages via apt-get                    | `packages`                  |
| `run_command`        | Execute a shell command                                | `command`                   |
| `get_file`           | Download a file and verify its checksum                | `url`, `dest`               |
| `unpack`             | Extract an archive                                     | `source`, `dest`            |
| `unarchive_from_url` | Download and extract in one step                       | `url`, `dest`               |
| `unarchive_from_ref` | Download and extract using a catalog ref from lockfile | `ref` or `url`, plus `dest` |
| `write_env_file`     | Write content to a file (e.g., `/etc/profile.d/`)      | `file`, `content`           |
| `install_target_lib` | Download a .deb and unpack into a sysroot              | `url`, `sysroot` or `dest`  |
| `build_from_source`  | Download source, extract, and run build commands       | `url`, `dest`, `command`    |

#### Common Task Fields

| Field      | Description                                                                             |
| ---------- | --------------------------------------------------------------------------------------- |
| `name`     | Human-readable step name (required)                                                     |
| `action`   | Action type from the table above (required)                                             |
| `creates`  | Idempotency check -- skip this step if the file or directory exists                     |
| `owner`    | Set ownership after execution (e.g., `root:root`)                                       |
| `mode`     | Set permissions after execution (octal or symbolic, e.g., `USER_RWX_GROUP_RX_OTHER_RX`) |
| `per_arch` | Architecture-specific overrides (see below)                                             |

#### Architecture-Specific Overrides (`per_arch`)

Many tools provide different binaries for different CPU architectures. Use `per_arch` to specify platform-specific URLs and checksums:

```yaml
- name: "Install ARM Toolchain"
  action: "unarchive_from_url"
  dest: "/opt/arm-toolchain"
  creates: "/opt/arm-toolchain/bin/arm-none-eabi-gcc"
  per_arch:
    amd64:
      url: "https://developer.arm.com/.../x86_64-arm-none-eabi.tar.xz"
      sha256: "95c011cee430e64dd6087c75c800f04b9c49832cc1000..."
    arm64:
      url: "https://developer.arm.com/.../aarch64-arm-none-eabi.tar.xz"
      sha256: "c8824bffd057afce2259f7618254e840715f33523a3d..."
```

When the provisioner runs on an `amd64` host, it uses the `amd64` URL and checksum. On an `arm64` host, it uses the `arm64` values. Fields in `per_arch` override the task-level defaults.

This is how the provisioner selects the correct binary for the host machine's CPU architecture.

#### Task Examples

**Install system packages:**

```yaml
- name: "Install build tools"
  action: "apt_install"
  packages:
    - build-essential
    - cmake
    - ninja-build
    - git
    - python3
    - python3-pip
```

**Download and extract a toolchain:**

```yaml
- name: "Install Go"
  action: "unarchive_from_url"
  dest: "/usr/local"
  creates: "/usr/local/go/bin/go"
  per_arch:
    amd64:
      url: "{{.Vars.GOLANG_URL_amd64}}"
      sha256: "{{.Vars.GOLANG_SHA_amd64}}"
    arm64:
      url: "{{.Vars.GOLANG_URL_arm64}}"
      sha256: "{{.Vars.GOLANG_SHA_arm64}}"
```

**Set environment variables:**

```yaml
- name: "Add Go to PATH"
  action: "write_env_file"
  file: "/etc/profile.d/10-golang.sh"
  content: |
    #!/bin/sh
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
```

**Run a shell command:**

```yaml
- name: "Run Zephyr SDK setup"
  action: "run_command"
  command: |
    cd /opt/zephyr-sdk && ./setup.sh -t arm-zephyr-eabi -h -c
  creates: "/opt/zephyr-sdk/.setup_complete"
```

**Use a catalog ref (resolved from lockfile):**

```yaml
- name: "Install ARM toolchain from catalog"
  action: "unarchive_from_ref"
  ref: "toolchain.arm-gnu.arm-none-eabi@stable"
  dest: "/opt/arm-toolchain"
  creates: "/opt/arm-toolchain/bin/arm-none-eabi-gcc"
```

### The Lockfile (`alloy.lock.yml`)

The lockfile is auto-generated by `alloy-cicd resolve` (or `alloy-host resolve`). It pins every catalog reference in the manifest to a concrete URL and SHA256 checksum for a specific host platform.

```yaml
# AUTO-GENERATED by alloy-cicd resolve. Do not edit.
resolved_at: "2026-02-15T10:30:00Z"
host: linux/amd64
toolchains:
  toolchain.arm-gnu.aarch64-none-linux-gnu@stable:
    url: "https://developer.arm.com/.../arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"
    sha256: "f0d87abe3dcc24797823f41a8c4eef0c8a76e82ab6ce30f43dc5f97c4b2b1b46"
    method: "archive"
  sdk.golang.go@1.24.4:
    url: "https://go.dev/dl/go1.24.4.linux-amd64.tar.gz"
    sha256: "77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"
    method: "archive"
```

The lockfile ensures reproducible builds: the same lockfile always produces the same environment, regardless of when it is used.

**Do not edit the lockfile manually.** It is regenerated every time CI publishes a blueprint.

---

## Part 3: The CI/CD Pipeline

When blueprints are modified and merged to `main`, GitHub Actions automatically validates, resolves, packs, and pushes them to the Alloy Imageregistry.

### What Happens on a Pull Request

The [validate-blueprints.yml](.github/workflows/validate-blueprints.yml) workflow:

1. Detects which `<vendor>/<board>` blueprints were changed in the PR.
2. Runs `alloy-cicd validate` on each changed blueprint.
3. Runs `alloy-cicd resolve` (dry-run) to verify catalog references can be resolved.

If any step fails, the PR is blocked from merging.

### What Happens on Merge to Main

The [publish-blueprints.yml](.github/workflows/publish-blueprints.yml) workflow:

1. Detects which blueprints changed in the merge commit.
2. Builds `alloy-cicd` from source (once, shared across jobs).
3. For each changed blueprint:
   - **Validate** -- checks YAML structure and task schemas.
   - **Resolve** -- expands catalog refs into `alloy.lock.yml` for `linux/amd64`.
   - **Push** -- packs the blueprint into an Alloy Imageimage and pushes it to the registry.

Each blueprint is published with two tags:

| Tag Pattern       | Example                                                |
| ----------------- | ------------------------------------------------------ |
| `<version>`       | `api.alloy-it.io/community/nordic/nrf91:1.0.0`         |
| `<version>-<sha>` | `api.alloy-it.io/community/nordic/nrf91:1.0.0-abc1234` |

### Alloy ImageImage Structure

Published blueprints are Alloy Imageartifacts with three layers:

| Layer            | Media Type                                          | Content                            |
| ---------------- | --------------------------------------------------- | ---------------------------------- |
| Blueprint bundle | `application/vnd.alloy.blueprint.layer.v1.tar+gzip` | Full blueprint directory as tar.gz |
| Lockfile         | `application/vnd.alloy.lockfile.v1+yaml`            | Standalone `alloy.lock.yml`        |
| Manifest         | `application/vnd.alloy.manifest.v1+yaml`            | Standalone `manifest.yml`          |

The config blob (`application/vnd.alloy.blueprint.config.v1+json`) contains:

```json
{
  "blueprint": { "name": "Nordic nRF91 Dev Environment", "version": "1.0.0" },
  "host": "linux/amd64",
  "resolved_at": "2026-02-15T10:00:00Z",
  "task_files": [
    "00-system-base.yml",
    "10-arm-toolchain.yml",
    "20-nrf-sdk.yml",
    "99-cleanup.yml"
  ]
}
```

---

## Part 4: How the Provisioner Pulls and Installs a Blueprint

The provisioner (`alloy-provisioner`) runs inside the guest VM and is responsible for pulling a blueprint from the Alloy Imageregistry and executing it.

### Platform-Aware Pull

When the provisioner pulls a blueprint, it selects the correct Alloy Imagemanifest based on the host machine's OS and CPU architecture:

1. Detects the current architecture using `uname -m`:
   - `x86_64` maps to `amd64`
   - `aarch64` maps to `arm64`
2. The OS is always `linux` (provisioner runs inside a Linux VM).
3. If the Alloy Imageimage is a multi-arch index, the provisioner selects the manifest matching `linux/<detected-arch>`.
4. Extracts the blueprint layer (`application/vnd.alloy.blueprint.layer.v1.tar+gzip`) into the config directory.

### Execution Flow

Once the blueprint is pulled, the provisioner executes it:

```text
1. Load manifest.yml
   └── Read variables, toolchains, run_order

2. Load alloy.lock.yml (if present)
   └── Map catalog refs → concrete URLs + SHA256

3. Inject lockfile variables
   └── For each toolchain with alias "FOO":
       inject FOO_URL and FOO_SHA into template context

4. For each task file in run_order:
   └── Parse YAML array of tasks
       └── For each task:
           a. Merge per_arch overrides for detected architecture
           b. Resolve catalog ref (if any) from lockfile
           c. Check idempotency (skip if "creates" path exists)
           d. Expand Go template variables: {{.Vars.NAME}}
           e. Execute the action (apt_install, unarchive_from_url, etc.)
           f. Apply owner/mode permissions (if specified)
```

### Architecture Selection in Practice

Consider a blueprint that installs a cross-compiler. The provisioner is running on two different machines:

**On an Intel x86_64 host:**

```text
Task: "Install ARM Toolchain"
  per_arch.amd64 matched
  → URL: https://developer.arm.com/.../x86_64-arm-none-eabi.tar.xz
  → SHA: 95c011cee430e64dd6087c75c800f04b9c49832cc1000...
```

**On an Apple Silicon (arm64) host:**

```text
Task: "Install ARM Toolchain"
  per_arch.arm64 matched
  → URL: https://developer.arm.com/.../aarch64-arm-none-eabi.tar.xz
  → SHA: c8824bffd057afce2259f7618254e840715f33523a3d...
```

The same blueprint works on both architectures. The `per_arch` blocks ensure the correct binaries are downloaded for each host.

### Security

- All downloads are verified against SHA256 checksums. Files are deleted if the checksum does not match.
- Archive extraction validates paths to prevent directory traversal attacks.
- Decompressed file sizes are limited to prevent decompression bombs.
- File operations use restrictive permissions by default.

---

## Writing a New Blueprint

### Step-by-Step Guide

1. **Create the directory:**

   ```bash
   mkdir -p blueprints/<vendor>/<board>
   ```

   Use the hardware vendor as the first level and the board/product as the second.

2. **Create `manifest.yml`:**

   ```yaml
   name: "My Board Dev Environment"
   version: "1.0.1"
   description: "Development tools for My Board."

   variables:
     MY_TOOL_VERSION: "2.0.0"
     MY_TOOL_DEST: "/opt/my-tool"
     MY_TOOL_URL_amd64: "https://example.com/my-tool-2.0.0-linux-amd64.tar.gz"
     MY_TOOL_SHA_amd64: "abc123..."
     MY_TOOL_URL_arm64: "https://example.com/my-tool-2.0.0-linux-arm64.tar.gz"
     MY_TOOL_SHA_arm64: "def456..."

   toolchains: []

   run_order:
     - "00-system-base.yml"
     - "10-tools.yml"
     - "99-cleanup.yml"
   ```

3. **Create task files:**

   `00-system-base.yml`:

   ```yaml
   - name: "Update APT cache"
     action: "run_command"
     command: "apt-get update -y"

   - name: "Install base packages"
     action: "apt_install"
     packages:
       - build-essential
       - git
       - cmake
   ```

   `10-tools.yml`:

   ```yaml
   - name: "Install My Tool"
     action: "unarchive_from_url"
     dest: "{{.Vars.MY_TOOL_DEST}}"
     creates: "{{.Vars.MY_TOOL_DEST}}/bin/my-tool"
     per_arch:
       amd64:
         url: "{{.Vars.MY_TOOL_URL_amd64}}"
         sha256: "{{.Vars.MY_TOOL_SHA_amd64}}"
       arm64:
         url: "{{.Vars.MY_TOOL_URL_arm64}}"
         sha256: "{{.Vars.MY_TOOL_SHA_arm64}}"

   - name: "Add My Tool to PATH"
     action: "write_env_file"
     file: "/etc/profile.d/10-my-tool.sh"
     content: |
       #!/bin/sh
       export PATH=$PATH:{{.Vars.MY_TOOL_DEST}}/bin
   ```

   `99-cleanup.yml`:

   ```yaml
   - name: "Clean APT cache"
     action: "run_command"
     command: "apt-get clean && rm -rf /var/lib/apt/lists/*"
   ```

4. **Test locally** (optional, requires `alloy-cicd` binary):

   ```bash
   alloy-cicd validate --dir blueprints/<vendor>/<board>
   alloy-cicd resolve \
     --dir blueprints/<vendor>/<board> \
     --catalog-dir . \
     --host-platform linux/amd64
   ```

5. **Submit a PR.** CI will validate the blueprint automatically.

### Best Practices

- **Use numbered prefixes** for task files (`00-`, `10-`, `20-`, `99-`) to make the execution order obvious at a glance.
- **Use `creates` for idempotency.** Every task that produces a file or directory should set `creates` so it is skipped on re-provision.
- **Always provide both `amd64` and `arm64`** in `per_arch` blocks when the tool supports both architectures.
- **Use variables** for versions, URLs, and SHA256 checksums. This keeps task files clean and makes updates easier.
- **Put cleanup last** (`99-cleanup.yml`) to shrink the final image size.
- **Name convention:** Use the vendor's official product name in lowercase with hyphens (e.g., `raspberry-pi-4-model-b`, `nrf91`).

### Using Catalog References

Instead of hardcoding URLs in variables, you can reference tools from the catalog. This delegates version resolution and platform-specific URL selection to the catalog system.

In `manifest.yml`:

```yaml
toolchains:
  - ref: "sdk.golang.go@stable"
    alias: GOLANG
  - ref: "toolchain.arm-gnu.arm-none-eabi@13.3.rel1"
    alias: ARM_TOOLCHAIN
```

In a task file:

```yaml
- name: "Install Go from catalog"
  action: "unarchive_from_ref"
  ref: "sdk.golang.go@stable"
  dest: "/usr/local"
  creates: "/usr/local/go/bin/go"
```

Or use the injected variables:

```yaml
- name: "Install ARM toolchain from catalog"
  action: "unarchive_from_url"
  dest: "/opt/arm-toolchain"
  creates: "/opt/arm-toolchain/bin/arm-none-eabi-gcc"
  per_arch:
    amd64:
      url: "{{.Vars.ARM_TOOLCHAIN_URL}}"
      sha256: "{{.Vars.ARM_TOOLCHAIN_SHA}}"
```

The `_URL` and `_SHA` variables are automatically injected from the lockfile based on the alias name and the host platform.

---

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
     stable: "1.22.8" # company-approved version
   ```

3. **Merge upstream** periodically -- only index aliases may conflict (intentionally).

---

## Contributing

1. Fork this repository.
2. Make your changes (new tool descriptor, new blueprint, or version update).
3. Submit a pull request.

CI will validate:

- Blueprint YAML schema compliance
- Catalog IDs match directory paths
- All task actions are valid and have required fields
- Catalog references can be resolved
