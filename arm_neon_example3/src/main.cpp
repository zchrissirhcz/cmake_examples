// https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/coding-for-neon---part-1-load-and-stores
// https://stackoverflow.com/a/39519421/2999096
// https://blog.csdn.net/wohenfanjian/article/details/103407259
// https://stackoverflow.com/a/11684331/2999096

#include <iostream>
#include <string>
#include <chrono>
#include <stdlib.h>

#if __ARM_NEON
#include <arm_neon.h>
#endif

#define STB_IMAGE_IMPLEMENTATION
#define STBI_NO_PSD
#define STBI_NO_TGA
#define STBI_NO_GIF
#define STBI_NO_HDR
#define STBI_NO_PIC
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

using namespace std;

typedef struct RGBImage {
    int h, w;
    unsigned char* data;
} RGBImage;

double msElapsedTime(chrono::system_clock::time_point start) {
    auto end = chrono::system_clock::now();

    return chrono::duration_cast<chrono::milliseconds>(end - start).count();
}

chrono::system_clock::time_point now() {
    return chrono::system_clock::now();
}

void rgb_bgr_swap(RGBImage* image) {
    int h = image->h;
    int w = image->w;
    for (int i=0; i<h; i++) {
        for (int j=0; j<w; j++) {
            int idx = i*w*3 + j*3;
            unsigned char t = image->data[idx];
            image->data[idx] = image->data[idx+2];
            image->data[idx+2] = t;
        }
    }
}

void rgb_bgr_swap2(RGBImage* image) {
    int h = image->h;
    int w = image->w;
    int len = h * w * 3;
    int segments = len / 12;
    uint32_t* p1 = (uint32_t*)image->data;
    uint32_t* p2 = p1 + 1;
    uint32_t* p3 = p2 + 1;
    uint32_t v1, v2, v3;
    uint32_t nv1, nv2, nv3;
    for (int i=0; i<segments; i++) {
        // read 12 bytes
        v1 = *p1;
        v2 = *p2;
        v3 = *p3;

        // shuffle bits in the pixels
        /*
        // [R1 G1 B1 R2 | G2 B2 R3 G3 | B3 R4 G4 B4]
        // [B1 G1 R1 B2 | G2 R2 B3 G3 | R3 B4 G4 R4]
        nv1 = (
            ((v1 & 0x0000FF00) << 16) |
            (v1 & 0x00FF0000) |
            ((v1 & 0xFF000000) >> 16) |
            ((v2 & 0x00FF0000) >> 16)
        );

        nv2 = (
            (v2 & 0xFF000000) |
            ((v1 & 0x000000FF) << 16) |
            ((v3 & 0xFF000000) >> 16) |
            (v2 & 0x000000FF)
        );

        nv3 = (
            ((v2 & 0x0000FF00) << 16) |
            ((v3 & 0x000000FF) << 16) |
            (v3 & 0x0000FF00) |
            ((v3 & 0x00FF0000) >> 16)
        );
        */

        // [R2 B1 G1 R1 | G3 R3 B2 G2 | B4 G4 R4 B3]
        // [B2 R1 G1 B1 | G3 B3 R2 G2 | R4 G4 B4 R3]
        nv1 = (
            ((v2 & 0x0000FF00) << 16) |
            ((v1 & 0x000000FF) << 16) |
            (v1 & 0x0000FF00) |
            ((v1 & 0x00FF0000) >> 16)
        );

        nv2 = (
            ((v2 & 0xFF000000)) |
            ((v3 & 0x000000FF) << 16) |
            ((v1 & 0xFF000000) >> 16) |
            ((v2 & 0x000000FF))
        );

        nv3 = (
            ((v3 & 0x0000FF00) << 16) |
            ((v3 & 0x00FF0000)) |
            ((v3 & 0xFF000000) >> 16) |
            ((v2 & 0x00FF0000) >> 16)
        );

        *p1 = nv1;
        *p2 = nv2;
        *p3 = nv3;

        p1 += 3;
        p2 += 3;
        p3 += 3;
    }

    int remain = len % 12;
    unsigned char* b1 = (unsigned char*)p1;
    // unsigned char* b2 = b1 + 1;
    unsigned char* b3 = b1 + 2;
    for (int i=0; i<remain; i+=3) {
        unsigned char t = *b1;
        *b1 = *b3;
        *b3 = t;
        b1+=3;
        b3+=3;
    }
}


#if __ARM_NEON
void rgb_bgr_swap_neon(RGBImage* image) {
    int h = image->h;
    int w = image->w;
    unsigned char* buf = image->data;

    int len = h * w;
    int segments = len / 8;
    for (int i=0; i+7<len; i+=8) {
        uint8x8x3_t pixel = vld3_u8(buf);

        uint8x8_t t = pixel.val[0];
        pixel.val[0] = pixel.val[2];
        pixel.val[2] = t;

        vst3_u8(buf, pixel);

        buf += 24;
    }

    int remain = len % 8;
    for (int i=0; i<remain; i++) {
        unsigned char t = buf[0];
        buf[0] = buf[2];
        buf[2] = t;
        buf += 3;
    }
}

