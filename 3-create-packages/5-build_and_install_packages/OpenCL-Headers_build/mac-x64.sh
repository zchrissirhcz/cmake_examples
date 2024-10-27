#!/bin/bash

BUILD_DIR=mac-x64
CVBUILD_PLATFORM=mac
CVBUILD_ARCH=x64

cmake \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-Headers

cmake --build $BUILD_DIR --target install

