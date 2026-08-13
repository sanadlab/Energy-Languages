use std::collections::HashMap;

impl Solution {
    pub fn uncommon_from_sentences(s1: String, s2: String) -> Vec<String> {
        let mut cnt: HashMap<String, i32> = HashMap::new();
        for w in s1.split_whitespace().chain(s2.split_whitespace()) {
            *cnt.entry(w.to_string()).or_insert(0) += 1;
        }
        cnt.into_iter().filter(|(_, c)| *c == 1).map(|(w, _)| w).collect()
    }
}
