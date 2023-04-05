#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
BUILD_DIR=linux-x64-static
mkdir -p $BUILD_DIR
cd $BUILD_DIR


#-D BUILD_LIST=core,imgcodecs,imgproc,highgui

cmake ../.. \
    -G Ninja \
    -D CMAKE_BUILD_TYPE=Release \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D CMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/opencv/4.6.0/linux-x64 \
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
    -D WITH_OPENCL=OFF

cmake --build .
cmake --install .

cd ..

