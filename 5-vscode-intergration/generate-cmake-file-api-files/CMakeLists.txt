cmake_minimum_required(VERSION 3.5)
project(hello VERSION 0.1.0 LANGUAGES C CXX)

find_package(OpenCV REQUIRED)
add_executable(hello main.cpp)
target_link_libraries(hello PRIVATE ${OpenCV_LIBS})

