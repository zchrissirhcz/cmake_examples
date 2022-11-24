@echo off


set BUILD_DIR=vs2022-x64-ninja
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

set CC=cl
set CXX=cl

cmake ../.. -G Ninja
cmake --build .
pause