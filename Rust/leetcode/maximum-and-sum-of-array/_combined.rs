pub struct Solution;

impl Solution {
    pub fn maximum_and_sum(nums: Vec<i32>, num_slots: i32) -> i32 {
        let n = nums.len();
        let full = (1usize << n) - 1;
        let mut dp = vec![-1i32; 1 << n];
        dp[0] = 0;
        for slot in 1..=num_slots {
            let mut ndp = dp.clone();
            for mask in 0..=full {
                if dp[mask] < 0 { continue; }
                let base = dp[mask];
                for i in 0..n {
                    if (mask >> i) & 1 == 1 { continue; }
                    let nm = mask | (1 << i);
                    let v = base + (nums[i] & slot);
                    if v > ndp[nm] { ndp[nm] = v; }
                    for j in (i + 1)..n {
                        if (mask >> j) & 1 == 1 { continue; }
                        let nm2 = nm | (1 << j);
                        let v2 = v + (nums[j] & slot);
                        if v2 > ndp[nm2] { ndp[nm2] = v2; }
                    }
                }
            }
            dp = ndp;
        }
        if dp[full] < 0 { 0 } else { dp[full] }
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::maximum_and_sum(vec![1,2,3,4,5], 20);
}
