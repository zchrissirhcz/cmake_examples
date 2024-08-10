# Specify cache variables in CMakePresets.json

## Writing CMakePresets.json

We specify a cache variable `HELLO` within a map (dict):
```json
    "cacheVariables": {
        "HELLO": "world"
    }
```
You may also specify more cache variables.


The full content of `CMakePresets.json` is:
```json
{
    "version": 9,
    "configurePresets": [
        {
            "name": "default",
            "binaryDir": "${sourceDir}/build",
            "cacheVariables": {
                "HELLO": "world"
            }
        }
    ]
}
```

## Using CMakePresets.json

```bash
cmake --preset default
```

This helps us from typing a long command:
```bash
cmake -S . -B build -DHELLO=world
```

And we get expected output:
```bash
Preset CMake variables:

  HELLO="world"

-- The C compiler identification is AppleClang 15.0.0.15000309
-- The CXX compiler identification is AppleClang 15.0.0.15000309
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /Library/Developer/CommandLineTools/usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /Library/Developer/CommandLineTools/usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- HELLO: world
-- Configuring done (0.4s)
-- Generating done (0.0s)
-- Build files have been written to: /Users/zz/work/cmake_examples/6-cmake-presets/3-specify-cache-variables/build
```
