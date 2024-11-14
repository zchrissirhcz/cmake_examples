# Use Ninja generator in workspace

## Why

I use Visual Studio for most C/C++ projects, for historical reasons, and `CMake: Configure` will use Visual Studio generators by default.

And for some new created project, whose compilation is way too long, I use Ninja. **It takes only 10 seconds for that switch**, by specify Ninja as generator in current workspace's setting.

## How-to

In command palette, type:

```
>Preferences: Open Workspace Settings (JSON)
```

Then in the opened file, the `.vscode/settings.json`, write this:
```json
{
    "cmake.generator": "Ninja"
}
```

Then, build it like before:
```
>CMake: Configure
```
or:
```
>CMake: Delete Cache and Reconfigure
```