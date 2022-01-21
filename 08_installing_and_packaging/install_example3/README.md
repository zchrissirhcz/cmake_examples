# cmake install example3

## Introduction
This example shows how to install a static library, with package management files installed:
- build the library `hello`
- install hello's library file and API header file
- install package package management files
    - `helloConfig.cmake`
    - `helloTargets.cmake`
    - `helloTargets-*.cmake` according to `CMAKE_BUILD_TYPE`

## Reference
- ncnn: https://github.com/tencent/ncnn
- cmake guide: `${CMake_Source_Dir}/Help/guide/tutorial/Complete`