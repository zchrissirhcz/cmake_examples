#include <gflags/gflags.h>
#include <glog/logging.h>
#include <glog/stl_logging.h>

int main(int argc, char* argv[]) {

  // Initialize Google's logging library.
  google::InitGoogleLogging(argv[0]);

  // Optional: parse command line flags
  //gflags::ParseCommandLineFlags(&argc, &argv, true);
  //FLAGS_logtostderr = 1;
  FLAGS_log_dir = "F:/zhangzhuo/debug/glog";

  LOG(INFO) << "Hello, world!";

  // glog/stl_logging.h allows logging STL containers.
  std::vector<int> x;
  x.push_back(1);
  x.push_back(2);
  x.push_back(3);
  LOG(INFO) << "ABC, it's easy as " << x;

  printf("hi, this is printed out from printf() \n");

  //google::ShutdownGoogleLogging();

  return 0;
}
