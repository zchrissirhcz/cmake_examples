#!/bin/bash


BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

#CMAKE=/home/zz/soft/cmake-3.20/bin/cmake
CMAKE=cmake

$CMAKE ../.. -DCMAKE_BUILD_TYPE=Debug
$CMAKE --build .
cd ..
