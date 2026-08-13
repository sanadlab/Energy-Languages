pub struct Solution;

impl Solution {
    pub fn min_swaps(s: String) -> i32 {
        let mut open = 0;
        for c in s.chars() {
            if c == '[' {
                open += 1;
            } else if open > 0 {
                open -= 1;
            }
        }
        (open + 1) / 2
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_swaps(String::from("abcde"));
}
