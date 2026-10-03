int countMaxOrSubsets(int* nums, int numsSize) {
    int max_or = 0;
    for (int i = 0; i < numsSize; i++) max_or |= nums[i];

    int count = 0;
    for (long mask = 1; mask < (1L << numsSize); mask++) {
        int cur = 0;
        for (int i = 0; i < numsSize; i++) {
            if (mask & (1L << i)) cur |= nums[i];
        }
        if (cur == max_or) count++;
    }
    return count;
}
