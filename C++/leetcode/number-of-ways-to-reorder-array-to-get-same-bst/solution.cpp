class Solution {
    static const long long MOD = 1000000007LL;
    vector<vector<long long>> C;

    long long ways(const vector<int>& arr) {
        int m = (int)arr.size();
        if (m <= 2) return 1;
        int root = arr[0];
        vector<int> left, right;
        for (int i = 1; i < m; ++i) {
            if (arr[i] < root) left.push_back(arr[i]);
            else right.push_back(arr[i]);
        }
        return C[m - 1][(int)left.size()] * ways(left) % MOD * ways(right) % MOD;
    }

public:
    int numOfWays(vector<int>& nums) {
        int n = (int)nums.size();
        C.assign(n + 1, vector<long long>(n + 1, 0));
        for (int i = 0; i <= n; ++i) {
            C[i][0] = 1;
            for (int j = 1; j <= i; ++j)
                C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
        }
        return (int)((ways(nums) - 1 + MOD) % MOD);
    }
};
