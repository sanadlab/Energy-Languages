// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::k_weakest_rows(vec![vec![1,2],vec![3,4]], 20);
}
