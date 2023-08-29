cmake_minimum_required(VERSION 3.20)
project(test)
add_executable(test test.c)
target_include_directories(test PUBLIC hello)
target_link_libraries(test PUBLIC
    ${CMAKE_SOURCE_DIR}/hello/build/linux-x64/libhello.so
)

set_target_properties(test PROPERTIES BUILD_RPATH "$ORIGIN;$ORIGIN/../lib")
