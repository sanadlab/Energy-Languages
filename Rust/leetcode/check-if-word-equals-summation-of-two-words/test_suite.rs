// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::is_sum_equal(String::from("abcde"), String::from("abcde"), String::from("abcde"));
}
