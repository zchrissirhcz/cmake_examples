# add_subdirectory_example

`add_subdirectory()` means using another directory as part of current build. The added subdirectory can be out of current project.

One of the most often use case is, use an 3rd-party project's source, instead of compile-install-import it.

```cmake
set(fmt_src_dir "/home/zz/work/github/fmt")
add_subdirectory(${fmt_src_dir} fmt.out)
```
This will use `/home/zz/work/github/fmt` directory (which contains CMakeLists.txt), and build output is placed in `fmt.out` directory.

Then just use the created target `fmt::fmt` (which is created by `${fmt_src_dir}`'s CMakeLists.txt) as usual:
```cmake
add_executable(testbed main.cpp)
target_link_libraries(testbed PUBLIC fmt::fmt)
```