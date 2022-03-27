# glm_example

glm is a header-only library, when intergrate glm in CMake, it js just like Eigen.

Download glm:
```bash
cd ~/artifacts
git clone https://github.com/g-truc/glm
```

Find and link it in CMake:
```cmake
set(glm_DIR "/home/zz/artifacts/glm")
find_package(glm REQUIRED)

add_executable(testbed main.cpp)
target_link_libraries(testbed glm::glm)
```

