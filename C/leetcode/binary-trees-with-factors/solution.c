#include <stdlib.h>

static int cmp_int(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    return (x > y) - (x < y);
}

int numFactoredBinaryTrees(int* arr, int arrSize) {
    const long long MOD = 1000000007LL;
    qsort(arr, arrSize, sizeof(int), cmp_int);
    long long* dp = malloc(arrSize * sizeof(long long));
    for (int i = 0; i < arrSize; i++) {
        long long cnt = 1;
        int v = arr[i];
        for (int j = 0; j < i; j++) {
            int a = arr[j];
            if (v % a == 0) {
                int b = v / a;
                // binary search for b in arr[0..i-1]
                int lo = 0, hi = i - 1, idx = -1;
                while (lo <= hi) {
                    int mid = (lo + hi) / 2;
                    if (arr[mid] == b) { idx = mid; break; }
                    else if (arr[mid] < b) lo = mid + 1;
                    else hi = mid - 1;
                }
                if (idx != -1) {
                    cnt = (cnt + dp[j] * dp[idx]) % MOD;
                }
            }
        }
        dp[i] = cnt % MOD;
    }
    long long sum = 0;
    for (int i = 0; i < arrSize; i++) sum = (sum + dp[i]) % MOD;
    free(dp);
    return (int)sum;
}
