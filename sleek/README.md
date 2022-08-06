# Sleek: make cmake easier to use

Sleek, provided as [sleek.cmake](sleek.cmake), encapsulates several commandly-required-but-missing functionalities of CMake, either in function or in macros.

## Get
```
git clone https://github.com/zchrissirhcz/sleek
```

## Use
```cmake
include(sleek.cmake)
sleek_print_cxx_flags()
sleek_add_debug_symbol()
sleek_add_asan_flags()
sleek_print_target_properties(testbed)
...
```

## Doc
Generate API document:
```python
python gen_sleek_doc.py
```