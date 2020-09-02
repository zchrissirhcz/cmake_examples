# Jni PC 例子
广泛使用Jni是在Android里面。但由于Android Studio反应不够快，而我对Jni编程又不够熟悉，因此现在在PC（x86-64）下进行Jni的学习。通过编写实际可以运行的例子来验证。

Java代码：
- 静态加载动态库
- 声明native方法
- 声明main函数；调用native方法

Java命令行：
- javac编译java类
- javah生成jni的头文件
Windows cmd:
```batch
javac droid\HelloWorld.java
javah droid.HelloWorld
mv droid_HelloWorld.h jni\
```

Jni代码：
- 使用javah生成的jni头文件（静态注册）
- 或者，自行使用动态注册，但函数签名建议直接从javah生成的头文件中获取

C/C++代码：
- 创建.c/.cpp文件，包含前面Jni代码中（自行创建的）头文件
- 实现jni函数

CMake代码：
- 设定动态库目标，注意库的名字和Java代码中静态加载动态库时一致
- 包含jni模块，给目标添加jni的头文件和库

运行：
- 调用cmake生成.sln或makefile，进而生成.so/.dll
- 设定PATH，包含刚刚生成的.so/.dll路径
windows：
```batch
set PATH=E:\dbg\zz\jni_example\build\vs2017-x64\Debug;%PATH%
```
- 执行java代码
```batch
java droid.HelloWorld
```


参考：
[JNI完整demo](https://blog.csdn.net/riluomati/article/details/103205528)