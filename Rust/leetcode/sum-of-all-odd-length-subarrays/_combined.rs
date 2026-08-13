pub struct Solution;

impl Solution {
    pub fn sum_odd_length_subarrays(arr: Vec<i32>) -> i32 {
        let n = arr.len();
        let mut total: i64 = 0;
        for i in 0..n {
            let count = ((i + 1) * (n - i) + 1) / 2;
            total += count as i64 * arr[i] as i64;
        }
        total as i32
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::sum_odd_length_subarrays(vec![1,2,3,4,5]);
}
