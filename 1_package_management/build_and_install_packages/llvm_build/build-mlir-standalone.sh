#!/bin/bash

BUILD_DIR=build-mlir

cmake \
    -S ../llvm \
    -B $BUILD_DIR \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS="mlir;clang" \
    -DLLVM_TARGETS_TO_BUILD="host;AArch64" \
    -DMLIR_ENABLE_CUDA_RUNNER=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_BUILD_TYPE=RELEASE

cmake --build $BUILD_DIR
