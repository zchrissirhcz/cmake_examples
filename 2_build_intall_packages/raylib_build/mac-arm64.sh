#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=mac-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/raylib/4.2.0/mac-arm64 \
    -DBUILD_SHARED_LIBS=ON

cmake --build . -j
cmake --install .
cd ..

