pub struct Solution;

impl Solution {
    pub fn are_occurrences_equal(s: String) -> bool {
        let mut counts = [0i32; 26];
        for c in s.chars() {
            counts[c as usize - 'a' as usize] += 1;
        }
        let mut f = -1;
        for &v in counts.iter() {
            if v == 0 {
                continue;
            }
            if f == -1 {
                f = v;
            } else if v != f {
                return false;
            }
        }
        true
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::are_occurrences_equal(String::from("abcde"));
}
