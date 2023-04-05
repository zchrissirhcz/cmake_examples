cmake_minimum_required (VERSION 3.17)
project(eigen_example)

set(Eigen3_dir "/home/zz/artifacts/eigen3/share/eigen3/cmake/" CATHE PATH "")
find_package(Eigen3 3.3 REQUIRED NO_MODULE)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed Eigen3::Eigen)

