#!/bin/bash

BUILD_DIR=clang
cmake \
    -S ../llvm \
    -B $BUILD_DIR \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD='X86' \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm16-dev \
    -DLLVM_INCLUDE_TESTS=OFF
cmake --build $BUILD_DIR
cmake --install $BUILD_DIR
cd ..
