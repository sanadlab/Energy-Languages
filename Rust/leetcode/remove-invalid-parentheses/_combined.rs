pub struct Solution;

use std::collections::HashSet;

impl Solution {
    pub fn remove_invalid_parentheses(s: String) -> Vec<String> {
        fn valid(st: &str) -> bool {
            let mut cnt = 0i32;
            for &b in st.as_bytes() {
                if b == b'(' {
                    cnt += 1;
                } else if b == b')' {
                    cnt -= 1;
                    if cnt < 0 {
                        return false;
                    }
                }
            }
            cnt == 0
        }
        let mut level: HashSet<String> = HashSet::new();
        level.insert(s);
        while !level.is_empty() {
            let valids: Vec<String> = level.iter().filter(|st| valid(st)).cloned().collect();
            if !valids.is_empty() {
                return valids;
            }
            let mut nxt: HashSet<String> = HashSet::new();
            for st in &level {
                let bytes = st.as_bytes();
                for i in 0..bytes.len() {
                    if bytes[i] == b'(' || bytes[i] == b')' {
                        let mut ns = String::with_capacity(bytes.len() - 1);
                        ns.push_str(&st[..i]);
                        ns.push_str(&st[i + 1..]);
                        nxt.insert(ns);
                    }
                }
            }
            level = nxt;
        }
        vec![String::new()]
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::remove_invalid_parentheses(String::from("abcde"));
}
