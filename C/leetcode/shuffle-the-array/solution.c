#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* shuffle(int* nums, int numsSize, int n, int* returnSize){
    int m = numsSize / 2;
    int* res = (int*) malloc(sizeof(int) * numsSize);
    for (int i = 0; i < m; i++) {
        res[2 * i]     = nums[i];
        res[2 * i + 1] = nums[i + m];
    }
    *returnSize = numsSize;
    return res;
}
