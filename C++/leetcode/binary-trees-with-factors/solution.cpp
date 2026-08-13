class Solution {
public:
    int numFactoredBinaryTrees(vector<int>& arr) {
        sort(arr.begin(), arr.end());
        const long long MOD = 1000000007LL;
        unordered_map<int, long long> dp;
        long long ans = 0;
        int n = arr.size();
        for (int i = 0; i < n; i++) {
            long long cnt = 1;
            for (int j = 0; j < i; j++) {
                if (arr[i] % arr[j] == 0) {
                    int b = arr[i] / arr[j];
                    auto it = dp.find(b);
                    if (it != dp.end()) {
                        cnt = (cnt + dp[arr[j]] * it->second) % MOD;
                    }
                }
            }
            dp[arr[i]] = cnt;
            ans = (ans + cnt) % MOD;
        }
        return (int)ans;
    }
};
