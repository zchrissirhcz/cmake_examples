#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/armadillo/11.2.x/linux-x64 \
    -DBUILD_SHARED_LIBS=OFF \
    -DDETECT_HDF5=OFF \
    -DBUILD_SMOKE_TEST=OFF

cmake --build . -j && cmake --install .

