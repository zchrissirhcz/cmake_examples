cmake_minimum_required(VERSION 3.20)
project(sfml_example)
set(CMAKE_CXX_STANDARD)

find_package(SFML COMPONENTS graphics window system)

add_executable(sfml_example sfml_example.cpp)
target_link_libraries(sfml_example PRIVATE sfml-graphics sfml-window sfml-system)
