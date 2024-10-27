#!/usr/bin/env python
# coding: utf-8

"""
用来生成 build 目录下的各种 xxx-build 脚本的 python 模板代码

目前是复刻了 mac-x64.sh 的内容

后续的计划是， main() 里头，每个目标编译平台，都对应一个 builder
"""

class Builder(object):
    def __init__(self):
        self.cmd_content_lines = []
    
    def add_cmd(self, cmd):
        # skip first line and last line, if it is raw str
        items = cmd.split('\n')
        if (len(items) > 1):
            start_idx = 0
            end_idx = -1
            if (len(items[0]) == 0):
                start_idx = 1
            if (len(items[-1]) == items.count(' ')):
                end_idx = -2

            cmd = '\n'.join(items[start_idx:end_idx])

        self.cmd_content_lines.append(cmd)

    def setup_envvars(self):
        cmd = r"""
#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

        """
        self.add_cmd(cmd)

    def create_build_dir(self, build_dir='mac-x64'):
        cmd = "BUILD_DIR=" + build_dir
        self.add_cmd(cmd)

        cmd = "mkdir -p $BUILD_DIR"
        self.add_cmd(cmd)

        cmd = "cd $BUILD_DIR"
        self.add_cmd(cmd)

        self.add_cmd("")

    def cmake_configure(self):
        cmd = r"""
cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPUINFO_BUILD_UNIT_TESTS=OFF \
    -DCPUINFO_BUILD_MOCK_TESTS=OFF \
    -DCPUINFO_BUILD_BENCHMARKS=OFF \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/cpuinfo/master/mac-x64 \
    ../..
        """
        self.add_cmd(cmd)

        self.add_cmd("")

    def cmake_build(self):
        cmd = """
#ninja
#cmake --build . --verbose
cmake --build .
        """
        self.add_cmd(cmd)

    def cmake_install(self):
        self.add_cmd("cmake --install .")
        self.add_cmd("")
        self.add_cmd("cd ..")

    def dump(self):
        for item in self.cmd_content_lines:
            print(item)

    def execute(self):
        pass

if __name__ == '__main__':
    builder = Builder()
    builder.setup_envvars()
    builder.create_build_dir()
    builder.cmake_configure()
    builder.cmake_build()
    builder.cmake_install()
    builder.dump()
    builder.execute()