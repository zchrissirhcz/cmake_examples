#!/bin/bash

BUILD_DIR=linux-x64-with-gtest
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/zz/artifact/benchmark/linux-x64 \
    -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON

# -DBENCHMARK_USE_BUNDLED_GTEST=OFF
# -DGTest_DIR=/home/zz/artifact/googletest/1.11.0/linux-x64/lib/cmake/GTest

# -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON

cmake --build . -j
cd ..

