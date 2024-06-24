cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /source-charset:utf-8 /execution-charset:gbk ")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /source-charset:utf-8 /execution-charset:gbk ")
endif()

add_executable(demo
    src/main.cpp
)

set(ZLIB_INCLUDE_DIR "E:/lib/Zlib-1.2.8-win64-AMD64/include")
set(ZLIB_LIB "E:/lib/Zlib-1.2.8-win64-AMD64/lib/zdll.lib")
set(ZLIB_DLL "E:/lib/Zlib-1.2.8-win64-AMD64/zlib1.dll")

target_include_directories(demo
    PUBLIC ${ZLIB_INCLUDE_DIR}
)
target_link_libraries(demo
    PUBLIC ${ZLIB_LIB}
)

# each time the `demo` target is built, we copy zlib1.dll if it is changed.
if(MSVC)
    add_custom_command(TARGET demo
        POST_BUILD

        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ZLIB_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()