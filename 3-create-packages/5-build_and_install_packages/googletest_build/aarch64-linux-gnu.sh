#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
TOOLCHAIN=~/work/crepo/toolchains/aarch64-linux-gnu.toolchain.cmake
BUILD_DIR=aarch64-linux-gnu
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DCMAKE_INSTALL_PREFIX=INSTALL_DIR=$ARTIFACT_DIR/googletest/1.11.0/aarch64-linux-gnu \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

#ninja
#cmake --build . --verbose
cmake --build . -j
cmake --install .

cd ..
