# gtest filter

使用 gtest 做单元测试时，可能出现：
1. 大部分 case 成功， 少部分 case 失败； 边修改边验证， 希望只跑这些曾失败的 case
2. 大部分 case 失败， 少部分 case 成功； 边修改边验证， 希望只跑这些曾失败的 case

下面列出命令行方式的过滤（代码中过滤的例子，见 [../gtest_examples2/testbed.cpp](../gtest_examples2/testbed.cpp) )

## only run one test case
```bash
./testbed --gtest_filter=Resize.ScaleTwice
```

## ignore one test case
```bash
./testbed --gtest_filter=-Resize.ScaleTwice
```

## multiple cases
https://stackoverflow.com/questions/14018434/how-to-specify-multiple-exclusion-filters-in-gtest-filter

