cmake_minimum_required(VERSION 3.20)
project(hello)
add_library(hello SHARED
    hello.h
    hello.c
)
