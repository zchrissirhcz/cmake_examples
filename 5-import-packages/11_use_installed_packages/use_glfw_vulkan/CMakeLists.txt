cmake_minimum_required(VERSION 3.20)
project(glfw_example)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE Release)

add_executable(testbed
  main.cpp
)

find_package(glfw3 REQUIRED)
find_package(Vulkan REQUIRED)

target_link_libraries(testbed PUBLIC
  glfw
  Vulkan::Vulkan
)

find_program(Glslc NAMES glslc PATHS "/home/zz/soft/vulkansdk/1.2.148.0/x86_64/bin")

if(NOT Glslc)
    message(FATAL_ERROR "failed to find glslc")
else()
    message(STATUS ">>> Glslc is: ${Glslc}")
endif()


# compile the shaders
add_custom_command(TARGET testbed
    PRE_BUILD
    COMMAND ${Glslc} ${CMAKE_SOURCE_DIR}/shaders/shader.vert -o ${CMAKE_BINARY_DIR}/shader.vert.spv
    COMMAND ${Glslc} ${CMAKE_SOURCE_DIR}/shaders/shader.frag -o ${CMAKE_BINARY_DIR}/shader.frag.spv
)
