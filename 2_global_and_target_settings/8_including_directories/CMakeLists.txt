cmake_minimum_required(VERSION 3.20)
project(example)

# Globally, affecting all target's include file searching path.
# OK. Not recommended
#include_directories("/home/zz/work/eigen3")

# Per-target setting include directories.
# OK. But still not perfect.
# add_executable(use_eigen use_eigen.cpp)
# target_include_directories(use_eigen PUBLIC eigen
#   "/home/zz/work/eigen3"
# )

# Actually, only leaf-node packages should specify including directories. Non-leaf node packages should only specify their required packages
# i.e. via target_link_libraries(), which will automatically populate including directories.
set(Eigen3_DIR "/home/zz/artifacts/eigen3/share/eigen3/cmake" CACHE PATH "")
find_package(Eigen3 REQUIRED NO_MODULE)
add_executable(testbed testbed.cpp)
target_link_libraries(testbed Eigen3::Eigen)
