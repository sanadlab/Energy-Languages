#include <stdlib.h>
#include <string.h>

int maximumANDSum(int* nums, int numsSize, int numSlots) {
    int n = numsSize;
    int size = 1 << n;
    int full = size - 1;

    int* dp = (int*)malloc(sizeof(int) * size);
    int* ndp = (int*)malloc(sizeof(int) * size);
    for (int i = 0; i < size; i++) dp[i] = -1;
    dp[0] = 0;

    for (int slot = 1; slot <= numSlots; slot++) {
        memcpy(ndp, dp, sizeof(int) * size);
        for (int mask = 0; mask < size; mask++) {
            if (dp[mask] < 0) continue;
            int base = dp[mask];
            for (int i = 0; i < n; i++) {
                if ((mask >> i) & 1) continue;
                int nm = mask | (1 << i);
                int v = base + (nums[i] & slot);
                if (v > ndp[nm]) ndp[nm] = v;
                for (int j = i + 1; j < n; j++) {
                    if ((mask >> j) & 1) continue;
                    int nm2 = nm | (1 << j);
                    int v2 = v + (nums[j] & slot);
                    if (v2 > ndp[nm2]) ndp[nm2] = v2;
                }
            }
        }
        int* tmp = dp; dp = ndp; ndp = tmp;
    }

    int ans = dp[full] >= 0 ? dp[full] : 0;
    free(dp);
    free(ndp);
    return ans;
}
