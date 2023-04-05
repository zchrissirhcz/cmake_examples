#!/bin/zsh

#export PYTHON_HOME=/home/zz/soft/miniconda3/bin
#export Python3_EXECUTABLE=/home/zz/soft/miniconda3/bin/python
cmake -S /home/zz/work/github/llvm-project/lldb \
    -B build-lldb-miniconda \
    -G Ninja \
    -DLLVM_DIR=/home/zz/work/github/llvm-project/build/build-clang/lib/cmake/llvm \
    -DLLDB_ENABLE_PYTHON=ON \
    -DPYTHON_HOME=/home/zz/soft/miniconda3/bin \
    -DLLDB_INCLUDE_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=~/soft/llvm-14.0.5

