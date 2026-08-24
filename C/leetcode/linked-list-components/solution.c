#include <stdbool.h>
#include <stdlib.h>
int numComponents(struct ListNode* head, int* nums, int numsSize) {
    int mx = 0;
    for (int i = 0; i < numsSize; i++) if (nums[i] > mx) mx = nums[i];
    char* seen = calloc(mx + 1, 1);
    for (int i = 0; i < numsSize; i++) seen[nums[i]] = 1;
    int cnt = 0;
    for (struct ListNode* p = head; p; p = p->next) {
        if (p->val <= mx && seen[p->val] && (!p->next || p->next->val > mx || !seen[p->next->val]))
            cnt++;
    }
    free(seen);
    return cnt;
}
