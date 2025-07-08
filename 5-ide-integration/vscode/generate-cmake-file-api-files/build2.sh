#!/bin/bash

BUILD_DIR=build

#mkdir -p ${BUILD_DIR}/.cmake/api/v1/query/client-vscode
cmake -E make_directory ${BUILD_DIR}/.cmake/api/v1/query/client-vscode
#echo '{"requests":[{"kind":"cache","version":2},{"kind":"codemodel","version":2},{"kind":"toolchains","version":1},{"kind":"cmakeFiles","version":1}]}' > ${BUILD_DIR}/.cmake/api/v1/query/client-vscode/query.json
cmake -E capabilities | jq '.fileApi' > ${BUILD_DIR}/.cmake/api/v1/query/client-vscode/query.json
cmake -S . -B ${BUILD_DIR}
#cmake --build ${BUILD_DIR}
