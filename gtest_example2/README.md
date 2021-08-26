# googletest cmake example2

## 0x0 目的

这个例子是为了展示， 在 Visual Studio 里用 MTDLL 情况下（例如使用 OpenCV 预编译包）， 配置 GTest 的一些踩坑要点。为了少走坑，先写正确步骤。


## 0x1 正确编译安装 gtest


```batch
@echo off

set BUILD_DIR=vs2019-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=./install -Dgtest_force_shared_crt=ON
cmake --build . --config Debug
cmake --build . --config Release
cmake --install . --config Debug
cmake --install . --config Release
cd ..
pause
```


## 0x2 一些报错记录

### 0x21 cmake 3.19.4 版本有bug
用 cmake 3.19.4 的过程中发现它无法正确用 find_package 找到 gtest，报错信息：

```
-- Selecting Windows SDK version 10.0.19041.0 to target Windows 10.0.18363.
-- The C compiler identification is MSVC 19.29.30038.1
-- The CXX compiler identification is MSVC 19.29.30038.1
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30037/bin/Hostx64/x64/cl.exe - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30037/bin/Hostx64/x64/cl.exe - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Error at D:/soft/cmake-3.19.4/share/cmake-3.19/Modules/FindPackageHandleStandardArgs.cmake:218 (message):
  Could NOT find GTest (missing: GTEST_LIBRARY GTEST_INCLUDE_DIR
  GTEST_MAIN_LIBRARY)
Call Stack (most recent call first):
  D:/soft/cmake-3.19.4/share/cmake-3.19/Modules/FindPackageHandleStandardArgs.cmake:582 (_FPHSA_FAILURE_MESSAGE)
  D:/soft/cmake-3.19.4/share/cmake-3.19/Modules/FindGTest.cmake:205 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
  CMakeLists.txt:9 (find_package)


-- Configuring incomplete, errors occurred!
See also "D:/dev/cmake_examples/gtest_example2/build/vs2019-x64/CMakeFiles/CMakeOutput.log".
请按任意键继续. . .
```

解决方法：**弃用 cmake 3.19.4， 换用最新的 cmake 3.21.2** 。


### 0x22 RuntimeLibrary不匹配
典型情况是， 直接 cmake 编译安装了 GTest， 没指定任何额外的 option。

而 OpenCV 也是从官方下载的 Windows 预编译版本（是MTDLL的Runtime）。

打开VS，默认在Debug模式，点绿三角，迎接我们的是链接报错：

>2>gtestd.lib(gtest-all.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)

