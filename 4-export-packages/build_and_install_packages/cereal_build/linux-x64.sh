#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

BUILD_DIR=linux-x64
cmake \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/cereal/1.3.2/linux-x64 \
    -D BUILD_TESTS=OFF \
    -D SKIP_PERFORMANCE_COMPARISON=ON \
    -D CMAKE_BUILD_TYPE=Release \
    -D BUILD_SANDBOX=OFF

cmake --build $BUILD_DIR --target install