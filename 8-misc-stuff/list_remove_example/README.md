# list remove example

## purpose
在 CMake 中，当工程规模较大包含了很多 .c/.cpp 文件时，会使用 `file(GLOB some_var some_pattern)` 的形式来匹配若干文件，例如 src 目录下的所有 cpp 等。

对于 `file(GLOB )` 得到的文件列表， 若想排除单个文件不编译，则用

```cmake
list(REMOVE_ITEM some_var some_path)
```

需要确保 some_path 能完全匹配 some_var 中的路径，通常是绝对路径，也就是说 `some_path` 以 `${CMAKE_SOURCE_DIR}` 开头。

更坑的情况是， `${CMAKE_CURRENT_SOURCE_DIR}` 和 `${CMAKE_SOURCE_DIR}`使用时的一个差异：

https://stackoverflow.com/questions/15550777/how-do-i-exclude-a-single-file-from-a-cmake-fileglob-pattern

## ppl.cv 例子
用 android ndk 编译 ppl.cv 的 arm64 版本，morph相关的代码无法编译通过。

修改方法：编辑 cmake/arm64.cmake
```cmake
# PPL CV AARCH64 source cmake script
file(GLOB PPLCV_AARCH64_PUBLIC_HEADERS src/ppl/cv/arm/*.h)
install(FILES ${PPLCV_AARCH64_PUBLIC_HEADERS}
        DESTINATION include/ppl/cv/arm)

set(PPLCV_USE_AARCH64 ON)
list(APPEND PPLCV_COMPILE_DEFINITIONS PPLCV_USE_AARCH64)

file(GLOB PPLCV_AARCH64_SRC
     src/ppl/cv/arm/*.cpp)

list(REMOVE_ITEM PPLCV_AARCH64_SRC "${CMAKE_SOURCE_DIR}/src/ppl/cv/arm/morph_f32.cpp") #!!
list(REMOVE_ITEM PPLCV_AARCH64_SRC "${CMAKE_SOURCE_DIR}/src/ppl/cv/arm/morph_u8.cpp")  #!!

#message(FATAL_ERROR "PPLCV_AARCH64_SRC: ${PPLCV_AARCH64_SRC}")

list(APPEND PPLCV_SRC ${PPLCV_AARCH64_SRC}) #!!

# glob benchmark and unittest sources
file(GLOB PPLCV_AARCH64_BENCHMARK_SRC "src/ppl/cv/arm/*_benchmark.cpp")
file(GLOB PPLCV_AARCH64_UNITTEST_SRC "src/ppl/cv/arm/*_unittest.cpp")

list(REMOVE_ITEM PPLCV_AARCH64_UNITTEST_SRC "${CMAKE_SOURCE_DIR}/src/ppl/cv/arm/morph_unittest.cpp") #!!

list(APPEND PPLCV_BENCHMARK_SRC ${PPLCV_AARCH64_BENCHMARK_SRC})
list(APPEND PPLCV_UNITTEST_SRC ${PPLCV_AARCH64_UNITTEST_SRC})

```
