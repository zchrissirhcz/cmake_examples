#!/bin/bash

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/artifacts/sdl2_image/master/mac-arm64
cmake --build .
cmake --install .
cd ..
