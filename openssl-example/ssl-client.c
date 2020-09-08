
#include <stdio.h> 
#include <string.h> 
#include <errno.h> 
#include <sys/socket.h> 
#include <resolv.h> 
#include <stdlib.h> 
#include <netinet/in.h> 
#include <arpa/inet.h> 
#include <unistd.h> 
#include <openssl/ssl.h> 
#include <openssl/err.h> 

#define MAXBUF 1024 

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

int main(int argc, char * *argv) 
{
    int sockfd, len;
    struct sockaddr_in dest;
    char buffer[MAXBUF + 1];
    SSL_CTX * ctx;
    SSL * ssl;
    if (argc != 3) 
    {
        printf("参数格式错误！正确用法如下：\n\t\t%s IP 地址端口\n\t 比如:\t%s 127.0.0.1 80\n 此程序用来从某个IP 地址的服务器某个端口接收最多MAXBUF 个字节的消息",
 argv[0], argv[0]);
        exit(0);
    }
    /* SSL 库初始化*/
    SSL_library_init();
    /* 载入所有SSL 算法*/
    OpenSSL_add_all_algorithms();
    /* 载入所有SSL 错误消息*/
    SSL_load_error_strings();
    /* 以SSL V2 和V3 标准兼容方式产生一个SSL_CTX ，即SSL Content Text */
    ctx = SSL_CTX_new(SSLv23_client_method());
    if (ctx == NULL) 
    {
        ERR_print_errors_fp(stdout);
        exit(1);
    }
    /* 创建一个socket 用于tcp 通信*/
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) 
    {
        perror("Socket");
        exit(errno);
    }
    printf("socket created\n");
    /* 初始化服务器端（对方）的地址和端口信息*/
    bzero( &dest, sizeof(dest));
    dest.sin_family = AF_INET;
    //设置连接的端口
    dest.sin_port = htons(atoi(argv[2]));
    //设置连接的IP地址
    if (inet_aton(argv[1], (struct in_addr * ) &dest.sin_addr.s_addr) == 0) 
    {
        perror(argv[1]);
        exit(errno);
    }
    printf("address created\n");
    /* 连接服务器*/
    if (connect(sockfd, (struct sockaddr * ) &dest, sizeof(dest)) != 0) 
    {
        perror("Connect ");
        exit(errno);
    }
    printf("server connected\n");
    /* 基于ctx 产生一个新的SSL */
    ssl = SSL_new(ctx);
    /* 将新连接的socket 加入到SSL */
    SSL_set_fd(ssl, sockfd);
    /* 建立SSL 连接*/
    if (SSL_connect(ssl) == -1) 
    {
        ERR_print_errors_fp(stderr);
    }
    else 
    {
        printf("Connected with %s encryption\n", SSL_get_cipher(ssl));
        ShowCerts(ssl);
    }
    /* 接收对方发过来的消息，最多接收MAXBUF 个字节*/
    bzero(buffer, MAXBUF + 1);
    /* 接收服务器来的消息*/
    len = SSL_read(ssl, buffer, MAXBUF);
    if (len > 0) 
    {
        printf("接收消息成功:'%s'，共%d 个字节的数据\n", buffer, len);
    }
    else 
    {
        printf("消息接收失败！错误代码是%d，错误信息是'%s'\n", errno, strerror(errno));
        goto finish;
    }
    bzero(buffer, MAXBUF + 1);
    strcpy(buffer, "from client->server");
    /* 发消息给服务器*/
    len = SSL_write(ssl, buffer, strlen(buffer));
    if (len < 0) 
    {
        printf("消息'%s'发送失败！错误代码是%d，错误信息是'%s'\n", buffer, errno, strerror(errno));
    }
    else 
    {
        printf("消息'%s'发送成功，共发送了%d 个字节！\n", buffer, len);
    }
    finish:
    /* 关闭连接*/
    SSL_shutdown(ssl);
    SSL_free(ssl);
    close(sockfd);
    SSL_CTX_free(ctx);
    return 0;
}
