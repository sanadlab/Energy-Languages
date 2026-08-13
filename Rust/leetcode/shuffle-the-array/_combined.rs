pub struct Solution;

impl Solution {
    pub fn shuffle(nums: Vec<i32>, n: i32) -> Vec<i32> {
        let m = nums.len() / 2;
        let mut res = Vec::with_capacity(2 * m);
        for i in 0..m {
            res.push(nums[i]);
            res.push(nums[i + m]);
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::shuffle(vec![1,2,3,4,5], 20);
}
