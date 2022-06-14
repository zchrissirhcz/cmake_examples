cmake_minimum_required(VERSION 3.20)

project(Vukan_Imgui)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BUILD_TYPE Debug)

include(cmake/deps.cmake)

#set(IMGUI_DIR "imgui")

add_executable(VulkanTest
    main.cpp
    src/vulkanBase/VulkanBase.cpp
    src/vulkanApp/VulkanApp.cpp
    src/myImgui/MyImgui.cpp
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
    ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp
)

target_link_libraries(VulkanTest
    glfw
    Vulkan::Vulkan
)
target_include_directories(VulkanTest
    PUBLIC
        ${CMAKE_SOURCE_DIR}/src/myImgui
        ${CMAKE_SOURCE_DIR}/src/vulkanBase
        ${CMAKE_SOURCE_DIR}/src/vulkanApp
        ${IMGUI_DIR}
        ${CMAKE_SOURCE_DIR}/src
)

# 一次拷贝多个文件
add_custom_command(TARGET VulkanTest
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/textures ${CMAKE_BINARY_DIR}/textures
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/shaders ${CMAKE_BINARY_DIR}/shaders
    COMMAND glslc ${CMAKE_BINARY_DIR}/shaders/shader.frag -o ${CMAKE_BINARY_DIR}/shaders/frag.spv
    COMMAND glslc ${CMAKE_BINARY_DIR}/shaders/shader.vert -o ${CMAKE_BINARY_DIR}/shaders/vert.spv
)

# convert GLSL to SPV
# glslc is provided by VulkanSDK
# Usage:
#   glslc shader.vert -o vert.spv
#   glslc shader.frag -o frag.spv

