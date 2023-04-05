#!/bin/bash

BUILD_DIR=build-clang
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang" ../../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD='X86' \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm-14.0.5
cd ..

