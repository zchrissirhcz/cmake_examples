cmake_minimum_required(VERSION 3.20)
project(x)

include(windows_encoding.cmake)

# option1: using doxygen provided prebuilt of libiconv
#add_definitions(-DLIBICONV_STATIC)
#set(Iconv_LIBRARY "D:/github/doxygen/winbuild/iconv64.lib")
#set(Iconv_INCLUDE_DIR "D:/github/doxygen/winbuild")

# option2: manually compile libiconv-for-Windows (change project property to compile static library)
# 如果编译 iconv 时开启了 LIBICONV_PLUG 宏， 则函数带有 lib 前缀
# 不过 libiconv-for-Windows 默认没开这个选项， 那么用的时候， 也就不能开启这个宏, 否则链接不上
set(Iconv_LIBRARY "D:/github/libiconv-for-Windows/output/x64/Release/libiconv.lib")
set(Iconv_INCLUDE_DIR "D:/github/libiconv-for-Windows/include")


find_package(Iconv REQUIRED)

add_executable(testbed main.cpp)

target_link_libraries(testbed PUBLIC Iconv::Iconv)

# unresolved external symbol sprintf
# requires legacy_stdio_definitions.lib
if(MSVC_VERSION GREATER 1800)
    target_link_libraries(testbed PUBLIC legacy_stdio_definitions.lib)
endif()

#target_include_directories(testbed PUBLIC ${Iconv_INCLUDE_DIR})
#target_link_libraries(testbed ${Iconv_LIBRARY})