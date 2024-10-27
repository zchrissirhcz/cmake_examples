#!/bin/bash

#https://github.com/KhronosGroup/OpenCL-ICD-Loader

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -DOpenCLHeaders_DIR=$ARTIFACTS_DIR/OpenCL-Headers/share/cmake/OpenCLHeaders \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-ICD-Loader/linux-x64

cmake --build . --target install
cd ..