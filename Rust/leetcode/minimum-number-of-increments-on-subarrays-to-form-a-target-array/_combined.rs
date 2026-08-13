pub struct Solution;

impl Solution {
    pub fn min_number_operations(target: Vec<i32>) -> i32 {
        if target.is_empty() {
            return 0;
        }
        let mut ans: i64 = target[0] as i64;
        for i in 1..target.len() {
            if target[i] > target[i-1] {
                ans += (target[i] - target[i-1]) as i64;
            }
        }
        ans as i32
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_number_operations(vec![1,2,3,4,5]);
}
