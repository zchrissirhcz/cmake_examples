#!/bin/bash

#export PATH=~/soft/gcc-linaro-arm-linux-gnueabihf-4.8/bin:$PATH

BUILD_DIR=arm-linux-gnueabihf-gcc
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -DCMAKE_TOOLCHAIN_FILE=../../arm-linux-gnueabihf-gcc.toolchain.cmake
make
cd ..
