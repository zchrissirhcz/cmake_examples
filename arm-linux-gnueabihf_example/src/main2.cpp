#include <stdio.h>
#include <arm_neon.h>
#include <stdlib.h>

static void rgb2bgr_asimd(unsigned char* src_buf, size_t height, size_t width, unsigned char* dst_buf);

void rgb2bgr_asimd(unsigned char* src_buf, size_t height, size_t width, unsigned char* dst_buf)
{
    size_t done = 0;
    size_t total_len = width * height * 3;
//#ifdef __ARM_NEON
    size_t step = 24;
    size_t vec_size = total_len - total_len % step;

    uint8x8x3_t v;
    uint8x8_t tmp;

    for (size_t i=0; i<vec_size; i+=step) {
        v = vld3_u8(src_buf);
        src_buf += step;
        tmp = v.val[0];
        v.val[0] = v.val[2];
        v.val[2] = tmp;
        vst3_u8(dst_buf, v);
        dst_buf += step;
    }

    done = vec_size;
//#endif // __ARM_NEON

    for ( ; done<total_len; done+=3) {
        dst_buf[2] = src_buf[0];
        dst_buf[1] = src_buf[1];
        dst_buf[0] = src_buf[2];
        dst_buf += 3;
        src_buf += 3;
    }
}

int main()
{

    size_t height = 256;
    size_t width = 256;
    int channel = 3;
    unsigned char* src_buf = (unsigned char*)malloc(height*width*channel);

    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            src_buf[i*width+j] = i;
        }
    }

    unsigned char* dst_buf = (unsigned char*)malloc(height*width*channel);

    rgb2bgr_asimd(src_buf, height, width, dst_buf);

    free(src_buf);
    free(dst_buf);

    return 0;
}
