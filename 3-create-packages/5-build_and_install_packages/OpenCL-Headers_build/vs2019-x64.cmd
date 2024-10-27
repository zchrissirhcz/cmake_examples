@echo off

if not defined ARTIFACTS_DIR (
    set ARTIFACTS_DIR=D:/artifacts
)

set BUILD_DIR=vs2019-x64
cmake ^
    -G "Visual Studio 16 2019" -A x64 ^
    -S .. ^
    -B %BUILD_DIR% ^
    -D CMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/OpenCL-Headers ^
    -D OPENCL_HEADERS_BUILD_CXX_TESTS=OFF

cmake --build %BUILD_DIR% --target install

pause