@echo off

if not defined ARTIFACTS_DIR (
    set ARTIFACTS_DIR=D:/artifacts
)

set BUILD_DIR=vs2019-x64

if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake ../.. ^
    -G "Visual Studio 16 2019" -A x64 ^
    -DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/lmdb/0.9.18/windows/vs2019-x64 ^
    -DLMDB_SRC_DIR=D:/github/lmdb/libraries/liblmdb ^
    -DCMAKE_DEBUG_POSTFIX=_d

cmake --build . --config Debug
cmake --install . --config Debug

cmake --build . --config Release
cmake --install . --config Release

cd ..

pause