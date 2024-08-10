# Specify toolchain file in CMakePresets.json

In this example we do cross-build with android ndk, targeting arm64-v8a.

We specify toolchain file, together with some cache variables, and generator.

## Writing CMakePresets.json

We specify toolchain file with:
```json
    "toolchainFile": "/Users/zz/soft/android-ndk-r23b/build/cmake/android.toolchain.cmake",
```

We also specify generator:
```json
    "generator": "Ninja",
```

We also specify cache variables:
```json
    "cacheVariables": {
        "ANDROID_ABI": "arm64-v8a",
        "ANDROID_PLATFORM": "android-24",
        "CMAKE_BUILD_TYPE": "Release"
    }
```

The full content of `CMakePresets.json` is:
```json
{
    "version": 9,
    "configurePresets": [
        {
            "name": "default",
            "binaryDir": "${sourceDir}/build",
            "generator": "Ninja",
            "toolchainFile": "/Users/zz/soft/android-ndk-r23b/build/cmake/android.toolchain.cmake",
            "cacheVariables": {
                "ANDROID_ABI": "arm64-v8a",
                "ANDROID_PLATFORM": "android-24",
                "CMAKE_BUILD_TYPE": "Release"
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
cmake \
    -S . \
    -B build \
    -DCMAKE_TOOLCHAIN_FILE="/Users/zz/soft/android-ndk-r23b/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM="android-24" \
    -DCMAKE_BUILD_TYPE=Release
```

And we get expected output:
```bash
Preset CMake variables:

  ANDROID_ABI="arm64-v8a"
  ANDROID_PLATFORM="android-24"
  CMAKE_BUILD_TYPE="Release"
  CMAKE_TOOLCHAIN_FILE:FILEPATH="/Users/zz/soft/android-ndk-r23b/build/cmake/android.toolchain.cmake"

-- Android: Targeting API '24' with architecture 'arm64', ABI 'arm64-v8a', and processor 'aarch64'
-- Android: Selected unified Clang toolchain
-- The C compiler identification is Clang 12.0.8
-- The CXX compiler identification is Clang 12.0.8
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /Users/zz/soft/android-ndk-r23b/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /Users/zz/soft/android-ndk-r23b/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- HELLO: hello
-- Configuring done (0.6s)
-- Generating done (0.0s)
-- Build files have been written to: /Users/zz/work/cmake_examples/6-cmake-presets/4-specify-toolchain-file/build
```

Then build it as usual:
```bash
cmake --build build
```
