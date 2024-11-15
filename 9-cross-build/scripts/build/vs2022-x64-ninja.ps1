. "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1" -SkipAutomaticLocation -Arch amd64 -HostArch amd64
cmake -S . -B build -G Ninja -D CMAKE_BUILD_TYPE=Release
cmake --build build