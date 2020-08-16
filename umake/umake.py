#!/usr/bin/env python
#coding: utf-8

class CMake(object):
    def __init__(self, cmake_version='3.15', project_name='project', tab='  '):
        self.txt = []
        self.txt.append('CMAKE_MINIMUM_REQUIRED(VERSION {:s})'.format(cmake_version))
        self.txt.append('')
        self.txt.append('project({:s})'.format(project_name))
        self.txt.append('')
        self.tab = tab

    def add_executable(self, target_name, src=[]):
        self.txt.append('add_executable({:s}'.format(target_name))
        for item in src:
            self.txt.append(self.tab + item)
        self.txt.append(')')
        self.txt.append('')

    def add_library(self, target_name, src=[], lib_type='STATIC'):
        self.txt.append('add_library({:s} {:s}'.format(target_name, lib_type))
        for item in src:
            self.txt.append(self.tab + item)
        self.txt.append(')')
        self.txt.append('')

    def target_link_libraries(self, target_name, dep_lst=[]):
        self.txt.append('target_link_libraries({:s}'.format(target_name))
        for item in dep_lst:
            self.txt.append(self.tab + item)
        self.txt.append(')')
        self.txt.append('')

    def dump(self):
        for item in self.txt:
            print(item)

    def add_target(self, target):
        target_dump = target.dump()
        for item in target_dump:
            self.txt.append(item)


    class find_package(object):
        def __init__(self, name):
            # TODO: 这里需要修正，不能仅仅是产生字符串
            # 而是应当执行真的查找
            """
            https://stackoverflow.com/questions/28863366/command-line-equivalent-of-cmakes-find-package
            检查是否存在：
            cmake --find-package -DNAME=OpenCV -DCOMPILER_ID=GNU -DLANGUAGE=CXX -DMODE=EXIST
            编译（头文件）：
            cmake --find-package -DNAME=OpenCV -DCOMPILER_ID=GNU -DLANGUAGE=CXX -DMODE=COMPILE
            链接（库文件）：
            cmake --find-package -DNAME=OpenCV -DCOMPILER_ID=GNU -DLANGUAGE=CXX -DMODE=LINK

            但是看到官方文档有一个备注，说--find_package命令，不建议用：
            This mode is not well-supported due to some technical limitations. It is kept for compatibility but should not be used in new projects.
            """

    class Target(object):
        def __init__(self):
            pass

        class Library(object):
            def __init__(self, target_name, lib_type='STATIC'):
                self.name = target_name
                self.file_lst = []
                self.inc_dir_lst = []
                self.lib_type = lib_type
                self.dep_lib_lst = []
                self.tab = '  '

            def add_dep_file(self, f):
                self.file_lst.append(f)

            def add_dep_files(self, f_lst):
                self.file_lst += f_lst

            def add_include_dir(self, inc_dir, priv):
                if priv not in ['PUBLIC', 'PRIVATE', 'INTERFACE']:
                    print('Error! priv invalid')

                inc_dir = '{:s} {:s}'.format(priv, inc_dir)
                self.inc_dir_lst.append(inc_dir)

            def add_dep_lib(self, dep_lib, priv=''):
                if priv not in ['', 'PUBLIC', 'PRIVATE', 'INTERFACE']:
                    print('Error! priv invalid')

                if (isinstance(dep_lib, str)):
                    dep_lib = '{:s} {:s}'.format(priv, dep_lib)
                    self.dep_lib_lst.append(dep_lib)
                elif (isinstance(dep_lib, CMake.Target.Library)):
                    dep_lib = dep_lib.name
                    dep_lib = '{:s} {:s}'.format(priv, dep_lib)
                    self.dep_lib_lst.append(dep_lib)
                else:
                    print('Error! dep_lib invalid')

            def dump(self):
                txt = []

                # target define
                txt.append('')
                txt.append('add_library({:s} {:s}'.format(self.name, self.lib_type))
                for item in self.file_lst:
                    txt.append(self.tab + item)
                txt.append(')')
                txt.append('')

                # target include directories
                if len(self.inc_dir_lst)>0:
                    txt.append('target_include_directories({:s}'.format(self.name))
                    for item in self.inc_dir_lst:
                        txt.append(self.tab + item)
                    txt.append(')')

                # target link libraries
                if len(self.dep_lib_lst)>0:
                    txt.append('target_link_libraries({:s}'.format(self.name))
                    for item in self.dep_lib_lst:
                        txt.append(self.tab + item)
                    txt.append(')')

                return txt

        class Executable(object):
            def __init__(self, target_name):
                self.name = target_name
                self.file_lst = []
                self.inc_dir_lst = []
                self.dep_lib_lst = []
                self.tab = '  '

            def add_dep_file(self, f):
                self.file_lst.append(f)

            def add_dep_files(self, f_lst):
                self.file_lst += f_lst

            def add_include_dir(self, inc_dir, priv):
                if priv not in ['PUBLIC', 'PRIVATE', 'INTERFACE']:
                    print('Error! priv invalid')

                inc_dir = '{:s} {:s}'.format(priv, inc_dir)
                self.inc_dir_lst.append(inc_dir)

            def add_dep_lib(self, dep_lib, priv=''):
                if priv not in ['', 'PUBLIC', 'PRIVATE', 'INTERFACE']:
                    print('Error! priv invalid')

                dep_lib = '{:s} {:s}'.format(priv, dep_lib)
                self.dep_lib_lst.append(dep_lib)

            def dump(self):
                txt = []

                # target define
                txt.append('add_executable({:s}'.format(self.name))
                for item in self.file_lst:
                    txt.append(self.tab + item)
                txt.append(')')
                txt.append('')

                # target include directories
                if len(self.inc_dir_lst)>0:
                    txt.append('target_include_directories({:s}'.format(self.name))
                    for item in self.inc_dir_lst:
                        txt.append(self.tab + item)
                    txt.append(')')

                # target link libraries
                if len(self.dep_lib_lst)>0:
                    txt.append('target_link_libraries({:s}'.format(self.name))
                    for item in self.dep_lib_lst:
                        txt.append(self.tab + item)
                    txt.append(')')

                return txt

