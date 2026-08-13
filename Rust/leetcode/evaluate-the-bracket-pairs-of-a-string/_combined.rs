pub struct Solution;

use std::collections::HashMap;

impl Solution {
    pub fn evaluate(s: String, knowledge: Vec<String>) -> String {
        let mut map: HashMap<&str, &str> = HashMap::new();
        let mut i = 0;
        while i + 1 < knowledge.len() {
            map.insert(knowledge[i].as_str(), knowledge[i + 1].as_str());
            i += 2;
        }
        let bytes = s.as_bytes();
        let n = bytes.len();
        let mut res = String::new();
        let mut idx = 0;
        while idx < n {
            if bytes[idx] == b'(' {
                let mut j = idx + 1;
                while j < n && bytes[j] != b')' {
                    j += 1;
                }
                let key = &s[idx + 1..j];
                match map.get(key) {
                    Some(v) => res.push_str(v),
                    None => res.push('?'),
                }
                idx = j + 1;
            } else {
                res.push(bytes[idx] as char);
                idx += 1;
            }
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::evaluate(String::from("abcde"), vec![String::from("a"),String::from("b"),String::from("c")]);
}
