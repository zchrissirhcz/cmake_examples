#include <iostream>
#include <string>
#include <zlib.h>
#include <zconf.h>

using namespace std;

int main(int argc, char *argv[])
{
    //unsigned char szSrc[] = "test the compression and uncompression of zlib.";
    const unsigned char szSrc[] = "test the compression and uncompression of zlib.";
    unsigned long nSrcLen = sizeof(szSrc);

    unsigned char szZip[1024] = { 0 };
    unsigned long nZipLen = 1024;
    compress(szZip, &nZipLen, szSrc, nSrcLen);
    unsigned char szUnZip[1024] = { 0 };
    unsigned long nUnZipLen = 1024;
    uncompress(szUnZip, &nUnZipLen, szZip, nZipLen);
    cout << "Src:" << szSrc << ", len:" << nSrcLen << endl;
    cout << "Zip:" << szZip << ", len:" << nZipLen << endl;
    cout << "UnZip:" << szUnZip << ", len:" << nUnZipLen << endl;

    return 0;

}
