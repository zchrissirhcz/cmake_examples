@echo off

@REM call enter-vs2022-x64-ninja-env.cmd
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=build-vs2022-x64-ninja

set CC=cl
set CXX=cl

cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Debug

cmake --build %BUILD_DIR%

pause