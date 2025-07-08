# Delete cache and reconfigure

## Problem description

You may define and change cache variables in CMakeLists.txt
```cmake
#set(OpenCV_DIR "/home/zz/OpenCV-4.10.0/install/lib/OpenCV" CACHE STRING "Directory that contains opencv-config.cmake") # previous
set(OpenCV_DIR "/home/zz/OpenCV-4.11.0/install/lib/OpenCV" CACHE STRING "Directory that contains opencv-config.cmake") # current
```

CMake options are also cmake cache variable, e.g. you change value of `ENABLE_LOGGING`:
```cmake
#set(ENABLE_LOGGING "enable logging?" OFF) # previous
set(ENABLE_LOGGING "enable logging?" ON) # current
```

## How to

In VSCode's command palette:

> CMake: Delete Cache and Reconfigure

If you are generating `.sln` and opened it in Visual Studio, choose `reload` in the pop-up window. This helps people from "close Visual Studio -> Delete build directory -> cmake generate from scratch".

