class Solution {
    public int countVowelPermutation(int n) {
        long mod = 1000000007;
        long a = 1, e = 1, i = 1, o = 1, u = 1;

        for (int j = 2; j <= n; ++j) {
            long aNext = (e + i + u) % mod;
            long eNext = (a + i) % mod;
            long iNext = (e + o) % mod;
            long oNext = i % mod;
            long uNext = (i + o) % mod;

            a = aNext; e = eNext; i = iNext; o = oNext; u = uNext;
        }

        return (int)((a + e + i + o + u) % mod);
    }
}