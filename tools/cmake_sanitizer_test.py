from mytest import MyTestRunner
import unittest
import cmake_sanitizer as csan

class XX_Test(unittest.TestCase):
    def test_version(self):
        path = 'cmake_sanitizer_test/test_minimal_version/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_add_definitions_for_compile_flags(self):
        path = 'cmake_sanitizer_test/test_add_definitions_for_compile_flags/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_add_definitions_for_macro(self):
        path = 'cmake_sanitizer_test/test_add_definitions_for_macro/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_add_definitions_for_fPIC(self):
        path = 'cmake_sanitizer_test/test_add_definitions_for_fPIC/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_link_directories(self):
        path = 'cmake_sanitizer_test/test_link_directories/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_link_directories(self):
        path = 'cmake_sanitizer_test/test_add_definitions_with_value/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_add_compile_options_after_target_creation(self):
        path = 'cmake_sanitizer_test/test_add_compile_options_after_target_creation/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))

    def test_global_fPIC_with_wrong_var_name(self):
        path = 'cmake_sanitizer_test/test_global_fPIC_with_wrong_var_name/CMakeLists.txt'
        ast = csan.parse(path)
        self.assertFalse(csan.validate(ast))


if __name__ == '__main__':
    unittest.main(testRunner=MyTestRunner())