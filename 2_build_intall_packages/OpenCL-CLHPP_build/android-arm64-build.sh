#!/bin/bash

ANDROID_NDK=~/soft/android-ndk-r23b
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

# echo "=== TOOLCHAIN is: $TOOLCHAIN"

BUILD_DIR=android-arm64
CVBUILD_PLATFORM=android
CVBUILD_ARCH=arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/OpenCL-CLHPP/android-arm64 \
    -D OpenCLHeaders_DIR=$ARTIFACTS_DIR/OpenCL-Headers/share/cmake/OpenCLHeaders \
    -D OpenCLICDLoader_DIR=$ARTIFACTS_DIR/OpenCL-ICD-Loader/android-arm64/share/cmake/OpenCLICDLoader \
    ../..

#ninja
#cmake --build . --verbose
cmake --build . --target install

cd ..

