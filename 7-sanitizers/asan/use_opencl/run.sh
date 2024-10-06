#!/bin/bash

export ASAN_OPTIONS=protect_shadow_gap=0
cmake -S . -B build && cmake --build build && ./build/test
