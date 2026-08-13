import java.util.*;

class Solution {
    private static final long MOD = 1000000007L;
    private long[][] C;

    public int numOfWays(int[] nums) {
        int n = nums.length;
        C = new long[n + 1][n + 1];
        for (int i = 0; i <= n; i++) {
            C[i][0] = 1;
            for (int j = 1; j <= i; j++)
                C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
        }
        List<Integer> list = new ArrayList<>();
        for (int x : nums) list.add(x);
        return (int)((ways(list) - 1 + MOD) % MOD);
    }

    private long ways(List<Integer> arr) {
        int m = arr.size();
        if (m <= 2) return 1;
        int root = arr.get(0);
        List<Integer> left = new ArrayList<>();
        List<Integer> right = new ArrayList<>();
        for (int i = 1; i < m; i++) {
            if (arr.get(i) < root) left.add(arr.get(i));
            else right.add(arr.get(i));
        }
        return C[m - 1][left.size()] * ways(left) % MOD * ways(right) % MOD;
    }
}
