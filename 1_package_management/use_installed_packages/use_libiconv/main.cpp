#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iconv.h>

#define OUTLEN 255
int covert(char *, char *, char *, size_t , char *, size_t );

int main(int argc, char *argv[])
{
    char *input = "中国";
    size_t len = strlen(input);
    char *output = (char *)malloc(OUTLEN);
    covert("UTF-8", "GBK", input, len, output, OUTLEN);
    printf("%s\n", output);
    return 0;
}

int covert(char *desc, char *src, char *input, size_t ilen, char *output, size_t olen)
{
    char **pin = &input;
    char **pout = &output;
    iconv_t cd = iconv_open(desc, src);
    if (cd == (iconv_t)-1)
    {
        return -1;
    }
    memset(output, 0, olen);
    if (iconv(cd, pin, &ilen, pout, &olen)) return -1;
    iconv_close(cd);
    return 0;
}