cmake_minimum_required(VERSION 3.20)
project(snake)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(snake snake.c)

find_package(GLUT REQUIRED) # GLUT 只是一个 wrapper， 仍然需要用户查找和链接 OpenGL、 GLU 库
find_package(OpenGL REQUIRED) # 找 OpenGL 的同时， 会找 GLU 库

target_link_libraries(snake
    GLUT::GLUT
    OpenGL::GLU
    OpenGL::GL
)
