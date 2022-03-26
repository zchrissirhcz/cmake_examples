# coding: utf-8

import os
from natsort import natsorted, ns

def get_sorted_items_from_dir(directory):
    items = [_ for _ in  os.listdir(directory)]
    return natsorted(items)

def process_one_dir(subdir):
    sorted_items = get_sorted_items_from_dir(subdir)
    for item in sorted_items:
        if os.path.isfile(item):
            continue

        first_two_chars = item[0:2]
        if (first_two_chars.isdigit()):
            process_one_dir(subdir + '/' + item)
        else:
            #print(subdir + '/' + item)
            fullpath = subdir + '/' + item
            content = '| {:s} | [{:s}]({:s}) |'.format(item, fullpath, fullpath)
            print(content)

def process_root_dir():
    sorted_items = get_sorted_items_from_dir('.')
    print("| examples | directory |")
    print("| -------- | --------- |")
    for item in sorted_items:
        if os.path.isfile(item):
            continue
        if item.startswith('.'):
            continue
        process_one_dir(item)

if __name__ == '__main__':
    process_root_dir()