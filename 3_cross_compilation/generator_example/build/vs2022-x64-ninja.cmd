@echo off

@REM call enter-vs2022-x64-ninja-env.cmd
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set BUILD_DIR=vs2022-x64-ninja

set CC=cl
set CXX=cl

cmake -S .. -B %BUILD_DIR% -G Ninja
cmake --build %BUILD_DIR%
pause