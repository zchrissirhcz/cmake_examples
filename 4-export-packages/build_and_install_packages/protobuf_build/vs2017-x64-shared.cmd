@echo off

set BUILD_DIR=vs2017-x64-shared
cmake ^
    -S .. ^
    -B %BUILD_DIR% ^
    -G "Visual Studio 15 2017 Win64" ^
    -Dprotobuf_BUILD_TESTS=OFF ^
    -DCMAKE_INSTALL_PREFIX=D:/artifacts/protobuf/v3.21.9/vs2017-x64-shared ^
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
    -DBUILD_SHARED_LIBS=ON

cmake --build %BUILD_DIR% --config Debug && cmake --build %BUILD_DIR% --config Debug --target INSTALL

cmake --build %BUILD_DIR% --config Release && cmake --build %BUILD_DIR% --config Release --target INSTALL


pause