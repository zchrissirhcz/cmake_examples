#!/bin/bash

0. update the latest llvm-project source code

1. install python3 first. I use miniconda3
可能最好换成 python 3.9 版本？
反正不用系统的 Python3.8 就行了，不然太坑了

2. then, install swig. required for lldb python binding
sudo apt install swig

3. run build-lldb.sh
May see some warings:
```
CMake Warning at cmake/modules/AddLLVM.cmake:873 (add_executable):
  Cannot generate a safe runtime search path for target
  ScriptInterpreterPythonTests because files in some directories may conflict
  with libraries in implicit directories:

    runtime library [libform.so.6] in /usr/lib/x86_64-linux-gnu may be hidden by files in:
      /home/zz/soft/miniconda3/lib
    runtime library [libpanel.so.6] in /usr/lib/x86_64-linux-gnu may be hidden by files in:
      /home/zz/soft/miniconda3/lib
    runtime library [liblzma.so.5] in /usr/lib/x86_64-linux-gnu may be hidden by files in:
      /home/zz/soft/miniconda3/lib
    runtime library [libz.so.1] in /usr/lib/x86_64-linux-gnu may be hidden by files in:
      /home/zz/soft/miniconda3/lib
    runtime library [libtinfo.so.6] in /usr/lib/x86_64-linux-gnu may be hidden by files in:
      /home/zz/soft/miniconda3/lib

  Some of these libraries may not be found correctly.
Call Stack (most recent call first):
  cmake/modules/AddLLVM.cmake:1457 (add_llvm_executable)
  /home/zz/work/github/llvm-project/lldb/unittests/CMakeLists.txt:47 (add_unittest)
  /home/zz/work/github/llvm-project/lldb/unittests/ScriptInterpreter/Python/CMakeLists.txt:1 (add_lldb_unittest)


-- Generating done
-- Build files have been written to: /home/zz/work/github/llvm-project/build/build-lldb

```

4. 编译好了， lldb 可以用， 但是没加载 ~/.lldbinit 的样子，有点奇怪（lldb代码版本太旧导致）
之前那个 pdb.py 里 readline 报错的问题消失了。

用 c2a8a104ec32 这个版本 (2022-04-04 | [MLIR][NFC] Remove unnecessary cast. (HEAD -> main, gitee/main, gitee/HEAD) [antonio-cortes-perez]
) 在工作机又编译了一次， 这次可以加载 ~/.lldbinit 了

5. 更新环境变量
```bash
export PYTHONPATH=/home/zz/soft/llvm15-dev/lib/python3.8/site-packages
```

6. 删掉老的不正确的lldb
```
(base) zz@home% which lldb
/usr/bin/lldb
(base) zz@home% ls -al /usr/bin/lldb
lrwxrwxrwx 1 root root 16 4月   4 13:42 /usr/bin/lldb -> /usr/bin/lldb-14
(base) zz@home% sudo ln -sf /home/zz/soft/llvm15-dev/bin/lldb /usr/bin/lldb
```

