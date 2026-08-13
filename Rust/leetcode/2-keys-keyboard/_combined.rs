pub struct Solution;

impl Solution {
    pub fn min_steps(n: i32) -> i32 {
        let mut n = n;
        let mut res = 0;
        let mut d = 2;
        while d <= n {
            while n % d == 0 {
                res += d;
                n /= d;
            }
            d += 1;
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_steps(20);
}
