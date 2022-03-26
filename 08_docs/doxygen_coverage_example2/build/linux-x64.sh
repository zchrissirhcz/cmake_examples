#!/bin/bash


BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. -GNinja -DCMAKE_BUILD_TYPE=Release
cmake --build . --target doc
cmake --build . --target doc_coverage
cd ..
