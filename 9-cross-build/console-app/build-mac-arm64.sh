#!/bin/zsh

BUILD_DIR=build-mac-arm64
cmake -S . -B $BUILD_DIR -DCMAKE_BUILD_TYPE=Release
cmake --build $BUILD_DIR
