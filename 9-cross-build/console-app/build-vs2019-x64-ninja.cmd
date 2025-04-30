@echo off

@REM call enter-vs2019-x64-ninja-env.cmd
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=build-vs2019-x64-ninja

set CC=cl
set CXX=cl

cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Debug

cmake --build %BUILD_DIR%

pause