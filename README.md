# CMake Examples

<img alt="GitHub" src="https://img.shields.io/github/license/zchrissirhcz/cmake_examples"> ![Ubuntu](https://img.shields.io/badge/Ubuntu-333333?style=flat&logo=ubuntu) ![Windows](https://img.shields.io/badge/Windows-333333?style=flat&logo=windows&logoColor=blue) ![macOS](https://img.shields.io/badge/-macOS-333333?style=flat&logo=apple) ![android](https://img.shields.io/badge/-Android-333333?style=flat&logo=Android)

Zhuo's CMake based C/C++ project templates.

## Features
- Modern:    Use latest cmake, write target-oriented configurations.
- Modular:   Formed into > 10 groups of examples, each group consists of strong related examples.
- Versatile: Extracted from practical, not restricted to simple tutorials.

## Contents
There are nearly 100 examples now. You may search them in this page, or use `./search.sh` for specific search, e.g. search `dll` as keyword:
```bash
bash ./search.sh dll
```
And get result:
```
./01_creating_targets/create_dll_example2
./01_creating_targets/create_dll_example1
./06_files_and_io/copy_dll_example
./06_files_and_io/dll_path_example
```

 | example name        | corresponding directory |
 | ------------------- | ----------------------- |
 | create_dll_example2 | [01_creating_targets/create_dll_example2](01_creating_targets) |
 | create_dll_example1 | [01_creating_targets/create_dll_example1](01_creating_targets) |
 | create_shared_lib_example | [01_creating_targets/create_shared_lib_example](01_creating_targets) |
 | header_only_library_example | [01_creating_targets/header_only_library_example](01_creating_targets) |
 | compile_database_example | [03_project_custom_configurations/compile_database_example](03_project_custom_configurations) |
 | option_example2 | [03_project_custom_configurations/option_example2](03_project_custom_configurations) |
 | cmake_build_type_example | [03_project_custom_configurations/cmake_build_type_example](03_project_custom_configurations) |
 | configure_file_example | [03_project_custom_configurations/configure_file_example](03_project_custom_configurations) |
 | options_via_txt_example | [03_project_custom_configurations/options_via_txt_example](03_project_custom_configurations) |
 | option_example | [03_project_custom_configurations/option_example](03_project_custom_configurations) |
 | regex_replace_example | [07_list_and_string/regex_replace_example](07_list_and_string) |
 | list_remove_example | [07_list_and_string/list_remove_example](07_list_and_string) |
 | opencl_example | [10_hpc_compute/opencl_example](10_hpc_compute) |
 | sse_example | [10_hpc_compute/sse_example](10_hpc_compute) |
 | opengl_example | [10_hpc_compute/opengl_example](10_hpc_compute) |
 | cuda_example | [10_hpc_compute/cuda_example](10_hpc_compute) |
 | simd_multiversion_example | [10_hpc_compute/simd_multiversion_example](10_hpc_compute) |
 | rtos-test | [04_cross_compilation/rtos-test](04_cross_compilation) |
 | arm-linux-gnueabihf_example | [04_cross_compilation/arm-linux-gnueabihf_example](04_cross_compilation) |
 | ohos_ndk_example | [04_cross_compilation/ohos_ndk_example](04_cross_compilation) |
 | arm_neon_example | [04_cross_compilation/arm_neon_example](04_cross_compilation) |
 | linux-32bit_example | [04_cross_compilation/linux-32bit_example](04_cross_compilation) |
 | arm_neon_example2 | [04_cross_compilation/arm_neon_example2](04_cross_compilation) |
 | generator_example | [04_cross_compilation/generator_example](04_cross_compilation) |
 | arm-none-eabi_example | [04_cross_compilation/arm-none-eabi_example](04_cross_compilation) |
 | c_call_python_example | [12_language_bindings/c_call_python_example](12_language_bindings) |
 | csharp_wpf_example | [12_language_bindings/csharp_wpf_example](12_language_bindings) |
 | csharp_winform_example | [12_language_bindings/csharp_winform_example](12_language_bindings) |
 | jni_example2 | [12_language_bindings/jni_example2](12_language_bindings) |
 | jni_example | [12_language_bindings/jni_example](12_language_bindings) |
 | fetchcontent_example | [15_external_dependency/fetchcontent_example](15_external_dependency) |
 | fetchcontent_example2 | [15_external_dependency/fetchcontent_example2](15_external_dependency) |
 | external_add_example | [15_external_dependency/external_add_example](15_external_dependency) |
 | cpm_example2 | [15_external_dependency/cpm_example2](15_external_dependency) |
 | fetchcontent_example3 | [15_external_dependency/fetchcontent_example3](15_external_dependency) |
 | onetbb_fetchcontent_example | [15_external_dependency/onetbb_fetchcontent_example](15_external_dependency) |
 | cpm_example | [15_external_dependency/cpm_example](15_external_dependency) |
 | cpack_example | [08_installing_and_packaging/cpack_example](08_installing_and_packaging) |
 | install_example | [08_installing_and_packaging/install_example](08_installing_and_packaging) |
 | install_find_package_example | [08_installing_and_packaging/install_find_package_example](08_installing_and_packaging) |
 | install_example2 | [08_installing_and_packaging/install_example2](08_installing_and_packaging) |
 | install_example3 | [08_installing_and_packaging/install_example3](08_installing_and_packaging) |
 | vulkan_example | [02_find_and_use_packages/vulkan_example](02_find_and_use_packages) |
 | eigen_example | [02_find_and_use_packages/eigen_example](02_find_and_use_packages) |
 | find_package_examples | [02_find_and_use_packages/find_package_examples](02_find_and_use_packages) |
 | include-what-you-use_example | [02_find_and_use_packages/include-what-you-use_example](02_find_and_use_packages) |
 | libclang_example | [02_find_and_use_packages/libclang_example](02_find_and_use_packages) |
 | crc32c_example | [02_find_and_use_packages/crc32c_example](02_find_and_use_packages) |
 | openssl_example | [02_find_and_use_packages/openssl_example](02_find_and_use_packages) |
 | windows_pkgconfig_zlib_example | [02_find_and_use_packages/windows_pkgconfig_zlib_example](02_find_and_use_packages) |
 | ncnn_example | [02_find_and_use_packages/ncnn_example](02_find_and_use_packages) |
 | rapidcheck_example2 | [02_find_and_use_packages/rapidcheck_example2](02_find_and_use_packages) |
 | benchmark_example | [02_find_and_use_packages/benchmark_example](02_find_and_use_packages) |
 | mex_example | [02_find_and_use_packages/mex_example](02_find_and_use_packages) |
 | pkgconfig_lmdb_example | [02_find_and_use_packages/pkgconfig_lmdb_example](02_find_and_use_packages) |
 | rapidcheck_example1 | [02_find_and_use_packages/rapidcheck_example1](02_find_and_use_packages) |
 | pybind11_example2 | [02_find_and_use_packages/pybind11_example2](02_find_and_use_packages) |
 | proto_to_cpp_example | [02_find_and_use_packages/proto_to_cpp_example](02_find_and_use_packages) |
 | opencv_example | [02_find_and_use_packages/opencv_example](02_find_and_use_packages) |
 | qt_example | [02_find_and_use_packages/qt_example](02_find_and_use_packages) |
 | zlib_example | [02_find_and_use_packages/zlib_example](02_find_and_use_packages) |
 | pybind11_example1 | [02_find_and_use_packages/pybind11_example1](02_find_and_use_packages) |
 | build | [11_vscode_debug_C++/build](11_vscode_debug_C++) |
 | src | [11_vscode_debug_C++/src](11_vscode_debug_C++) |
 | function_example1 | [14_functions_and_macros/function_example1](14_functions_and_macros) |
 | glob_example | [06_files_and_io/glob_example](06_files_and_io) |
 | copy_dll_example | [06_files_and_io/copy_dll_example](06_files_and_io) |
 | dll_path_example | [06_files_and_io/dll_path_example](06_files_and_io) |
 | download_example | [06_files_and_io/download_example](06_files_and_io) |
 | copy_files_example | [06_files_and_io/copy_files_example](06_files_and_io) |
 | openmp_example2 | [05_set_C_C++_flags/openmp_example2](05_set_C_C++_flags) |
 | openmp_example3 | [05_set_C_C++_flags/openmp_example3](05_set_C_C++_flags) |
 | thread_sanitizer_example | [05_set_C_C++_flags/thread_sanitizer_example](05_set_C_C++_flags) |
 | address_sanitizer_example | [05_set_C_C++_flags/address_sanitizer_example](05_set_C_C++_flags) |
 | openmp_example | [05_set_C_C++_flags/openmp_example](05_set_C_C++_flags) |
 | compile_flag_example1 | [05_set_C_C++_flags/compile_flag_example1](05_set_C_C++_flags) |
 | doctest_example | [09_testing_docs_and_coverage/doctest_example](09_testing_docs_and_coverage) |
 | doxygen_coverage_example3 | [09_testing_docs_and_coverage/doxygen_coverage_example3](09_testing_docs_and_coverage) |
 | gtest_example3 | [09_testing_docs_and_coverage/gtest_example3](09_testing_docs_and_coverage) |
 | doxygen_example | [09_testing_docs_and_coverage/doxygen_example](09_testing_docs_and_coverage) |
 | gtest_example2 | [09_testing_docs_and_coverage/gtest_example2](09_testing_docs_and_coverage) |
 | doxygen_coverage_example | [09_testing_docs_and_coverage/doxygen_coverage_example](09_testing_docs_and_coverage) |
 | doxygen_example2 | [09_testing_docs_and_coverage/doxygen_example2](09_testing_docs_and_coverage) |
 | gtest_example | [09_testing_docs_and_coverage/gtest_example](09_testing_docs_and_coverage) |
 | gcc_coverage_example | [09_testing_docs_and_coverage/gcc_coverage_example](09_testing_docs_and_coverage) |
 | clang_coverage_example | [09_testing_docs_and_coverage/clang_coverage_example](09_testing_docs_and_coverage) |
 | ctest_example | [09_testing_docs_and_coverage/ctest_example](09_testing_docs_and_coverage) |
 | gtest_ctest_example | [09_testing_docs_and_coverage/gtest_ctest_example](09_testing_docs_and_coverage) |
 | ctest_example2 | [09_testing_docs_and_coverage/ctest_example2](09_testing_docs_and_coverage) |
 | test_coverage_example | [09_testing_docs_and_coverage/test_coverage_example](09_testing_docs_and_coverage) |
 | gtest_ctest_example2 | [09_testing_docs_and_coverage/gtest_ctest_example2](09_testing_docs_and_coverage) |
 | doxygen_coverage_example2 | [09_testing_docs_and_coverage/doxygen_coverage_example2](09_testing_docs_and_coverage) |
 | test_coverage_example2 | [09_testing_docs_and_coverage/test_coverage_example2](09_testing_docs_and_coverage) |
 | generate_assemble_example | [13_misc/generate_assemble_example](13_misc) |
 | masm_example | [13_misc/masm_example](13_misc) |
 | umake | [13_misc/umake](13_misc) |
 | modules | [13_misc/modules](13_misc) |
 | ninja_colorful_output_example | [13_misc/ninja_colorful_output_example](13_misc) |


## ♥️ Thanks

If you like this project, welcome <a class="github-button" href="https://github.com/zchrissirhcz/cmake_examples" data-icon="octicon-star" data-show-count="true" aria-label="Star zchrissirhcz/cmake_examples on GitHub">Star</a>.
You may also <a class="github-button" href="https://github.com/zchrissirhcz/cmake_examples/subscription" data-icon="octicon-eye" data-show-count="true" aria-label="Watch zchrissirhcz/cmake_examples on GitHub">watch</a> this project for updated notifications in the first time!

[![Stargazers over time](https://starchart.cc/zchrissirhcz/cmake_examples.svg)](https://starchart.cc/zchrissirhcz/cmake_examples)


## References
- [More Modern CMake](https://hsf-training.github.io/hsf-training-cmake-webpage/)
- [Modern CMake](https://cliutils.gitlab.io/modern-cmake)
- [CMake Cookbook](https://github.com/dev-cafe/cmake-cookbook), [中文翻译](https://github.com/xiaoweiChen/CMake-Cookbook)
- [Effective Modern CMake](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1)
- [13 valuable things I learned using CMake](https://gist.github.com/GuillaumeDua/a2e9cdeaf1a26906e2a92ad07137366f)

Note: Official cmake bundled FindXXX.cmake failed to find packages sometimes, you may be interested in my another project [cmake_modules](https://github.com/zchrissirhcz/cmake_modules)

## LICENSE

[MIT](./LICENSE)

## Acknowledgement

Thanks [JetBrains](https://www.jetbrains.com) company for providing 1 year license for all products to support this open source project.
