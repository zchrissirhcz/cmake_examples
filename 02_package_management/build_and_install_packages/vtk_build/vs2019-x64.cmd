@echo off

set BUILD_DIR=vs2019-x64
cmake -S .. -B %BUILD_DIR% -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=D:/artifacts/vtk/9.1.0/vs2019-x64
cmake --build %BUILD_DIR% --config Release
cmake --build %BUILD_DIR% --config Release --target INSTALL