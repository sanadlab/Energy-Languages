int countVowelPermutation(int n) {
    const long long MOD = 1000000007LL;
    // counts of strings ending with each vowel: a,e,i,o,u
    long long a = 1, e = 1, i = 1, o = 1, u = 1;
    for (int len = 2; len <= n; len++) {
        long long na = e % MOD;                         // 'a' <- 'e'
        long long ne = (a + i) % MOD;                   // 'e' <- 'a','i'
        long long ni = (a + e + o + u) % MOD;           // 'i' <- all but 'i'
        long long no = (i + u) % MOD;                   // 'o' <- 'i','u'
        long long nu = a % MOD;                         // 'u' <- 'a'
        a = na; e = ne; i = ni; o = no; u = nu;
    }
    return (int)((a + e + i + o + u) % MOD);
}
