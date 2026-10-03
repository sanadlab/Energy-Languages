/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
bool* kidsWithCandies(int* candies, int candiesSize, int extraCandies, int* returnSize) {
    int maxc = 0;
    for (int i = 0; i < candiesSize; i++)
        if (candies[i] > maxc) maxc = candies[i];
    bool* res = (bool*) malloc(sizeof(bool) * candiesSize);
    for (int i = 0; i < candiesSize; i++)
        res[i] = (candies[i] + extraCandies >= maxc);
    *returnSize = candiesSize;
    return res;
}
