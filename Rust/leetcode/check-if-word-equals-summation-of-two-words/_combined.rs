pub struct Solution;

impl Solution {
    pub fn is_sum_equal(first_word: String, second_word: String, target_word: String) -> bool {
        fn word_to_num(word: &str) -> i32 {
            word.chars()
                .map(|c| (c as u8 - b'a') as u32)
                .fold(0, |acc, d| acc * 10 + d) as i32
        }
        
        word_to_num(&first_word) + word_to_num(&second_word) == word_to_num(&target_word)
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::is_sum_equal(String::from("abcde"), String::from("abcde"), String::from("abcde"));
}
