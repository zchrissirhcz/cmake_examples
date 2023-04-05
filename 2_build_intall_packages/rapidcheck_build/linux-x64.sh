#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/rapidcheck/20211010/linux-x64 \
    -DBUILD_SHARED_LIBS=OFF

cmake --build . -j
cmake --install .
cd ..

