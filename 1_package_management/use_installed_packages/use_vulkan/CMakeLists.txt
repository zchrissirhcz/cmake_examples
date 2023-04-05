cmake_minimum_required(VERSION 3.0)

project(demo)

set(CMAKE_CXX_STANDARD 11)

add_executable(hello
    src/lodepng.cpp
    src/main.cpp
)

find_package(Vulkan QUIET)
if(NOT Vulkan_FOUND)
    message(STATUS "=== CMAKE_SYSTEM_NAME is: ${CMAKE_SYSTEM_NAME}")
    if(DEFINED ENV{VULKAN_SDK})
        if(CMAKE_SYSTEM_NAME MATCHES "Linux")
            list(APPEND CMAKE_MODULE_PATH "$ENV{VULKAN_SDK}/../source/VulkanTools/cmake")
        elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
            list(APPEND CMAKE_MODULE_PATH "$ENV{VULKAN_SDK}/Samples/cmake")
        elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
            message(WARNING "Failed to find vulkan since cmake too old\n"
                "cmake >= 3.7 required. Consider `brew upgrade cmake`")
        endif()
    else()
        message(FATAL_ERROR "!! CMake didn't find Vulkan. Please set VULKAN_SDK env var, e.g.:\n"
            "Linux: export VULKAN_SDK=~/soft/vulkansdk/1.2.148.0/x86_64\n"
            "Windows: set VULKAN_SDK=E:/lib/VulkanSDK/1.2.148.0\n"
            "MacOS: export VULKAN_SDK=~/soft/vulkansdk/1.2.148.0/macOS\n"
        )
    endif()
    find_package(Vulkan REQUIRED)
endif()




message(STATUS "--- Vulkan_FOUND: ${Vulkan_FOUND}")
message(STATUS "--- Vulkan_LIB: ${Vulkan_LIB}")
message(STATUS "--- Vulkan_INCLUDE_DIR: ${Vulkan_INCLUDE_DIR}")
message(STATUS "--- Vulkan_LIBRARY: ${Vulkan_LIBRARY}")

target_link_libraries(hello Vulkan::Vulkan)
#target_include_directories(hello
    #PUBLIC ${Vulkan_INCLUDE_DIR}
    #PUBLIC ${CMAKE_SOURCE_DIR}
#)
