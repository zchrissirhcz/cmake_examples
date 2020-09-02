```batch
javac droid\HelloWorld.java
javah droid.HelloWorld
run build\vs2017-x64.bat
set PATH=E:\dbg\zz\cmake_examples\jni_example2\build\vs2017-x64\Debug;%PATH%
java droid.HelloWorld
```