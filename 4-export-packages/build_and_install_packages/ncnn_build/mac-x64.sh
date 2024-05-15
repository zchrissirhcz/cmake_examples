#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=mac-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

echo $ARTIFACTS_DIR

cmake ../.. \
    -GNinja \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/ncnn/20211208/mac-x64-vulkan \
    -DCMAKE_BUILD_TYPE=Release \
    -DNCNN_VULKAN=ON \

cmake --build . -j
cmake --install .
cd ..
