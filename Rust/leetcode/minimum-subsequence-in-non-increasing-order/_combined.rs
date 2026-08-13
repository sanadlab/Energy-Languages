pub struct Solution;

impl Solution {
    pub fn min_subsequence(mut nums: Vec<i32>) -> Vec<i32> {
        nums.sort_unstable_by(|a, b| b.cmp(a));
        let total: i64 = nums.iter().map(|&x| x as i64).sum();
        let mut running: i64 = 0;
        let mut res = Vec::new();
        for x in nums {
            running += x as i64;
            res.push(x);
            if running * 2 > total {
                break;
            }
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_subsequence(vec![1,2,3,4,5]);
}
