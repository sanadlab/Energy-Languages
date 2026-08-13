pub struct Solution;

impl Solution {
    pub fn kids_with_candies(candies: Vec<i32>, extra_candies: i32) -> Vec<bool> {
        let mx = *candies.iter().max().unwrap();
        candies.iter().map(|&c| c + extra_candies >= mx).collect()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::kids_with_candies(vec![1,2,3,4,5], 20);
}
