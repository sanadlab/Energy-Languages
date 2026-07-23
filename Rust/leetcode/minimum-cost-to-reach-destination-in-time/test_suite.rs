// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_cost(20, vec![vec![1,2],vec![3,4]], vec![1,2,3,4,5]);
}
