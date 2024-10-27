#!/bin/bash

# note: this will very time costing
# you may drop some items in LLVM_ENABLE_PROJECTS list
# clang-tools-extra: contains many tools, such as clangd and clang-tidy

cmake .. \
    -G Ninja \
    -D LLVM_ENABLE_PROJECTS='clang;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp;clang-tools-extra' \
    -D CMAKE_BUILD_TYPE=Release \
    -D LLVM_TARGETS_TO_BUILD='X86' \
    -D CMAKE_INSTALL_PREFIX=~/soft/llvm13 \
    -D CMAKE_C_COMPILER=clang \
    -D CMAKE_CXX_COMPILER=clang++ \
    -D LIBCXX_CXX_ABI=libcxxabi \
    ../llvm

