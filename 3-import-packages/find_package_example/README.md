# find package example

In this example we demonstrate how to use `find_package()` to find the OpenCV library, then use it as an required dependency for our executable target `test_opencv`.

## C++11
We use OpenCV's latest version 4.7.0. Starting from OpenCV 4.0, it requires C++11 standard. Thus we have to turn it on:
```cmake
set(CMAKE_CXX_STANDARD 11)
```

## OpenCV_DIR
```cmake
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(OpenCV_DIR "C:/Users/zz/work/opencv/4.7.0/build/x64/vc16/lib")
endif()
```
We set value for an variable called `OpenCV_DIR`. This variable consist of 3 parts:
- `OpenCV`: the package name is called OpenCV
- `_`: separation char
- `DIR`: the abbrevation of `Directory`

`OpenCV_DIR` has the format of `<PackageName>_DIR`, and its values is a path that contains `OpenCVConfig.cmake`.
For Ubuntu / MacOSX, We can use apt-get / brew to install OpenCV, the we don't have to specify `OpenCV_DIR` for most time

For Windows, There are many version of Visual Studio, the OpenCV official provided prebuilt of OpenCV is built with VS2019 (vc16). If we just pointing to the root of `build` directory:
```cmake
set(OpenCV_DIR "C:/Users/zz/work/opencv/4.7.0/build")
```
Then `find_package(OpenCV REQUIRED)` will fail, complaining Visual Studio version mismatch. We have to pointing OpenCV_DIR the inner one:
```cmake
set(OpenCV_DIR "C:/Users/zz/work/opencv/4.7.0/build/x64/vc16/lib")
```
Then `find_package(OpenCV REQUIRED)` can successfully find package for Visual Studio 2022.

## find_package
```cmake
find_package(OpenCV REQUIRED)
```
This means we let cmake help us find the whole OpenCV package, including:
- The header files' directory, such as the directory that contains `opencv/opencv2`
- The library files, such as opencv_core.lib, opencv_world.lib, libpng.lib
- The C/C++ compilation options, such as C++11, SSE2/AVX/NEON optimizations
- The C/C++ macro definitons, if any.

The `REQUIRED` means if cmake cannot find OpenCV package, it will cause an error, stop running following cmake script lines.

## Use the OpenCV package
```cmake
target_link_libraries(test_opencv PUBLIC ${OpenCV_LIBS})
```
This means we mark an dependency relation: `test_opencv` target requires OpenCV. Actually OpenCV package consists of many library files, i.e. components of OpenCV. `${OpenCV_LIBS}` is a variable that containing these library files. You may just print them:

```cmake
message(STATUS "OpenCV_LIBS are: ${OpenCV_LIBS}")
```

By using `target_link_libraries(test_opencv PUBLIC ${OpenCV_LIBS})`, we propagate the required libraries' properties to `test_opencv` target, including:
- Inluding directories
- Library file names
- Library searching paths

This `target_link_libraries()` is Target Oriented Dependency Marking. It won't polute other targets since it is not globally setting.

## Advanced stuffs
This find opencv package example is quite simple. You may also suffer or require more advanced stuffs, such as:
- OpenCV related:
    - Platform mismatch failure: Your project use MT/MTd, but OpenCV use MD/MDd
    - Manully compiled OpenCV is not found, maybe OpenCV_DIR not correctly assigned
    - Find wrong version of OpenCV, especially there are several OpenCV in your machine
- Find Other packages:
    - Some package's `find_package()` failed
    - Some package does not provide `find_package()` usage
    - Some package provide `find_package()` but not including all required dependencies
    - Some package provide `find_package()` but find wrong package, such as shared lib v.s. static lib
- Make own packages:
    - Would like to know how to create own package, provide to other people with `find_package()` usage
    - ...