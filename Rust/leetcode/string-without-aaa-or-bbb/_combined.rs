pub struct Solution;

impl Solution {
    pub fn str_without3a3b(mut a: i32, mut b: i32) -> String {
        let mut res: Vec<u8> = Vec::new();
        while a > 0 || b > 0 {
            let n = res.len();
            let write_a = if n >= 2 && res[n-1] == res[n-2] {
                res[n-1] == b'b'
            } else {
                a >= b
            };
            if write_a {
                if a == 0 { break; }
                res.push(b'a'); a -= 1;
            } else {
                if b == 0 { break; }
                res.push(b'b'); b -= 1;
            }
        }
        String::from_utf8(res).unwrap()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::str_without3a3b(20, 20);
}
