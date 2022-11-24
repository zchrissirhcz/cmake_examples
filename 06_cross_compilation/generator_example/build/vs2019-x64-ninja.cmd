@echo off


set BUILD_DIR=vs2019-x64-ninja
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

set CC=cl
set CXX=cl

cmake ../.. -G Ninja
cmake --build .
pause