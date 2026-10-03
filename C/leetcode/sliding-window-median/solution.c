#include <stdlib.h>

static int cmp_int(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    return (x > y) - (x < y);
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
double* medianSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    int cnt = numsSize - k + 1;
    if (cnt < 0) cnt = 0;
    double* res = (double*) malloc(sizeof(double) * (cnt > 0 ? cnt : 1));
    int* w = (int*) malloc(sizeof(int) * (k > 0 ? k : 1));
    for (int i = 0; i < cnt; i++) {
        for (int j = 0; j < k; j++) w[j] = nums[i + j];
        qsort(w, k, sizeof(int), cmp_int);
        double median;
        if (k % 2 == 1) median = (double) w[k / 2];
        else median = ((double) w[k / 2 - 1] + (double) w[k / 2]) / 2.0;
        res[i] = median;
    }
    free(w);
    *returnSize = cnt;
    return res;
}
