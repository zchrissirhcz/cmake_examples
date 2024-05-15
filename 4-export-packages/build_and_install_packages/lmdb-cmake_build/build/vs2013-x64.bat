@echo off

set BUILD_DIR=vs2013-x64
set BUILD_PLATFORM=x64
set BUILD_COMPILER=vc12

if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake -G "Visual Studio 12 2013 Win64" ^
    -DCMAKE_INSTALL_PREFIX=%cd%/install/%BUILD_PLATFORM%/%BUILD_COMPILER% ^
    -C ../custom.cmake ^
    ../../

cmake --build . --config Release --target install

cd ..

pause