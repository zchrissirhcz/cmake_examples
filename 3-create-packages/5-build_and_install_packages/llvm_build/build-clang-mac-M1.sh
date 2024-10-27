#!/bin/bash

BUILD_DIR=clang

cmake \
    -S ../llvm \
    -B $BUILD_DIR \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD='AArch64' \
    -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind' \
    -DDEFAULT_SYSROOT="$(xcrun --show-sdk-path)" \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm16-dev

cmake --build $BUILD_DIR
