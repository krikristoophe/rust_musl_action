#!/usr/bin/env bash
set -euo pipefail

TOOLCHAIN="${1:-stable}"
TARGET="${2:-x86_64-unknown-linux-musl}"
ARGS="${3:---release --locked}"
WORKDIR="${4:-.}"
USE_SCCACHE="${5:-true}"

export PATH="/opt/cargo/bin:${PATH}"
export HOME=${HOME:-/github/home}
export CARGO_HOME="$HOME/.cargo"
#export RUSTUP_HOME="$HOME/.rustup"   # optionnel (rustup peut rester /opt/rustup)
export SCCACHE_DIR="$HOME/.cache/sccache"

mkdir -p "$CARGO_HOME" "$SCCACHE_DIR"

# Sélection dynamique de toolchain si demandé
if [ "$TOOLCHAIN" != "stable" ]; then
  rustup toolchain install "$TOOLCHAIN" --profile minimal
  rustup default "$TOOLCHAIN"
  rustup target add "$TARGET"
fi

# sccache optionnel
#if [ "$USE_SCCACHE" != "true" ]; then
#  unset RUSTC_WRAPPER
#fi

cd "$WORKDIR"

# Print versions (debug utile)
rustc -V
cargo -V
echo "Target: $TARGET"
echo "Args  : $ARGS"
echo "CARGO_HOME : $CARGO_HOME"
echo "SCCACHE_DIR : $SCCACHE_DIR"

# Build
cargo build --target "$TARGET" $ARGS

chown -R 1001:1001 /github/workspace/target || true

# Stats sccache si actif (non bloquant)
(sccache --show-stats || true)

# Output (pour récupérer le chemin des artefacts)
TARGET_DIR="target/${TARGET}"

echo "artifact-path=${TARGET_DIR}" >> "$GITHUB_OUTPUT"

ls -la $HOME
