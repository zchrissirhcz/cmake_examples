#!/usr/bin/env python

import subprocess

NDK_DIR="/home/zz/soft/android-ndk-r21e"
NDK_ADDR2LINE="{:s}/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-addr2line".format(NDK_DIR)

raw_lines = """
    #0 0x7bfd1c84a4  (/system/lib64/libclang_rt.asan-aarch64-android.so+0xa24a4)
    #1 0x5eed33b55c  (/data/local/tmp/testbed+0x7eb55c)
    #2 0x5eecc88ca4  (/data/local/tmp/testbed+0x138ca4)
    #3 0x5eecca2b1c  (/data/local/tmp/testbed+0x152b1c)
    #4 0x5eecca2958  (/data/local/tmp/testbed+0x152958)
    #5 0x5eecca0bd4  (/data/local/tmp/testbed+0x150bd4)
    #6 0x5eeccce800  (/data/local/tmp/testbed+0x17e800)
    #7 0x5eed311a60  (/data/local/tmp/testbed+0x7c1a60)
    #8 0x5eed2f01d8  (/data/local/tmp/testbed+0x7a01d8)
    #9 0x5eecc94034  (/data/local/tmp/testbed+0x144034)
    #10 0x5eecc94dc0  (/data/local/tmp/testbed+0x144dc0)
    #11 0x7bfebe71e4  (/data/local/tmp/testbed+0x4a1e4)
    #12 0x7bfebe73e4  (/data/local/tmp/testbed+0x4a3e4)
    #13 0x7bfec1e0f8  (/data/local/tmp/testbed+0x810f8)
    #14 0x7bfec1d008  (/data/local/tmp/testbed+0x80008)
    #15 0x7bfebe9d24  (/data/local/tmp/testbed+0x4cd24)
""".strip().split("\n")

exe_file = 'android-arm64/testbed'
exe_file_name = exe_file.split('/')[-1]

for raw_line in raw_lines:
    pos = raw_line.find("+0x")
    addr_str = raw_line[pos+1:-1]
    #$NDK_ADDR2LINE 0x5f5a559d90 -C -f -e ./android-arm64/testbed
    #print(remain)

    cmd = "{:s} {:s} -C -f -e {:s}".format(NDK_ADDR2LINE, addr_str, exe_file)
    #cmd = "$NDK_ADDR2LINE {:s} -C -f -e {:s}".format(addr_str, exe_file)

    process = subprocess.Popen(cmd,
                                shell=True,
                                stdout=subprocess.PIPE,
                            )
    output = process.communicate()[0].decode('utf-8').strip()
    outlines = output.split('\n')

    # ignore no address info
    if (outlines[0] == "??" or outlines[1] == "??:0"):
        continue

    # ignore LLVM compiler(STL) stuffs
    if ('llvm' in outlines[1]):
        continue
    # ignore google test stuffs
    if ('buildbot' in outlines[1]):
        continue

    #print("[command] \n" + cmd)
    print(cmd)
    print(output)
    print("")

    