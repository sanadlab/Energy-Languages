pub struct Solution;

impl Solution {
    pub fn max_score(nums: Vec<i32>) -> i32 {
        fn gcd(a: i32, b: i32) -> i32 { if b == 0 { a } else { gcd(b, a % b) } }
        let m = nums.len();
        let mut dp = vec![0i32; 1 << m];
        let mut best = 0i32;
        for mask in 0..(1usize << m) {
            let cnt = (mask as u32).count_ones();
            if cnt & 1 == 1 { continue; }
            let op = (cnt / 2 + 1) as i32;
            for i in 0..m {
                if (mask >> i) & 1 == 1 { continue; }
                for j in (i + 1)..m {
                    if (mask >> j) & 1 == 1 { continue; }
                    let nm = mask | (1 << i) | (1 << j);
                    let val = dp[mask] + op * gcd(nums[i], nums[j]);
                    if val > dp[nm] { dp[nm] = val; }
                    if dp[nm] > best { best = dp[nm]; }
                }
            }
        }
        best
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::max_score(vec![1,2,3,4,5]);
}
