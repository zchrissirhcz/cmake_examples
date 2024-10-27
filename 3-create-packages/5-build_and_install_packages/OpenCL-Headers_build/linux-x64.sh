#!/bin/bash

# https://github.com/KhronosGroup/OpenCL-Headers/

BUILD_DIR=linux-x64
cmake \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-Headers

cmake --build $BUILD_DIR --target install
