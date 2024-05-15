#!/bin/bash


BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DHPCC_USE_X86_64=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=~/artifacts/ppl.cv/0.6.2/linux-x64 \
    -DPPLCV_INSTALL=ON \
    -DPPLCV_BUILD_TESTS=OFF \
    -DPPLCV_BUILD_BENCHMARK=OFF \
    -DPPLCV_HOLD_DEPS=ON \
    -DDPPLCV_DEPS_USE_GITEE=ON
cmake --build . -j
cd ..
