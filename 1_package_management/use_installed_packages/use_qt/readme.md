## Original Code
[remarkable](https://github.com/junluan/remarkable)

## Installation
Tested on ubuntu 20.04
```bash
sudo apt install qtcreator qt5-default qtbase5-doc-dev qtbase5-examples
```

菜单(Menu)->工具(Tools)->选项->Kits->构建套件(Kit)，检查"Qt Version"的值，如果是None，则点选Manage->添加，它会弹窗问qmake安装的位置，选择`/usr/bin/qmake`，然后保存。


代码中出现类似 `unknown type name 'QApplication'` 的报错。
但是构建没有问题，能run程序。

解决：菜单(Menu)->帮助(Help)->关于插件->C++， 去掉 Clang Code Model 那个勾，然后重启QtCreator


## References
[Qt Documentation - Building with CMake](https://doc.qt.io/qt-5.12/cmake-manual.html)

[Kitware Blog - CMake: Finding Qt 5 the "Right Way"](https://blog.kitware.com/cmake-finding-qt5-the-right-way/)

[How to place header and ui file in different folders using autouic in cmake](https://stackoverflow.com/a/45132079/2999096)
