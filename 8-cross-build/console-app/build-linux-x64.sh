#!/bin/bash

BUILD_DIR=build-linux-x64
cmake -S . -B $BUILD_DIR -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build $BUILD_DIR
