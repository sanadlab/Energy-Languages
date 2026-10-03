#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// binary search for value `v` in a strictly ascending array; returns index or -1
static int find_idx(int* arr, int n, int v) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (arr[mid] == v) return mid;
        if (arr[mid] < v) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}

bool canCross(int* stones, int stonesSize) {
    if (stonesSize >= 2 && stones[1] != 1) return false;
    if (stonesSize < 2) return false;

    // dp[i][k] == reachable at stone index i having jumped with size k.
    // k ranges 0..stonesSize+1 (grows by at most 1 per jump).
    int kdim = stonesSize + 2;
    char* dp = (char*)calloc((size_t)stonesSize * kdim, sizeof(char));

    // dp[value 1] (= index 1) reachable with jump size 1
    dp[(size_t)1 * kdim + 1] = 1;

    for (int i = 0; i < stonesSize; i++) {
        char* row = dp + (size_t)i * kdim;
        for (int k = 0; k < kdim; k++) {
            if (!row[k]) continue;
            for (int d = -1; d <= 1; d++) {
                int step = k + d;
                if (step <= 0) continue;
                int t = find_idx(stones, stonesSize, stones[i] + step);
                if (t >= 0) dp[(size_t)t * kdim + step] = 1;
            }
        }
    }

    char* last = dp + (size_t)(stonesSize - 1) * kdim;
    bool ans = false;
    for (int k = 0; k < kdim; k++) {
        if (last[k]) { ans = true; break; }
    }
    free(dp);
    return ans;
}
