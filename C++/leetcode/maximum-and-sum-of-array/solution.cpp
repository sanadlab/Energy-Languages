class Solution {
public:
    int maximumANDSum(vector<int>& nums, int numSlots) {
        int n = nums.size();
        int full = (1 << n) - 1;
        vector<int> dp(1 << n, -1);
        dp[0] = 0;
        for (int slot = 1; slot <= numSlots; ++slot) {
            vector<int> ndp = dp;
            for (int mask = 0; mask <= full; ++mask) {
                if (dp[mask] < 0) continue;
                int base = dp[mask];
                for (int i = 0; i < n; ++i) {
                    if ((mask >> i) & 1) continue;
                    int nm = mask | (1 << i);
                    int v = base + (nums[i] & slot);
                    if (v > ndp[nm]) ndp[nm] = v;
                    for (int j = i + 1; j < n; ++j) {
                        if ((mask >> j) & 1) continue;
                        int nm2 = nm | (1 << j);
                        int v2 = v + (nums[j] & slot);
                        if (v2 > ndp[nm2]) ndp[nm2] = v2;
                    }
                }
            }
            dp = ndp;
        }
        return dp[full] < 0 ? 0 : dp[full];
    }
};
