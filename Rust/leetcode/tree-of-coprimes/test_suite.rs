// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::get_coprimes(vec![1,2,3,4,5], vec![vec![1,2],vec![3,4]]);
}
