#!/usr/bin/env python

"""
Author      : ChrisZZ
Start Date  : 2023-02-08 11:00:00
Description : Parse, validate and report bad uses in CMakeLists.txt/xxx.cmake files.
"""

# init logging
import logging
from rich.logging import RichHandler
import unittest

FORMAT = "%(message)s"
logging.basicConfig(
    level="NOTSET", format=FORMAT, datefmt="[%X]", handlers=[RichHandler()]
)  # set level=20 or logging.INFO to turn of debug
logger = logging.getLogger("rich")

def print_version_info():
    print('--------------------------------------------------------')
    print('    CMake Sanitizer: detect bad uses in CMake files')
    print('    Author: Zhuo Zhang (imzhuo#foxmail.com)')
    print('    Version: 2023.05.04')
    print('--------------------------------------------------------')

def get_lines(filepath):
    """
    @param filepath path to CMakeLists.txt, or path to xxx.cmake
    """
    fin = open(filepath, encoding='UTF-8')
    lines = [_.rstrip('\n') for _ in fin.readlines()]
    fin.close()
    return lines

"""
cmake 的语法包括这几种：
- 函数调用: <函数名字>(<参数列表>), 可以写成多行的形式, 寻找右括号)即可
    - set(), unset(), return(), add_definitions(), add_compile_definitions(), include_directories(), add_compile_options(), cmake_minimum_required(), find_package(), target_include_directories(), target_link_libraries(), ...
    - list(), include(), get_filepath_component()
    - find_program(), message(), string()
    - file()
    - set_property(), get_target_property(), set_target_properties()
    - execute_process(), add_custom_command()
    - target_sources()
    - 自定义函数() / 宏()
- 控制流
    - if()/endif()
    - if()/elseif()/endif()
    - foreach()/endforeach()
    - macro()/endmacro()
    - function()/endfunction()
"""
control_flow_keywords = [
    'if', 'endif', 'elseif',
    'foreach', 'endforeach',
    'macro', 'endmacro',
    'function', 'endfunction'
]

class Node(object):
    def __init__(self, identifier, content, start_line_number, end_line_number):
        self.identifier = identifier
        self.content = content
        self.start_line_number = start_line_number
        self.end_line_number = end_line_number
    
    def __str__(self):
        return self.content

class Ast(object):
    def __init__(self, node_lst, filepath):
        self.filepath = filepath
        self.node_lst = node_lst
        self.minimum_cmake_version = None
        for node in node_lst:
            if (node.identifier == 'cmake_minimum_required'):
                self.minimum_cmake_version = node.content.split(' ')[1]
            break

def remove_trailing_comments(line):
    pos = -1
    has_left_quote = False
    for i in range(len(line)):
        if (line[i] == '#' and (not has_left_quote)):
            pos = i
            break
        if (line[i] == '"'): # TODO: consider escaped quote char
            has_left_quote = (not has_left_quote)
    if (pos == -1):
        return line
    return line[0:pos]

def parse(filepath):
    """
    @param filepath of CMakeLists.txt, or xxx.cmake

    @brief parse the given text lines, get list of nodes
    return the ast
    """
    lines = get_lines(filepath)
    num_of_lines = len(lines)
    i = 0

    node_lst = []
    while (i < num_of_lines):
        line = lines[i]
        #print('line {:d} = {:s}'.format(i, line))
        
        lstriped_line = line.lstrip()
        
        # ignore single line comment
        if (lstriped_line.startswith('#')):
            i += 1
            continue

        lstriped_line = remove_trailing_comments(lstriped_line)
        
        # non-control-flow: functions. maybe single line, maybe multiple line. end with ')'. No nesting (assume no trailing comments)
        # actually, `link_directories()` allow nested braces.
        left_brace_pos = lstriped_line.find('(')
        #print('!!', lstriped_line)
        if (left_brace_pos > 0):
            identifier = lstriped_line[0:left_brace_pos].rstrip()
            # print('!! ' + identifier)
            if (identifier not in control_flow_keywords):
                # print('!!' + identifier)

                # single line
                if (lstriped_line.rstrip().endswith(')')):
                    line_number = i + 1
                    node = Node(identifier, line, line_number, line_number)
                    node_lst.append(node)
                else:
                    j = i + 1
                    content_lines = [line]
                    while (j < num_of_lines):
                        content_lines.append(lines[j])
                        if (lines[j].rstrip().endswith(')')):
                            break
                        j += 1
                    content = '\n'.join(content_lines)
                    start_line_number = i + 1
                    end_line_number = j + 1
                    node = Node(identifier, content, start_line_number, end_line_number)
                    node_lst.append(node)
                    i = j
        i += 1
    
    # print all node
    # print('----------\ndump node info:')
    # for node in node_lst:
    #     print(node.identifier, node.start_line_number, node.end_line_number)
    
    #return node_lst
    ast = Ast(node_lst, filepath)
    return ast

