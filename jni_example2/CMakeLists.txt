cmake_minimum_required(VERSION 3.15)

project(hello)

add_library(hello SHARED
    jni/hello.cpp
)

include(FindJNI)

include(CMakePrintHelpers)
cmake_print_variables(JNI_INCLUDE_DIRS)
cmake_print_variables(JNI_LIBRARIES)
cmake_print_variables(JNI_FOUND)

target_include_directories(hello
    PRIVATE ${JNI_INCLUDE_DIRS}
)
target_link_libraries(hello
    PRIVATE ${JNI_LIBRARIES}
)