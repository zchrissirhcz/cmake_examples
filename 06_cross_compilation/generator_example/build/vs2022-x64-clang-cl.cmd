@echo off

@REM https://docs.microsoft.com/en-us/cpp/build/clang-support-cmake?view=msvc-170
@REM install C++ Clang Compiler for Windows
@REM install C++ Clang-cl for v142 build tools

set BUILD_DIR=vs2022-x64-clang-cl
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 17 2022" -A x64 -T ClangCL
cd ..
pause