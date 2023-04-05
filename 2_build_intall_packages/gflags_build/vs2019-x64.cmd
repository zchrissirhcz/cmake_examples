@echo off

if not defined ARTIFACTS_DIR (
    set ARTIFACTS_DIR=D:/artifacts
)

set BUILD_DIR=vs2019-x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 16 2019" -A x64 ^
    -DBUILD_TESTING=OFF ^
    -DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/gflags/2.2.2/windows/vs2019-x64 ^
    -DREGISTER_BUILD_DIR=OFF ^
    -DREGISTER_INSTALL_PREFIX=OFF ^
	-DCMAKE_DEBUG_POSTFIX=_d

cmake --build . --config Debug
cmake --install . --config Debug

cmake --build . --config Release
cmake --install . --config Release


cd ..

pause

