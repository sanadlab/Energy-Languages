#include <stdlib.h>
#include <stdbool.h>

static bool backtrack(int k, int cur, int start, int* nums, int n, int target, bool* used) {
    if (k == 0) return true;
    if (cur == target) return backtrack(k - 1, 0, 0, nums, n, target, used);
    for (int i = start; i < n; i++) {
        if (used[i] || cur + nums[i] > target) continue;
        used[i] = true;
        if (backtrack(k, cur + nums[i], i + 1, nums, n, target, used)) return true;
        used[i] = false;
        if (cur == 0) break;
    }
    return false;
}

static int cmp_desc(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    return (x < y) - (x > y);
}

bool canPartitionKSubsets(int* nums, int numsSize, int k) {
    if (k <= 0 || numsSize < k) return false;
    long long total = 0;
    for (int i = 0; i < numsSize; i++) total += nums[i];
    if (total % k != 0) return false;
    int target = (int)(total / k);
    qsort(nums, numsSize, sizeof(int), cmp_desc);
    if (nums[0] > target) return false;
    bool* used = calloc(numsSize, sizeof(bool));
    bool res = backtrack(k, 0, 0, nums, numsSize, target, used);
    free(used);
    return res;
}
