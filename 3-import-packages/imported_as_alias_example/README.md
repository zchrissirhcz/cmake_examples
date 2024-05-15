# Imported-As-Alias-Example

## alias library: the proxy layer
In this example, we have prebuilt library `libhello.a` from other people.

We manually put it in `hello` directory, write `CMakeLists.txt`, then use it in root `CMakeLists.txt`.

We would like to use `deps::hello` as the target name, which serves as an proxy layer for dependencies. With this design, we can have different `hello` targets. e.g.:
- Only library, the `libhello.lib`
- Our fake implementation, the `fake_hello.lib`

## alias library with global scope
The being aliased library should be with `GLOBAL` property.