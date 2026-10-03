#include <stdlib.h>
#include <limits.h>

static long long best(int* nums, int n, int k) {
    const long long NEG = LLONG_MIN / 4;
    long long** dp = malloc((n + 1) * sizeof(long long*));
    for (int i = 0; i <= n; i++) {
        dp[i] = malloc((k + 1) * sizeof(long long));
        for (int j = 0; j <= k; j++) dp[i][j] = NEG;
        dp[i][0] = 0;
    }
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= k; j++) {
            long long skip = dp[i - 1][j];
            long long prev;
            if (i >= 2) prev = dp[i - 2][j - 1];
            else prev = (j == 1) ? 0 : NEG;
            long long take = prev + nums[i - 1];
            dp[i][j] = skip > take ? skip : take;
        }
    }
    long long ans = dp[n][k];
    for (int i = 0; i <= n; i++) free(dp[i]);
    free(dp);
    return ans;
}

int maxSizeSlices(int* slices, int slicesSize) {
    int total = slicesSize;
    int k = total / 3;
    if (k == 0) return 0;
    long long a = best(slices, total - 1, k);
    long long b = best(slices + 1, total - 1, k);
    return (int)(a > b ? a : b);
}
