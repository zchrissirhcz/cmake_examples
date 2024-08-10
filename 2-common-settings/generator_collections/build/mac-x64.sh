#!/bin/bash


BUILD_DIR=mac-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. -GNinja -DCMAKE_BUILD_TYPE=Debug -DPLAIN_USE_ASAN=ON
cmake --build . -j
cd ..
