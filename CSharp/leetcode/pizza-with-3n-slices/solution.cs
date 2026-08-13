public class Solution {
    public int MaxSizeSlices(int[] slices) {
        int total = slices.Length;
        int k = total / 3;
        if (k == 0) return 0;
        int[] a = new int[total - 1];
        int[] b = new int[total - 1];
        Array.Copy(slices, 0, a, 0, total - 1);
        Array.Copy(slices, 1, b, 0, total - 1);
        return Math.Max(Best(a, k), Best(b, k));
    }

    private int Best(int[] nums, int k) {
        int n = nums.Length;
        long NEG = long.MinValue / 4;
        long[,] dp = new long[n + 1, k + 1];
        for (int i = 0; i <= n; i++)
            for (int j = 1; j <= k; j++)
                dp[i, j] = NEG;
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= k; j++) {
                long skip = dp[i - 1, j];
                long prev = (i >= 2) ? dp[i - 2, j - 1] : (j == 1 ? 0L : NEG);
                long take = prev + nums[i - 1];
                dp[i, j] = Math.Max(skip, take);
            }
        }
        return (int)dp[n, k];
    }
}
