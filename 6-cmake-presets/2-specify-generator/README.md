# Specify generator in CMakePresets.json

## Writing CMakePresets.json

We specify generator with:
```json
    "generator": "Ninja"
```

The full content of `CMakePresets.json` is:
```json
{
    "version": 9,
    "configurePresets": [
        {
            "name": "default",
            "binaryDir": "${sourceDir}/build",
            "generator": "Ninja"
        }
    ]
}
```

## Using CMake Configure Presets

Simple run:
```bash
cmake --preset default
```

Which works the same as the classical long commane line:
```bash
cmake -S . -B build -G Ninja
```

