cmake_minimum_required(VERSION 3.25)
project(imgui-SFML_example)

set(CMAKE_CXX_STANDARD 11)
find_package(OpenGL REQUIRED)
find_package(glfw3 REQUIRED)
find_package(Vulkan REQUIRED)
find_package(SFML COMPONENTS audio graphics window system)

#--- imgui: https://github.com/ocornut/imgui
set(IMGUI_DIR "/Users/zz/work/github/imgui")
add_library(imgui STATIC
  ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
  ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
  ${IMGUI_DIR}/imgui.cpp
  ${IMGUI_DIR}/imgui_demo.cpp
  ${IMGUI_DIR}/imgui_draw.cpp
  ${IMGUI_DIR}/imgui_tables.cpp
  ${IMGUI_DIR}/imgui_widgets.cpp
)
target_include_directories(imgui PUBLIC
  ${IMGUI_DIR}
  ${IMGUI_DIR}/backends
)
target_link_libraries(imgui PUBLIC glfw OpenGL::GL)

#--- imgui-SFML: https://github.com/SFML/imgui-sfml
set(IMGUI_SFML_DIR "/Users/zz/work/github/imgui-sfml")
add_library(ImGui-SFML STATIC
  ${IMGUI_SFML_DIR}/imgui-SFML.cpp
  ${IMGUI_SFML_DIR}/imconfig-SFML.h
)
target_include_directories(ImGui-SFML PUBLIC ${IMGUI_SFML_DIR})
target_link_libraries(ImGui-SFML PUBLIC sfml-graphics sfml-window sfml-system imgui)

#--- imgui-SFML_example
add_executable(imgui-SFML_example imgui-SFML_example.cpp)
target_link_libraries(imgui-SFML_example PUBLIC ImGui-SFML)
