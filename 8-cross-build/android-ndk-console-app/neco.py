#!/usr/bin/env python

import os
import sys
import subprocess

def logd(*msg):
    filename = os.path.basename(__file__)
    print("[{}] {}".format(filename, " ".join(msg)))
    sys.stdout.flush()

def run(cmd):
    """
    cmd: str or sequence
    """
    logd("run: {}".format(cmd))
    if isinstance(cmd, str):
        subprocess.run(cmd, shell=True)
    else:
        subprocess.run(cmd)

class TextFileWriter:
    def __init__(self, filename):
        self.filename = filename
        self.fout = open(self.filename, "wt", encoding="utf-8")
    
    def println(self, content, trim=True):
        if trim:
            content = content.strip()
        self.fout.write(content + "\n")

    def close(self):
        self.fout.close()

class Actions:
    def configure(self):
        NDK = "~/soft/android-ndk/r27c"
        cmd = [
            "cmake",
            "-S .",
            "-B build",
            "-G Ninja",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_TOOLCHAIN_FILE={:s}/build/cmake/android.toolchain.cmake".format(NDK),
            "-DANDROID_ABI=arm64-v8a",
            "-DANDROID_PLATFORM=android-21",
        ]
        run(cmd)

    def build(self):
        run('cmake --build build')

    def deploy(self):
        cmd = "adb push build/hello /data/local/tmp/hello"
        run(cmd)

    def run(self):
        run('adb shell "cd /data/local/tmp; chmod +x ./hello; ./hello"')

def help():
    print("Usage: {:s} configure|build|deploy|run".format(os.path.basename(__file__)))

def main():
    if len(sys.argv) == 1:
        help()
        return
    
    a = Actions()
    if sys.argv[1] == 'configure':
        a.configure()
    elif sys.argv[1] == 'build':
        a.build()
    elif sys.argv[1] == 'deploy':
        a.deploy()
    elif sys.argv[1] == 'run':
        a.run()
    else:
        print("not supported subcommand:", sys.argv[1])
        help()

if __name__ == '__main__':
    main()
