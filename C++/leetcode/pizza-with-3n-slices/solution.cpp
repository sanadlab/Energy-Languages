class Solution {
public:
    int maxSizeSlices(vector<int>& slices) {
        int total = slices.size();
        int k = total / 3;
        if (k == 0) return 0;
        vector<int> a(slices.begin(), slices.end() - 1);
        vector<int> b(slices.begin() + 1, slices.end());
        return max(best(a, k), best(b, k));
    }

private:
    int best(vector<int>& nums, int k) {
        int n = nums.size();
        const long long NEG = LLONG_MIN / 4;
        vector<vector<long long>> dp(n + 1, vector<long long>(k + 1, NEG));
        for (int i = 0; i <= n; i++) dp[i][0] = 0;
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= k; j++) {
                long long skip = dp[i - 1][j];
                long long prev = (i >= 2) ? dp[i - 2][j - 1] : (j == 1 ? 0LL : NEG);
                long long take = prev + nums[i - 1];
                dp[i][j] = max(skip, take);
            }
        }
        return (int)dp[n][k];
    }
};
