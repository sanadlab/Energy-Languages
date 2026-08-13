class Solution {
public:
    int countVowelPermutation(int n) {
        static const int MOD = 1'000'000'007;
        // dp arrays for each vowel count at length i
        // a=0, e=1, i=2, o=3, u=4
        long long a = 1, e = 1, i = 1, o = 1, u = 1;
        for (int len = 2; len <= n; ++len) {
            long long na = (e + i + u) % MOD; // from e, i, u to a
            long long ne = (a + i) % MOD;     // from a, i to e
            long long ni = (e + o) % MOD;     // from e, o to i
            long long no = i % MOD;           // from i to o
            long long nu = (i + o) % MOD;     // from i, o to u

            a = na;
            e = ne;
            i = ni;
            o = no;
            u = nu;
        }
        return (a + e + i + o + u) % MOD;
    }
};