cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# --- ncnn
set(ncnn_DIR "E:/lib/ncnn/master/lib/cmake/ncnn" CACHE PATH "folder that contains ncnnConfig.cmake")
find_package(ncnn REQUIRED)

# --- opencv
set(OpenCV_DIR "E:/lib/opencv/3.4.10" CACHE PATH "folder that contains OpenCVConfig.cmake")
find_package(OpenCV REQUIRED)

# --- target
add_executable(yolov4
    src/yolov4.cpp
)
target_link_libraries(yolov4 ncnn ${OpenCV_LIBS})

# each time the `yolov4` target is built, copy model and image files if they are changed.
add_custom_command(TARGET yolov4
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/asset/yolo-fastest.param
    ${CMAKE_BINARY_DIR}/

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/asset/yolo-fastest.bin
    ${CMAKE_BINARY_DIR}/

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/asset/000011.jpg
    ${CMAKE_BINARY_DIR}/
)