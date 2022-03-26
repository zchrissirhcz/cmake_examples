#!/bin/bash

simple_search()
{
    find . -mindepth 2 -maxdepth 3 -type d ! -path '*/\.git/*' ! -path '*/.vscode' | grep $1
}

# deprecated. Use gen_table.py instead.
generate_table()
{
    #find . -mindepth 2 -maxdepth 2 -type d ! -path '*/\.git/*' ! -path '*/.vscode' | awk -F '/' '{print " | " $3 " | " $2 " |"}'
    find . -mindepth 2 -maxdepth 2 -type d ! -path '*/\.git/*' ! -path '*/.vscode' | awk -F '/' '{print " | " $3 " | " "[" $2"/"$3 "]" "(" $2 ")" " |"}'
}

simple_search $1
#generate_table

