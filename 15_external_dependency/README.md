# external dependency

在 CMake 中使用外部依赖时， 前面介绍了 find_package() 的使用。

但 find_package() 仅仅是 “消耗” “使用” 依赖项。 怎样导入依赖项呢？

- apt / brew 等系统包管理工具安装
    缺点是版本可能太旧， 而且不能切换版本
- 在 CMakeLists.txt 里使用 cmake 自带的导入依赖的模块
    - FetchContent, configure 阶段下载
    - ExternalProject, build 阶段下载
- 使用 CPM.cmake 这样的第三方工具
    - CPM.cmake 是封装了 FetchContent
    - 商汤的 hpcc.common， 轻量级的封装了 FetcContent

上述几种方法都解决了一些问题，但都不彻底、不优雅。考虑这些问题：
- 引入外部项目后， 若该项目不清真（改了CMAKE_CXX_FLAGS， 可执行文件输出目录等默认配置）， 导致不符合预期结果
- 没法按官方说明的 find_package() 方式使用， 例如 OpenCV 本来只要 `${OpenCV_LIBS}` 就处理了库和头文件， 但现在由于 FetchContent、ExternalProject 无法或难以执行安装， 只能用原始的 opencv_core, opencv_imgproc 目标和手动添加头文件搜索目录



