public class Solution {
    public int NumFactoredBinaryTrees(int[] arr) {
        Array.Sort(arr);
        const long MOD = 1000000007L;
        var dp = new Dictionary<int, long>();
        long ans = 0;
        for (int i = 0; i < arr.Length; i++) {
            long cnt = 1;
            for (int j = 0; j < i; j++) {
                if (arr[i] % arr[j] == 0) {
                    int b = arr[i] / arr[j];
                    if (dp.TryGetValue(b, out long bv)) {
                        cnt = (cnt + dp[arr[j]] * bv) % MOD;
                    }
                }
            }
            dp[arr[i]] = cnt;
            ans = (ans + cnt) % MOD;
        }
        return (int)ans;
    }
}
