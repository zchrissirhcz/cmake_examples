#include <iostream>
#include <chrono>
#include <pybind11/pybind11.h>

using namespace std;

int dfs(int n, int i = 0, int cols = 0, int diags = 0, int trans = 0) {
    if (i == n) {
        return 1;
    } else {
        int rt = 0;
        for (int j = 0; j < n; j++) {
            int col = (1 << j);
            int diag = (1 << (i - j + n - 1));
            int tran = (1 << (i + j));
            if (!(col & cols) && !(diag & diags) && !(tran & trans)) {
                rt += dfs(n, i + 1, col | cols, diag | diags, tran | trans);
            }
        }
        return rt;
    }
}

int calc(int n) {
    return dfs(n);
}

int test() {
    auto t = chrono::system_clock::now();
    cout << calc(13) << endl;
    cout << (chrono::system_clock::now() - t).count() * 1e-6 << " ms"<< endl;
    return 0;
}

PYBIND11_MODULE(eight_queens_fast, m) {
    m.doc() = "eight queens with fast speed"; // optional module docstring

    m.def("calc", &calc, "compute result for 8queens with specified input");
}

