import sys
import os

if __name__ == '__main__':
    print('Hello, CMake; Hello, Python')
    print('sys.argv:', sys.argv)

    test_flags = os.getenv('TEST_FLAGS', default='')
    print("environ variable TEST_FLAGS: ", test_flags)