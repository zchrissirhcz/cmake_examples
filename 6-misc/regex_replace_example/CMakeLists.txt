cmake_minimum_required(VERSION 3.15)

project(hh)

#正则模式串中，如果出现了小括号，那么输入的字符中，匹配到的部分，可以用(n)的方式来表示
#而在REGEX REPLACE的语法中，作为匹配后的被替换到的内容，可以用\\n来表示
#具体来说，\0表示整个匹配的结果，\1表示第一个匹配的子表达式，\2表示第二个匹配的子表达式
#而为了应对双引号中的字符转义，原本的\n要用\\n来表示

#----------------
# 输出ChrisZZ.67
string(REGEX REPLACE "([0-9]+).([0-9]+)" "ChrisZZ" out1 "123.45.67")

# 输出123.45.67
string(REGEX REPLACE "([0-9]+).([0-9]+)" "\\0" out2 "123.45.67")

# 输出45.67
string(REGEX REPLACE "([0-9]+).([0-9]+)" "\\2" out3 "123.45.67")

# 输出1234567
string(REGEX REPLACE "([0-9]+)r" "\\1" out4 "12r3r4567")


message(STATUS "--- out1: ${out1}")
message(STATUS "--- out2: ${out2}")
message(STATUS "--- out3: ${out3}")
message(STATUS "--- out4: ${out4}")
#----------------


# 针对.这个字符，需要特别关照一下
string(REGEX REPLACE "([0-9]+)" "\\0" output1 "12.3.45")

# cmake的正则表达式中，.表示任意字符，用"."来匹配:
#输出1234，因为12被匹配一次， 3.被匹配一次，45被匹配一次
string(REGEX REPLACE "[0-9]." "-" output2 "12.3.45")

# 如果要匹配一个数字和.这个字符（而不是任意字符），则应当用"\\."
#输出12345, 因为\\.匹配到了.字符
string(REGEX REPLACE "([0-9]+)\\." "\\1" output3 "12.3.45")

# 但如果是\.这样的表示，就比较蛋疼了。
# 它表示的是任意字符，而不是.这个字符
string(REGEX REPLACE "([0-9]+)\." "\\1" output4 "12.3.45")


#string(REGEX REPLACE "([0-9]+)\.([0-9]+)\." "\\1" output3 "12.3.45")

message("output1: " ${output1})
message("output2: " ${output2})
message("output3: " ${output3})
message("output4: " ${output4})


# 这个好理解，匹配上的话就放到output var里。
string(REGEX MATCHALL "([0-9]+)" f1 "12.3.45")
string(REGEX MATCHALL "([0-9]+)\." f2 "12.3.45")
string(REGEX MATCHALL "([0-9]+)\.([0-9]+)\." f3 "12.3.45")

message("f1: " ${f1})
message("f2: " ${f2})
message("f3: " ${f3})


if( "12.3.45"  MATCHES "([0-9])\." )
    message(STATUS "--- CMAKE_MATCH_COUNT is: ${CMAKE_MATCH_COUNT}")
    message(STATUS "--- CMAKE_MATCH_0 is: ${CMAKE_MATCH_0}")
    message(STATUS "--- CMAKE_MATCH_1 is: ${CMAKE_MATCH_1}")
endif()

if( "12.3.45  12.3.45"  MATCHES "([0-9]+)\." )
    message(STATUS "--- CMAKE_MATCH_COUNT is: ${CMAKE_MATCH_COUNT}")
    message(STATUS "--- CMAKE_MATCH_0 is: ${CMAKE_MATCH_0}")
endif()
#string(REGEX MATCHALL "([0-9]+)\.([0-9]+)\." fuck3 "12.3.45")



