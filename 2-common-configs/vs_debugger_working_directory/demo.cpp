#include <stdio.h>

int main()
{
    // read input.txt's content, and print to console, line by line
    FILE *file = fopen("input.txt", "r");
    if (file == NULL)
    {
        printf("File not found\n");
        return 1;
    }

    char line[100];
    while (fgets(line, sizeof(line), file))
    {
        printf("%s", line);
    }
    
    fclose(file);

    return 0;
}