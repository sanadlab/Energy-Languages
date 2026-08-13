class Solution {
public:
    int gcd(int a, int b) { while (b != 0) { int t = a % b; a = b; b = t; } return a; }
    int maxScore(vector<int>& nums) {
        int m = nums.size();
        vector<int> dp(1 << m, 0);
        int best = 0;
        for (int mask = 0; mask < (1 << m); ++mask) {
            int cnt = __builtin_popcount(mask);
            if (cnt & 1) continue;
            int op = cnt / 2 + 1;
            for (int i = 0; i < m; ++i) {
                if ((mask >> i) & 1) continue;
                for (int j = i + 1; j < m; ++j) {
                    if ((mask >> j) & 1) continue;
                    int nm = mask | (1 << i) | (1 << j);
                    int val = dp[mask] + op * gcd(nums[i], nums[j]);
                    if (val > dp[nm]) dp[nm] = val;
                    if (dp[nm] > best) best = dp[nm];
                }
            }
        }
        return best;
    }
};
