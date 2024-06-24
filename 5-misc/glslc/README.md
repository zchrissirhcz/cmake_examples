# glslc example

## 介绍
在一些 c++ 工程中提供了 glsl 文件 （名如`shader.frag` 和 `shader.vert`），而如果是用 Vulkan 替代 OpenGL, 则需要将这些 glsl 文件转为 `.spv` 文件。即“编译 glsl 为 SPIR-V" 的过程：

```bash
glslc xxx.vert -o xxx.spv
```

在 CMake 中可通过 `add_custom_command()` 将上述编译命令进行集成：

```cmake
add_custom_command(TARGET VulkanTest
    POST_BUILD

    COMMAND glslc ${CMAKE_BINARY_DIR}/shaders/shader.frag -o ${CMAKE_BINARY_DIR}/shaders/frag.spv
    COMMAND glslc ${CMAKE_BINARY_DIR}/shaders/shader.vert -o ${CMAKE_BINARY_DIR}/shaders/vert.spv
)
```

## 实操
除 README.md 外的文件， 是从 https://github.com/Earsuit/Vulkan_Imgui 稍作修改的到， 展示了一个实际的“在cmake中调用glslc编译glsl为spv”的例子。

要跑通，还需要在 cmake/deps.cmake 中配置相关库的路径， 以及安装 vulkan sdk， 并确保 glslc 可执行文件在 PATH 中。