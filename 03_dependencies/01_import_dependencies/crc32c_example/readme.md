# Crc32c cmake example

CRC32C is specified as the CRC that uses the iSCSI polynomial in RFC 3720.

This demo project show how to use Crc32c in cmake based projects.

Before using & modifying this project, please make sure you have installed Crc32c. If not, do like the following:

## Install Crc32c

```batch
cd d:/work
git clone https://github.com/google/crc32c
cd crc32c
git submodule update --init --recursive
mkdir build
```

Create `build/vs2017-x64.bat`, whose content is:
```batch
@echo off

set BUILD_DIR=vs2017-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 15 2017 Win64" -DCRC32C_BUILD_TESTS=0 -DCRC32C_BUILD_BENCHMARKS=0 -DCMAKE_INSTALL_PREFIX=D:/lib/crc32c
cmake --build . --config Release
cmake --install . --config Release --prefix d:/lib/crc32c -v
cd ..
pause
```
