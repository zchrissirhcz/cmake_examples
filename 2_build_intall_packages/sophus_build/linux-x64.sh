#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/sophus/master/linux-x64 \
	-DUSE_BASIC_LOGGING=ON \
    -DBUILD_SOPHUS_TESTS=OFF

cmake --build . -j
cmake --install .
cd ..

