pub struct Solution;

impl Solution {
    pub fn num_factored_binary_trees(arr: Vec<i32>) -> i32 {
        let mut arr = arr;
        arr.sort();
        const MOD: i64 = 1_000_000_007;
        let mut dp: std::collections::HashMap<i32, i64> = std::collections::HashMap::new();
        let mut ans: i64 = 0;
        for i in 0..arr.len() {
            let mut cnt: i64 = 1;
            for j in 0..i {
                if arr[i] % arr[j] == 0 {
                    let b = arr[i] / arr[j];
                    if let Some(&bv) = dp.get(&b) {
                        let av = *dp.get(&arr[j]).unwrap();
                        cnt = (cnt + av * bv) % MOD;
                    }
                }
            }
            dp.insert(arr[i], cnt);
            ans = (ans + cnt) % MOD;
        }
        ans as i32
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::num_factored_binary_trees(vec![1,2,3,4,5]);
}
