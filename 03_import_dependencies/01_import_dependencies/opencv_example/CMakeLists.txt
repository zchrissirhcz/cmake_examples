cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(OpenCV_DIR "D:/lib/opencv/4.5.5" CACHE PATH "Directory that contains OpenCVConfig.cmake")

find_package(OpenCV QUIET COMPONENTS opencv_world)
# for opencv 2.4 on ubuntu 16.04, there is no opencv_world but OpenCV_FOUND will be TRUE
if("${OpenCV_LIBS}" STREQUAL "")
    set(OpenCV_FOUND FALSE)
endif()
if(NOT OpenCV_FOUND)
    find_package(OpenCV QUIET COMPONENTS core highgui imgproc imgcodecs videoio)
endif()
if(NOT OpenCV_FOUND)
    find_package(OpenCV QUIET COMPONENTS core highgui imgproc)
endif()


if(OpenCV_FOUND)
    message(STATUS "OpenCV library: ${OpenCV_INSTALL_PATH}")
    message(STATUS "    version: ${OpenCV_VERSION}")
    message(STATUS "    libraries: ${OpenCV_LIBS}")
    message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")
    if(${OpenCV_VERSION_MAJOR} GREATER 3)
        set(CMAKE_CXX_STANDARD 11)
    endif()
else()
    message(FATAL_ERROR "Error! OpenCV not found!")
endif()

add_executable(demo
    src/demo.cpp
)

target_link_libraries(demo ${OpenCV_LIBS})

# opencv 3.0.0 requires manually including header files and MT(static) linking
if(${OpenCV_VERSION_MAJOR} EQUAL 3 AND
    ${OpenCV_VERSION_MINOR} EQUAL 0 AND
    ${OpenCV_VERSION_PATCH} EQUAL 0)

  target_include_directories(demo PUBLIC ${OpenCV_INCLUDE_DIRS})

  if(MSVC AND NOT CMAKE_VERSION VERSION_LESS "3.15")
    set_property(TARGET demo PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
  endif()

endif()