def check_rule1(ast, node):
    # rule1:
    # 不应当使用 add_definitions()
    # 对于 add_definitions(-w) 或 add_definitions(-Wfoo=123) 的用法则更是大坑， 无法在 CMakeLists.txt 里获取到指定的 flags, 但 compile_commands.json 中却确实存在， 导致 overlook 工具失效并且难以察觉
    ret = True
    if (node.identifier == 'add_definitions'):
        ret = False
        if (('-w' in node.content) or ('-W' in node.content)):
            logger.error('Wrong usage detected in {:s}:{:d}\n{:s}\n'.format(ast.filepath, node.start_line_number, node.content))
            logger.info('add_definitions() should only be used for macro definitions(e.g. -Dfoo=1), you should not pass compile options (e.g. -w, -Werror=return-type) to it!')
        else:
            logger.warning('Not recommended usage detected in {:s}:{:d}\n{:s}'.format(ast.filepath, node.start_line_number, node.content))

            if ('-D' in node.content):
                logger.info('    Use add_compile_definitions(foo=1) to add preprocessor definitions (cmake>=3.12)')
            if ('-I' in node.content):
                logger.info('    Use include_directories(some_dir) to add include directories.')
            if (('-D' not in node.content) and ('-I' not in node.content)):
                logger.info('    Use add_compile_options() to add other options, e.g. -Werror=return-type, -fPIC')
            logger.info('    c.f. https://cmake.org/cmake/help/latest/command/add_definitions.html\n')
    return ret


def check_rule2(ast, node):
    # rule2:
    # 尽量不要使用具有全局作用域的函数 link_directories
    ret = True
    if (node.identifier in ['link_directories', 'link_libraries']):
        ret = False
        logger.warning('Not recommended usage detected in {:s}:{:d}\n{:s}'.format(ast.filepath, node.start_line_number, node.content))
        logger.info('    Use target_link_libraries(target <PUBLIC|PRIVATE|INTERFACE> dep_target_lst)\n')
        logger.info('    or, target_link_libraries(target <PUBLIC|PRIVATE|INTERFACE> /absolute/path/to/lib/file)\n')
        logger.info('    or, target_link_directories(target <PUBLIC|PRIVATE|INTERFACE> the_dir)\n')
    return ret


def check_rule3(ast):
    ret = True

    # rule3:
    # add_compile_options() 是对它之后的 target 生效的， 如果它之前没有任何 target 则不起作用， 应当报 error。
    # ref: https://stackoverflow.com/a/40522384/2999096
    node_lst = ast.node_lst
    add_compile_options_appeared_lines = []
    for node in node_lst:
        if (node.identifier == 'add_compile_options'):
            add_compile_options_appeared_lines.append(node.start_line_number)
    if (len(add_compile_options_appeared_lines) == 0):
        return ret

    target_nodes = []
    for node in node_lst:
        #print('  ', node.identifier)
        if (node.identifier in ['add_executable', 'add_libraries']):
            target_nodes.append(node)

    # print('target_create_lines:')
    # print(target_create_lines)

    # print('add_compile_options_appeared_lines')
    # print(add_compile_options_appeared_lines)

    for target_node in target_nodes:
        for compile_options_line in add_compile_options_appeared_lines:
            if (target_node.start_line_number < compile_options_line):
                ret = False
                logger.error('add_compile_options() should appear before all targets creation. It appeard in {:s}:{:d}'.format(ast.filepath, compile_options_line))
                logger.error('    while {:s}() appeared in {:s}:{:d}'.format(target_node.identifier, ast.filepath, target_node.start_line_number))
                logger.error('You may also use target_compile_options() instead.')
    
    return ret


def parse_set(content):
    # 解析 set(xxKey xxValue) 的语句， 得到 xxKey, xxValue
    inner_content = content.split('(')[1].split(')')[0]
    key, value = inner_content.split(' ')[0], inner_content.split(' ')[1]
    return key, value


def check_rule4(ast):
    # rule4: 检查 fPIC 全局设置是否正确
    ret = True
    node_lst = ast.node_lst
    for node in node_lst:
        if (node.identifier == 'set'):
            key, value = parse_set(node.content)
            if (key == 'POSITION_INDEPENDENT_CODE'):
                logger.error('Invalid variable name for setting fPIC: `POSITION_INDEPENDENT_CODE`. It appeard in {:s}:{:d}'.format(ast.filepath, node.start_line_number))
                logger.error('The correct one is `CMAKE_POSITION_INDEPENDENT_CODE`')
                ret = False
                break
    return ret


def validate(ast):
    node_lst = ast.node_lst
    ret = True

    if (ast.minimum_cmake_version < '3.15'):
        ret = False
        logger.warning('Suggested minimum cmake version >= 3.15, detected is {:s}'.format(ast.minimum_cmake_version))
        return ret

    print('--- checking rule1')
    for node in node_lst:
        ret = check_rule1(ast, node)
        if (ret != True):
            return ret
    
    print('--- checking rule2')
    for node in node_lst:
        ret = check_rule2(ast, node)
        if (ret != True):
            return ret

    print('--- checking rule3')
    ret = check_rule3(ast)
    if (ret != True):
        return ret

    print('--- checking rule4')
    ret = check_rule4(ast)
    if (ret != True):
        return ret

    print("===")
    if (ret == True):
        print('CMake Sanity Result: OK')
    else:
        print('CMake Sanity Result: Not OK')
    return ret


def test_remove_trailing_comments():
    s = remove_trailing_comments('set(s "1#2")#555')
    assert(s == 'set(s "1#2")')


if __name__ == '__main__':
    print_version_info()
    
    import sys
    if (len(sys.argv) > 1):
        path = sys.argv[1]
        ast = parse(path)
        
        # path = 'cmake_sanitizer_test/test_global_fPIC_with_wrong_var_name/CMakeLists.txt'
        # check_rule4(ast)

        validate(ast)
    else:
        print('Usage: python cmake_sanitizer.py /path/to/CMakeLists.txt')

