@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
set BUILD_DIR=build
cmake --build %BUILD_DIR% --config %1
