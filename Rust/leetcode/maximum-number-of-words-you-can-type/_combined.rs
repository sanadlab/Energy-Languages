pub struct Solution;

impl Solution {
    pub fn can_be_typed_words(text: String, broken_letters: String) -> i32 {
        let mut broken = [false; 26];
        for c in broken_letters.bytes() {
            if c.is_ascii_lowercase() {
                broken[(c - b'a') as usize] = true;
            }
        }
        let mut count = 0;
        for word in text.split(' ') {
            if word.bytes().all(|c| !(c.is_ascii_lowercase() && broken[(c - b'a') as usize])) {
                count += 1;
            }
        }
        count
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::can_be_typed_words(String::from("abcde"), String::from("abcde"));
}
