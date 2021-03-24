给cmake传入的option，是放在txt文件里，然后通过某种方式，把txt内容传给cmake。

## powershell

.ps1 脚本里，用`$(type options.txt)`表示`cat options.txt`。

限制：似乎不能连行，只能单行写option或指定cache变量。

## cmd

.cmd 脚本里，用`set /p VV=<..\options.txt`的方式，创建了`VV`变量，它等于options.txt的第一行。

也就是说，只能读取txt的第一行然后作为参数传给cmake。

## bash

TODO