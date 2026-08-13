class Solution {
public:
    vector<int> shuffle(vector<int>& nums, int n) {
        int m = nums.size() / 2;
        vector<int> res;
        res.reserve(2 * m);
        for (int i = 0; i < m; i++) {
            res.push_back(nums[i]);
            res.push_back(nums[i + m]);
        }
        return res;
    }
};
