#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

BUILD_DIR=linux-x64

cmake -G Ninja \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/SPIRV-LLVM-Translator/master/linux

cmake --build $BUILD_DIR -j4
cmake --install $BUILD_DIR

