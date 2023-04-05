cmake_minimum_required(VERSION 3.20)

project(openblas_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# OpenBLAS_DIR 指向包含OpenBLASConfig.cmake的目录
set(OpenBLAS_DIR "D:/lib/openblas/clang-cl/x64/share/cmake/OpenBLAS")
find_package(OpenBLAS REQUIRED)

add_executable(testbed testbed.cpp)

target_include_directories(testbed
    PUBLIC include
    ${OpenBLAS_INCLUDE_DIRS}
)
target_link_libraries(testbed ${OpenBLAS_LIBRARY})
if(UNIX)
  target_link_libraries(testbed pthread)
endif()