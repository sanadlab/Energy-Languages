#include <stdlib.h>

static int cmp_bits(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    int bx = __builtin_popcount((unsigned) x), by = __builtin_popcount((unsigned) y);
    if (bx != by) return bx - by;
    return (x > y) - (x < y);
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* sortByBits(int* arr, int arrSize, int* returnSize) {
    qsort(arr, arrSize, sizeof(int), cmp_bits);
    int* res = (int*) malloc(sizeof(int) * (arrSize > 0 ? arrSize : 1));
    for (int i = 0; i < arrSize; i++) res[i] = arr[i];
    *returnSize = arrSize;
    return res;
}
