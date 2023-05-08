# CMake Examples

<img alt="GitHub" src="https://img.shields.io/github/license/zchrissirhcz/cmake_examples"> ![Ubuntu](https://img.shields.io/badge/Ubuntu-333333?style=flat&logo=ubuntu) ![Windows](https://img.shields.io/badge/Windows-333333?style=flat&logo=windows&logoColor=blue) ![macOS](https://img.shields.io/badge/-macOS-333333?style=flat&logo=apple) ![android](https://img.shields.io/badge/-Android-333333?style=flat&logo=Android)

Zhuo's CMake based C/C++ project templates.

*Currently in a refactor progress.*

## Features
- Modern:    Use latest cmake, write target-oriented configurations.
- Modular:   Formed into > 10 groups of examples, each group consists of strong related examples.
- Versatile: Extracted from practical, not restricted to simple tutorials.

## Contents
There are above 100 examples now. Some of them are written in English, some in Chinese, but anyway, each of them are simple enough, just find your interested one, and run it!

You may search them in this page, you may search each of them in the following table:

### 0_helloworld
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | executable_example | [0_helloworld/executable_example](0_helloworld/executable_example) |
| 1 | find_package_example | [0_helloworld/find_package_example](0_helloworld/find_package_example) |
| 2 | static_library_example | [0_helloworld/static_library_example](0_helloworld/static_library_example) |

### 1_package_management
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | auto_download_packages | [1_package_management/auto_download_packages](1_package_management/auto_download_packages) |
| 1 | build_and_install_packages | [1_package_management/build_and_install_packages](1_package_management/build_and_install_packages) |
| 2 | files_and_directories | [1_package_management/files_and_directories](1_package_management/files_and_directories) |
| 3 | manually_create_packages | [1_package_management/manually_create_packages](1_package_management/manually_create_packages) |
| 4 | pack_and_install_packages | [1_package_management/pack_and_install_packages](1_package_management/pack_and_install_packages) |
| 5 | use_installed_packages | [1_package_management/use_installed_packages](1_package_management/use_installed_packages) |

### 2_global_and_target_settings
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | build_type | [2_global_and_target_settings/build_type](2_global_and_target_settings/build_type) |
| 1 | c++_standard | [2_global_and_target_settings/c++_standard](2_global_and_target_settings/c++_standard) |
| 2 | cmake_options | [2_global_and_target_settings/cmake_options](2_global_and_target_settings/cmake_options) |
| 3 | compilation_database | [2_global_and_target_settings/compilation_database](2_global_and_target_settings/compilation_database) |
| 4 | configure_file | [2_global_and_target_settings/configure_file](2_global_and_target_settings/configure_file) |
| 5 | debug_symbol_example | [2_global_and_target_settings/debug_symbol_example](2_global_and_target_settings/debug_symbol_example) |
| 6 | define_c_c++_macros | [2_global_and_target_settings/define_c_c++_macros](2_global_and_target_settings/define_c_c++_macros) |
| 7 | flags_and_properties | [2_global_and_target_settings/flags_and_properties](2_global_and_target_settings/flags_and_properties) |
| 8 | fPIC | [2_global_and_target_settings/fPIC](2_global_and_target_settings/fPIC) |
| 9 | include_directories | [2_global_and_target_settings/include_directories](2_global_and_target_settings/include_directories) |
| 10 | link_libraries | [2_global_and_target_settings/link_libraries](2_global_and_target_settings/link_libraries) |
| 11 | postfix | [2_global_and_target_settings/postfix](2_global_and_target_settings/postfix) |
| 12 | sanitizers | [2_global_and_target_settings/sanitizers](2_global_and_target_settings/sanitizers) |
| 13 | specify_output_name | [2_global_and_target_settings/specify_output_name](2_global_and_target_settings/specify_output_name) |

### 3_cross_compilation
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | arm-linux-gnueabihf_example | [3_cross_compilation/arm-linux-gnueabihf_example](3_cross_compilation/arm-linux-gnueabihf_example) |
| 1 | arm-none-eabi_example | [3_cross_compilation/arm-none-eabi_example](3_cross_compilation/arm-none-eabi_example) |
| 2 | arm_neon_example | [3_cross_compilation/arm_neon_example](3_cross_compilation/arm_neon_example) |
| 3 | arm_neon_example2 | [3_cross_compilation/arm_neon_example2](3_cross_compilation/arm_neon_example2) |
| 4 | generator_example | [3_cross_compilation/generator_example](3_cross_compilation/generator_example) |
| 5 | linux-32bit_example | [3_cross_compilation/linux-32bit_example](3_cross_compilation/linux-32bit_example) |
| 6 | neon_intrinsics_example | [3_cross_compilation/neon_intrinsics_example](3_cross_compilation/neon_intrinsics_example) |
| 7 | ohos_ndk_example | [3_cross_compilation/ohos_ndk_example](3_cross_compilation/ohos_ndk_example) |
| 8 | presets-example | [3_cross_compilation/presets-example](3_cross_compilation/presets-example) |
| 9 | rtos-test | [3_cross_compilation/rtos-test](3_cross_compilation/rtos-test) |

### 4_testing_and_coverage
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | clang_coverage_example | [4_testing_and_coverage/clang_coverage_example](4_testing_and_coverage/clang_coverage_example) |
| 1 | ctest_example | [4_testing_and_coverage/ctest_example](4_testing_and_coverage/ctest_example) |
| 2 | ctest_example2 | [4_testing_and_coverage/ctest_example2](4_testing_and_coverage/ctest_example2) |
| 3 | doctest_example | [4_testing_and_coverage/doctest_example](4_testing_and_coverage/doctest_example) |
| 4 | gcc_coverage_example | [4_testing_and_coverage/gcc_coverage_example](4_testing_and_coverage/gcc_coverage_example) |
| 5 | gtest_ctest_example | [4_testing_and_coverage/gtest_ctest_example](4_testing_and_coverage/gtest_ctest_example) |
| 6 | gtest_ctest_example2 | [4_testing_and_coverage/gtest_ctest_example2](4_testing_and_coverage/gtest_ctest_example2) |
| 7 | gtest_example | [4_testing_and_coverage/gtest_example](4_testing_and_coverage/gtest_example) |
| 8 | gtest_example2 | [4_testing_and_coverage/gtest_example2](4_testing_and_coverage/gtest_example2) |
| 9 | gtest_example3 | [4_testing_and_coverage/gtest_example3](4_testing_and_coverage/gtest_example3) |
| 10 | gtest_filter | [4_testing_and_coverage/gtest_filter](4_testing_and_coverage/gtest_filter) |
| 11 | test_coverage_example | [4_testing_and_coverage/test_coverage_example](4_testing_and_coverage/test_coverage_example) |
| 12 | test_coverage_example2 | [4_testing_and_coverage/test_coverage_example2](4_testing_and_coverage/test_coverage_example2) |

### 5_documentation
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | doxygen_coverage_example | [5_documentation/doxygen_coverage_example](5_documentation/doxygen_coverage_example) |
| 1 | doxygen_coverage_example2 | [5_documentation/doxygen_coverage_example2](5_documentation/doxygen_coverage_example2) |
| 2 | doxygen_coverage_example3 | [5_documentation/doxygen_coverage_example3](5_documentation/doxygen_coverage_example3) |
| 3 | doxygen_example | [5_documentation/doxygen_example](5_documentation/doxygen_example) |
| 4 | doxygen_example2 | [5_documentation/doxygen_example2](5_documentation/doxygen_example2) |

### 6_bindings
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | csharp_winform_example | [6_bindings/csharp_winform_example](6_bindings/csharp_winform_example) |
| 1 | csharp_wpf_example | [6_bindings/csharp_wpf_example](6_bindings/csharp_wpf_example) |
| 2 | c_call_python_example | [6_bindings/c_call_python_example](6_bindings/c_call_python_example) |
| 3 | jni_example | [6_bindings/jni_example](6_bindings/jni_example) |
| 4 | jni_example2 | [6_bindings/jni_example2](6_bindings/jni_example2) |
| 5 | mex_example | [6_bindings/mex_example](6_bindings/mex_example) |
| 6 | pybind11_example1 | [6_bindings/pybind11_example1](6_bindings/pybind11_example1) |
| 7 | pybind11_example2 | [6_bindings/pybind11_example2](6_bindings/pybind11_example2) |
| 8 | swift_example | [6_bindings/swift_example](6_bindings/swift_example) |
| 9 | windows_masm_example | [6_bindings/windows_masm_example](6_bindings/windows_masm_example) |

### 7_debugging
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | debug_dependencies | [7_debugging/debug_dependencies](7_debugging/debug_dependencies) |
| 1 | sleek | [7_debugging/sleek](7_debugging/sleek) |
| 2 | vscode_debug_C++ | [7_debugging/vscode_debug_C++](7_debugging/vscode_debug_C++) |

### 8_cmake_language
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | copy_dll_as_function | [8_cmake_language/copy_dll_as_function](8_cmake_language/copy_dll_as_function) |
| 1 | function_example1 | [8_cmake_language/function_example1](8_cmake_language/function_example1) |
| 2 | list_remove_example | [8_cmake_language/list_remove_example](8_cmake_language/list_remove_example) |
| 3 | regex_replace_example | [8_cmake_language/regex_replace_example](8_cmake_language/regex_replace_example) |

### 9_misc
| number | examples | directory |
| ------ | -------- | --------- |
| 0 | cmake_format_usage | [9_misc/cmake_format_usage](9_misc/cmake_format_usage) |
| 1 | find_package_examples | [9_misc/find_package_examples](9_misc/find_package_examples) |
| 2 | generate_assemble_example | [9_misc/generate_assemble_example](9_misc/generate_assemble_example) |
| 3 | masm_example | [9_misc/masm_example](9_misc/masm_example) |
| 4 | modules | [9_misc/modules](9_misc/modules) |
| 5 | ninja_colorful_output_example | [9_misc/ninja_colorful_output_example](9_misc/ninja_colorful_output_example) |
| 6 | umake | [9_misc/umake](9_misc/umake) |

### Search
You may also use `./search.sh` for specific search, e.g. search `target` as keyword:
```bash
bash ./search.sh target
```
And get result:
```
./2_global_and_target_settings/compilation_database
./2_global_and_target_settings/postfix
./2_global_and_target_settings/flags_and_properties
./2_global_and_target_settings/flags_and_properties/msvc_runtime_mt_md_example
./2_global_and_target_settings/flags_and_properties/hpc_compute
./2_global_and_target_settings/flags_and_properties/compile_flag_example1
./2_global_and_target_settings/link_libraries
./2_global_and_target_settings/c++_standard
./2_global_and_target_settings/fPIC
./2_global_and_target_settings/configure_file
./2_global_and_target_settings/include_directories
./2_global_and_target_settings/sanitizers
./2_global_and_target_settings/sanitizers/thread_sanitizer_example
./2_global_and_target_settings/sanitizers/address_sanitizer_example
./2_global_and_target_settings/specify_output_name
./2_global_and_target_settings/cmake_options
./2_global_and_target_settings/cmake_options/option_example2
./2_global_and_target_settings/cmake_options/cmake_dependent_option
./2_global_and_target_settings/cmake_options/options_via_txt_example
./2_global_and_target_settings/cmake_options/option_example
./2_global_and_target_settings/build_type
./2_global_and_target_settings/debug_symbol_example
./2_global_and_target_settings/define_c_c++_macros
```

## ♥️ Thanks

If you like this project, welcome <a class="github-button" href="https://github.com/zchrissirhcz/cmake_examples" data-icon="octicon-star" data-show-count="true" aria-label="Star zchrissirhcz/cmake_examples on GitHub">Star</a>.
You may also <a class="github-button" href="https://github.com/zchrissirhcz/cmake_examples/subscription" data-icon="octicon-eye" data-show-count="true" aria-label="Watch zchrissirhcz/cmake_examples on GitHub">watch</a> this project for updated notifications in the first time!

[![Star History Chart](https://api.star-history.com/svg?repos=zchrissirhcz/cmake_examples&type=Date)](https://star-history.com/#zchrissirhcz/cmake_examples&Date)


## References
- [More Modern CMake](https://hsf-training.github.io/hsf-training-cmake-webpage/)
- [Modern CMake](https://cliutils.gitlab.io/modern-cmake)
- [CMake Cookbook](https://github.com/dev-cafe/cmake-cookbook), [中文翻译](https://github.com/xiaoweiChen/CMake-Cookbook)
- [Effective Modern CMake](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1)
- [13 valuable things I learned using CMake](https://gist.github.com/GuillaumeDua/a2e9cdeaf1a26906e2a92ad07137366f)
- [CMake Workshop](https://coderefinery.github.io/cmake-workshop/)

## LICENSE

[MIT](./LICENSE)

## Acknowledgement
Proudly to gain one year license for all products from [JetBrains](https://www.jetbrains.com).