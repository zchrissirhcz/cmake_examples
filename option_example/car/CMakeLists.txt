project(car)

add_library(car
    ${CMAKE_CURRENT_SOURCE_DIR}/car.h
    ${CMAKE_CURRENT_SOURCE_DIR}/car.cpp
)

target_include_directories(car PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})