#!/bin/bash


BUILD_DIR=arm-none-eabi
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -DCMAKE_TOOLCHAIN_FILE=../../arm-none-eabi-gcc.toolchain.cmake
make
cd ..
