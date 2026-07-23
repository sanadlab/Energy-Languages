// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::max_compatibility_sum(vec![vec![1,2],vec![3,4]], vec![vec![1,2],vec![3,4]]);
}
