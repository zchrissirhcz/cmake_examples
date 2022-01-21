@echo off

set BUILD_DIR=vs2019-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=./install -Dgtest_force_shared_crt=ON
cmake --build . --config Debug
cmake --build . --config Release
cmake --install . --config Debug
cmake --install . --config Release
cd ..
pause