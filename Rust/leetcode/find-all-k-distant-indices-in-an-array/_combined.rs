pub struct Solution;

impl Solution {
    pub fn find_k_distant_indices(nums: Vec<i32>, key: i32, k: i32) -> Vec<i32> {
        let n = nums.len();
        let mut is_k_distant = vec![false; n];
        
        for j in 0..n {
            if nums[j] == key {
                let start = (j as i32 - k) as usize;
                let end = (j as i32 + k) as usize;
                let start = start.max(0);
                let end = end.min(n - 1);
                
                for i in start..=end {
                    is_k_distant[i] = true;
                }
            }
        }
        
        let mut result = Vec::new();
        for i in 0..n {
            if is_k_distant[i] {
                result.push(i as i32);
            }
        }
        
        result
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::find_k_distant_indices(vec![1,2,3,4,5], 20, 20);
}
