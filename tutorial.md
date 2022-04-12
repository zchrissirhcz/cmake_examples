# cmake tutorial

## 0. 目的
随便写点 cmake tutorial， 不求全面， 只是稍作入门引导。

有些可能写的不对， 可以开 issue / PR 反馈。

## 1. 大小写

```
SET(var "123")
```

```
set(var "123")
```
哪个对？

都对， 但是对于 `set()`, `list()` 等， 这些 CMake 内置的关键字、命令，遵循习惯应当小写，虽然大写也不报错但不太好。更完整的清单是：
- set
- list
- if, else, elseif, endif
- foreach, endforeach
- function, endfunction
- macro, endmacro

## 2. cmake 风格和版本
cmake 是一个有着多年历史的软件； 类似于 C++ 分为 classical c++ 和 modern c++， cmake 也区分 classifical cmake 和 modern cmake。
- classical cmake：古典 cmake，各种设置往往是全局的，不能说不work，只能说潜在的坑比较多，不够灵活
- modern cmake：类似于 object orientated 的想法，尽量减少全局设定，尽量按每个 target 设定， target 属性有 PRIVATE/PUBLIC/INTERFACE 这样的修饰关键字

通常来说，能用最新 cmake 就用最新版的。通常是兼容老版本的。

## 3. TODO
