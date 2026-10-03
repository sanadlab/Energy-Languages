#include <stdlib.h>

static int cmp_desc(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    return (x < y) - (x > y);
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* minSubsequence(int* nums, int numsSize, int* returnSize) {
    qsort(nums, numsSize, sizeof(int), cmp_desc);
    long long total = 0;
    for (int i = 0; i < numsSize; i++) total += nums[i];
    int* res = (int*) malloc(sizeof(int) * (numsSize > 0 ? numsSize : 1));
    long long running = 0;
    int cnt = 0;
    for (int i = 0; i < numsSize; i++) {
        running += nums[i];
        res[cnt++] = nums[i];
        if (running * 2 > total) break;
    }
    *returnSize = cnt;
    return res;
}
