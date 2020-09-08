cmake_minimum_required(VERSION 3.15)

project(openssl_example)

find_package(OpenSSL REQUIRED)

add_executable(client ssl-client.c)
add_executable(server ssl-server.c)
add_executable(man_in_middle SSL_man_in_middle.c)

set(DEP_LIBS
    OpenSSL::Crypto OpenSSL::SSL  # modern
    #${OPENSSL_SSL_LIBRARY} ${OPENSSL_CRYPTO_LIBRARY}  # old style
)

target_link_libraries(client ${DEP_LIBS})
target_link_libraries(server ${DEP_LIBS})
target_link_libraries(man_in_middle ${DEP_LIBS})

