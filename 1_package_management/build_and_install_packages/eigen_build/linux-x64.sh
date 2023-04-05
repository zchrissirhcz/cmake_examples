#!/bin/bash

# Althoug Eigen is an header-only library, you may just include it's path for including files
# However, if you treat it as an package, then you must configure-build-install Eigen, which generates Eigen3Config.cmake file, required by find_package(Eigen3)


BUILD_DIR=build
# cd ~/work/eigen
cmake -S . -B $BUILD_DIR -DCMAKE_INSTALL_PREFIX=/home/zz/artifacts/eigen3
cmake --build $BUILD_DIR
cmake --build $BUILD_DIR --target install