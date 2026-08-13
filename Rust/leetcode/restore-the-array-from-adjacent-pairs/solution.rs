use std::collections::HashMap;

impl Solution {
    pub fn restore_array(adjacent_pairs: Vec<Vec<i32>>) -> Vec<i32> {
        let mut adj: HashMap<i32, Vec<i32>> = HashMap::new();
        for p in &adjacent_pairs {
            adj.entry(p[0]).or_default().push(p[1]);
            adj.entry(p[1]).or_default().push(p[0]);
        }
        let n = adjacent_pairs.len() + 1;
        let mut start = if adjacent_pairs.is_empty() { 0 } else { adjacent_pairs[0][0] };
        for (node, nbrs) in &adj {
            if nbrs.len() == 1 {
                start = *node;
                break;
            }
        }
        let mut res = vec![start];
        let mut prev = start;
        let mut cur = start;
        let mut has_prev = false;
        while res.len() < n {
            let mut nxt: Option<i32> = None;
            if let Some(nbrs) = adj.get(&cur) {
                for &x in nbrs {
                    if !has_prev || x != prev {
                        nxt = Some(x);
                        break;
                    }
                }
            }
            match nxt {
                Some(v) => {
                    res.push(v);
                    prev = cur;
                    has_prev = true;
                    cur = v;
                }
                None => break,
            }
        }
        res
    }
}
