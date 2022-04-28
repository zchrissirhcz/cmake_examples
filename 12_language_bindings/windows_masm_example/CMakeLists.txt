cmake_minimum_required(VERSION 3.20)
enable_language(C ASM_MASM)
project(example)
add_executable(testbed
    foo.c
    bar.asm
) 
