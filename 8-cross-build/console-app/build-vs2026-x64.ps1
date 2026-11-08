. "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools" -SkipAutomaticLocation -Arch amd64 -HostArch amd64
cmake -S . -B build -G "Visual Studio 18 2026" -A x64
cmake --build build

