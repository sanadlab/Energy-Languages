typedef struct { int* nums; int n; } Solution;
Solution* solutionCreate(int* nums, int numsSize) {
    Solution* o = malloc(sizeof(Solution));
    o->nums = malloc(sizeof(int) * numsSize);
    memcpy(o->nums, nums, sizeof(int) * numsSize);
    o->n = numsSize;
    return o;
}
int solutionPick(Solution* obj, int target) {
    int cnt = 0, res = -1;
    for (int i = 0; i < obj->n; i++)
        if (obj->nums[i] == target) { cnt++; if (rand() % cnt == 0) res = i; }
    return res;
}
void solutionFree(Solution* obj) { free(obj->nums); free(obj); }
