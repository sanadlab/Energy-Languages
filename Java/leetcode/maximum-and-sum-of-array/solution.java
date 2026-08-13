class Solution {
    public int maximumANDSum(int[] nums, int numSlots) {
        int n = nums.length;
        int full = (1 << n) - 1;
        int[] dp = new int[1 << n];
        java.util.Arrays.fill(dp, -1);
        dp[0] = 0;
        for (int slot = 1; slot <= numSlots; slot++) {
            int[] ndp = dp.clone();
            for (int mask = 0; mask <= full; mask++) {
                if (dp[mask] < 0) continue;
                int base = dp[mask];
                for (int i = 0; i < n; i++) {
                    if (((mask >> i) & 1) == 1) continue;
                    int nm = mask | (1 << i);
                    int v = base + (nums[i] & slot);
                    if (v > ndp[nm]) ndp[nm] = v;
                    for (int j = i + 1; j < n; j++) {
                        if (((mask >> j) & 1) == 1) continue;
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
}
