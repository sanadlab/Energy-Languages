pub struct Solution;

use std::collections::HashSet;

impl Solution {
    pub fn count_vowel_substrings(word: String) -> i32 {
        let vowels: HashSet<char> = ['a', 'e', 'i', 'o', 'u'].iter().cloned().collect();
        let chars: Vec<char> = word.chars().collect();
        let n = chars.len();
        let mut count = 0;

        for i in 0..n {
            for j in i..n {
                let mut all_vowels = true;
                for k in i..=j {
                    if !vowels.contains(&chars[k]) {
                        all_vowels = false;
                        break;
                    }
                }
                if !all_vowels {
                    continue;
                }
                let distinct_vowels: HashSet<char> = chars[i..j+1].iter().cloned().collect();
                if distinct_vowels.len() == 5 {
                    count += 1;
                }
            }
        }
        count
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::count_vowel_substrings(String::from("abcde"));
}
