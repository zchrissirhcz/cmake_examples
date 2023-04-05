#!/bin/bash

BUILD_DIR=mac-arm64
CVBUILD_PLATFORM=mac
CVBUILD_ARCH=arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. -DCMAKE_BUILD_TYPE=Debug
cmake --build . -j
cd ..

