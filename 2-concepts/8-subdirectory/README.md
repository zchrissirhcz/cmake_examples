# subdirectory

## Physical subdirectory

`add_subdirectory()` can add a "subdirectory": it can be a physical subdirectory, which locates as subtree of current node in the filesystem-tree. 

And the subdirectory must contains a `CMakeLists.txt` file.

e.g.
```cmake
add_subdirectory(hello) # only specify subdir name

add_subdirectory(world world.out) # also specify output dir name, but its optional
```

## Logical subdirectory

`add_subdirectory()` can also add a subdirectory that is not child node of current node in the filesystem-tree. e.g.:

```bash
/home/zz/work/github/fmtlib # git clone of fmtlib
    | -- CMakeLists.txt
    | ...

/home/zz/work/test # my project root
    | -- CMakeLists.txt  # it writes: `add_subdirectory("/home/zz/work/github/fmtlib" fmt.out)`
    | ...
```

for this "logical subdirectory" case, the usage:
```cmake
add_subdirectory("/home/zz/work/github/fmtlib" fmt.out)
```
- the first parameter is an absolute path, which contains a CMakeLists.txt
- the second parameter is required, it is the build output directory