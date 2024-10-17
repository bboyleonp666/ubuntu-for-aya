FROM ubuntu:22.04
LABEL maintainer="bboyleonp666 <bboyleonp@gmail.com>"
WORKDIR /root

ARG LLVM_VERSION=19

## Install packages for building BPF
# 1. build tools
# 2. Rust
# 3. LLVM
RUN apt update && \
    apt install -y build-essential git cmake curl wget vim && \
    apt install -y pkg-config libelf-dev libssl-dev zlib1g zlib1g-dev && \
    apt install -y lsb-release wget software-properties-common gnupg && \
    curl -fsS https://apt.llvm.org/llvm.sh | bash -s -- ${LLVM_VERSION} && \
    ln -s /usr/lib/llvm-${LLVM_VERSION}/bin/clang /usr/bin/clang && \
    ln -s /usr/lib/llvm-${LLVM_VERSION}/bin/llvm-config /usr/bin/llvm-config && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    ln -s "$HOME/.cargo/bin/cargo" /usr/local/bin/cargo && \
    rustup install stable && \
    rustup toolchain install nightly --component rust-src && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add aarch64-unknown-linux-musl && \
    if [ "$(uname -m)" = "aarch64" ]; then \
        apt install -y llvm-19-dev libclang-19-dev libpolly-19-dev && \
        ln -s /usr/lib/aarch64-linux-gnu/libzstd.so.1 /usr/lib/aarch64-linux-gnu/libzstd.so && \
        cargo install bpf-linker --no-default-features; \
    else \
        cargo install bpf-linker; \
    fi && \
    cargo install cargo-generate

CMD ["/bin/bash"]
