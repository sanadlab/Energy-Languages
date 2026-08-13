class Solution {
    private int best(int[] pre, int n, int L, int M) {
        int res = 0, maxL = 0;
        for (int i = L + M; i <= n; i++) {
            maxL = Math.max(maxL, pre[i - M] - pre[i - M - L]);
            res = Math.max(res, maxL + pre[i] - pre[i - M]);
        }
        return res;
    }
    public int maxSumTwoNoOverlap(int[] nums, int firstLen, int secondLen) {
        int n = nums.length;
        int[] pre = new int[n + 1];
        for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + nums[i];
        return Math.max(best(pre, n, firstLen, secondLen), best(pre, n, secondLen, firstLen));
    }
}
