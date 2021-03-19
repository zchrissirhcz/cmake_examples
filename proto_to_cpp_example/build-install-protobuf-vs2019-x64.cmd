@echo off

set BUILD_DIR=vs2019-x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake -G "Visual Studio 16 2019" -A x64 ^
    -DCMAKE_INSTALL_PREFIX=e:/lib/protobuf/3.15.6 ^
    -Dprotobuf_BUILD_TESTS=OFF ^
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
    G:/dev/protobuf-3.15.6/cmake

cmake --build . --config Release --target INSTALL

cd ..

pause