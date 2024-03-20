#!/bin/bash

cmake -DCMAKE_TOOLCHAIN_FILE=hello.toolchain.cmake -S . -B build1 > 1.log 2>&1
cmake -DCMAKE_TOOLCHAIN_FILE=hello.toolchain.cmake -S . -B build2 -DCMAKE_CXX_FLAGS="-DmacOS=1" > 2.log 2>&1
#diff 1.log 2.log

cmake -S . -B build3 > 3.log 2>&1
cmake -S . -B build4 -DCMAKE_CXX_FLAGS="-DmacOS=1" > 4.log 2>&1