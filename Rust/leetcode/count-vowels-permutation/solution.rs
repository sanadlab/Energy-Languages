impl Solution {
    pub fn count_vowel_permutation(n: i32) -> i32 {
        const MOD: i64 = 1_000_000_007;
        let (mut a, mut e, mut i, mut o, mut u): (i64, i64, i64, i64, i64) = (1, 1, 1, 1, 1);
        for _ in 1..n {
            let na = (e + i + u) % MOD;
            let ne = (a + i) % MOD;
            let ni = (e + o) % MOD;
            let no = i % MOD;
            let nu = (i + o) % MOD;
            a = na; e = ne; i = ni; o = no; u = nu;
        }
        ((a + e + i + o + u) % MOD) as i32
    }
}
