@echo off

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=build-vs2017-x64-ninja
set CC=cl
set CXX=cl

cmake ^
    -S . ^
    -B %BUILD_DIR% ^
    -G Ninja
cmake --build %BUILD_DIR% --config Debug
cmake --build %BUILD_DIR% --config Release
@REM pause
