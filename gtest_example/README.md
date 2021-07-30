## Intro
Googletest cmake example

## Build google test

```bash
cd ~/work
git clone https://github.com/google/googletest
cd googletest
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=./install
cmake --build . -j4
cmake --install .
```

## Specify GTest_DIR

Open your CMakeLists.txt, specify `GTest_DIR` to the directory that contains `GTestConfig.cmake`.

For me, it is `/home/zz/work/googletest/build/install/lib/cmake/GTest`.


## find_package, and link
```cmake
find_package(GTest REQUIRED)

add_executable(testbed
    main.cpp
)

target_link_libraries(testbed GTest::gtest)
```
Note, you don't have to manually specify including directory.

## Refs
https://github.com/google/googletest/blob/master/googletest/README.md