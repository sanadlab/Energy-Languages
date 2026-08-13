use std::collections::HashMap;

impl Solution {
    pub fn evaluate(s: String, knowledge: Vec<Vec<String>>) -> String {
        let mut map: HashMap<&str, &str> = HashMap::new();
        for pair in &knowledge {
            map.insert(pair[0].as_str(), pair[1].as_str());
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
