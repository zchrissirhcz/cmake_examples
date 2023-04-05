## download
https://github.com/glennrp/libpng

## Linux-x64
正常编译

## Android NDK
修改1： arm/filter_neon.S , 删掉 `__clang__` 相关的三行:
```
(base) zz@home% git diff
diff --git a/arm/filter_neon.S b/arm/filter_neon.S
index e7f3e291d..2308aad13 100644
--- a/arm/filter_neon.S
+++ b/arm/filter_neon.S
@@ -20,10 +20,6 @@
 .section .note.GNU-stack,"",%progbits /* mark stack as non-executable */
 #endif

-#ifdef __clang__
-.section __LLVM,__asm
-#endif
-
 #ifdef PNG_READ_SUPPORTED

 /* Assembler NEON support - only works for 32-bit ARM (i.e. it does not work for
```

修改2：cmake 时指定
```
-DHAVE_LD_VERSION_SCRIPT=OFF
```

https://github.com/glennrp/libpng/issues/240
