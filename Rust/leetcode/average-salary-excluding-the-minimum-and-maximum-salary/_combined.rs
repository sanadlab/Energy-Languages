pub struct Solution;

impl Solution {
    pub fn average(salary: Vec<i32>) -> f64 {
        let mn = *salary.iter().min().unwrap();
        let mx = *salary.iter().max().unwrap();
        let sum: i32 = salary.iter().sum();
        (sum - mn - mx) as f64 / (salary.len() - 2) as f64
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::average(vec![1,2,3,4,5]);
}
