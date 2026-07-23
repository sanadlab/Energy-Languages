pub struct Solution;

impl Solution {
    pub fn min_steps(n: i32) -> i32 {
        if n == 1 { return 0; }
        let mut ans = 0; let mut d = 2; let mut m = n;
        while m > 1 {
            while m % d == 0 { ans += d; m /= d; }
            d += 1;
        }
        ans
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_steps(20);
}
