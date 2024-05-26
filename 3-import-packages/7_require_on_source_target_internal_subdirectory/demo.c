#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "cJSON.h"

cJSON* basic_cjson_pkg(void)
{
    cJSON* root = cJSON_CreateObject();
    if (NULL == root) {
        return NULL;
    }
    cJSON_AddNumberToObject(root, "action", 666);
    cJSON* data = cJSON_CreateObject();
    if (NULL == data) {
        goto err1;
    }
    cJSON_AddStringToObject(data, "user", "Sky.J");
    cJSON_AddStringToObject(data, "pwd", "123456");
    cJSON_AddItemToObject(root, "data", data);
    return root;
err1:
    cJSON_Delete(root);
    return NULL;
}

void basic_cjson_sys(cJSON* root)
{
    if (NULL == root) {
        return;
    }
    //将json包转为字符串显示，一般我们使用时选择str1，str2这种方式是更加容易我们观看的方式
    char* str1 = cJSON_PrintUnformatted(root);
    char* str2 = cJSON_Print(root);
    printf("str1: \r\n%s\r\n", str1);
    printf("str2: \r\n%s\r\n", str2);
    cJSON_Delete(root);
    free(str2);
    //一般我们接收到的也是cjson类型的字符串str1，下面解析
    //将字符串格式cjson数据转为cJSON类型数据
    cJSON* sys_root = cJSON_Parse(str1);
    if (NULL == sys_root) {
        goto err1;
    }
    cJSON* action = cJSON_GetObjectItem(sys_root, "action");
    if (NULL == action) {
        goto err2;
    }
    int action_value = action->valueint;

    cJSON* data = cJSON_GetObjectItem(sys_root, "data");
    if (NULL == data) {
        goto err2;
    }

    cJSON* user = cJSON_GetObjectItem(data, "user");
    if (NULL == user) {
        goto err2;
    }
    char* user_value = user->valuestring;

    cJSON* pwd = cJSON_GetObjectItem(data, "pwd");
    if (NULL == pwd) {
        goto err2;
    }
    char* pwd_value = pwd->valuestring;

    printf("action = %d, user = %s, pwd = %s\r\n", action_value, user_value, pwd_value);
err2:
    cJSON_Delete(sys_root);
err1:
    free(str1);
    return;
}

cJSON* array_cjson_pkg(void)
{
    int i;
    char buffer[20];
    cJSON* root = cJSON_CreateObject();
    if (NULL == root) {
        return NULL;
    }
    cJSON_AddNumberToObject(root, "action", 888);
    cJSON* data = cJSON_CreateObject();
    if (NULL == data) {
        goto err1;
    }
    cJSON_AddItemToObject(root, "data", data);
    cJSON* rows = cJSON_CreateArray();
    if (NULL == rows) {
        goto err1;
    }
    cJSON_AddItemToObject(data, "rows", rows);
    for (i = 0; i < 3; i++) {
        memset(buffer, 0, sizeof(buffer));
        snprintf(buffer, sizeof(buffer), "user%d", i);
        cJSON* row = cJSON_CreateObject();
        if (NULL == row) {
            goto err1;
        }
        //将新建项目插入数组中
        cJSON_AddItemToArray(rows, row);
        //添加详细信息
        cJSON_AddStringToObject(row, "user", buffer);
        cJSON_AddStringToObject(row, "pwd", "123456");
    }
    return root;
err1:
    cJSON_Delete(root);
    return NULL;
}

void array_cjson_sys(cJSON* root)
{
    if (NULL == root) {
        return;
    }
    //将json包转为字符串显示，一般我们使用时选择str1，str2这种方式是更加容易我们观看的方式
    char* str1 = cJSON_PrintUnformatted(root);
    char* str2 = cJSON_Print(root);
    printf("str1: \r\n%s\r\n\r\n", str1);
    printf("str2: \r\n%s\r\n\r\n", str2);
    cJSON_Delete(root);
    free(str2);
    //一般我们接收到的也是cjson类型的字符串str1，下面解析
    //将字符串格式cjson数据转为cJSON类型数据
    cJSON* sys_root = cJSON_Parse(str1);
    if (NULL == sys_root) {
        goto err1;
    }
    cJSON* action = cJSON_GetObjectItem(sys_root, "action");
    if (NULL == action) {
        goto err2;
    }
    int action_value = action->valueint;

    cJSON* data = cJSON_GetObjectItem(root, "data");
    if (NULL == data) {
        goto err2;
    }
    //解析数组
    cJSON* rows = cJSON_GetObjectItem(data, "rows");
    if (NULL == rows) {
        goto err2;
    }
    int array_cnt = cJSON_GetArraySize(rows);
    printf("\r\naction = %d, array_cnt = %d\r\n", action_value, array_cnt);
    int i;
    for (i = 0; i < array_cnt; i++) {
        //取出单个数组
        cJSON* row = cJSON_GetArrayItem(rows, i);
        if (NULL == row) {
            goto err2;
        }
        cJSON* user = cJSON_GetObjectItem(row, "user");
        if (NULL == user) {
            goto err2;
        }
        cJSON* pwd = cJSON_GetObjectItem(row, "pwd");
        if (NULL == pwd) {
            goto err2;
        }
        printf("user: %s, pwd: %s\r\n", user->valuestring, pwd->valuestring);
    }
err2:
    cJSON_Delete(sys_root);
err1:
    free(str1);
    return;
}



int main()
{
#if 1
    cJSON* root = basic_cjson_pkg();
    basic_cjson_sys(root);
#else
    cJSON* root = array_cjson_pkg();
    array_cjson_sys(root);
#endif
    return 0;
}

