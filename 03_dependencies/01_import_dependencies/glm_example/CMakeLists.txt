cmake_minimum_required(VERSION 3.20)
project(example)

set(glm_DIR "/home/zz/artifacts/glm")
find_package(glm REQUIRED)

add_executable(testbed main.cpp)
target_link_libraries(testbed glm::glm)