#include <iostream>
#include <gflags/gflags.h>

// 定义gflags
DEFINE_bool(foo, false, "a simple gflags named foo, default value is flase, wuruilong, 2018-08-16");
DEFINE_int32(thread_num, 10, "thread number, default value is 10, wuruilong, 2018-08-16");

int main(int argc, char **argv) {
	// 解析gflags参数，只需要1行代码
	google::ParseCommandLineFlags(&argc, &argv, true);

	// 使用gflags
	if (FLAGS_foo) {
		std::cout << "foo is true" << std::endl;
	}
	else {
		std::cout << "foo is false" << std::endl;
	}

	// 使用gflags
	int thread_num = FLAGS_thread_num;
	std::cout << "thread number:" << thread_num << std::endl;
	return 0;
}