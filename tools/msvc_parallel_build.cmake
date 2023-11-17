# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

# cmake's -j or --parallel option does not work for msbuild
# let's do parallel build by pasing /MP to cl.exe

# https://zhuanlan.zhihu.com/p/628860221
# 高版本已被废弃，但是低版本的Gm会影响并行
add_compile_options($<$<C_COMPILER_ID:MSVC>:/Gm->)
add_compile_options($<$<CXX_COMPILER_ID:MSVC>:/Gm->)
cmake_host_system_information(RESULT CPU_NUMBER_OF_LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
# NOTE: not all of the CPU's are used for code building to make UI responsible
math(EXPR PARALLEL_BUILD_PROCESSR_COUNT "${CPU_NUMBER_OF_LOGICAL_CORES}/2")
add_compile_options($<$<C_COMPILER_ID:MSVC>:/MP${PARALLEL_BUILD_PROCESSR_COUNT}>)
add_compile_options($<$<CXX_COMPILER_ID:MSVC>:/MP${PARALLEL_BUILD_PROCESSR_COUNT}>)
