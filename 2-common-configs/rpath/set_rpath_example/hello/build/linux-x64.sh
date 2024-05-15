#!/bin/bash

BUILD_DIR=linux-x64
cmake -S .. -B $BUILD_DIR && cmake --build $BUILD_DIR
