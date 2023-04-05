#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
ANDROID_NDK=~/soft/android-ndk-r21e
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

#-D BUILD_LIST=core,imgcodecs,imgproc,highgui,calib3d,videoio,features2d
#-D BUILD_LIST=core,imgcodecs,imgproc,highgui
cmake ../.. \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/opencv/4.6.0/android-arm64 \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_VTK=OFF \
    -D WITH_MATLAB=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_opencv_python3=OFF \
    -D BUILD_opencv_python2=OFF \
    -D WITH_IPP=OFF \
    -D BUILD_SHARED_LIBS=OFF \
    -D WITH_PROTOBUF=OFF \
    -D WITH_QUIRC=OFF \
    -D WITH_EIGEN=OFF \
    -D CV_DISABLE_OPTIMIZATION=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_PTHREADS_PF=ON \
    -D WITH_TBB=OFF \
    -D WITH_OPENMP=OFF \
    -D OPENCV_DISABLE_THREAD_SUPPORT=OFF \
    -D BUILD_ANDROID_PROJECTS=OFF \
    -D BUILD_ANDROID_EXAMPLES=OFF \
    -D BUILD_ANDROID_SERVICE=OFF

cmake --build . -j6
cmake --install .

cd ..