// try to use arm inline asm for optimization, most for vswp
// but got compile error
// error: unknown register name 'q0' in asm
// void rgb_bgr_swap_neon2(RGBImage* image) {
//     int h = image->h;
//     int w = image->w;
//     unsigned char* buf = image->data;

//     int len = h * w;
//     int segments = len / 8;
//     for (int i=0; i+7<len; i+=8) {
//         asm volatile(
//             "1:                          \n"
//             "vld3.u8 {d0-d2}, [%[buf]]!       \n"
//             "vswp d0, d2                 \n"
//             "vst3.u8 {d0, d1, d2}, [%[buf]]!  \n"
//             : [buf] "+r" (buf)
//             : "memory", "q0", "q1"
//         );

//         buf += 24;
//     }

//     int remain = len % 8;
//     for (int i=0; i<remain; i++) {
//         unsigned char t = buf[0];
//         buf[0] = buf[2];
//         buf[2] = t;
//         buf += 3;
//     }
// }

// ARMv7-A/AArch32
// copied from https://zyddora.github.io/2016/03/16/neon_2/
// but still got compile error
// error: unknown register name 'q0' in asm
// void add_float_neon2(int* dst, int* src1, int* src2, int count)
// {
//   asm volatile (
//     "0: \n"
//     "vld1.32 {q0}, [%[src1]]! \n"
//     "vld1.32 {q1}, [%[src2]]! \n"
//     "vadd.f32 q0, q0, q1 \n"
//     "subs %[count], %[count], #4 \n"
//     "vst1.32 {q0}, [%[dst]]! \n"
//     "bgt 1b \n"
//     : [dst] "+r" (dst)
//     : [src1] "r" (src1), [src2] "r" (src2), [count] "r" (count)
//     : "memory", "q0", "q1"
//   );
// }

#endif // __ARM_NEON

RGBImage load_image(const char* filename)
{
    RGBImage image;
    int channels;
    image.data = stbi_load(filename, &image.w, &image.h, &channels, 0);

    printf("-- loaded image %s, height=%d, width=%d\n",
        filename, image.h, image.w);
    return image;
}

RGBImage copy_image(RGBImage* src_image)
{
    RGBImage copy;
    copy.h = src_image->h;
    copy.w = src_image->w;
    size_t buf_size = copy.h * copy.w * 3;
    copy.data = (unsigned char*)malloc(buf_size);
    memcpy(copy.data, src_image->data, buf_size);
    return copy;
}

void save_image(RGBImage* image, const char* filename)
{
    if (strlen(filename) < 5) {
        fprintf(stderr, "filename too short\n");
        return;
    }
    const char* ext = filename + strlen(filename) - 4;
    if(0==strcmp(ext, ".jpg")) {
        int quality = 100;
        stbi_write_jpg(filename, image->w, image->h, 3, image->data, quality);
    }
    else if(0==strcmp(ext, ".png")) {
        int stride_in_bytes = image->w * 3;
        stbi_write_png(filename, image->w, image->h, 3, image->data, stride_in_bytes);
    }
}

void perf_test()
{
    // assign trials with an odd number, thus validating if neon and none-neon impl matches
    // you may use winmerge / beyond compare to compare tow images
    const int trials = 1001;

    RGBImage image = load_image("000001.jpg");
    RGBImage image_copy1 = copy_image(&image);
    RGBImage image_copy2 = copy_image(&image);
    RGBImage image_copy3 = copy_image(&image);

    // Without NEON intrinsics
    // Invoke dotProduct and measure performance
    // int lastResult = 0;

    auto start = now();
    for (int i = 0; i < trials; i++) {
        rgb_bgr_swap(&image_copy1);
    }
    auto elapsedTime = msElapsedTime(start);
    save_image(&image_copy1, "non_neon.jpg");

    // C, speedup
    start = now();
    for (int i = 0; i < trials; i++) {
        rgb_bgr_swap2(&image_copy2);
    }
    auto elapsedTime2 = msElapsedTime(start);
    save_image(&image_copy2, "non_neon2.jpg");


#if __ARM_NEON
    // With NEON intrinsics
    // Invoke dotProductNeon and measure performance
    // int lastResultNeon = 0;
    start = now();
    for (int i = 0; i < trials; i++) {
        rgb_bgr_swap_neon(&image_copy3);
    }
    auto elapsedTimeNeon = msElapsedTime(start);
    save_image(&image_copy3, "neon.jpg");
#endif // __ARM_NEON

    std::string resultsString =
        "=== NO NEON 1 ==="
        "\nElapsed time: " + to_string((int)elapsedTime) + " ms"
        "\n\n=== NO NEON 2 ===\n"
        "\nElapsed time: " + to_string((int) elapsedTime2) + " ms";

    // Display results
    // std::string resultsString =
    //        "----==== NO NEON ====----\nResult: "
    //        "\nElapsed time: " + to_string((int) elapsedTime) + " ms"
    //        "\n\n----==== NEON ====----\n"
    //        "\nElapsed time: " + to_string((int) elapsedTimeNeon) + " ms";

    std::cout << resultsString << std::endl;

    free(image.data);
    free(image_copy1.data);
    free(image_copy2.data);
}

int main(int, char*[])
{
    perf_test();

    return 0;
}