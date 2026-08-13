class Solution {
public:
    vector<int> minSubsequence(vector<int>& nums) {
        sort(nums.begin(), nums.end(), greater<int>());
        long total = 0;
        for (int x : nums) total += x;
        long running = 0;
        vector<int> res;
        for (int x : nums) {
            running += x;
            res.push_back(x);
            if (running * 2 > total) break;
        }
        return res;
    }
};
