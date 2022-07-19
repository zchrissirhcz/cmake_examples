#include <stdio.h>

#if __ARM_NEON
#include <arm_neon.h>
#endif // __ARM_NEON

int main()
{
    printf("Hello, neon!\n");

#if __ARM_NEON
    float data[4] = {0.1f, 2.3f, 4.5f, 6.7f};
    float32x4_t v_data = vld1q_f32(data);
    float32x4_t v_1 = vdupq_n_f32(1.0f);
    float32x4_t v_res = vaddq_f32(v_data, v_1);
    float res[4];
    vst1q_f32(res, v_res);

    for(int i = 0; i < 4; i++)
    {
        printf("%f, ", res[i]);
    }
    printf("\n");
#endif // __ARM_NEON

    return 0;
}

