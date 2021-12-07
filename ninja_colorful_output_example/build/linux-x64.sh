#!/bin/bash

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -G Ninja \
    -DFORCE_COLORED_OUTPUT=ON
cmake --build .
cd ..
