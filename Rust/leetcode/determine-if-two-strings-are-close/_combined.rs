pub struct Solution;

use std::collections::HashMap;

impl Solution {
    pub fn close_strings(word1: String, word2: String) -> bool {
        // If lengths differ, cannot be close
        if word1.len() != word2.len() {
            return false;
        }

        let mut freq1 = [0; 26];
        let mut freq2 = [0; 26];

        for b in word1.bytes() {
            freq1[(b - b'a') as usize] += 1;
        }
        for b in word2.bytes() {
            freq2[(b - b'a') as usize] += 1;
        }

        // Check that the sets of characters are the same
        for i in 0..26 {
            if (freq1[i] == 0) != (freq2[i] == 0) {
                return false;
            }
        }

        // Check if the multisets of frequencies are the same
        let mut freq1_sorted = freq1.iter().filter(|&&x| x > 0).cloned().collect::<Vec<_>>();
        let mut freq2_sorted = freq2.iter().filter(|&&x| x > 0).cloned().collect::<Vec<_>>();
        freq1_sorted.sort_unstable();
        freq2_sorted.sort_unstable();

        freq1_sorted == freq2_sorted
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::close_strings(String::from("abcde"), String::from("abcde"));
}
