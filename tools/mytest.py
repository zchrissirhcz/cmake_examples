##################################################################################################################
# Make Python unittest output like googletest
# --------------------
#
# Exampe usage:
# --------------------
# import unittest
# from mytest import MyTestRunner
#
# def inc(x):
#     return x + 1
#
# class JustTest(unittest.TestCase):
#     def test_answer(self):
#         assert inc(3) == 5
#
# if __name__ == '__main__':
#     unittest.main(testRunner=MyTestRunner())
#
# References
# --------------------
# https://www.cnblogs.com/coderzh/archive/2010/08/23/custom-python-unittestoutput-as-gtest.html
# https://github.com/xxhfg/youlook/blob/8d30e008260540902dacf5fbc5d4015bd68dc13e/libs/ColorUnittest/myunittest.py
# https://github.com/sndnyang/Tools/blob/d0bc2a7f5aa645048bd2fbaa28a43b1cccfac323/colortest.py
#
##################################################################################################################

import unittest
import time
import sys


import os

if os.name == 'nt':
    import ctypes

    ## {{{ http://code.activestate.com/recipes/496901/ (r3)
    # See http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winprog/winprog/windows_api_reference.asp
    # for information on Windows APIs.
    STD_INPUT_HANDLE = -10
    STD_OUTPUT_HANDLE = -11
    STD_ERROR_HANDLE = -12

    FOREGROUND_WHITE = 0x0007
    FOREGROUND_BLUE = 0x01  # text color contains blue.
    FOREGROUND_GREEN = 0x02  # text color contains green.
    FOREGROUND_RED = 0x04  # text color contains red.
    FOREGROUND_INTENSITY = 0x08  # text color is intensified.
    FOREGROUND_YELLOW = FOREGROUND_RED | FOREGROUND_GREEN

    BACKGROUND_BLUE = 0x10  # background color contains blue.
    BACKGROUND_GREEN = 0x20  # background color contains green.
    BACKGROUND_RED = 0x40  # background color contains red.
    BACKGROUND_INTENSITY = 0x80  # background color is intensified.

    std_out_handle = ctypes.windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)

    def set_color(color, handle=std_out_handle):
        """(color) -> BOOL
        Example: set_color(FOREGROUND_GREEN | FOREGROUND_INTENSITY)
        """
        bool = ctypes.windll.kernel32.SetConsoleTextAttribute(handle, color)
        return bool

    class _ColorWritelnDecorator:
        """Used to decorate file-like objects with a handy 'writeln' method"""
        def __init__(self, stream):
            self.stream = stream
            if os.name == 'nt':
                self.std_out_handle = ctypes.windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)

        def __getattr__(self, name):
            return getattr(self.stream, name)

        def yellow(self, msg):
            set_color(FOREGROUND_YELLOW | FOREGROUND_INTENSITY)
            self.write(msg)
            set_color(FOREGROUND_WHITE)

        def writeln(self, msg=None):
            if msg:
                self.write(msg)
            self.write('\n')

        def red(self, msg):
            set_color(FOREGROUND_RED | FOREGROUND_INTENSITY)
            self.write(msg)
            set_color(FOREGROUND_WHITE)

        def green(self, msg):
            set_color(FOREGROUND_GREEN | FOREGROUND_INTENSITY)
            self.write(msg)
            set_color(FOREGROUND_WHITE)

else:
    # https://en.wikipedia.org/wiki/ANSI_escape_code
    black = (1, 1, 1)
    red = (222, 56, 43)
    green = (57, 181, 74)
    yellow = (255, 199, 6)
    blue = (0, 111, 184)
    magenta = (118, 38, 113)
    cyan = (44, 181, 233)
    white = (204, 204, 204)
    bright_black = (128, 128, 128)
    bright_red = (255, 0, 0)
    bright_green = (0, 255, 0)
    bright_yellow = (255, 255, 0)
    bright_blue = (0, 0, 255)
    bright_magenta = (255, 0, 255)
    bright_cyan = (0, 255, 255)
    bright_white = (255, 255, 255)

    class _ColorWritelnDecorator:
        """Used to decorate file-like objects with a handy 'writeln' method"""
        def __init__(self, stream):
            self.stream = stream
            if os.name == 'nt':
                self.std_out_handle = ctypes.windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)

        def __getattr__(self, name):
            return getattr(self.stream, name)

        def set_color(self, color):
            #stream.write("\033[38;2;{};{};{}m{} \033[38;2;255;255;255m".format(255, 0, 0, msg))
            r, g, b = color
            self.stream.write("\033[38;2;{};{};{}m ".format(r, g, b))

        def yellow(self, msg):
            self.set_color(yellow)
            self.write(msg)
            self.set_color(white)

        def writeln(self, msg=None):
            if msg:
                self.write(msg)
            self.write('\n')

        def red(self, msg):
            self.set_color(red)
            self.write(msg)
            self.set_color(white)

        def green(self, msg):
            self.set_color(green)
            self.write(msg)
            self.set_color(white)

