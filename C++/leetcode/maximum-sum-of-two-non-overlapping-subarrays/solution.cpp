class Solution {
    int best(vector<int>& pre, int n, int L, int M) {
        int res = 0, maxL = 0;
        for (int i = L + M; i <= n; ++i) {
            maxL = max(maxL, pre[i - M] - pre[i - M - L]);
            res = max(res, maxL + pre[i] - pre[i - M]);
        }
        return res;
    }
public:
    int maxSumTwoNoOverlap(vector<int>& nums, int firstLen, int secondLen) {
        int n = nums.size();
        vector<int> pre(n + 1, 0);
        for (int i = 0; i < n; ++i) pre[i + 1] = pre[i] + nums[i];
        return max(best(pre, n, firstLen, secondLen), best(pre, n, secondLen, firstLen));
    }
};
