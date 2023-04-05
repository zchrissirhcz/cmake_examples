#!/bin/zsh

# 先编译好 clang， 再编译 lldb， 目的是加速编译过程

BUILD_DIR=lldb

cmake -S /home/zz/work/github/llvm-project/lldb \
    -B $BUILD_DIR \
    -G Ninja \
    -DLLVM_DIR=/home/zz/work/github/llvm-project/build-dev/build-clang/lib/cmake/llvm \
    -DLLDB_ENABLE_PYTHON=ON \
    -DLLVM_EXTERNAL_LIT=/home/zz/work/github/llvm-project/build-dev/build-clang/bin/llvm-lit \
    -DPYTHON_HOME=/home/zz/soft/miniconda3/bin \
    -DLLDB_INCLUDE_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm16-dev

cmake --build $BUILD_DIR -j4
cmake --install $BUILD_DIR
