cmake_minimum_required(VERSION 3.18)

project(onednn_demo)
set(CMAKE_CXX_STANDARD 11)

option(DEP_USE_GITEE "use gitee for dependency speed up?" ON)

set(src_file
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
)

add_executable(onednn_demo ${src_file})
target_include_directories(onednn_demo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include/)

# ONETBB
if(DEP_USE_GITEE)
    set(ONETBB_REPO https://gitee.com/aczz/oneTBB.git)
else()
    set(ONETBB_REPO https://github.com/oneapi-src/oneTBB.git)
endif()
set(ONETBB_TAG v2021.5.0)
#set(ONETBB_MD5 5e5f2ee22a0d19c0abbe7478f1c7ccf6)

# ONEDNN
if(DEP_USE_GITEE)
    set(ONEDNN_REPO https://gitee.com/leonationality/oneDNN.git)
else()
    set(ONEDNN_REPO https://github.com/oneapi-src/oneDNN.git)
endif()
#set(ONEDNN_MD5 c60ea96acbaccec053be7e3fa81c6184)
set(ONEDNN_TAG v2.4.3)

#set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH}")

# include(tbb)
# include(dnnl)
include(cmake/deps.cmake)

target_link_libraries(onednn_demo PRIVATE tbb)
target_link_libraries(onednn_demo PRIVATE dnnl)
# --------------------------------------------------------------