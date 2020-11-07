# 基于ARM NEON Intrinsics 的 RGB BGR 转换加速


Tested on MI8 (QC845) for 1001 trials, image size 353 x 500
- no neon: 264 ms
- neon: 50 ms


## Ref links

- https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/coding-for-neon---part-1-load-and-stores

- https://stackoverflow.com/a/39519421/2999096

- https://blog.csdn.net/wohenfanjian/article/details/103407259

- https://stackoverflow.com/a/11684331/2999096