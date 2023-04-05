# find_opencl_with_megpeak_opencl_stub

使用旷视 MegPeak 开源项目中的 opencl_stub 这个 loader 库， 在运行阶段加载 opencl 库。

基于我的 PR [Fix loading of OpenCL library on MacOS](https://github.com/MegEngine/MegPeak/pull/22), 现在支持了 Linux, Android 和 MacOS.

而头文件方面， opencl_stub 里提供的不太完整， 仍然需要使用 opencl 官方的 headers。

由于 opencl_stub 不是一个独立的工程， cmake 写的不太完善， 本 example 工程中以源码引入的 （add_subdirectory）方式引入。