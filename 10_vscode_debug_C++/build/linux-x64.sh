#!/bin/bash

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../..
cmake --build . -DCMAKE_BUILD_TYPE=Debug
cd ..