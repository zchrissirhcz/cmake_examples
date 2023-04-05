# find_opencl_with_icd_loader

ICD Loader 是 Khronos 官方提供的 opencl loader 库。 所谓 loader 库是说它是一个 “假的 opencl 库”， 链接了它之后， 它里面有和 OpenCL 真正的库同名的函数符号， 并且在运行时通过 dlopen 和 dlsym 函数来加载真正的 opencl 库当中的真正的函数， 并进行调用。

在 Linux 和 Android 平台， 可使用 ICD Loader。

在 MacOS 平台， 按官方说法， 通常不应当用 ICD Loader， 而应该用系统自带的。 在使用 [clvk](https://github.com/kpet/clvk) 和 [MoltenVK](https://github.com/KhronosGroup/MoltenVK) 时， 才需要用 ICD Loader:

https://github.com/KhronosGroup/OpenCL-ICD-Loader/issues/183