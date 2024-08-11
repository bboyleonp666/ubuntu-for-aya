FROM ubuntu:22.04
LABEL maintainer="bboyleonp <bboyleonp@gmail.com>"
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
    ln -s /usr/lib/llvm-18/bin/clang /usr/bin/clang && \
    ln -s /usr/lib/llvm-18/bin/llvm-config /usr/bin/llvm-config && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    rustup install stable && \
    rustup toolchain install nightly --component rust-src && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add aarch64-unknown-linux-musl && \
    cargo install bpf-linker && \
    cargo install cargo-generate

## Clone aya and Build libbpf
RUN git clone https://github.com/aya-rs/aya.git && \
    git clone --recurse-submodules https://github.com/libbpf/bpftool.git && \
    cd bpftool/src && make && make install

CMD ["/bin/bash"]
