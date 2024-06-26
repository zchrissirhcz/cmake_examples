- `<>` means required
- `[]` means optional

For example:
```cmake
write_basic_package_version_file(<filename>
  [VERSION <major.minor.patch>]
  COMPATIBILITY <AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion>
  [ARCH_INDEPENDENT] )
```

- `<filename>` is required
- `VERSION` is optional, but once given, the concreate version `major.minor.patch` is required
