@echo off

set BUILD_DIR=vs2019-x64

cmake ^
    -G "Visual Studio 16 2019" -A x64 ^
    -S .. ^
    -B %BUILD_DIR% ^
    -D CMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/OpenCL-ICD-Loader/windows-x64 ^
    -D OpenCLHeaders_DIR=%ARTIFACTS_DIR%/OpenCL-Headers/share/cmake/OpenCLHeaders ^
    -DCMAKE_DEBUG_POSTFIX=_d

cmake --build %BUILD_DIR% --config Debug
cmake --install %BUILD_DIR% --config Debug

cmake --build %BUILD_DIR% --config Release
cmake --install %BUILD_DIR% --config Release

cd ..

pause
