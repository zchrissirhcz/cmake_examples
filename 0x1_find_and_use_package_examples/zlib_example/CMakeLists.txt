cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(MSVC)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /source-charset:utf-8 /execution-charset:gbk ")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /source-charset:utf-8 /execution-charset:gbk ")
endif()

#------------------------------------------------------
# cmake手动设定zlib的说明
#------------------------------------------------------
# 虽然CMake安装包提供了FindZLIB.cmake，但它很不完善
#   - 安装程序不提供FindZLIB.cmake，也不提供其他cmake文件
#   - 默认只找动态库，并且不配置DLL
#   - 如果要找静态库，需要手动指定
#   - 不支持ZLIB_DIR变量，只支持ZLIB_ROOT变量
#
# 因此，我们不用find_package(ZLIB)
# 作为替代，我们手动设定ZLIB的头文件目录、库路径和DLL路径
# 并同时支持Debug和Release模式(生成表达式)，方便使用
# P.S. 目前只考虑了Windows Visual Studio平台
#------------------------------------------------------

option(ZLIB_USE_STATIC_LIBS "use static zlib library?" ON)
set(ZLIB_ROOT "D:/lib/zlib/1.2.11/x64/vc15")

set(ZLIB_INCLUDE_DIR "${ZLIB_ROOT}/include")
if(ZLIB_USE_STATIC_LIBS)
  set(ZLIB_LIBRARY
    ${ZLIB_ROOT}/lib/zlibstatic$<$<CONFIG:Debug>:d>.lib
  )
else() # if using shared zlib, we have to manually specify DLLs absolute path
  set(ZLIB_DLL
    $<$<CONFIG:Debug>:"${ZLIB_ROOT}/bin/zlibd.dll">
    $<$<CONFIG:Release>:"${ZLIB_ROOT}/bin/zlib.dll">
  )
endif()


#------------------------------------------------------
# 使用zlib
#------------------------------------------------------
add_executable(demo
  src/demo.cpp
)

target_include_directories(demo PUBLIC ${ZLIB_INCLUDE_DIR})
target_link_libraries(demo ${ZLIB_LIBRARY})

if(MSVC AND NOT ZLIB_USE_STATIC_LIBS) # copy dll
  add_custom_command(TARGET demo
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${ZLIB_DLL}
    ${CMAKE_BINARY_DIR}/
  )
endif()

