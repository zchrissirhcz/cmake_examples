# coding: utf-8

import os
from natsort import natsorted, ns

total = 0

def get_sorted_items_from_dir(directory):
    items = [_ for _ in  os.listdir(directory)]
    return natsorted(items)

def process_one_dir(subdir):
    global total

    if(subdir=='10_vscode_debug_C++'):
        total += 1
        content = '| {:d} | {:s} | [{:s}]({:s}) |'.format(total, subdir, subdir, subdir)
        print(content)
        return

    sorted_items = get_sorted_items_from_dir(subdir)
    for item in sorted_items:
        if os.path.isfile(subdir + '/' + item):
            continue

        first_two_chars = item[0:2]
        if (first_two_chars.isdigit()):
            process_one_dir(subdir + '/' + item)
        if item.startswith('.'):
            continue
        else:
            total += 1
            #print(subdir + '/' + item)
            fullpath = subdir + '/' + item
            content = '| {:d} | {:s} | [{:s}]({:s}) |'.format(total, item, fullpath, fullpath)
            print(content)

def process_root_dir():
    sorted_items = get_sorted_items_from_dir('.')
    print("| number | examples | directory |")
    print("| ------ | -------- | --------- |")
    total = 0
    for item in sorted_items:
        if os.path.isfile(item):
            continue
        if item.startswith('.'):
            continue
        process_one_dir(item)

if __name__ == '__main__':
    process_root_dir()