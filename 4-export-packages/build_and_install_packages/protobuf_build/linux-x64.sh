#!/bin/bash

# have to manually download 3.21.0 source package
# the git-clone-then-checkout-tag will cause cmake error. don't know why.
# https://github.com/protocolbuffers/protobuf/releases/download/v21.10/protobuf-all-21.10.tar.gz

BUILD_DIR=linux-x64

cmake \
    -G Ninja \
    -S ../cmake \
    -B ${BUILD_DIR} \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/home/zz/artifacts/protobuf/3.21.0/linux-x64 \
    -Dprotobuf_BUILD_TESTS=OFF \
    -D BUILD_SHARED_LIBS=ON

cmake --build ${BUILD_DIR} \
     && cmake --build ${BUILD_DIR} --target install