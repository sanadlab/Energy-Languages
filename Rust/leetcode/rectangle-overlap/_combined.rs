pub struct Solution;

impl Solution {
    pub fn is_rectangle_overlap(rec1: Vec<i32>, rec2: Vec<i32>) -> bool {
        rec1[0] < rec2[2] && rec2[0] < rec1[2]
            && rec1[1] < rec2[3] && rec2[1] < rec1[3]
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::is_rectangle_overlap(vec![1,2,3,4,5], vec![1,2,3,4,5]);
}
