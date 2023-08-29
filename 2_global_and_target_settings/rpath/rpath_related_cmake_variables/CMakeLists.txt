cmake_minimum_required(VERSION 3.26)
project(x)

#set(CMAKE_SKIP_RPATH TRUE)  # 全局配置， 默认值为NO， 意思是默认情况下会分别为 编译阶段（其实是静态链接阶段）、安装阶段得到的动态库、可执行文件设置RPATH。这里设置为不生成 build 和 install 两个 stage 的 RPATH。
#set(CMAKE_SKIP_BUILD_RPATH TRUE)  # 全局配置，默认值为<empty>，意思是默认情况下会为编译得到的动态库、可执行文件设置RPATH。这里设置为编译阶段不生成 RPATH。
#set(CMAKE_SKIP_INSTALL_RPATH TRUE) # 全局配置, 默认值为NO，意思是默认情况下，会为安装的动态库、可执行文件设置RPATH。这里设置为安装阶段不生成 RPATH。
#set(BUILD_WITH_INSTALL_RPATH TRUE) # 全局配置，默认值为<empty>， 也就是 FALSE, 意思是编译阶段 和 安装阶段为动态库、可执行文件设置的RPATH，是不相同的。这里设置为相同的。

message(STATUS "CMAKE_SKIP_RPATH: ${CMAKE_SKIP_RPATH}") # NO
message(STATUS "CMAKE_SKIP_BUILD_RPATH: ${CMAKE_SKIP_BUILD_RPATH}") # <empty>
message(STATUS "CMAKE_SKIP_INSTALL_RPATH: ${CMAKE_SKIP_INSTALL_RPATH}") # NO
message(STATUS "BUILD_WITH_INSTALL_RPATH: ${BUILD_WITH_INSTALL_RPATH}") # <empty>


add_library(world SHARED world.c)
add_library(hello SHARED hello.c)

target_link_libraries(hello PUBLIC world)

add_executable(test test.c)
target_link_libraries(test PUBLIC hello)

# 在 CMAKE_SKIP_BUILD_RPATH 为 ON， 或 CMAKE_SKIP_RPATH 为 ON 时， BUILD_RPATH 属性的设置不会生效
#set_target_properties(test PROPERTIES BUILD_RPATH "$ORIGIN;$ORIGIN/../lib")

# target properties:
# - BUILD_RPATH # 设定 build 阶段的动态库、可执行目标的 rpath 属性
# - INSTALL_RPATH # 设定 install 阶段的动态库、可执行目标的 rpath 属性
# - INSTALL_RPATH_USE_LINK_PATH # ？
# - INSTALL_REMOVE_ENVIRONMENT_RPATH # ？
# - SKIP_BUILD_RPATH # build 阶段不设置 rpath
# - BUILD_RPATH_USE_ORIGIN # ORIGIN 意思是动态库、可执行文件（被标记RPATH的文件）所在的目录， “当前目录”
# - BUILD_WITH_INSTALL_RPATH # build 阶段和 install 阶段使用相同的 rpath
#
# - MACOSX_RPATH # ？

# 执行安装， 目的是查看安装的文件中的 rpath
install(TARGETS hello LIBRARY DESTINATION lib)
install(TARGETS world LIBRARY DESTINATION lib)
install(TARGETS test RUNTIME DESTINATION bin)

# 尝试打印 rpath 相关的 per-target property、全局 property， 目前得到全是空的结果
get_target_property(test_build_rpath test BUILD_RPATH)
message(STATUS "test_build_rpath: ${test_build_rpath}")

get_target_property(test_install_rpath test INSTALL_RPATH)
message(STATUS "test_install_rpath: ${test_install_rpath}")

get_property(global_build_rpath GLOBAL PROPERTY BUILD_RPATH)
message(STATUS "global_build_rpath: ${global_build_rpath}")

get_property(global_install_rpath GLOBAL PROPERTY INSTALL_RPATH)
message(STATUS "global_install_rpath: ${global_install_rpath}")

include(summary.cmake)
