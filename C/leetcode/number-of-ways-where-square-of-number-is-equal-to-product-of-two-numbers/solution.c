#include <stdlib.h>
#include <string.h>

static long long helper(int* a, int an, int* b, int bn) {
    long long cnt = 0;
    int maxB = 0;
    for (int j = 0; j < bn; j++) if (b[j] > maxB) maxB = b[j];
    int* seen = calloc((size_t)maxB + 1, sizeof(int));
    for (int i = 0; i < an; i++) {
        long long t = (long long)a[i] * a[i];
        memset(seen, 0, ((size_t)maxB + 1) * sizeof(int));
        for (int j = 0; j < bn; j++) {
            int y = b[j];
            if (t % y == 0) {
                long long need = t / y;
                if (need <= maxB) cnt += seen[need];
            }
            seen[y]++;
        }
    }
    free(seen);
    return cnt;
}

int numTriplets(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    return (int)(helper(nums1, nums1Size, nums2, nums2Size) +
                 helper(nums2, nums2Size, nums1, nums1Size));
}
