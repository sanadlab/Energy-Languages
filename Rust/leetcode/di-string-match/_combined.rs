pub struct Solution;

impl Solution {
    pub fn di_string_match(s: String) -> Vec<i32> {
        let n = s.len() as i32;
        let (mut lo, mut hi) = (0i32, n);
        let mut res: Vec<i32> = Vec::with_capacity((n + 1) as usize);
        for c in s.chars() {
            if c == 'I' {
                res.push(lo);
                lo += 1;
            } else {
                res.push(hi);
                hi -= 1;
            }
        }
        res.push(lo);
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::di_string_match(String::from("abcde"));
}
