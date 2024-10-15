FROM ubuntu:22.04 AS rust
LABEL maintainer="bboyleonp666 <bboyleonp@gmail.com>"
WORKDIR /root

ARG LLVM_VERSION=18

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
    rustup install stable && \
    rustup toolchain install nightly --component rust-src && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add aarch64-unknown-linux-musl && \
    cargo install bpf-linker && \
    cargo install cargo-generate

FROM rust AS aya
## Clone aya and Build libbpf
RUN mkdir -p /root/aya-rs && \
    cd /root/aya-rs && \
    git clone https://github.com/aya-rs/aya.git && \
    git clone https://github.com/aya-rs/book.git && \
    git clone --recurse-submodules https://github.com/libbpf/bpftool.git && \
    cd bpftool/src && make && make install

CMD ["/bin/bash"]
