#!/bin/bash

BUILD_DIR=xcode
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. -G "Xcode"
cmake --build .

#cmake --install .
# or:
#cmake --install . --prefix /usr/local/xxx

cd ..
