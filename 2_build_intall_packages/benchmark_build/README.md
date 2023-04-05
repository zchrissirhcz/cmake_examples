repo: https://github.com/google/benchmark

note: People don't have to install gtest. It should be the official's duty to ensure the unit test is OK. But people have to manually disable building tests.

On MSVC platform, people may write code in Debug mode, to ensure program result correct, then switch to Release mode, for performance benchmark. In such situation, people have to compile both the Debug and Release library, and since the correspoinding library file name is the same, one shadows the other, thus people have to specify postfix for the Debug mode's library file. See vs2019-x64-debug.cmd for detail.