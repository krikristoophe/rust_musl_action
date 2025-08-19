# syntax=docker/dockerfile:1

FROM debian:12-slim

ARG RUST_TOOLCHAIN=stable
ARG SCCACHE_VERSION=0.10.0

ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo \
    PATH=/opt/cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Packages de base + musl
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git xz-utils pkg-config build-essential \
    musl-tools \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain ${RUST_TOOLCHAIN} \
    && rustup target add x86_64-unknown-linux-musl \
    && curl -sSL https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-x86_64-unknown-linux-musl.tar.gz \
    | tar -xz --strip-components=1 -C /usr/local/bin --wildcards '*/sccache' \
    || (cargo install sccache && mv /opt/cargo/bin/sccache /usr/local/bin/)

# Valeurs par défaut utiles à l’exécution
ENV RUSTFLAGS="-C target-feature=+crt-static" \
    RUSTC_WRAPPER="sccache" \
    CC_x86_64_unknown_linux_musl="musl-gcc" \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER="musl-gcc"

WORKDIR /github/workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
