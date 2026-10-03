#include <stdlib.h>

int lengthOfLIS(int* nums, int numsSize) {
    int* tails = (int*)malloc(sizeof(int) * (numsSize > 0 ? numsSize : 1));
    int len = 0;
    for (int idx = 0; idx < numsSize; idx++) {
        int x = nums[idx];
        // bisect_left: leftmost position with tails[i] >= x
        int lo = 0, hi = len;
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            if (tails[mid] < x) lo = mid + 1;
            else hi = mid;
        }
        if (lo == len) tails[len++] = x;
        else tails[lo] = x;
    }
    free(tails);
    return len;
}
