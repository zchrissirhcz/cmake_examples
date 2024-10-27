@echo off

set BUILD_DIR=vs2022-x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 17 2022" -A x64 ^
    -DCPUINFO_BUILD_UNIT_TESTS=OFF ^
    -DCPUINFO_BUILD_MOCK_TESTS=OFF ^
    -DCPUINFO_BUILD_BENCHMARKS=OFF ^
    -DCMAKE_INSTALL_PREFIX=d:/ARTIFACTS/cpuinfo/master/windows-x64


cmake --build . --config Debug
cmake --build . --config Release

cmake --install . --config Debug
cmake --install . --config Release

cd ..
pause

