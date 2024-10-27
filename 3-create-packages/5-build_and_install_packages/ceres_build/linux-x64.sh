#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/ceres/2.1.0/linux-x64 \
    -DMINIGLOG=ON \
    -DGFLAGS=OFF \
    -DSUITESPARSE=OFF \
    -DCXSPARSE=OFF \
    -DCUDA=OFF \
    -DBUILD_BENCHMARKS=OFF

# https://github.com/google/googletest/pull/3661

cmake --build . -j
cmake --install .
cd ..
