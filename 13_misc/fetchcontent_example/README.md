# fetch content example

## 0x0 目的
cmake 自带了 FetchContent 模块， 用来“获取”（通过网络）依赖项：
- 若是一套 cmake 工具， 或 header-only 的库， 则获取后 include 使用即可
- 若是一套 C/C++ 源代码， 通常也是基于 CMake 构建的， 则获取后执行编译， 编译后产生的target 在当前构建过程中也是可见的， 可以被用到 target_link_libraries() 等命令中。

## 0x1 基本用法
FetchContent_Declare： 声明（记录）需要的依赖的具体信息（如url，hash等，后面详细解释）；

FetchContent_MakeAvailable： 检查依赖是否被成功引入（populate），若populate了则产生相应的变量， 类似于 find_package(xxx) 后了， 有 xxx 的相关变量。

```cmake
FetchContent_Declare(xxx
    ...
)
FetchContent_MakeAvailable(xxx)
```

## 0x2 高阶用法
```cmake
FetchContent_Declare(xxx)
FetchContent_GetProperties(xxx)
if(NOT xxx_POPULATED)
    FetchContent_Populate(xxx)
    # 后续可使用 xxx 项目中的 cmake targets
endif()
```

## 0x3 命令具体解释

### FetchContent_Declare

**hpcc的例子**

以 ppl.cv 中下载 hpcc 为例进行说明：
```cmake
FetchContent_Declare(hpcc
    GIT_REPOSITORY https://github.com/openppl-public/hpcc.git
    GIT_TAG fe210f0d20cc50da9ad51b29edc02bfeb7cda24a
    SOURCE_DIR ${HPCC_DEPS_DIR}/hpcc
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/hpcc-build
    SUBBUILD_DIR ${HPCC_DEPS_DIR}/hpcc-subbuild)

FetchContent_GetProperties(hpcc)
if(NOT hpcc_POPULATED)
    FetchContent_Populate(hpcc)
    include(${hpcc_SOURCE_DIR}/cmake/hpcc-common.cmake)
endif()
```

GIT_REPOSITORY: 仓库地址
GIT_TAG： 在上一步repo地址的基础上， 指明 tag。 可以是hash值，也可以是tag名字，但是推荐用hash值。
SOURCE_DIR: 把 hpcc 下载后， 解压到这个目录
BINARY_DIR: 在这个目录， 对 hpcc 展开编译。实际上 hpcc 是一些 cmake 脚本， 没有C/C++源码， 因此此目录将为空
SUBBUILD_DIR： 下载 hpcc 过程中的临时目录。由于是 git repo形式，因此是执行了 git clone。


**googletest的例子**

googletest 官方的 cmake 用法， 是通过 FetchContent 引入：
```cmake
FetchContent_Declare(googletest
    URL https://github.com/google/googletest/archive/refs/tags/release-1.8.1.zip
    URL_HASH MD5=ad6868782b5952b7476a7c1c72d5a714
    SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/googletest
    BINARY_DIR ${FETCHCONTENT_BASE_DIR}/googletest-build
    SUBBUILD_DIR ${FETCHCONTENT_BASE_DIR}/googletest-subbuild
)

FetchContent_MakeAvailable(googletest)
```
URL: 指明了下载地址，是一个zip压缩包
URL_HASH： zip压缩包的md5哈希值
SOURCE_DIR： 下载并解压zip后，放在SOURCE_DIR
BINARY_DIR: 编译googletest的目录
SUBBUILD_DIR: 执行下载zip的时候的临时目录， 例如下载的zip在 deps/googletest-subbuild/googletest-populate-prefix/src/release-1.8.1.zip

## 0x4 注意项
1. SUBBUILD 作为“下载时的临时目录”， 并没在官方文档中找到， 是根据实际执行情况猜测的

2. `FetchContent_Declare` 并不会执行下载， 仅仅是“记录”（注册）；需要配合 `FetchContent_MakeAvailable` 或 `FetchContent_GetProperties` + `FetchContent_Populate` 才是真正的下载

3. 修改fetchcontent的默认下载、编译目录: 在 FetchContent_Declare 之前
```cmake
# 若未设定FETCHCONTENT_BASE_DIR， 则默认用 ${CMAKE_BINARY_DIR}/_deps
set(FETCHCONTENT_BASE_DIR ${HPCC_DEPS_DIR})
```

4. 显示下载细节，例如进度、是否失败: 在 FetchContent_Declare 之前
```
# 若未设定FETCHCONTENT_QUIET， 则默认用 ON， 意思是“静默模式”，获取内容期间保持不输出， 除非遇到错误才会输出
# 而现在设定FETCHCONTENT_QUIET为OFF，意思是“获取内容期间， 显示各种log输出， 让用户看到细节”。
# 对于网络不好的情况， 建议打开此选项
set(FETCHCONTENT_QUIET OFF)
```

5. 若FetchContent_Declare 成功， 则可使用里面的 targets
```cmake
enable_testing()
add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC gtest_main) ##
```