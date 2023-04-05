cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Turn on automatic invocation of the MOC, UIC & RCC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

#"You must build your code with position independent code if Qt was built with -reduce-relocations. " "Compile your code with -fPIC (-fPIE is not enough)."
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

# resolve AutoUic error
set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_SOURCE_DIR}/ui)

# Qt5_DIR: contain `Qt5Config.cmake`
set(Qt5_DIR "/usr/lib/x86_64-linux-gnu/cmake/Qt5")
find_package(Qt5 REQUIRED COMPONENTS Core Gui Widgets)

# Full list of Qt5 components, located in ${Qt5_DIR}:
# Concurrent 5Core DBus Gui Network OpenGL OpenGLExtensions PrintSupport Sql Test Widgets 5Xml

# Make this a GUI application on Windows
# Do we need this?
if(WIN32)
  set(CMAKE_WIN32_EXECUTABLE ON)
endif()


add_executable(remarkable
    core/main.cpp
    core/remarkable.cpp
    core/remarkable.hpp
    core/render_line.cpp
    core/render_line.hpp
    core/render_scene.cpp
    core/render_scene.hpp

    ui/remarkable.ui
    ui/resource.qrc
)
target_include_directories(remarkable
    PUBLIC
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/ui
    ${Qt5Widgets_INCLUDE_DIRS}
)

target_link_libraries(remarkable
	Qt5::Core Qt5::Gui Qt5::Widgets
)


# more setups
# library                cmake find package component
# Qt5::PrintSupport      PrintSupport
#                        LinguistTools

