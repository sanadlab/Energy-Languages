#include <stdlib.h>

static long long gMOD = 1000000007LL;
static long long** gC;

static long long ways(int* arr, int m) {
    if (m <= 2) return 1;
    int root = arr[0];
    int* left = malloc(m * sizeof(int));
    int* right = malloc(m * sizeof(int));
    int ln = 0, rn = 0;
    for (int i = 1; i < m; i++) {
        if (arr[i] < root) left[ln++] = arr[i];
        else if (arr[i] > root) right[rn++] = arr[i];
    }
    long long res = gC[m - 1][ln] * ways(left, ln) % gMOD * ways(right, rn) % gMOD;
    free(left);
    free(right);
    return res;
}

int numOfWays(int* nums, int numsSize) {
    int n = numsSize;
    gMOD = 1000000007LL;
    gC = malloc((n + 1) * sizeof(long long*));
    for (int i = 0; i <= n; i++) {
        gC[i] = calloc(n + 1, sizeof(long long));
        gC[i][0] = 1;
        for (int j = 1; j <= i; j++)
            gC[i][j] = (gC[i - 1][j - 1] + gC[i - 1][j]) % gMOD;
    }
    long long res = ((ways(nums, n) - 1) % gMOD + gMOD) % gMOD;
    for (int i = 0; i <= n; i++) free(gC[i]);
    free(gC);
    return (int)res;
}
