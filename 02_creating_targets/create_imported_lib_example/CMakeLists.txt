cmake_minimum_required(VERSION 3.20)

project(example)

add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/3rdparty/hello"
    INTERFACE_POSITION_INDEPENDENT_CODE "ON"
)

if(ANDROID)
    set_target_properties(hello PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/3rdparty/hello/build/android-arm64/libhello.a"
        INTERFACE_LINK_LIBRARIES "log"
    )
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set_target_properties(hello PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/3rdparty/hello/build/linux-x64/libhello.a"
    )
endif()

add_executable(testbed src/testbed.cpp)
target_link_libraries(testbed hello)