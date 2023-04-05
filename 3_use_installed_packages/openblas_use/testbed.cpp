#include <stdio.h>
 
extern "C" {
#include <cblas.h>
}
 
int main() {
	printf("OpenBLAS config info:\n%s\n", openblas_get_config());
 
 
#if 1 // will cause crash on VS2017 x64 with OpenBLAS latest
	const int M = 16;
	const int N = 676;
	const int K = 27;
#else // won't crash
	const int M = 4;
	const int N = 2;
	const int K = 3;
#endif
 
	const float alpha = 1.0f;
	const float beta = 0.f;
 
	int lda = K;
	int ldb = N;
	int ldc = N;
 
	float A[M*K];
	float B[K*N];
	float C[M*N];
 
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, alpha, A, lda, B,
		ldb, beta, C, ldc);
 
	return 0;
}