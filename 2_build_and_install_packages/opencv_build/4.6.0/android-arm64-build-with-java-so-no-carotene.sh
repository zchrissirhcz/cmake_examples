#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
# android sdk and ndk env vars are required
# you may also set them up in gradle config file by setup ndk.dir and sdk.dir
export ANDROID_SDK_ROOT='~/Android/Sdk'
export ANDROID_NDK_ROOT=~/soft/android-ndk-r21e

# note: jdk and jre variables are not required
# but we usually put $ANDROID_SDK_ROOT/platform-tools in PATH, in order to use `adb` command
TOOLCHAIN=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake


BUILD_DIR=android-arm64-with-java-so-no-carotene
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -GNinja \
    -DANDROID_ABI='arm64-v8a' \
    -DANDROID_STL='c++_static' \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/opencv/android-arm64/4.6.0-no-carotene  \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID_PLATFORM='24' \
    -DANDROID_TOOLCHAIN='clang' \
    -DANDROID_PROJECTS_BUILD_TYPE='GRADLE' \
    -DANDROID_PLATFORM_ID='3' \
    -DANDROID_GRADLE_PLUGIN_VERSION='4.1.2' \
    -DGRADLE_VERSION='6.5' \
    -DOPENCV_FORCE_3RDPARTY_BUILD=ON \
    -DINSTALL_TESTS=OFF \
    -DINSTALL_CREATE_DISTRIB='ON' \
    -DWITH_OPENCL='OFF' \
    -DWITH_IPP='OFF' \
    -DWITH_TBB='ON' \
    -DBUILD_EXAMPLES='OFF' \
    -DBUILD_TESTS='OFF' \
    -DBUILD_PERF_TESTS='OFF' \
    -DINSTALL_TESTS='OFF' \
    -DBUILD_DOCS='OFF' \
    -DWITH_CAROTENE='OFF' \
    -DBUILD_ANDROID_EXAMPLES='OFF' \
    -DINSTALL_ANDROID_EXAMPLES='OFF' \
    -DWITH_PROTOBUF='OFF' \
    -DWITH_PTHREADS_PF=OFF \
    -DOPENCV_DISABLE_THREAD_SUPPORT=OFF

cmake --build .
cmake --install .
cd ..
