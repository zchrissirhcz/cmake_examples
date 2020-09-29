# Effective Modern CMake

## Getting Started

For a brief user-level introduction to CMake, watch C++ Weekly, Episode 78, [Intro to CMake](https://www.youtube.com/watch?v=HPMvU64RUTY) by Jason Turner. LLVM’s [CMake Primer](https://llvm.org/docs/CMakePrimer.html) provides a good high-level introduction to the CMake syntax. Go read it now. 

After that, watch Mathieu Ropert’s CppCon 2017 talk [Using Modern CMake Patterns to Enforce a Good Modular Design](https://www.youtube.com/watch?v=eC9-iRN2b04) ([slides](https://github.com/CppCon/CppCon2017/blob/master/Tutorials/Using%20Modern%20CMake%20Patterns%20to%20Enforce%20a%20Good%20Modular%20Design/Using%20Modern%20CMake%20Patterns%20to%20Enforce%20a%20Good%20Modular%20Design%20-%20Mathieu%20Ropert%20-%20CppCon%202017.pdf)). It provides a thorough explanation of what modern CMake is and why it is so much better than “old school” CMake. The modular design ideas in this talk are based on the book [Large-Scale C++ Software Design](https://www.amazon.de/Large-Scale-Software-Addison-Wesley-Professional-Computing/dp/0201633620) by John Lakos. The next video that goes more into the details of modern CMake is Daniel Pfeifer’s C++Now 2017 talk [Effective CMake](https://www.youtube.com/watch?v=bsXLMQ6WgIk) ([slides](https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf)). 

This text is heavily influenced by Mathieu Ropert’s and Daniel Pfeifer’s talks.

If you are interested in the history and internal architecture of CMake, have a look at the article [CMake](http://www.aosabook.org/en/cmake.html) in the book [The Architecture of Open Source Applications](http://aosabook.org/en/index.html).

## General

### Use at least CMake version 3.0.0.

Modern CMake is only available starting with version 3.0.0.

### Treat CMake code like production code. 

CMake is code. Therefore, it should be clean. Use the same principles for `CMakeLists.txt` and modules as for the rest of the codebase.

### Define project properties globally.

For example, a project might use a common set of compiler warnings. Defining such properties globally in the top-level `CMakeLists.txt` file prevents scenarios where public headers of a dependent target causing a depending target not to compile because the depending target uses stricter compiler options. Defining such project properties globally makes it easier to manage the project with all its targets.

### Forget the commands `add_compile_options`, `include_directories`, `link_directories`, `link_libraries`.

Those commands operate on the directory level. All targets defined on that level inherit those properties. This increases the chance of hidden dependencies. Better operate on the targets directly.

### Get your hands off `CMAKE_CXX_FLAGS`.

Different compilers use different command-line parameter formats. Setting the C++ standard via `-std=c++14` in `CMAKE_CXX_FLAGS` will brake in the future, because those requirements are also fulfilled in other standards like C++17 and the compiler option is not the same on old compilers. So it’s much better to tell CMake the compile features so that it can figure out the appropriate compiler option to use.

### Don’t abuse usage requirements.

As an example, don’t add `-Wall` to the `PUBLIC` or `INTERFACE` section of `target_compile_options`, since it is not required to build depending targets.

## Modules

### Use modern find modules that declare exported targets.

Starting with CMake 3.4, more and more find modules export targets that can be used via `target_link_libraries`.

### Use exported targets of external packages.

Don’t fall back to the old CMake style of using variables defined by external packages. Use the exported targets via `target_link_libraries` instead.

### Use a find module for third-party libraries that do not support clients to use CMake.

CMake provides a collection of find modules for third-party libraries. For example, Boost doesn't support CMake. Instead, CMake provides a find module to use Boost in CMake.

### Report it as a bug to third-party library authors if a library does not support clients to use CMake. If the library is an open-source project, consider sending a patch.

CMake dominates the industry. It’s a problem if a library author does not support CMake.

### Write a find module for third-party libraries that do not support clients to use CMake.

It’s possible to retrofit a find module that properly exports targets to an external package that does not support CMake. 

### Export your library’s interface, if you are a library author.

See Daniel Pfeifer’s C++Now 2017 talk [Effective CMake](https://youtu.be/bsXLMQ6WgIk?t=37m15s) ([slide](https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf) 24ff.) on how to do this. Keep in mind to export the right information. Use `BUILD_INTERFACE` and `INSTALL_INTERFACE` generator expressions as filters.

## Projects 

### Avoid custom variables in the arguments of project commands.

Keep things simple. Don't introduce unnecessary custom variables. Instead of `add_library(a ${MY_HEADERS} ${MY_SOURCES})`, do `add_library(a b.h b.cpp)`.

### Don't use `file(GLOB)` in projects. 

CMake is a build system generator, not a build system. It evaluates the `GLOB` expression to a list of files when generating the build system. The build system then operates on this list of files. Therefore, the build system cannot detect that something changed in the file system.

CMake cannot just forward the `GLOB` expression to the build system, so that the expression is evaluated when building. CMake wants to be the common denominator of the supported build systems. Not all build systems support this, so CMake cannot support it neither. 

### Put CI-specific settings in CTest scripts, not in the project.

It just makes things simpler. See Dashboard Client via CTest Script for more information.

### Follow a naming convention for test names. 

This simplifies filtering by regex when running tests via CTest.

## Targets and Properties

### Think in terms of targets and properties.

By defining properties (i.e., compile definitions, compile options, compile features, include directories, and library dependencies) in terms of targets, it helps the developer to reason about the system at the target level. The developer does not need to understand the whole system in order to reason about a single target. The build system handles transitivity.

### Imagine targets as objects.

Calling the member functions modifies the member variables of the object.

Analogy to constructors:
* `add_executable`
* `add_library`

Analogy to member variables: 
* target properties (too many to list here)

Analogy to member functions:
* `target_compile_definitions`
* `target_compile_features`
* `target_compile_options`
* `target_include_directories`
* `target_link_libraries`
* `target_sources`
* `get_target_property`
* `set_target_property`

### Keep internal properties `PRIVATE`.

If a target needs properties internally (i.e., compile definitions, compile options, compile features, include directories, and library dependencies), add them to the `PRIVATE` section of the `target_*` commands.

### Declare compile definitions with `target_compile_definitions`.

This associates the compile definitions with their visibility (`PRIVATE`, `PUBLIC`, `INTERFACE`) to the target. This is better than using `add_compile_definitions`, which has no association with a target.

### Declare compile options with `target_compile_options`.

This associates the compile options with their visibility (`PRIVATE`, `PUBLIC`, `INTERFACE`) to the target. This is better than using `add_compile_options`, which has no association with a target. But be careful not to declare compile options that affect the ABI. Declare those options globally. See “Don’t use `target_compile_options` to set options that affect the ABI.”

### Declare compile features with `target_compile_features`.

t.b.d.

### Declare include directories with `target_include_directories`.

This associates the include directories with their visibility (`PRIVATE`, `PUBLIC`, `INTERFACE`) to the target. This is better than using `include_directories`, which has no association with a target.

### Declare direct dependencies with `target_link_libraries`.

This propagates usage requirements from the dependent target to the depending target. The command also resolves transitive dependencies.

### Don’t use `target_include_directories` with a path outside the component’s directory.

Using a path outside a component’s directory is a hidden dependency. Instead, use `target_include_directories` to propagate include directories as usage requirements to depending targets via `target_link_directories`. 

### Always explicitly declare properties `PUBLIC`, `PRIVATE`, or `INTERFACE` when using `target_*`.

Being explicit reduces the chance to unintendedly introduce hidden dependencies.

### Don’t use target_compile_options to set options that affect the ABI.

Using different compile options for multiple targets may affect ABI compatibility. The simplest solution to prevent such problems is to define compile options globally (also see “Define project properties globally.”). 

### Using a library defined in the same CMake tree should look the same as using an external library.

Packages defined in the same CMake tree are directly accessible. Make prebuilt libraries available via `CMAKE_PREFIX_PATH`. Finding a package with `find_package` should be a no-op if the package is defined in the same build tree. When you export target `Bar` into namespace `Foo`, also create an alias `Foo::Bar` via `add_library(Foo::Bar ALIAS Bar)`. Create a variable that lists all sub-projects. Define the macro `find_package` to wrap the original `find_package` command (now accessible via `_find_package`). The macro inhibits calls to `_find_package` if the variable contains the name of the package. See Daniel Pfeifer’s C++Now 2017 talk [Effective CMake](https://youtu.be/bsXLMQ6WgIk?t=50m30s) ([slide](https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf) 31ff.) for more information.

## Functions and Macros

### Prefer functions over macros whenever reasonable.

In addition to directory-based scope, CMake functions have their own scope. This means variables set inside functions are not visible in the parent scope. This is not true of macros.

### Use macros for defining very small bits of functionality only or to wrap commands that have output parameters. Otherwise create a function.

Functions have their own scope, macros don’t. This means variables set in macros will be visible in the calling scope.

Arguments to macros are not set as variables, instead dereferences to the parameters are resolved across the macro before executing it. This can result in unexpected behavior when using unreferenced variables. Generally speaking this issue is uncommon because it requires using non-dereferenced variables with names that overlap in the parent scope, but it is important to be aware of because it can lead to subtle bugs.

### Don’t use macros that affect all targets in a directory tree, like `include_directories`, `add_definitions`, or `link_libraries`. 

Those macros are evil. If used on the top level, all targets can use the properties defined by them. For example, all targets can use (i.e., `#include`) the headers defined by `include_directories`. If a target does not require linking (e.g., interface library, inline template), you won’t even get a compiler error in this case. It is easy to accidentally create hidden dependencies through other targets with those macros.

## Arguments

### Use `cmake_parse_arguments` as the recommended way to handle complex argument-based behaviors or optional arguments in any function.

Don’t reinvent the wheel.

## Loops

### Use modern foreach syntax.

* `foreach(var IN ITEMS foo bar baz) ...`
* `foreach(var IN LISTS my_list) ...`
* `foreach(var IN LISTS my_list ITEMS foo bar baz) ...`

## Packages

### Use CPack to create packages.

CPack is part of CMake and nicely integrates with it.

## Write a `CPackConfig.cmake` that includes the one generated by CMake.

This makes it possible to set additional variables that don’t need to appear in the project.

## Cross Compiling

### Use toolchain files for cross compiling.

Toolchain files encapsulate toolchains for cross compilation.

### Keep toolchain files simple.

It’s easier to understand and simpler to use. Don’t put logic in toolchain files. Create a single toolchain file per platform.

## Warnings and Errors

### Treat build errors correctly.

* Fix them.
* Reject pull requests.
* Hold off releases.

### Treat warnings as errors.

To treat warnings as errors, never pass `-Werror` to the compiler. If you do, the compiler treats warnings as errors. You can no longer treat warnings as errors, because you no longer get any warnings. All you get is errors.

* You cannot enable `-Werror` unless you already reached zero warnings.
* You cannot increase the warning level unless you already fixed all warnings introduced by that level.
* You cannot upgrade your compiler unless you already fixed all new warnings that the compiler reports at your warning level.
* You cannot update your dependencies unless you already ported your code away from any symbols that are now `[[deprecated]]`.
* You cannot `[[deprecated]]` your internal code as long as it is still used. But once it is no longer used, you can as well just remove it.

### Treat new warnings as errors.

1. At the beginning of a development cycle (e.g., sprint), allow new warnings to be introduced.
    * Increase warning level, enable new warnings explicitly.
    * Update the compiler.
    * Update dependencies.
    * Mark symbols as `[[deprecated]]`.
2. Burn down the number of warnings.
3. Repeat.

## Static Analysis

### Use more than one supported analyzer.

Using clang-tidy (`<lang>_CLANG_TIDY`), cpplint (`<lang>_CPPLINT`), include-what-you-use (`<lang>_INCLUDE_WHAT_YOU_USE`), and `LINK_WHAT_YOU_USE` help you find issues in the code. The diagnostics output of those tools will appear in the build output as well as in the IDE.

## For each header file, there must be an associated source file that `#include`s the header file at the top, even if that source file would otherwise be empty.

Most of the analysis tools report diagnostics for the current source file plus the associated header. Header files with no associated source file will not be analyzed. You may be able to set a custom header filter, but then the headers may be analyzed multiple times.

## Sources

* [Intro to CMake](https://www.youtube.com/watch?v=HPMvU64RUTY) by Jason Turner at C++ Weekly (Episode 78)
* LLVM [CMake Primer](https://llvm.org/docs/CMakePrimer.html)
* [Using Modern CMake Patterns to Enforce a Good Modular Design](https://www.youtube.com/watch?v=eC9-iRN2b04) ([slides](https://github.com/CppCon/CppCon2017/blob/master/Tutorials/Using%20Modern%20CMake%20Patterns%20to%20Enforce%20a%20Good%20Modular%20Design/Using%20Modern%20CMake%20Patterns%20to%20Enforce%20a%20Good%20Modular%20Design%20-%20Mathieu%20Ropert%20-%20CppCon%202017.pdf)) by Mathieu Ropert at CppCon 2017
* [Effective CMake](https://www.youtube.com/watch?v=bsXLMQ6WgIk) ([slides](https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf)) by Daniel Pfeifer at C++Now 2017
* The Architecture of Open Source Applications: [CMake](http://www.aosabook.org/en/cmake.html)