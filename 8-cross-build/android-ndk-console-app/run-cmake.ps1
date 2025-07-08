$NDK="C:/soft/android-ndk/r27c"
$BUILD_DIR = "build"

cmake `
    -S . `
    -B $BUILD_DIR `
    -G Ninja `
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" `
    -DANDROID_ABI=arm64-v8a `
    -DANDROID_PLATFORM=21

cmake --build $BUILD_DIR

adb push build/hello /data/local/tmp/hello
adb shell "cd /data/local/tmp; chmod +x ./hello; ./hello"