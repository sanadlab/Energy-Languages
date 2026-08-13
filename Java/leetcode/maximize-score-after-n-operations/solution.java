class Solution {
    public int maxScore(int[] nums) {
        int m = nums.length;
        int[] dp = new int[1 << m];
        int best = 0;
        for (int mask = 0; mask < (1 << m); mask++) {
            int cnt = Integer.bitCount(mask);
            if ((cnt & 1) == 1) continue;
            int op = cnt / 2 + 1;
            for (int i = 0; i < m; i++) {
                if (((mask >> i) & 1) == 1) continue;
                for (int j = i + 1; j < m; j++) {
                    if (((mask >> j) & 1) == 1) continue;
                    int nm = mask | (1 << i) | (1 << j);
                    int val = dp[mask] + op * gcd(nums[i], nums[j]);
                    if (val > dp[nm]) dp[nm] = val;
                    if (dp[nm] > best) best = dp[nm];
                }
            }
        }
        return best;
    }
    int gcd(int a, int b) { while (b != 0) { int t = a % b; a = b; b = t; } return a; }
}
