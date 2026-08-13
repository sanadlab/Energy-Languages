pub struct Solution;

impl Solution {
    pub fn k_length_apart(nums: Vec<i32>, k: i32) -> bool {
        let mut prev: i32 = -1;
        for i in 0..nums.len() {
            if nums[i] == 1 {
                if prev != -1 && (i as i32) - prev - 1 < k {
                    return false;
                }
                prev = i as i32;
            }
        }
        true
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::k_length_apart(vec![1,2,3,4,5], 20);
}
