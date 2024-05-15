#!/bin/bash

BUILD_DIR=mac-x64
CVBUILD_PLATFORM=mac
CVBUILD_ARCH=x64

cmake \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-ICD-Loader/mac-x64 \
    -D OpenCLHeaders_DIR=$ARTIFACTS_DIR/OpenCL-Headers/share/cmake/OpenCLHeaders

cmake --build $BUILD_DIR --target install
