class Solution {
    vector<int> nums;
public:
    Solution(vector<int>& nums) : nums(nums) {}

    int pick(int target) {
        // Reservoir sampling over the indices whose value == target.
        int count = 0;
        int res = -1;
        for (int i = 0; i < (int)nums.size(); i++) {
            if (nums[i] == target) {
                count++;
                if (rand() % count == 0) {
                    res = i;
                }
            }
        }
        return res;
    }
};
