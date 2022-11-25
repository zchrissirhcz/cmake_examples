@echo off

@REM call enter-vs2019-x64-ninja-env.cmd
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=vs2019-x64-ninja
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

set CC=cl
set CXX=cl

cmake ../.. -G Ninja
cmake --build .
pause