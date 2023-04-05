#!/bin/bash

BUILD_DIR=linux-x64
CVBUILD_PLATFORM=linux
CVBUILD_ARCH=x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. -DCMAKE_BUILD_TYPE=Debug
cmake --build . -j
cd ..

