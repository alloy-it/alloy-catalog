#!/usr/bin/env bash
# Validate and resolve blueprints locally (without writing alloy.lock.yml).
# Run from alloy-catalog repo root to catch errors before pushing to CI.
# Usage: ./scripts/validate-blueprints-local.sh [blueprint ...]
#   With no args: validate all blueprints under blueprints/
#   With args:    validate only blueprints/vendor/board (e.g. nordic/nrf91)

set -euo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
cd "$REPO_ROOT"

# alloy-cicd binary: ALLOY_CICD_BIN, or ./alloy-cicd-bin, or PATH
if [[ -n "${ALLOY_CICD_BIN:-}" && -x "$ALLOY_CICD_BIN" ]]; then
  CICD_BIN="$ALLOY_CICD_BIN"
elif [[ -x "./alloy-cicd-bin" ]]; then
  CICD_BIN="./alloy-cicd-bin"
elif command -v alloy-cicd &>/dev/null; then
  CICD_BIN="alloy-cicd"
else
  echo "Error: alloy-cicd not found. Set ALLOY_CICD_BIN or build and run from repo root:" >&2
  echo "  (cd ../alloy-cicd && go build -o alloy-cicd ./cmd/alloy-cicd) && export ALLOY_CICD_BIN=\$(pwd)/alloy-cicd" >&2
  exit 1
fi

HOST_PLATFORM="${HOST_PLATFORM:-linux/amd64}"

# Resolve list of blueprint dirs: blueprints/vendor/board
if [[ $# -gt 0 ]]; then
  BLUEPRINTS=()
  for bp in "$@"; do
    dir="blueprints/$bp"
    if [[ -f "$dir/manifest.yml" ]]; then
      BLUEPRINTS+=("$dir")
    else
      echo "Error: $dir/manifest.yml not found." >&2
      exit 1
    fi
  done
else
  BLUEPRINTS=()
  while IFS= read -r f; do
    BLUEPRINTS+=("$(dirname "$f")")
  done < <(find blueprints -maxdepth 3 -name manifest.yml -type f 2>/dev/null | sort)
fi

if [[ ${#BLUEPRINTS[@]} -eq 0 ]]; then
  echo "No blueprints found under blueprints/." >&2
  exit 1
fi

echo "Validating and resolving ${#BLUEPRINTS[@]} blueprint(s) (dry-run, no lock files written)..."
failed=0
for dir in "${BLUEPRINTS[@]}"; do
  name="${dir#blueprints/}"
  printf "\n--- %s ---\n" "$name"
  if ! "$CICD_BIN" validate --dir "$dir"; then
    echo "Validate failed: $dir" >&2
    failed=1
    continue
  fi
  if ! "$CICD_BIN" resolve --dir "$dir" --catalog-dir . --host-platform "$HOST_PLATFORM" --dry-run; then
    echo "Resolve failed: $dir" >&2
    failed=1
  fi
done

if [[ $failed -eq 1 ]]; then
  echo "One or more blueprints failed validation or resolve." >&2
  exit 1
fi
echo "All blueprints passed validation and resolve (dry-run)."
