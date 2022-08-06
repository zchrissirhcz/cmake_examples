cmake_minimum_required(VERSION 3.17)

project(hello)

find_package(Doxygen REQUIRED)

set(DOXYGEN_IN ${CMAKE_SOURCE_DIR}/docs/Doxyfile.in)
set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT})

# 注意这里的 `ALL` 参数是必须的：有了它，就可以用 cmake --build 生成文档，而不必手动执行 doxygen
add_custom_target(doc ALL
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generate API documentations with Doxygen"
    VERBATIM
)
