#include <stdlib.h>

int maxEqualFreq(int* nums, int numsSize) {
    int n = numsSize;
    int* count = (int*)calloc(100001, sizeof(int));
    int* freq = (int*)calloc((size_t)n + 1, sizeof(int));
    int maxF = 0, res = 0;

    for (int i = 0; i < n; i++) {
        int v = nums[i];
        if (count[v] > 0) freq[count[v]] -= 1;
        count[v] += 1;
        freq[count[v]] += 1;
        if (count[v] > maxF) maxF = count[v];
        if (maxF == 1
                || (long long)freq[maxF] * maxF == i
                || (freq[maxF] == 1 && (long long)(maxF - 1) * (freq[maxF - 1] + 1) == i)) {
            res = i + 1;
        }
    }
    free(count);
    free(freq);
    return res;
}
