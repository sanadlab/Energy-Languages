/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* findKDistantIndices(int* nums, int numsSize, int key, int k, int* returnSize) {
    int* res = (int*) malloc(sizeof(int) * (numsSize > 0 ? numsSize : 1));
    int cnt = 0;
    for (int i = 0; i < numsSize; i++) {
        bool ok = false;
        for (int j = 0; j < numsSize; j++) {
            int d = i - j; if (d < 0) d = -d;
            if (d <= k && nums[j] == key) { ok = true; break; }
        }
        if (ok) res[cnt++] = i;
    }
    *returnSize = cnt;
    return res;
}
