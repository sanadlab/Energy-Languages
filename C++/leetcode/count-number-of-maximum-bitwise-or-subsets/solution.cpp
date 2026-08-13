class Solution {
public:
    int countMaxOrSubsets(vector<int>& nums) {
        int n = (int)nums.size();
        int maxOr = 0;
        // First find the maximum OR possible from all elements
        for (int num : nums) {
            maxOr |= num;
        }
        
        int count = 0;
        // There are at most 2^n subsets, n <= 16 so this is feasible
        int total = 1 << n;
        for (int mask = 1; mask < total; ++mask) {
            int currOr = 0;
            for (int i = 0; i < n; ++i) {
                if (mask & (1 << i)) {
                    currOr |= nums[i];
                }
            }
            if (currOr == maxOr) {
                ++count;
            }
        }
        return count;
    }
};