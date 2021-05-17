# vscode cmake example

若干年前，我写了怎样用 VSCode 调试基于 cmake 构建的 C/C++ 工程，原文在：

https://www.cnblogs.com/zjutzz/p/9389106.html

这里贴出最近顺手的配置，相比原文略有更新，但差异不大。

## 安装 lldb-mi

如果要用 clang 作为编译器，搭配的调试器是 lldb。要在 VSCode 里用 lldb 调试，需要能找到 lldb-mi 这一可执行程序，或手动指定其路径。

在 ubuntu 20.04 上，由于官方没有把 lldb-mi 打包到进 apt（一说是忘记了），需要自行编译 lldb-mi （只需要 10 秒钟）：

```bash
sudo apt install liblldb-10-dev

cd ~/work
git clone https://github.com/lldb-tools/lldb-mi.git
cd lldb-mi
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/soft/lldb-mi
cmake --build .
cmake --install .

# 覆盖系统的 lldb-mi 软链接；可选
sudo ln -sf /home/zz/soft/lldb-mi/bin/lldb-mi /usr/bin/lldb-mi
```

launch.json 中指定:
```json
"miDebuggerPath": "/home/zz/soft/lldb-mi/bin/lldb-mi",
```

### 报错1: registered more than once!
断点调试遇到报错：
```
: CommandLine Error: Option 'help-list' registered more than once!
LLVM ERROR: inconsistency in registered CommandLine options
[1] + Aborted (core dumped)      "/usr/bin/lldb-mi" --interpreter=mi --tty=${DbgTerm} 0<"/tmp/Microsoft-MIEngine-In-o6gf3wbo.w0h" 1>"/tmp/Microsoft-MIEngine-Out-pr6267el.0aa"
```
原因：大概是因为系统装了多个版本的 llvm 导致的。。

解决办法：系统PATH中只保留系统自带的 clang，也就是 clang-10 。手动放到 ~/.pathrc 的 clang 11，只好先byebye了。


虽然试过`-DCMAKE_PREFIX_PATH=/home/zz/soft/clang+llvm-11.0.0`参数，但没有效果。。（可能软连接忘记更新导致的，有时间再试试。）


## 报错2：process launch failed: unable to locate lldb-server-10.0.0
```
Warning: Debuggee TargetArchitecture not detected, assuming x86_64.
ERROR: Unable to start debugging. Unexpected LLDB output from command "-exec-run". process launch failed: unable to locate lldb-server-10.0.0
The program '/home/zz/work/cmake_examples/vscode_example/build/linux-x64/testbed' has exited with code 42 (0x0000002a).
```

原因： VSCode 比较傻，只认  `lldb-server-10.0.0` 不认 `lldb-server-10`. 

解决：创建软连接：
```bash
sudo ln -s /usr/bin/lldb-server-10 /usr/bin/lldb-server-10.0.0
```

## 问题3：断点不停，怎么办？

https://github.com/microsoft/vscode-cpptools/issues/5415

试了这帖子贴出的方法，都不行。目前只好切回 gcc