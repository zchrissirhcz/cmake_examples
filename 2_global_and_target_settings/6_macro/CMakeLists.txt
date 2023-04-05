cmake_minimum_required(VERSION 3.20)
project(example)

# globally, affect all targets. not recommended
add_definitions(-Dfoo)  # ok. not recommended.
#add_definitions(pop)   # not ok

# globally, affect all targets. 
# Note: there is no "-D" required.
add_compile_definitions(bar)    # ok. not recommended.
add_compile_definitions(-Dyoh)  # ok. not recommended.


add_executable(main main.cpp)
target_compile_definitions(main PUBLIC -Dwater) # ok. Pick this!
target_compile_definitions(main PUBLIC spring)  # ok. Pick this!
target_compile_options(main PUBLIC -Dmusic) # ok. not recommended
#target_compile_options(main PUBLIC jazz) # not ok