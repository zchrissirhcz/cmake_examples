#!/bin/bash

BUILD_DIR=mac-arm64
CVBUILD_PLATFORM=mac
CVBUILD_ARCH=arm64

cmake \
    -S .. \
    -B $BUILD_DIR \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-CLHPP/mac-arm64 \
    -D OpenCLHeaders_DIR=$ARTIFACTS_DIR/OpenCL-Headers/share/cmake/OpenCLHeaders \
    -D OpenCLICDLoader_DIR=$ARTIFACTS_DIR/OpenCL-ICD-Loader/mac-arm64/share/cmake/OpenCLICDLoader

cmake --build $BUILD_DIR --target install


