#include <stdlib.h>

static int gcd_i(int a, int b) {
    while (b != 0) {
        int t = a % b;
        a = b;
        b = t;
    }
    return a;
}

int maxScore(int* nums, int numsSize) {
    int m = numsSize;
    int size = 1 << m;
    int* dp = (int*)calloc(size, sizeof(int));
    int best = 0;
    for (int mask = 0; mask < size; mask++) {
        int cnt = __builtin_popcount((unsigned)mask);
        if (cnt & 1) continue;
        int op = cnt / 2 + 1;
        for (int i = 0; i < m; i++) {
            if ((mask >> i) & 1) continue;
            for (int j = i + 1; j < m; j++) {
                if ((mask >> j) & 1) continue;
                int nm = mask | (1 << i) | (1 << j);
                int val = dp[mask] + op * gcd_i(nums[i], nums[j]);
                if (val > dp[nm]) {
                    dp[nm] = val;
                    if (val > best) best = val;
                }
            }
        }
    }
    free(dp);
    return best;
}
