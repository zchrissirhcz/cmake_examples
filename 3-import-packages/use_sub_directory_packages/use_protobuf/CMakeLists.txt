cmake_minimum_required(VERSION 3.20)
project(x)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 由于 protobuf 官方的 cmake 写法问题， 编译安装后的 protobuf 仍然不能通过 find_package() 找到
# 例如 ubuntu 系统， apt 装的 protobuf 是 3.12， 但想用 protobuf 3.21. 而 protobuf 偏偏不兼容老版本， cmake 如果找到的是 apt 装到 /usr/include/ 这里的 protobuf 的头文件，就导致编译报错
# 解决办法是手动搞一个 imported library
# 也就是， 你就当编译安装 protobuf 时根本就没有 cmake 目录好了， 根本就没提供能用的东西。
add_subdirectory(protobuf)