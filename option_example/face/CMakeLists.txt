project(face)

add_library(face
    ${CMAKE_CURRENT_SOURCE_DIR}/face.h
    ${CMAKE_CURRENT_SOURCE_DIR}/face.cpp
)

target_include_directories(face PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})