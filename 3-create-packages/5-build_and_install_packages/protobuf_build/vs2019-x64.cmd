@echo off

if not defined ARTIFACTS_DIR (
    set ARTIFACTS_DIR=D:/artifacts
)

set BUILD_DIR=vs2019-x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../../cmake ^
	-G "Visual Studio 16 2019" -A x64 ^
	-DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/protobuf/3.11.2/windows/vs2019-x64 ^
	-Dprotobuf_BUILD_TESTS=OFF ^
	-Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
	-DCMAKE_DEBUG_POSTFIX=_d

cmake --build . --config Debug
cmake --install . --config Debug

cmake --build . --config Release
cmake --install . --config Release

cd ..

pause

