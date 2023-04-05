#!/bin/bash
BUILD_DIR=linux

mkdir -p $BUILD_DIR

cd $BUILD_DIR

cmake -C ../custom.cmake \
    -DCMAKE_INSTALL_PREFIX=./install \
    ../..

make
make install

cd ..
