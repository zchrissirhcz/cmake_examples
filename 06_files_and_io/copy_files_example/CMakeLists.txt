cmake_minimum_required(VERSION 3.17)

project(copy_files_example)

find_package(OpenCV REQUIRED)

add_executable(test_triangulate_points essential_mat_reconstr.cpp)
target_link_libraries(test_triangulate_points ${OpenCV_LIBS})

# 一次拷贝多个文件
add_custom_command(TARGET test_triangulate_points
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/assets/essential_mat_data.txt ${CMAKE_BINARY_DIR}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/assets/leuvenA.jpg ${CMAKE_BINARY_DIR}/
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/assets/leuvenB.jpg ${CMAKE_BINARY_DIR}/
)
