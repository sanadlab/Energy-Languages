public class Solution {
    private int Best(int[] pre, int n, int L, int M) {
        int res = 0, maxL = 0;
        for (int i = L + M; i <= n; i++) {
            maxL = Math.Max(maxL, pre[i - M] - pre[i - M - L]);
            res = Math.Max(res, maxL + pre[i] - pre[i - M]);
        }
        return res;
    }
    public int MaxSumTwoNoOverlap(int[] nums, int firstLen, int secondLen) {
        int n = nums.Length;
        int[] pre = new int[n + 1];
        for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + nums[i];
        return Math.Max(Best(pre, n, firstLen, secondLen), Best(pre, n, secondLen, firstLen));
    }
}
