# coding: utf-8

import os
from natsort import natsorted, ns

total = 0


def get_sorted_items_from_dir(directory):
    items = [_ for _ in os.listdir(directory)]
    return natsorted(items)


def process_one_dir(subdir):
    global total

    if subdir == '10_vscode_debug_C++':
        total += 1
        content = '| {:d} | {:s} | [{:s}]({:s}) |'.format(total, subdir, subdir, subdir)
        print(content)
        return

    sorted_items = get_sorted_items_from_dir(subdir)
    for item in sorted_items:
        if os.path.isfile(subdir + '/' + item):
            continue

        first_two_chars = item[0:2]
        if first_two_chars.isdigit():
            process_one_dir(subdir + '/' + item)
        if item.startswith('.'):
            continue
        else:
            total += 1
            # print(subdir + '/' + item)
            fullpath = subdir + '/' + item
            content = '| {:d} | {:s} | [{:s}]({:s}) |'.format(total, item, fullpath, fullpath)
            print(content)


def process_sub_dir(subdir):
    print("### {:s}".format(subdir))
    print("| number | examples | directory |")
    print("| ------ | -------- | --------- |")
    idx = 0
    for item in os.listdir(subdir):
        item_path = subdir + "/" + item
        if os.path.isdir(item_path):
            # process_sub_sub_dir(item_path)
            content = '| {:d} | {:s} | [{:s}]({:s}) |'.format(idx, item, item_path, item_path)
            print(content)
            idx += 1


def process_root_dir():
    # sorted_items = get_sorted_items_from_dir('.')
    subdirs = []
    for item in os.listdir('.'):
        if os.path.isdir(item) and item[0].isdigit():
            subdirs.append(item)

    for subdir in subdirs:
        process_sub_dir(subdir)
        print('')


if __name__ == '__main__':
    process_root_dir()
