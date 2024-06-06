@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1

set BUILD_DIR=build

set CC=cl
set CXX=cl

cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G "Ninja Multi-Config"
