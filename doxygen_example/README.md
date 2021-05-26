# Doxygen CMake Example

## 准备

必备：
```bash
sudo apt install doxygen
```

可选，但本例子需要：
```bash
sudo apt install doxygen-latex
sudo apt install dot
sudo apt install dia
sudo apt install pdflatex
```

## 步骤

在本工程目录下执行：

```bash
# 常规构建
mkdir build
cd build
cmake ..
cmake --build . # 好吧，这里没反应

doxygen Doxyfile.my_docs # 这才是生成文档的命令

cd html
python -m http.server 7083 # 打开浏览器，访问 localhost:7083 即可访问
```

其中 `Doxyfile.my_docs` 是由 CMakeLists.txt 中指定的的 `my_docs` 这一 target 确定的名字。

生成 pdf 的步骤：
```
cd latex
make
open refman.pdf
```

## 结论

看起来仅仅是勉强能用。通过 CMakeLists.txt 传入 Doxyfile 的相关变量，并不是 Doxyfile 本身的方式，比较繁琐。

## References

https://cmake.org/cmake/help/latest/module/FindDoxygen.html