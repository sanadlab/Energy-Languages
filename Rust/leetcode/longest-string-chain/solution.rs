use std::collections::HashMap;

impl Solution {
    pub fn longest_str_chain(words: Vec<String>) -> i32 {
        let mut words = words;
        words.sort_by_key(|w| w.len());
        let mut dp: HashMap<String, i32> = HashMap::new();
        let mut best = 1;
        for w in &words {
            let chars: Vec<char> = w.chars().collect();
            let mut cur = 1;
            for i in 0..chars.len() {
                let mut pred = String::with_capacity(chars.len().saturating_sub(1));
                for (j, c) in chars.iter().enumerate() {
                    if j != i {
                        pred.push(*c);
                    }
                }
                if let Some(&v) = dp.get(&pred) {
                    if v + 1 > cur {
                        cur = v + 1;
                    }
                }
            }
            dp.insert(w.clone(), cur);
            if cur > best {
                best = cur;
            }
        }
        best
    }
}
