pub struct Solution;

impl Solution {
    pub fn license_key_formatting(s: String, k: i32) -> String {
        let cleaned: String = s.chars()
            .filter(|c| *c != '-')
            .map(|c| {
                if c.is_ascii_lowercase() {
                    c.to_ascii_uppercase()
                } else {
                    c
                }
            })
            .collect();

        if cleaned.is_empty() {
            return String::new();
        }

        let k_usize = k as usize;
        let L = cleaned.len();
        let m = L % k_usize;
        let m = if m == 0 { k_usize } else { m };

        let first_group = &cleaned[..m];
        let rest = &cleaned[m..];

        let mut groups = vec![first_group.to_string()];
        let mut i = 0;
        while i < rest.len() {
            groups.push(rest[i..i + k_usize].to_string());
            i += k_usize;
        }

        groups.join("-")
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::license_key_formatting(String::from("abcde"), 20);
}
