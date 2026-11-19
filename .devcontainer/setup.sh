#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Workshop setup failed during ${stage:-initialization} at line $LINENO. See the error above; rerun bash .devcontainer/setup.sh after fixing it." >&2' ERR
cd "$(dirname "${BASH_SOURCE[0]}")/.."

stage="Lean setup"
stage_start=$SECONDS
echo "==> $stage"
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
echo "$stage finished in $((SECONDS - stage_start))s"

stage="Dependency checkout and Mathlib cache retrieval"
stage_start=$SECONDS
echo "==> $stage"
# The pinned cache client defaults to Azure. Use its Cloudflare mirror by default.
export USE_FRO_CACHE="${USE_FRO_CACHE:-1}"
# Match the direct Mathlib import in Tutorial.lean and Solutions.lean.
mathlib_root=Mathlib.Data.ZMod.Basic
cache_ready=false
if lake exe cache get "$mathlib_root"; then
  # A cache request can succeed even when individual artifacts are missing.
  if lake build --no-build "+$mathlib_root"; then
    cache_ready=true
  fi
fi
echo "$stage finished in $((SECONDS - stage_start))s"

if [[ "$cache_ready" != true ]]; then
  echo "Mathlib's precompiled files are unavailable or incomplete for $mathlib_root." >&2
  echo "See the cache and Lake output above. Check connectivity to mathlib4.lean-cache.cloud and GitHub, then retry." >&2
  echo "To try the Azure endpoint, rerun with USE_FRO_CACHE=0." >&2
  if [[ "${WORKSHOP_ALLOW_SOURCE_BUILD:-0}" != 1 ]]; then
    echo "Maintainers can opt into a potentially lengthy source build with WORKSHOP_ALLOW_SOURCE_BUILD=1." >&2
    exit 1
  fi
  echo "Maintainer override enabled. Building any missing Mathlib dependencies from source." >&2
fi

stage="Workshop build"
stage_start=$SECONDS
echo "==> $stage"
lake build
echo "$stage finished in $((SECONDS - stage_start))s"
echo "Workshop ready. Open Workshop/Tutorial.lean."
