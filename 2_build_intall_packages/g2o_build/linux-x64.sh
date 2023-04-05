#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/g2o/master/linux-x64

cmake --build . -j
cmake --install .
cd ..