import re

pattern = re.compile('File "(.+)",', re.IGNORECASE)

class MyTestResult(unittest.TestResult):
    separator1 = '[----------] '
    separator2 = '[==========] '

    def __init__(self, stream=sys.stderr, descriptions=1, verbosity=1):
        unittest.TestResult.__init__(self)
        self.stream = stream
        self.showAll = verbosity > 1
        self.dots = verbosity == 1
        self.descriptions = descriptions

    def getDescription(self, test):
        if self.descriptions:
            return test.shortDescription() or str(test)
        else:
            return str(test)

    def startTest(self, test):
        self.stream.green('[ Run      ] ')
        self.stream.writeln(self.getDescription(test))
        unittest.TestResult.startTest(self, test)
        if self.showAll:
            self.stream.write(self.getDescription(test))
            self.stream.write(" ... ")

    def addSuccess(self, test):
        unittest.TestResult.addSuccess(self, test)
        if self.showAll:
            self.stream.writeln("ok")
        elif self.dots:
            self.stream.green('[       OK ] ')
            self.stream.writeln(self.getDescription(test))

    def addError(self, test, err):
        unittest.TestResult.addError(self, test, err)
        if self.showAll:
            self.stream.writeln("ERROR")
        elif self.dots:
            self.stream.red('[  ERRORED ] ')
            self.stream.writeln(self.getDescription(test))
            self.stream.write(self._exc_info_to_string(err, test))

    def addFailure(self, test, err):
        unittest.TestResult.addFailure(self, test, err)
        if self.showAll:
            self.stream.writeln("FAIL")
        elif self.dots:
            #self.stream.write(self._exc_info_to_string(err, test))
            content = self._exc_info_to_string(err, test)
            content_lines = content.split('\n')
            linenum_line = content_lines[1]
            file_desc, linenum_desc, testcase_desc = linenum_line.split(', ')
            linenum = linenum_desc.split(' ')[-1]
            filename = file_desc.split(' ')[-1][1:-1]
            result = '{:s}:{:s} Failure'.format(filename, linenum)
            self.stream.writeln(result)
            self.stream.writeln('Expected:')
            self.stream.writeln("\t" + content_lines[2].strip())
            self.stream.writeln('Actual:')
            self.stream.writeln("\t" + content_lines[3].strip())

            self.stream.red('[   FAILED ] ')
            self.stream.writeln(self.getDescription(test))


class MyTestRunner:
    def __init__(self, stream=sys.stderr, descriptions=1, verbosity=1):
        self.stream = _ColorWritelnDecorator(stream)
        self.descriptions = descriptions
        self.verbosity = verbosity

    def run(self, test):
        result = MyTestResult(self.stream, self.descriptions, self.verbosity)
        self.stream.green(result.separator2)
        self.stream.writeln('Your Unit Tests Start')

        startTime = time.time()
        test(result)

        stopTime = time.time()
        timeTaken = stopTime - startTime
        self.stream.green(result.separator2)
        run = result.testsRun
        self.stream.writeln("Run %d test%s in %.3fs" %
                            (run, run != 1 and "s" or "", timeTaken))

        failed, errored = map(len, (result.failures, result.errors))

        self.stream.green("[  PASSED  ]  %d tests" % (run - failed - errored))
        self.stream.writeln()

        if not result.wasSuccessful():
            errorsummary = ""
            if failed:
                self.stream.red("[  FAILED  ] %d tests, listed below:" % failed)
                self.stream.writeln()
                for failedtest, failederorr in result.failures:
                    match = pattern.findall(failederorr)
                    if match:
                        src_file = match[0]
                    self.stream.red("[  FAILED  ] %s in %s" % (failedtest, src_file))
                    self.stream.writeln()
            if errored:
                self.stream.red("[  ERRORED ] %d tests, listed below:" % errored)
                self.stream.writeln()
                for erroredtest, erorrmsg in result.errors:
                    match = pattern.findall(erorrmsg)
                    if match:
                        src_file = match[0]
                    self.stream.red("[  ERRORED ] %s in %s" % (erroredtest, src_file))
                    self.stream.writeln()

            self.stream.writeln()
            if failed:
                self.stream.writeln("%2d FAILED TEST" % failed)
            if errored:
                self.stream.writeln("%2d ERRORED TEST" % errored)

        return result