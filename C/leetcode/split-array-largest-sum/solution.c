int splitArray(int* nums, int numsSize, int k) {
    long long lo = 0, hi = 0;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] > lo) lo = nums[i];
        hi += nums[i];
    }
    while (lo < hi) {
        long long mid = (lo + hi) / 2;
        long long cnt = 1, cur = 0;
        for (int i = 0; i < numsSize; i++) {
            if (cur + nums[i] > mid) {
                cnt++;
                cur = nums[i];
            } else {
                cur += nums[i];
            }
        }
        if (cnt <= k) hi = mid;
        else lo = mid + 1;
    }
    return (int)lo;
}
