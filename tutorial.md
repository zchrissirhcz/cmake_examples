# cmake tutorial

## 0. 目的
随便写点 cmake tutorial， 不求全面， 只是稍作入门引导。

有些可能写的不对， 可以开 issue / PR 反馈。

## 1. 大小写

```
SET(var "123")
```

```
set(var "123")
```
哪个对？

都对， 但是对于 `set()`, `list()` 等， 这些 CMake 内置的关键字、命令，遵循习惯应当小写，虽然大写也不报错但不太好。更完整的清单是：
- set
- list
- if, else, elseif, endif
- foreach, endforeach
- function, endfunction
- macro, endmacro

## 2. cmake 风格和版本
cmake 是一个有着多年历史的软件； 类似于 C++ 分为 classical c++ 和 modern c++， cmake 也区分 classifical cmake 和 modern cmake。
- classical cmake：古典 cmake，各种设置往往是全局的，不能说不work，只能说潜在的坑比较多，不够灵活
- modern cmake：类似于 object orientated 的想法，尽量减少全局设定，尽量按每个 target 设定， target 属性有 PRIVATE/PUBLIC/INTERFACE 这样的修饰关键字

通常来说，能用最新 cmake 就用最新版的。通常是兼容老版本的。

## 3. 设置编译选项

### 全局的
咱也不是完全反对全局设置。

设置 C++11 语言标准:
```
set(CMAKE_CXX_STANDARD 11)
```

设置构建类型:
```
set(CMAKE_BUILD_TYPE Release)
#set(CMAKE_BUILD_TYPE Debug)
```

生成 compile_commands.json (非MSVC)
```
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

开启 AddressSanitizer（以下一大坨看似头疼，其实能适配99%的 CMAKE_BUILD_TYPE，通常无脑copy使用）
```
option(USE_ASAN "Use Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
if(USE_ASAN)
  if(MSVC)
    message(WARNING "AddressSanitizer for MSVC must be enabled manually in project's property page.")
  else()
    message(STATUS ">>> USE_ASAN: YES")
    message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
    if(CMAKE_BUILD_TYPE MATCHES "Debug")
      # On debug mode
      set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "Release")
      # Note: `-g` is explicitly required here, even if NDK android.toolchain.cmake's `-g` exists.
      set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
      set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
      set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
    else()
      message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for asan setup: ${CMAKE_BUILD_TYPE}")
    endif()
  endif()
else()
  message(STATUS ">>> USE_ASAN: NO")
endif()
```

开启/关闭调试符号信息：
可以手动改 ndk 的 toolchain.cmake 中的 "-g"，也可以用类似上面 Address Sanitizer 的方式设置；或者用我封装好的 cmake 函数：
```
# download https://github.com/zchrissirhcz/sleek/blob/master/sleek.cmake
include(sleek.cmake)
sleek_add_debug_symbol()
```
弄懂这个 sleek_add_debug_symbol() 需要会写点 cmake 的 function 和 macro 。

## 4. 写 xxx.cmake 或 FindXXX.cmake
有头文件，有库文件，但是没 xxx.cmake 或 FindXXX.cmake

### 暴力一点的搞法
```
set(hello_inc_dir "/path/to/hello_include")
set(hello_lib "/path/to/hello_lib")
```
于是用的时候:
```
# 假设你的 target 名为 testbed
target_include_directories(testbed PUBLIC ${hello_inc_dir})
target_link_libraries(testbed PUBLIC ${hello_lib})
```
不用担心有其他的库也要调用 `target_include_directories()` 和 `target_link_libraries()`. 只要没写 `include_directories()` 和 `link_libraries()`， 就可以多次用。

### 怎样优雅、不暴力的配置？
比如 modern cmake 一再强调的，链接一个依赖项的时，只要链接了库， 就别麻烦用户去配置 include 路径了。
换言之， 你可以“费点力气”创建一个 IMPORTED 类型的 target（通常是库类型的 target），但后续用的时候就轻松了：
```
add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/3rdparty/hello"
    INTERFACE_POSITION_INDEPENDENT_CODE "ON"
)
...

target_link_libraries(testbed hello) # 只需要链接哦，不用蛋疼的配置头文件目录了
```
完整工程在 02_creating_targets/create_imported_lib_example

### 再优雅点？
你前面配置的虽然 work， 但是是在当前工程里配置的。我换个工程，或者要共享给别人，咋用？

嗯，就把 IMPORTED 那一段copy出来，放在 hello.cmake 中吧！不过，你可以做更多补充：
- debug 库和 release 库同时存在，咋弄？关键字： optimize
- 如果 hello 这个库本身还依赖别的库呢？ 例如 openmp？

### 再再优雅点？
比如说吧，给我 hello 库的人， 更新库了。我咋区分新旧两个版本的 hello 库呢？注意是 cmake 方式区分。

好吧我摊牌了， 还没有特别好用的 C++ 包管理器， 但是有一些可以凑合用的：
- vcpkg： 开源公共库支持的比较多。 不过由于官方没合并我的 PR 还拒不认错，我不用它
- conan.io: 基于 JFrog ARTIFACTORY 的，应该是不错的，我没用过- 不过公司有类似的方案实现的包管理库，用起来很舒服就是了


### 我就想要 FindXXX.cmake 的例子，快给我！
我写过 FindZLIB.cmake: https://github.com/zchrissirhcz/sleek/blob/master/FindZLIB.cmake

cmake 安装包里自带了 FindZLIB.cmake, 但是它有bug， 只找动态库不找静态库；而 cmake 官方说每个 package 的 FindXXX.cmake 由 contributor 维护； 可是这些 contributor 也不来 github 毫不活跃的样子，那就自己瞎改改用吧！


