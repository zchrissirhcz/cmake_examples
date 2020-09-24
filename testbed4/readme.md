git clone https://gitee.com/aczz/libjpeg

cd libjpeg
mkdir build
cmake ..
make -j8
make install

cmake .. -DBUILD_STATIC=ON
make -j8
make install
