#!/bin/bash

BUILD_DIR=build-xcode
cmake -S . -B $BUILD_DIR -G "Xcode"
cmake --build $BUILD_DIR

#cmake --install $BUILD_DIR
# or:
#cmake --install $BUILD_DIR --prefix /usr/local/xxx
