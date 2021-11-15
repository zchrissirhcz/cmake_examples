#!/bin/bash

#TOOLCHAIN=/home/zz/work/test/rtos-test/arm-none-eabi-gcc.toolchain.cmake
TOOLCHAIN=/home/zz/work/test/rtos-test/arm-gcc-toolchain.cmake

BUILD_DIR=arm-none-eabi
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .

cd ..
