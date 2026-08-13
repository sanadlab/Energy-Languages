public class Solution {
    const long MOD = 1000000007L;
    long[][] C;

    public int NumOfWays(int[] nums) {
        int n = nums.Length;
        C = new long[n + 1][];
        for (int i = 0; i <= n; i++) {
            C[i] = new long[n + 1];
            C[i][0] = 1;
            for (int j = 1; j <= i; j++)
                C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
        }
        return (int)((Ways(new List<int>(nums)) - 1 + MOD) % MOD);
    }

    long Ways(List<int> arr) {
        int m = arr.Count;
        if (m <= 2) return 1;
        int root = arr[0];
        var left = new List<int>();
        var right = new List<int>();
        for (int i = 1; i < m; i++) {
            if (arr[i] < root) left.Add(arr[i]);
            else right.Add(arr[i]);
        }
        return C[m - 1][left.Count] * Ways(left) % MOD * Ways(right) % MOD;
    }
}
