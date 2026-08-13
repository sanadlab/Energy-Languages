class Solution {
public:
    bool backtrack(vector<int>& nums, vector<bool>& used, int k, long cur, int start, long target) {
        if (k == 0) return true;
        if (cur == target) return backtrack(nums, used, k - 1, 0, 0, target);
        for (int i = start; i < (int)nums.size(); i++) {
            if (used[i]) continue;
            if (cur + nums[i] > target) continue;
            used[i] = true;
            if (backtrack(nums, used, k, cur + nums[i], i + 1, target)) return true;
            used[i] = false;
            if (cur == 0) break;
        }
        return false;
    }
    bool canPartitionKSubsets(vector<int>& nums, int k) {
        if (k <= 0 || (int)nums.size() < k) return false;
        long sum = 0;
        for (int x : nums) sum += x;
        if (sum % k != 0) return false;
        long target = sum / k;
        sort(nums.rbegin(), nums.rend());
        if (nums[0] > target) return false;
        vector<bool> used(nums.size(), false);
        return backtrack(nums, used, k, 0, 0, target);
    }
};
