@echo off

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=build-vs2022-x64-ninja-multi-config

set CC=cl
set CXX=cl

cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G "Ninja Multi-Config"

cmake --build %BUILD_DIR% --config Debug
cmake --build %BUILD_DIR% --config Release

pause