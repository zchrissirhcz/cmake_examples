#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPUINFO_BUILD_UNIT_TESTS=OFF \
    -DCPUINFO_BUILD_MOCK_TESTS=OFF \
    -DCPUINFO_BUILD_BENCHMARKS=OFF \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/cpuinfo/master/linux-x64 \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .
cmake --install .

cd ..
