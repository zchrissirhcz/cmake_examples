#!/bin/bash


#!/bin/bash

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/artifact/DBoW3/master/linux-x64
cmake --build . -j
cmake --install .
cd ..

