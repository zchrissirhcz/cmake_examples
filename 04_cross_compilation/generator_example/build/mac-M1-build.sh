#!/bin/zsh

BUILD_DIR=mac-M1
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# -G "Xcode"

cmake ../.. -DCMAKE_BUILD_TYPE=Release

cmake --build .
#cmake --build . --target install
#cmake --build . --target arcpkg-export
cd ..
