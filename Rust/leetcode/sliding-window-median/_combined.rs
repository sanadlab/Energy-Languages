pub struct Solution;

impl Solution {
    pub fn median_sliding_window(nums: Vec<i32>, k: i32) -> Vec<f64> {
        let n = nums.len();
        let k = k as usize;
        let mut res: Vec<f64> = Vec::new();
        if k == 0 || k > n {
            return res;
        }
        for i in 0..=(n - k) {
            let mut w: Vec<i32> = nums[i..i + k].to_vec();
            w.sort();
            let median = if k % 2 == 1 {
                w[k / 2] as f64
            } else {
                (w[k / 2 - 1] as f64 + w[k / 2] as f64) / 2.0
            };
            res.push(median);
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::median_sliding_window(vec![1,2,3,4,5], 20);
}
