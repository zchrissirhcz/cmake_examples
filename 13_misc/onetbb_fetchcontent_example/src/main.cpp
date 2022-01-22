#include <algorithm>
#include <cmath>
#include <iostream>
#include <string>
#include <vector>
#include <chrono>

#include <oneapi/dnnl/dnnl.hpp>

#define DIM_N 102400000

void test_linear(void)
{
    // Create execution dnnl::engine.
    // engine(kind akind, size_t index);
    dnnl::engine engine(dnnl::engine::kind::cpu, 0);

    // Create dnnl::stream.
    dnnl::stream engine_stream(engine);
 
    dnnl::memory::dims src_dims = {DIM_N};

    std::vector<float> src1_data(DIM_N);
    std::vector<float> dst_data(DIM_N);

    std::generate(src1_data.begin(), src1_data.end(), [](){static int i = 0; return i++;});

    auto src_md = dnnl::memory::desc(src_dims, dnnl::memory::data_type::f32, dnnl::memory::format_tag::x);
    auto dst_md = dnnl::memory::desc(src_dims, dnnl::memory::data_type::f32, dnnl::memory::format_tag::x);

    
    auto start = std::chrono::steady_clock::now();
    // Create operation descriptor.
    auto eltwise_d = dnnl::eltwise_forward::desc(dnnl::prop_kind::forward_inference, dnnl::algorithm::eltwise_linear,
                                                 src_md, 0.5f, 1.0f);

    // Create primitive descriptor.
    auto eltwise_pd = dnnl::eltwise_forward::primitive_desc(eltwise_d, engine);

    // Create the primitive.
    auto eltwise_prim = dnnl::eltwise_forward(eltwise_pd);

    auto end = std::chrono::steady_clock::now();
    std::chrono::duration<double> elapsed_seconds = end-start;
    std::cout << "elapsed time: " << elapsed_seconds.count() << "s\n";
    //test
    dnnl::memory::dims tmp_src_dims = {DIM_N};
    std::vector<float> tmp_src1_data(DIM_N);
    std::vector<float> tmp_dst_data(DIM_N);

    std::generate(tmp_src1_data.begin(), tmp_src1_data.end(), [](){static int i = 0; return i++;});

    auto tmp_src_md = dnnl::memory::desc(tmp_src_dims, dnnl::memory::data_type::f32, dnnl::memory::format_tag::x);
    auto tmp_dst_md = dnnl::memory::desc(tmp_src_dims, dnnl::memory::data_type::f32, dnnl::memory::format_tag::x);
    auto tmp_src_mem = dnnl::memory(tmp_src_md, engine, tmp_src1_data.data());
    auto tmp_dst_mem = dnnl::memory(tmp_dst_md, engine, tmp_dst_data.data());

    // Primitive arguments.
    std::unordered_map<int, dnnl::memory> tmp_eltwise_args;
    tmp_eltwise_args.insert({DNNL_ARG_SRC, tmp_src_mem});
    tmp_eltwise_args.insert({DNNL_ARG_DST, tmp_dst_mem});

    // eltwise_d.data.alpha = 1.0;
    // Primitive execution: element-wise (ReLU).
    eltwise_prim.execute(engine_stream, tmp_eltwise_args);

    // Wait for the computation to finalize.
    engine_stream.wait();


    for(int64_t i=0; i < 128; i++)
    {
        std::cout<< "src1_data : " << tmp_src1_data[i] << std::endl;
    }
    std::cout << "..." << std::endl;
    std::cout << "________________________________" << std::endl;

    for(int64_t i=0; i < 128; i++)
    {
        std::cout<< "dst_data : " << tmp_dst_data[i] << std::endl;
    }
}

int main(void)
{
    test_linear();
}