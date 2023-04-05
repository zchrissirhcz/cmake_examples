#!/bin/bash


BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DNCNN_OPENMP=ON \
    -DCMAKE_INSTALL_PREFIX=/home/zz/artifacts/ncnn/20220216/linux-x64 \
    -DNCNN_SHARED_LIB=OFF \
    -DNCNN_BUILD_TESTS=OFF
cmake --build .
cd ..
