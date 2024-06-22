cmake_minimum_required(VERSION 3.20)
project(x)

include(CMakeDependentOption) # cmake_dependent_option()

option(USE_FAKE "use fake?" ON)
cmake_dependent_option(USE_FOO "use foo?" ON "NOT USE_FAKE" OFF)

message(STATUS "USE_FOO: ${USE_FOO}")
