@echo off

set BUILD_DIR=vs2017-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 15 2017 Win64" -DCRC32C_BUILD_TESTS=0 -DCRC32C_BUILD_BENCHMARKS=0 -DCMAKE_INSTALL_PREFIX=D:/lib/crc32c
cmake --build . --config Release
cmake --install . --config Release --prefix d:/lib/crc32c -v
cd ..
pause