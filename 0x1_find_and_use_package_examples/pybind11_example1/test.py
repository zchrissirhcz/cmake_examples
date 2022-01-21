#!/usr/bin/env python
#coding: utf-8


import time

import sys
sys.path.insert(1, 'build')
import eight_queens_fast

def calc(n, i=0, cols=0, diags=0, trans=0):
    if i == n:
        return 1
    else:
        rt = 0
        for j in range(n):
            col = 1 << j
            diag = 1 << (i - j + n - 1)
            tran = 1 << (i + j)
            if (col & cols) == 0 and (diag & diags) == 0 and (tran & trans) == 0:
                rt += calc(n, i+1, cols | col, diags | diag, trans | tran)
        return rt

def get_time():
    return int(1000*time.time())

if __name__ == '__main__':
    n = 10

    t_start = get_time()
    print('8queens({:d}), cpp implementation'.format(n))
    res = eight_queens_fast.calc(13)
    t_cost = get_time() - t_start
    print('\tresult = {:d}, time cost = {:d} ms'.format(res, t_cost))

    t_start = get_time()
    print('8queens({:d}), python implementation'.format(n))
    res = calc(13)
    t_cost = get_time() - t_start
    print('\tresult = {:d}, time cost = {:d} ms'.format(res, t_cost))

