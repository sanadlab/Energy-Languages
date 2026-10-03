int minStartValue(int* nums, int numsSize) {
    int prefix = 0, min_prefix = 0;
    for (int i = 0; i < numsSize; i++) {
        prefix += nums[i];
        if (prefix < min_prefix) min_prefix = prefix;
    }
    int cand = 1 - min_prefix;
    return cand > 1 ? cand : 1;
}
