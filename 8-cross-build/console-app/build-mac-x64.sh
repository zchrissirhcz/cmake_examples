#!/bin/bash

BUILD_DIR=build-mac-x64
cmake -S . -B $BUILD_DIR -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build $BUILD_DIR
