#!/bin/bash

git clone https://github.com/linux-test-project/lcov.git
cd lcov
make PREFIX=~/soft/lcov/1.15 install

