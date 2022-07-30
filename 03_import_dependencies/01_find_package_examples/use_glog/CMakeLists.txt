cmake_minimum_required(VERSION 3.20)

project(glog_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(GFLAGS_DIR "D:/artifacts/gflags/2.2.2/windows/vs2019-x64/lib/cmake/gflags")
set(glog_DIR "D:/artifacts/glog/0.6.0/windows/vs2019-x64/lib/cmake/glog")

find_package(GFlags REQUIRED)
find_package(glog REQUIRED)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed glog::glog gflags)


