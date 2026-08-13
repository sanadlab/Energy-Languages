pub struct Solution;

impl Solution {
    pub fn remove_palindrome_sub(s: String) -> i32 {
        if s.is_empty() {
            return 0;
        }
        let b = s.as_bytes();
        let (mut i, mut j) = (0usize, b.len() - 1);
        while i < j {
            if b[i] != b[j] {
                return 2;
            }
            i += 1;
            j -= 1;
        }
        1
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::remove_palindrome_sub(String::from("abcde"));
}
