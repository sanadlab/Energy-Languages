#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* nextGreaterElements(int* nums, int numsSize, int* returnSize) {
    int n = numsSize;
    int* res = (int*) malloc(sizeof(int) * (n > 0 ? n : 1));
    for (int i = 0; i < n; i++) res[i] = -1;
    int* st = (int*) malloc(sizeof(int) * (n > 0 ? n : 1));
    int top = 0;
    for (int i = 0; i < 2 * n; i++) {
        int cur = nums[i % n];
        while (top > 0 && nums[st[top - 1]] < cur) {
            res[st[--top]] = cur;
        }
        if (i < n) st[top++] = i;
    }
    free(st);
    *returnSize = n;
    return res;
}
