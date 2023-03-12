手动定义一个导入库（imported）， 类型是 windows 下的共享库， 设置三个属性：
- 头文件搜索目录
- dll 路径
- lib 路径
- 附带宏定义

注意， 还需要手动把 dll 文件所在目录放到 PATH 环境变量。

CMakeLists.txt 里以 windows pthread 为例进行了设置。