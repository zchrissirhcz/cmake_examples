#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=mac-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/glfw/3.3.6/mac-arm64 \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

# https://github.com/google/googletest/pull/3661

cmake --build . -j
cmake --install .
cd ..
