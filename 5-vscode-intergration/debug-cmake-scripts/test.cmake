message("Welcom to CMake script mode!")
message("Hello, ${HELLO}")

message(STATUS "CMAKE_ARGC: ${CMAKE_ARGC}")
foreach(_arg RANGE ${CMAKE_ARGC})
  message(STATUS "${_arg}: ${CMAKE_ARGV${_arg}}")
endforeach()

function(add_numbers num1 num2 OUTPUT_VAR)
  math(EXPR output "${num1} + ${num2}")
  set(${OUTPUT_VAR} ${output} PARENT_SCOPE)
endfunction()

set(my_result 0)

add_numbers(5 3 my_result)

message("5 + 3 = ${my_result}")
message("bye~")