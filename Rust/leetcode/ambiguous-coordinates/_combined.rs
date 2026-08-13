pub struct Solution;

impl Solution {
    pub fn ambiguous_coordinates(s: String) -> Vec<String> {
        let digits = &s[1..s.len() - 1];
        let n = digits.len();
        let mut res = Vec::new();
        for i in 1..n {
            let left = Self::make(&digits[..i]);
            let right = Self::make(&digits[i..]);
            for a in &left {
                for b in &right {
                    res.push(format!("({}, {})", a, b));
                }
            }
        }
        res
    }

    fn make(d: &str) -> Vec<String> {
        let mut out = Vec::new();
        let n = d.len();
        if n == 1 {
            out.push(d.to_string());
            return out;
        }
        let bytes = d.as_bytes();
        if bytes[0] != b'0' {
            out.push(d.to_string());
        }
        for i in 1..n {
            let l = &d[..i];
            let r = &d[i..];
            let lb = l.as_bytes();
            let rb = r.as_bytes();
            if (l == "0" || lb[0] != b'0') && rb[rb.len() - 1] != b'0' {
                out.push(format!("{}.{}", l, r));
            }
        }
        out
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::ambiguous_coordinates(String::from("abcde"));
}
