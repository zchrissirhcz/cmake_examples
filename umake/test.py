#!/usr/bin/env python
#coding: utf-8


from umake import CMake


#cmake = CMake('3.15', 'hello')
#cmake.add_library('hello', ['src/hello.h', 'src/hello.cpp'])
#cmake.add_executable('demo', ['src/main.cpp'])
#cmake.target_link_libraries('demo', ['hello'])

cmake = CMake('3.15', 'hello')

hello = CMake.Target.Library('hello')
hello.add_dep_files([
    'inc/hello.h',
    'src/hello.cpp'
])
hello.add_include_dir('inc', 'PUBLIC')

demo = CMake.Target.Executable('demo')
demo.add_dep_file(
    'test/main.cpp'
)
demo.add_include_dir('inc', 'PUBLIC')
demo.add_dep_lib('hello')

#opencv_pkg = CMake.find_package('OpenCV')
#demo.add_dep_lib(opencv_pkg)

cmake.add_target(hello)
cmake.add_target(demo)

cmake.dump()
