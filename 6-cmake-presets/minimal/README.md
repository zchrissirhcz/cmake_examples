# Minimal CMakePreset.json usage example

## Writing CMakePresets.json

`version` is required. We pick the latest one, `9`, which is introduced in CMake 3.30. See other versions from its document: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html#format

`configurePreset` is optional, but frequently used so we pick it, w.r.t its document: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html#configure-preset

`${sourceDir}` is a macro, which will be evaluated in the context of the preset being used (https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html#macro-expansion), expanded to "Path to the project source dir", i.e. the same as `CMAKE_SOURCE_DIR`.

`${binaryDir}` is an optional string, representing the path to the output binary directory. We specify it as `build` directory under `${sourceDir}`.

We come up with the minimal `CMakePresets.json`:
```json
{
    "version": 9,
    "configurePresets": [
        {
            "name": "default",
            "binaryDir": "${sourceDir}/build"
        }
    ]
}
```

## Using CMake Configure Presets

Get available configure presets:
```bash
cmake --list-presets # get configure presets
# or, explicitly specify type:
cmake --list-presets=configure
```

And get:
>Available configure presets:
>
>  "default"

CMake configure with preset `default`:
```bash
cmake --preset <preset-name>
# e.g.
cmake --preset default
```

This helps us from typing a long command:
```bash
cmake -S . -B build
# or
cmake -B build # this assumes cwd as source-dir
```

## Conclusion

With a minimal cmake-preset (only contains cmake configure preset), the cmake configure step can be simplied from
```bash
cmake -S . -B build
```
to
```bash
cmake --preset default
```


