#!/bin/bash

cmake --preset linux-x64-release
cmake --build --preset linux-x64-release
./out/build/linux-x64-release/testbed