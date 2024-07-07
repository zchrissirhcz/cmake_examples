# Cross Compilation

CMake's `C` means cross-platform. How we do cross-platform compilation?

1. Specify generator when invodking cmake. i.e. the `-G xxx` option:
```
cmake -S . -B build -G "Visual Studio 17 2022" -A x64
```
See [generator_examples/build](generator/build) directory for more examples.

2. Specify `xxx.toolchain.cmake` file when invoking cmake. i.e. the `-DCMAKE_TOOLCHAIN_FILE=xxx.toolchain.cmake`

3. In CMakeLists.txt, write if/else for different platforms.
e.g. 
```cmake
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
    message(STATUS "this is windows")
elif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    message(STATUS "this is linux")
endif()
```


