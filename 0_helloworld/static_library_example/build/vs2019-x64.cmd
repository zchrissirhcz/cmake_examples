@echo off

set BUILD_DIR=vs2019-x64
cmake ^
    -S .. ^
    -B %BUILD_DIR% ^
    -G "Visual Studio 16 2019" -A x64
    cmake --build %BUILD_DIR% --config Debug
    pause
