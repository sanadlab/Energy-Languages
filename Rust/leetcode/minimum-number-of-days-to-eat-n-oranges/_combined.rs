pub struct Solution;

use std::collections::HashMap;

impl Solution {
    pub fn min_days(n: i32) -> i32 {
        let mut memo: HashMap<i64, i32> = HashMap::new();
        Self::solve(n as i64, &mut memo)
    }
    fn solve(n: i64, memo: &mut HashMap<i64, i32>) -> i32 {
        if n <= 1 {
            return n as i32;
        }
        if let Some(&v) = memo.get(&n) {
            return v;
        }
        let a = (n % 2) as i32 + Self::solve(n / 2, memo);
        let b = (n % 3) as i32 + Self::solve(n / 3, memo);
        let res = 1 + a.min(b);
        memo.insert(n, res);
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_days(20);
}
