set(GFLAGS_DIR "D:/lib/gflags/2.2.2/x64/vc12/lib/cmake/gflags")
set(GLOG_DIR "D:/lib/glog/0.4.0/x64/vc12/lib/cmake/glog")

find_package(glog 0.4.0 REQUIRED)
add_executable(glog_example src/glog_example.cpp)
target_link_libraries(glog_example glog::glog)
