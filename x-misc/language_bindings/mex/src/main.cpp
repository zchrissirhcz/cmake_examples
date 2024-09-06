#include <mex.h>
#include "add.h"

/*
Usage:
    res = my_add(a, b)
*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // float a;
    // a = add(3, 5);
    // mexPrintf("Hello World\n");
    // mexPrintf("%g\n", a);

    double* a;
    double b, c;
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    a = mxGetPr(plhs[0]);
    b = *(mxGetPr(prhs[0]));
    c = *(mxGetPr(prhs[1]));
    *a = add(b, c);

}
