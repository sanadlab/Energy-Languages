#include <stdlib.h>

static int bestLM(long long* pre, int n, int L, int M) {
    long long res = 0, maxL = 0;
    for (int i = L + M; i <= n; i++) {
        long long cand = pre[i - M] - pre[i - M - L];
        if (cand > maxL) maxL = cand;
        long long cur = maxL + pre[i] - pre[i - M];
        if (cur > res) res = cur;
    }
    return (int)res;
}

int maxSumTwoNoOverlap(int* nums, int numsSize, int firstLen, int secondLen) {
    int n = numsSize;
    long long* pre = (long long*)malloc((n + 1) * sizeof(long long));
    pre[0] = 0;
    for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + nums[i];
    int a = bestLM(pre, n, firstLen, secondLen);
    int b = bestLM(pre, n, secondLen, firstLen);
    free(pre);
    return a > b ? a : b;
}
