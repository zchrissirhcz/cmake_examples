@echo off

@REM 生成后，CLion选择import existing工程，选择到build/mingw-w64目录，即可打开CLion工程
@REM 这个技巧可以用来给CLion工程的cmake传入定制的option以及cache参数。
@REM 其实mingw-w64的terminal，无非是改了PATH。直接拿来用。

set PATH=e:\soft\mingw-w64\mingw64\bin;%PATH%

set BUILD_DIR=mingw-w64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake -G "CodeBlocks - MinGW Makefiles" ^
	../..

cd ..

pause


