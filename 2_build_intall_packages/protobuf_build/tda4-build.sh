#!/bin/bash

BUILD_DIR=tda4

cmake \
    -G Ninja \
    -S ../cmake \
    -B ${BUILD_DIR} \
    -P ../arcbuild.cmake \
    -p linux \
    -a arm64 \
    -D ARCBUILD_ROOT=/home/zz/soft/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/home/zz/artifacts/protobuf/3.21.9/tda4 \
    -Dprotobuf_BUILD_TESTS=OFF \
    -D BUILD_SHARED_LIBS=ON

cmake --build ${BUILD_DIR} \
     && cmake --build ${BUILD_DIR} --target install