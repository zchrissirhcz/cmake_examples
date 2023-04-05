@echo off

set BUILD_DIR=vs2022-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 17 2022" -A x64 ^
    -D CMAKE_INSTALL_PREFIX=d:/artifacts/sdl/2.24.0/windows-x64 ^
    -D SDL2_DISABLE_SDL2MAIN=ON

cmake --build . --config Debug
cmake --install . --config Debug

cmake --build . --config Release
cmake --install . --config Release

cd ..
pause