完整信息：
```
已启动生成…
1>------ 已启动生成: 项目: ZERO_CHECK, 配置: Debug x64 ------
1>Checking Build System
2>------ 已启动生成: 项目: testbed, 配置: Debug x64 ------
2>Building Custom Rule D:/dev/cmake_examples/gtest_example2/CMakeLists.txt
2>testbed.cpp
2>gtestd.lib(gtest-all.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: struct _Cvtvec __cdecl std::_Locinfo::_Getcvt(void)const " (?_Getcvt@_Locinfo@std@@QEBA?AU_Cvtvec@@XZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: bool __cdecl std::ios_base::good(void)const " (?good@ios_base@std@@QEBA_NXZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: int __cdecl std::ios_base::flags(void)const " (?flags@ios_base@std@@QEBAHXZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: __int64 __cdecl std::ios_base::width(void)const " (?width@ios_base@std@@QEBA_JXZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: __int64 __cdecl std::ios_base::width(__int64)" (?width@ios_base@std@@QEAA_J_J@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: int __cdecl std::basic_streambuf<char,struct std::char_traits<char> >::sputc(char)" (?sputc@?$basic_streambuf@DU?$char_traits@D@std@@@std@@QEAAHD@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: __int64 __cdecl std::basic_streambuf<char,struct std::char_traits<char> >::sputn(char const *,__int64)" (?sputn@?$basic_streambuf@DU?$char_traits@D@std@@@std@@QEAA_JPEBD_J@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: void __cdecl std::basic_ios<char,struct std::char_traits<char> >::setstate(int,bool)" (?setstate@?$basic_ios@DU?$char_traits@D@std@@@std@@QEAAXH_N@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: class std::basic_ostream<char,struct std::char_traits<char> > * __cdecl std::basic_ios<char,struct std::char_traits<char> >::tie(void)const " (?tie@?$basic_ios@DU?$char_traits@D@std@@@std@@QEBAPEAV?$basic_ostream@DU?$char_traits@D@std@@@2@XZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: class std::basic_streambuf<char,struct std::char_traits<char> > * __cdecl std::basic_ios<char,struct std::char_traits<char> >::rdbuf(void)const " (?rdbuf@?$basic_ios@DU?$char_traits@D@std@@@std@@QEBAPEAV?$basic_streambuf@DU?$char_traits@D@std@@@2@XZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: char __cdecl std::basic_ios<char,struct std::char_traits<char> >::fill(void)const " (?fill@?$basic_ios@DU?$char_traits@D@std@@@std@@QEBADXZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: void __cdecl std::basic_ostream<char,struct std::char_traits<char> >::_Osfx(void)" (?_Osfx@?$basic_ostream@DU?$char_traits@D@std@@@std@@QEAAXXZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: class std::basic_ostream<char,struct std::char_traits<char> > & __cdecl std::basic_ostream<char,struct std::char_traits<char> >::operator<<(int)" (??6?$basic_ostream@DU?$char_traits@D@std@@@std@@QEAAAEAV01@H@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: class std::basic_ostream<char,struct std::char_traits<char> > & __cdecl std::basic_ostream<char,struct std::char_traits<char> >::operator<<(float)" (??6?$basic_ostream@DU?$char_traits@D@std@@@std@@QEAAAEAV01@M@Z) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>msvcprtd.lib(MSVCP140D.dll) : error LNK2005: "public: class std::basic_ostream<char,struct std::char_traits<char> > & __cdecl std::basic_ostream<char,struct std::char_traits<char> >::flush(void)" (?flush@?$basic_ostream@DU?$char_traits@D@std@@@std@@QEAAAEAV12@XZ) 已经在 gtestd.lib(gtest-all.obj) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(locale0.obj) : error LNK2005: "void __cdecl std::_Facet_Register(class std::_Facet_base *)" (?_Facet_Register@std@@YAXPEAV_Facet_base@1@@Z) 已经在 msvcprtd.lib(locale0_implib.obj) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2005: "private: static class std::locale::_Locimp * __cdecl std::locale::_Getgloballocale(void)" (?_Getgloballocale@locale@std@@CAPEAV_Locimp@12@XZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2005: "private: static class std::locale::_Locimp * __cdecl std::locale::_Init(bool)" (?_Init@locale@std@@CAPEAV_Locimp@12@_N@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2005: "public: static void __cdecl std::_Locinfo::_Locinfo_ctor(class std::_Locinfo *,char const *)" (?_Locinfo_ctor@_Locinfo@std@@SAXPEAV12@PEBD@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2005: "public: static void __cdecl std::_Locinfo::_Locinfo_dtor(class std::_Locinfo *)" (?_Locinfo_dtor@_Locinfo@std@@SAXPEAV12@@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(locale0.obj) : error LNK2005: "private: static class std::locale::_Locimp * __cdecl std::locale::_Locimp::_New_Locimp(class std::locale::_Locimp const &)" (?_New_Locimp@_Locimp@locale@std@@CAPEAV123@AEBV123@@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(cout.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(cerr.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(locale.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(locale.obj) : error LNK2005: "private: static void __cdecl std::locale::_Locimp::_Locimp_Addfac(class std::locale::_Locimp *,class std::locale::facet *,unsigned __int64)" (?_Locimp_Addfac@_Locimp@locale@std@@CAXPEAV123@PEAVfacet@23@_K@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(iosptrs.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xlock.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xlock.obj) : error LNK2005: "public: __cdecl std::_Lockit::_Lockit(int)" (??0_Lockit@std@@QEAA@H@Z) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xlock.obj) : error LNK2005: "public: __cdecl std::_Lockit::~_Lockit(void)" (??1_Lockit@std@@QEAA@XZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(wlocale.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(wlocale.obj) : error LNK2005: "public: char const * __cdecl std::_Locinfo::_Getdays(void)const " (?_Getdays@_Locinfo@std@@QEBAPEBDXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(wlocale.obj) : error LNK2005: "public: char const * __cdecl std::_Locinfo::_Getmonths(void)const " (?_Getmonths@_Locinfo@std@@QEBAPEBDXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(wlocale.obj) : error LNK2005: "public: unsigned short const * __cdecl std::_Locinfo::_W_Getdays(void)const " (?_W_Getdays@_Locinfo@std@@QEBAPEBGXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(wlocale.obj) : error LNK2005: "public: unsigned short const * __cdecl std::_Locinfo::_W_Getmonths(void)const " (?_W_Getmonths@_Locinfo@std@@QEBAPEBGXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xlocale.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xlocale.obj) : error LNK2005: "public: char const * __cdecl std::_Locinfo::_Getdays(void)const " (?_Getdays@_Locinfo@std@@QEBAPEBDXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xlocale.obj) : error LNK2005: "public: char const * __cdecl std::_Locinfo::_Getmonths(void)const " (?_Getmonths@_Locinfo@std@@QEBAPEBDXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xlocale.obj) : error LNK2005: "public: unsigned short const * __cdecl std::_Locinfo::_W_Getdays(void)const " (?_W_Getdays@_Locinfo@std@@QEBAPEBGXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xlocale.obj) : error LNK2005: "public: unsigned short const * __cdecl std::_Locinfo::_W_Getmonths(void)const " (?_W_Getmonths@_Locinfo@std@@QEBAPEBGXZ) 已经在 msvcprtd.lib(MSVCP140D.dll) 中定义
2>libcpmtd.lib(xstol.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xstoul.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xstoll.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xstoull.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xmtx.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xstrcoll.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xdateord.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xwcscoll.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xwcsxfrm.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xgetwctype.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xtowlower.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xtowupper.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(xstrxfrm.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(StlCompareStringA.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(StlCompareStringW.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(StlLCMapStringW.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>libcpmtd.lib(StlLCMapStringA.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MTd_StaticDebug”不匹配值“MDd_DynamicDebug”(testbed.obj 中)
2>LINK : warning LNK4098: 默认库“LIBCMTD”与其他库的使用冲突；请使用 /NODEFAULTLIB:library
2>D:\dev\cmake_examples\gtest_example2\build\vs2019-x64\Debug\testbed.exe : fatal error LNK1169: 找到一个或多个多重定义的符号
2>已完成生成项目“testbed.vcxproj”的操作 - 失败。
========== 生成: 成功 1 个，失败 1 个，最新 0 个，跳过 0 个 ==========
```


