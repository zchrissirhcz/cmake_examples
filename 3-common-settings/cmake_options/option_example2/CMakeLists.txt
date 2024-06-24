cmake_minimum_required(VERSION 3.15)

project(hello)

option(USE_PLUGIN1 "use plugin1?" ON)
option(USE_PLUGIN2 "use plugin2?" ON)

set(compile_defs "")

if(USE_PLUGIN1)
    list(APPEND compile_defs "-DUSE_PLUGIN1")
endif()

if(USE_PLUGIN2)
    list(APPEND compile_defs "-DUSE_PLUGIN2")
endif()

add_executable(testbed
    testbed.cpp
)

target_compile_definitions(testbed PUBLIC ${compile_defs})


