#!/bin/bash
cmake -S . -B build -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=~/.zzpkg/Catch2/3.7.1
cmake --build build
cmake --install build