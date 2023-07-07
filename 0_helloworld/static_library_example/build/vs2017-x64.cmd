@echo off

set BUILD_DIR=vs2017-x64
cmake ^
    -S .. ^
    -B %BUILD_DIR% ^
    -G "Visual Studio 15 2017" -A x64
    cmake --build %BUILD_DIR% --config Debug
   
cmake --build %BUILD_DIR% --config Debug
cmake --build %BUILD_DIR% --config Release
pause