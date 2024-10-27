编译 ppl.cv 步骤：
1. 克隆 https://github.com/openppl-public/ppl.cv
2. 拷贝 deps.cmake 到 cmake/deps.cmake
3. 拷贝 build 脚本到 build 目录，并执行
4. 下载 opencv 过程中遇到下载 ADE.zip 卡住的情况。中断它，然后删除 deps/opencv/modules/gapi 目录，重新来过即可。

注： 由于官方不肯接受 git mirror 的 PR，只能每次手动用这套脚本修改了。
