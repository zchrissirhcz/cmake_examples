#!/bin/bash

BUILD_DIR=build-lldb
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang;lldb" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD='X86' \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm16-dev \
    -DLLDB_ENABLE_PYTHON=ON \
    ../../llvm
cd ..

