function(CHECK_GLIBC_VERSION FOUND_GLIBC GLIBC_VERSION)
  # currently we only consider GCC and Clang for GLIBC version determination
  # AppleClang is ignored
  set(FOUND_GLIBC FALSE)
  set(GLIBC_VERSION "")
  if(CMAKE_C_COMPILER_ID MATCHES "^(GNU|Clang)$")
    set(FOUND_GLIBC TRUE)
    execute_process (
        COMMAND ${CMAKE_C_COMPILER} -print-file-name=libc.so.6
        OUTPUT_VARIABLE GLIBC_PATH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    execute_process (
      COMMAND ${GLIBC_PATH}
      OUTPUT_VARIABLE GLIBC_OUTPUT
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    # convert \n to ; and remove the last ;
    string (REPLACE "\n" ";" GLIBC_OUTPUT ${GLIBC_OUTPUT})
    # only keep the first element
    list (GET GLIBC_OUTPUT 0 first_line)
    # convert space to ; and remove the last ;
    string (REPLACE " " ";" first_line ${first_line})
    # only keep the last element
    list(LENGTH first_line len)
    math(EXPR last_index "${len} - 1")
    list(GET first_line ${last_index} GLIBC_VERSION)
    # GLIBC_VERSION should ends with number, other stuff should be removed
    string(REGEX REPLACE "[^0-9]$" "" GLIBC_VERSION ${GLIBC_VERSION})
  endif()

  set(FOUND_GLIBC ${FOUND_GLIBC} PARENT_SCOPE)
  set(GLIBC_VERSION ${GLIBC_VERSION} PARENT_SCOPE)
endfunction()