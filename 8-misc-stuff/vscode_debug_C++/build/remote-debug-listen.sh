#!/bin/bash

# simple. sometimes not working
#adb shell "cd /data/local/tmp; ./lldb-server platform --listen \*:10086 --server"



# useless, too long
# # 2. forward
# adb forward tcp:10086 tcp:10086

# # 1. listen
adb shell
cd /data/local/tmp
./lldb-server platform --listen *:10086 --server