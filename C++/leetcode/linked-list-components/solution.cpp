struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution {
public:
    int numComponents(ListNode* head, vector<int>& nums) {
        unordered_set<int> s(nums.begin(), nums.end());
        int count = 0;
        bool prev = false;
        while (head) {
            bool cur = s.count(head->val) > 0;
            if (cur && !prev) count++;
            prev = cur;
            head = head->next;
        }
        return count;
    }
};
