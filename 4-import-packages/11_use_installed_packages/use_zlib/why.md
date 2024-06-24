## 为什么有这个仓库？

我日常使用 cmake 构建 C/C++ 工程，一切还算顺利。直到某天编译了 OpenCV Android 库给同事，使用时链接报错 libz.a 所在的 NDK 路径（在ta电脑上）不存在。排查了几个小时，问题锁定在 `<cmake_install_dir>/share/cmake/Modules/FindZLIB.cmake`，即使是最新版 cmake (3.19.4, 截止2021-02-10)，也不能精准的找到 NDK-r21b 里的 libz.so 或 libz.a。这太糟糕了！

我希望把修改后的更好用更准确的 FindZLIB.cmake 开源出来，后人少踩坑；如果你有遇到类似的情况，也欢迎提 issue / 发 PR。


## Why create this repo?

I build my C/C++ programs with cmake, everything keeps fine, until someday I compiled OpenCV Android package and sharing to my collegue, encounter linking error saying libz.a in NDK directory, but that directory not found on his/her compuetr. I inspect this issue for several hours, and it figured out the file `<cmake_install_dir>/share/cmake/Modules/FindZLIB.cmake` is unable to accurately find libz.so or libz.a in NDK-r21b directories, even if cmake is the latest (3.19.4, by 2021-02-10). Terrible!

I modified that FindZLIB.cmake and open source it now, hoping to save people from this pitfall. If you've encountered similiar problem, welcome to create issues and even make Pull Requests.