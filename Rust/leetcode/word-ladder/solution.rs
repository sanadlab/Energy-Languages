use std::collections::{HashSet, VecDeque};

impl Solution {
    pub fn ladder_length(begin_word: String, end_word: String, word_list: Vec<String>) -> i32 {
        let word_set: HashSet<String> = word_list.into_iter().collect();
        if !word_set.contains(&end_word) {
            return 0;
        }

        let mut queue = VecDeque::new();
        let mut visited = HashSet::new();

        queue.push_back((begin_word.clone(), 1));
        visited.insert(begin_word);

        while let Some((current_word, length)) = queue.pop_front() {
            if current_word == end_word {
                return length;
            }

            let mut chars: Vec<char> = current_word.chars().collect();
            for i in 0..chars.len() {
                let original_char = chars[i];
                for c in b'a'..=b'z' {
                    let ch = c as char;
                    if ch == original_char {
                        continue;
                    }
                    chars[i] = ch;
                    let next_word: String = chars.iter().collect();
                    if word_set.contains(&next_word) && !visited.contains(&next_word) {
                        visited.insert(next_word.clone());
                        queue.push_back((next_word, length + 1));
                    }
                }
                chars[i] = original_char;
            }
        }

        0
    }
}