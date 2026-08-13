pub struct Solution;

use std::cell::RefCell;

struct TrieNode {
    next: Vec<Option<Box<TrieNode>>>,
    word: bool,
}

impl TrieNode {
    fn new() -> Self {
        let mut next = Vec::with_capacity(26);
        for _ in 0..26 {
            next.push(None);
        }
        TrieNode { next, word: false }
    }
}

struct StreamChecker {
    root: TrieNode,
    stream: RefCell<Vec<u8>>,
    max_len: usize,
}

impl StreamChecker {
    fn new(words: Vec<String>) -> Self {
        let mut root = TrieNode::new();
        let mut max_len = 0;
        for w in &words {
            let bytes = w.as_bytes();
            let mut node = &mut root;
            for i in (0..bytes.len()).rev() {
                let c = (bytes[i] - b'a') as usize;
                if node.next[c].is_none() {
                    node.next[c] = Some(Box::new(TrieNode::new()));
                }
                node = node.next[c].as_mut().unwrap();
            }
            node.word = true;
            if bytes.len() > max_len {
                max_len = bytes.len();
            }
        }
        StreamChecker {
            root,
            stream: RefCell::new(Vec::new()),
            max_len,
        }
    }

    fn query(&self, letter: char) -> bool {
        self.stream.borrow_mut().push(letter as u8);
        let stream = self.stream.borrow();
        let n = stream.len();
        let mut node = &self.root;
        let mut step = 0;
        while step < self.max_len && step < n {
            let c = (stream[n - 1 - step] - b'a') as usize;
            match &node.next[c] {
                None => return false,
                Some(child) => {
                    node = child;
                    if node.word {
                        return true;
                    }
                }
            }
            step += 1;
        }
        false
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
fn main() {
    let sc = StreamChecker::new(vec!["a".to_string(), "b".to_string(), "c".to_string()]);
    let _ = sc.query('a');
}
