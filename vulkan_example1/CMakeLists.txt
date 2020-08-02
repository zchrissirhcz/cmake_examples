cmake_minimum_required(VERSION 3.0)

project(demo)

add_executable(hello
    src/lodepng.cpp
    src/main.cpp
)


find_package(Vulkan QUIET)
if(Vulkan_FOUND)
    set(Vulkan_LIB Vulkan::Vulkan)
else()
    if(0)
    if(${CMAKE_VERSION} VERSION_LESS "3.7.0")
        message(FATAL_ERROR
            "Your cmake version < 3.7.0 which doesn't provide FindVulkan.cmake"
            "You have to either modify CMAKE_MODULE_PATH to contain directory that contains FindVulkan.cmake"
            "(e.g. vulkansdk/source/VulkanTools/cmake)"
            "Or you may use pkg_config in cmake "
        )
    else()
        message(FATAL_ERROR
            "Your cmake version > 3.7.0 which provides FindVulkan.cmake"
            "However, you have to specify CMAKE_MODULE_PATH"
        )
    endif()
    endif()

    # example: speicfy CMAKE_MODULE_PATH
    if (0)
        set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH} /home/zz/soft/vulkansdk/1.1.126.0/source/VulkanTools/cmake")
        find_package(Vulkan REQUIRED)
        set(Vulkan_LIB Vulkan::Vulkan)
    endif()

    # example: using pkg_config in cmake
    if (0)
        # You may specify a customed directory that contains vulkan.pc
        # set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH} /home/zz/soft/vulkansdk/1.1.126.0/x86_64/lib/pkgconfig")
        find_package(PkgConfig)
        pkg_search_module(Vulkan REQUIRED vulkan)
        set(Vulkan_LIB Vulkan)
    endif()

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
