pub struct Solution;

impl Solution {
    pub fn maximum_binary_string(binary: String) -> String {
        let bytes = binary.as_bytes();
        let n = bytes.len();
        let mut first: i64 = -1;
        let mut zeros = 0usize;
        for i in 0..n {
            if bytes[i] == b'0' {
                if first == -1 { first = i as i64; }
                zeros += 1;
            }
        }
        if first == -1 { return binary; }
        let mut res = vec![b'1'; n];
        res[first as usize + zeros - 1] = b'0';
        String::from_utf8(res).unwrap()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::maximum_binary_string(String::from("abcde"));
}
