# 4_create_imported_packages

## From find_package() to manually makeing package
Using `find_package()` is easy, only when packages maintainers give good cmake experience.

There are many C/C++ projects doesn't provide good `find_package()` experience (you may just find wrong result), or doesn't provide `find_package()` usage at all. Unfortunately, many C/C++ packages is in this bad situation.

To handle these non-find-package-usage packages, people may:
- Choose makefile, instead of CMake
- Choose directly create Visual Studio solution, instead of via CMake, and set project properties manully
- Choose CMake, but hard code each package's header file searching path, library searching path and library names

I myself think these actions are "ugly", since:
- They didn't treat a package as an entity
- For Visual Studio project property settings, can't reuse in other projects, have to repeatedly configure
- Nearly no version information provides
- What's more bad: some people just put library files like "gtest.lib" under their svn/git repo, without knowing their version.

Let's just switch to an elegant way: **write an CMakeLists.txt for each package, make it an imported library target, then use these package as an entity**.

## The simplest imported library example
*The example is in `easyx` directory.*

```cmake
add_library(easyx STATIC IMPORTED GLOBAL)
```
This means we create an target, it's type is static library, and it is imported, i.e. there is already its library files, together with its header files, instead of we hold its source code (actually we don't have its source code). We just "pack it" as an entity.

We use `GLOBAL` keyword to mark this target visible for parent directories. When not using `GLOBAL`, only visible to subdirectories.

```cmake
set_target_properties(easyx PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/lib/VC2015/x64/EasyXa.lib"
)
```
We specify the target "easyx"'s properties now. We specify it header file search path, and specify its library file path. `${CMAKE_CURRENT_SOURCE_DIR}` means the `easyx` directory for `easyx/CMakeLists.txt` file.

We also put the acutal header files and library files, i.e. the "include" and "lib" directories, under this "easyx" directory. Thus match the contents in "easyx/CMakeLists.txt".

Then, how we use this package? Just `add_subdirectory(easyx)`:

```cmake
add_subdirectory(easyx)
add_executable(use_easyx use_easyx.cpp)
target_link_libraries(use_easyx PUBLIC easyx)
```

## Use source code example
*The example is in `cJSON` directory.*

Some times we have source code for some projects, but we just use it as an dependency, instead of modifying it. Its source code may help use debugging memory issues.

And these source code are quite lightweight, don't have to write heavy CMakeLists.txt for installation and provide find_package usages.

Take a look at the "cJSON" directory.

```cmake
# Get cJSON from https://github.com/DaveGamble/cJSON
add_library(cJSON STATIC
  ${CMAKE_CURRENT_SOURCE_DIR}/cJSON.h
  ${CMAKE_CURRENT_SOURCE_DIR}/cJSON.cpp
)
```
We just create an static library from its source, and put cJSON source files under cJSON directory.

```cmake
target_include_directories(cJSON PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)
```
Then we just mark the target cJSON its publicly including directory, the cmake current source directory, i.e. the "cJSON" directory.

Then how we use it? Still using `add_subdirectory()` (note this time we didn't specify `GLOBAL` keyword.)

```cmake
add_subdirectory(cJSON)
add_executable(use_cJSON use_cJSON.cpp)
target_link_libraries(use_cJSON PUBLIC cJSON)
```

## Debug and Release libraries example
*The example is in `hello` directory.*

Sometimes we have debug and release two library files (both static library). The debug library file is with postfix "d" or "_d". For example:
- hello.lib, the Release one
- hello_d.lib, the Debug one

We still would like to use `add_subdirectory()` to consuming this hello package (I just created the fake hello.lib and hello_d.lib, replace them your actual files). Then in `hello/CMakeLists.txt` we have to specify 4 build type's library file path (yes, this is just for Visual Studio):
```cmake
add_library(hello STATIC IMPORTED)
set_target_properties(easyx PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
    IMPORTED_LOCATION_DEBUG "${CMAKE_CURRENT_LIST_DIR}/lib/vs2019_x64/hello_d.lib"
    IMPORTED_LOCATION_RELEASE "${CMAKE_CURRENT_LIST_DIR}/lib/vs2019_x64/hello.lib"
    IMPORTED_LOCATION_MINSIZEREL "${CMAKE_CURRENT_LIST_DIR}/lib/vs2019_x64/hello.lib"
    IMPORTED_LOCATION_RELWITHDEBINFO "${CMAKE_CURRENT_LIST_DIR}/lib/vs2019_x64/hello.lib"
)
```
Among which, thought we only use `IMPORTED_LOCATION_DEBUG` for Debug and `IMPORTED_LOCATION_RELEASE` for Release, but actually we may also use `IMPORTED_LOCATION_MINSIZEREL` for MinSizeRel and `IMPORTED_LOCATION_RELWITHDEBINFO` for RelWithDebInfo.

## Shared library(DLL) example
*The example is in `protobuf` directory.*

Sometimes people just give us an tiny `.lib` file, and an `.dll` file. Say, we have `libprotobuf.lib` and `libprotobuf.dll`. We should create an shared, imported library this time:

```cmake
add_library(protobuf SHARED IMPORTED GLOBAL)
```

And we specify this target's .dll and .lib files path:
```cmake
set_target_properties(protobuf PROPERTIES
    #INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/inc"
    IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/lib/vs2017_x64/libprotobuf.dll"
    IMPORTED_IMPLIB "${CMAKE_CURRENT_SOURCE_DIR}/lib/vs2017_x64/libprotobuf.lib"
    VERSION 3.21.9
)
```
Since I don't use its header files now, just comment it out.

Then we still use this imported target with `add_subdirectory()`, but we also copy its dll file to where we executing the Visual Studio solution project:
```cmake
add_subdirectory(protobuf)

get_target_property(protobuf_dll_path pthread IMPORTED_LOCATION)
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy ${protobuf_dll_path} ${CMAKE_CURRENT_BINARY_DIR}/
)
```

## Header-only library example
*The example is in `autologger` directory.*

We may use open-source or manually created header-only libraries. Say we have one `autologger.hpp` file as an header-only library, then how should we make it an cmake package and use it?

We use `INTERFACE` as keyword for creating an header-only library(package):
```cmake
add_library(autologger INTERFACE
  autologger.hpp
)
```

Then we mark its incluyding directory, still have to use `INTERFACE` keyword:
```cmake
target_include_directories(autologger INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}
)
```

Then we use it in outer CMakeLists.txt:
```cmake
add_subdirectory(autologger)
add_executable(use_autologger use_autologger.cpp)
target_link_libraries(use_autologger PUBLIC autologger)
```