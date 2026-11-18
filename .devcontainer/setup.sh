#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Workshop setup failed at line $LINENO. See the error above; rerun bash .devcontainer/setup.sh after fixing it." >&2' ERR
cd "$(dirname "${BASH_SOURCE[0]}")/.."

export ELAN_HOME="${ELAN_HOME:-$HOME/.elan}"
export PATH="$ELAN_HOME/bin:$PATH"
if ! command -v elan >/dev/null 2>&1; then
  case "$(uname -m)" in
    x86_64) platform=x86_64-unknown-linux-gnu ;;
    aarch64) platform=aarch64-unknown-linux-gnu ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
  esac
  installer_dir=$(mktemp -d)
  curl --fail --show-error --location --retry 3 \
    "https://github.com/leanprover/elan/releases/download/v4.1.2/elan-${platform}.tar.gz" \
    --output "$installer_dir/elan.tar.gz"
  tar -xzf "$installer_dir/elan.tar.gz" -C "$installer_dir"
  "$installer_dir/elan-init" -y --default-toolchain none --no-modify-path
  rm -rf "$installer_dir"
fi

# Lake reads lean-toolchain and the committed manifest; do not run lake update.
if [[ ! -f lake-manifest.json ]]; then
  echo "Missing lake-manifest.json: restore the committed dependency lockfile." >&2
  exit 1
fi
lean --version
lake --version
# Cache only the Mathlib import needed by the checked solutions, keeping cold starts small.
if ! lake exe cache get Mathlib.Tactic.NormNum; then
  echo "WARNING: Mathlib cache unavailable; lake build will compile dependencies from source (much slower)." >&2
fi
lake build
echo "Workshop ready. Open Workshop/Tutorial.lean."