### 0x23 可执行目标是Release版，用了Debug版的gtest库
关键报错：

```
2>gtestd.lib(gtest-all.obj) : error LNK2038: 检测到“_ITERATOR_DEBUG_LEVEL”的不匹配项: 值“2”不匹配值“0”(testbed.obj 中)
```

完整报错：
```
已启动生成…
1>------ 已启动生成: 项目: ZERO_CHECK, 配置: Release x64 ------
1>Checking Build System
2>------ 已启动生成: 项目: testbed, 配置: Release x64 ------
2>Building Custom Rule D:/dev/cmake_examples/gtest_example2/CMakeLists.txt
2>testbed.cpp
2>gtestd.lib(gtest-all.obj) : error LNK2038: 检测到“_ITERATOR_DEBUG_LEVEL”的不匹配项: 值“2”不匹配值“0”(testbed.obj 中)
2>gtestd.lib(gtest-all.obj) : error LNK2038: 检测到“RuntimeLibrary”的不匹配项: 值“MDd_DynamicDebug”不匹配值“MD_DynamicRelease”(testbed.obj 中)
2>LINK : warning LNK4098: 默认库“MSVCRTD”与其他库的使用冲突；请使用 /NODEFAULTLIB:library
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__invalid_parameter，函数 "class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl std::operator+<char,struct std::char_traits<char>,class std::allocator<char> >(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > &&,class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > &&)" (??$?HDU?$char_traits@D@std@@V?$allocator@D@1@@std@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@0@$$QEAV10@0@Z) 中引用了该符号
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__CrtSetDbgFlag，函数 "public: __cdecl testing::internal::`anonymous namespace'::MemoryIsNotDeallocated::MemoryIsNotDeallocated(void)" (??0MemoryIsNotDeallocated@?A0xd80f512d@internal@testing@@QEAA@XZ) 中引用了该符号
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__calloc_dbg，函数 "char * __cdecl std::_Maklocstr<char>(char const *,char *,struct _Cvtvec const &)" (??$_Maklocstr@D@std@@YAPEADPEBDPEADAEBU_Cvtvec@@@Z) 中引用了该符号
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__CrtDbgReport，函数 "class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl std::operator+<char,struct std::char_traits<char>,class std::allocator<char> >(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > &&,class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > &&)" (??$?HDU?$char_traits@D@std@@V?$allocator@D@1@@std@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@0@$$QEAV10@0@Z) 中引用了该符号
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__CrtSetReportFile，函数 "public: int __cdecl testing::UnitTest::Run(void)" (?Run@UnitTest@testing@@QEAAHXZ) 中引用了该符号
2>gtestd.lib(gtest-all.obj) : error LNK2019: 无法解析的外部符号 __imp__CrtSetReportMode，函数 "public: int __cdecl testing::UnitTest::Run(void)" (?Run@UnitTest@testing@@QEAAHXZ) 中引用了该符号
2>D:\dev\cmake_examples\gtest_example2\build\vs2019-x64\Release\testbed.exe : fatal error LNK1120: 6 个无法解析的外部命令
2>已完成生成项目“testbed.vcxproj”的操作 - 失败。
========== 生成: 成功 1 个，失败 1 个，最新 0 个，跳过 0 个 ==========
```


解决办法：**gtest的debug和release版本的库，都需要编译安装**。


## 0x3 References
https://stackoverflow.com/questions/12540970