# create_imported_lib_example

## Intro
Building your project with CMake is simple, especially there's no dependencies, or the dependencies are with great `find_package()` configurations (such as OpenCV's OpenCVConfig.cmake, ncnn's ncnnConfig.cmake, etc).

However, when integrating 3rdparty libraies that with poor cmake configurations, it is tedious. People may directly mark the header file directories and library path to targets directly:
```cmake
add_executable(testbed testbed.cpp)
target_include_directories(testbed
    ${CMAKE_SOURCE_DIR}/3rdparty/hello
)
target_link_libraries(testbed
    ${CMAKE_SOURCE_DIR}/3rdparty/hello/build/linux-x64/libhello.a
)
```
Which, can be use, but can't be reuse. What if there are more than 2 targets that depends on this `hello` library in the project? What if there are more than 2 projects that requires linking to this `hello` library?

Hense, let's wrap the `hello` library, together with its header files, with CMake's imported library.

### Get a library
Creating hello library for your interested platform, such as Linux-x64, android arm64, etc.
This step can be replaced with "other people give me a library file" or "download a library file from the Internet".

```bash
cd 3rdparty/hello/build
./linux-x64-build.sh
./android-x64-build.sh
cd ../../
```

### Create the importeed library
This step we write some cmake as a wrapper of the library you get in the previous step. We wrap a library file, together with its header file, header file's location, as an "imported target".

```cmake
add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/3rdparty/hello"
    INTERFACE_POSITION_INDEPENDENT_CODE "ON"
)

if(ANDROID)
    set_target_properties(hello PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/3rdparty/hello/build/android-arm64/libhello.a"
        INTERFACE_LINK_LIBRARIES "log"
    )
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set_target_properties(hello PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/3rdparty/hello/build/linux-x64/libhello.a"
    )
endif()
```

### Use the imported lib
We use the imported lib, as the dependency of our new created executable target `testbed`, which is nothing different than marking an denpendency that was from`find_package()`.

```cmake
add_executable(testbed src/testbed.cpp)
target_link_libraries(testbed hello)
```

Then we do the compilation:
```bash
cd build
./linux-x64-build.sh
./linux-x64-run.sh

./android-arm64-build.sh
./android-arm64-run.sh
```

### Snapshot
![](run_executables.png)

## References
https://cmake.org/cmake/help/git-stage/guide/importing-exporting/index.html