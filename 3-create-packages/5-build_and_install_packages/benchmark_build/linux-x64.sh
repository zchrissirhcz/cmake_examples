#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/benchmark/1.7.0/linux-x64 \
    -DBENCHMARK_ENABLE_TESTING=OFF \
    -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

cmake --build . -j
cmake --install .
cd ..

