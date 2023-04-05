@echo off

set BUILD_DIR=vs2022-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=D:/artifacts/sdl_image/2.6.2/windows-x64 ^
    -DSDL2_DIR=D:/artifacts/sdl/2.24.0/windows-x64/cmake ^
    -DBUILD_SHARED_LIBS=OFF
cd ..

pause