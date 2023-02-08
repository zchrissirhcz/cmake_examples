#!/bin/bash

# cmakelint \
#     --filter=+convention/filename \
#     --filter=+convention/linelength \
#     --filter=+package/consistency \
#     --filter=+readability/logic \
#     --filter=+readability/mixedcase \
#     --filter=+readability/wonkycase \
#     --filter=+syntax \
#     --filter=+whitespace/eol \
#     --filter=+whitespace/extra \
#     --filter=+whitespace/indent \
#     --filter=+whitespace/mismatch \
#     --filter=+whitespace/newline \
#     --filter=+whitespace/tabs \
#     CMakeLists.txt

# 生成并打印 AST(?)
cmake-format --dump parse CMakeLists.txt