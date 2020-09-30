#include <stdlib.h>
#include <stdio.h>

int main()
{
    int count = 10;
    int *arr = malloc(count * sizeof(int));

    for (int i = 0; i < count; ++i) {
        arr[i] = count;
    }

    for (int i = 0; i < count; ++i) {
        printf("%d\n", arr[i]);
    }

    return 0;
}