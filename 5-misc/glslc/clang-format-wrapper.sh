#!/bin/bash

diff <(cat $@) <(clang-format -style=file $@) || true