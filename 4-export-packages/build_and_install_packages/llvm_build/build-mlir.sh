#!/bin/bash

BUILD_DIR=mlir

# 提前编译好 clang， 再单独编译 mlir。 目的是加速编译过程。
# 编译 clang 时需要关掉 include 的 test

cmake -S /home/zz/work/github/llvm-project/mlir \
    -B $BUILD_DIR \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS="mlir" \
    -DLLVM_TARGETS_TO_BUILD="host;RISCV" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_DIR=/home/zz/work/github/llvm-project/build-dev/clang/lib/cmake/llvm \
    -DMLIR_INCLUDE_TESTS=OFF \
    -DMLIR_INCLUDE_INTEGRATION_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm16-mlir

cmake --build $BUILD_DIR

# cmake -G Ninja ../llvm \
#     -DLLVM_ENABLE_PROJECTS="mlir;clang" \
#     -DLLVM_TARGETS_TO_BUILD="host;RISCV" \
#     -DLLVM_ENABLE_ASSERTIONS=ON \
#     -DCMAKE_BUILD_TYPE=RELEASE
#     -DLLDB_INCLUDE_TESTS=OFF
