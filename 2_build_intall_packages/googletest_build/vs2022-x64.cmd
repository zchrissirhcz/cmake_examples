@echo off

set BUILD_DIR=vs2022-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. ^
	-G "Visual Studio 17 2022" -A x64 ^
	-DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/googletest/1.11.0/windows/vs2022-x64 ^
	-Dgtest_force_shared_crt=ON ^
	-DCMAKE_DEBUG_POSTFIX=_d
	
cmake --build . --config Debug
cmake --build . --config Release
cmake --install . --config Debug
cmake --install . --config Release
cd ..
pause